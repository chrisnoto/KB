#!/usr/bin/python

from cryptography import x509
from cryptography.x509.oid import NameOID
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
import requests
from requests.auth import HTTPBasicAuth
from requests_ntlm import HttpNtlmAuth
from bs4 import BeautifulSoup
import subprocess
import os

env_vars = ['CERT_DIR','FQDN','AD_IP','AD_USER','AD_PW','AD_CERT_TPL']
command = 'source /root/install.config; echo ' + ' '.join(f'${var}' for var in env_vars)

process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
output, error = process.communicate()
output = output.decode('utf-8')

env_dict =dict(zip(env_vars,output.strip().split()))

ad_ntlm_login = 'CESBG\\' + env_dict['AD_USER']
cert_dir = env_dict['CERT_DIR']
key_file = cert_dir + env_dict['FQDN'] + ".key"
csr_file = cert_dir + env_dict['FQDN'] + ".csr"
cer_file = cert_dir + env_dict['FQDN'] + ".cer"
ca_file = cert_dir + "ca.cer"
adcs_url = "http://" + env_dict['AD_IP'] + "/certsrv/"
auth = HttpNtlmAuth(ad_ntlm_login,env_dict['AD_PW'])
template_name = env_dict['AD_CERT_TPL']

csr_fields = {
    NameOID.COUNTRY_NAME: "CN",
    NameOID.STATE_OR_PROVINCE_NAME: "TianJin",
    NameOID.LOCALITY_NAME: "TianJin",
    NameOID.ORGANIZATION_NAME: "Foxconn",
    NameOID.COMMON_NAME: env_dict['FQDN'],
    NameOID.EMAIL_ADDRESS: "sen.chen@mail.foxconn.com",
}

# generate private key
private_key = rsa.generate_private_key(
    public_exponent=65537,
    key_size=2048,
    backend=default_backend()
)

# generate CSR
csr = x509.CertificateSigningRequestBuilder().subject_name(x509.Name([
    x509.NameAttribute(name,value) for name,value in csr_fields.items()
])).sign(private_key, hashes.SHA256(), default_backend())

# save private key
with open(key_file, "wb") as f:
    f.write(private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.TraditionalOpenSSL,
        encryption_algorithm=serialization.NoEncryption(),
    ))

# save CSR
with open(csr_file, "wb") as f:
    f.write(csr.public_bytes(serialization.Encoding.PEM))

# ADCS url for submit CSR
cr_url = adcs_url + "certfnsh.asp"

with open(csr_file,"r") as file:
    csr = file.read()

data = {
    "Mode": "newreq",
    "CertRequest": csr,
    "CertAttrib": "CertificateTemplate:" + template_name,
    "TargetStoreFlags": "0",
    "SaveCert": "yes",
}

# submit certificate request to ADCS
response = requests.post(cr_url,data=data,auth=auth)
soup = BeautifulSoup(response.content,'html.parser')
tag = soup.find('a', href=True, text='Base 64 encoded')
cert_download_url=tag['href']
request_id = cert_download_url.split('=')[1].split('&')[0]


if response.status_code == 200:
    print("Submit certificate request successfully")
    print("request id is " + request_id)
    # ADCS url for download server cert
    srv_cert_url = adcs_url + cert_download_url
else:
    print(f"Failed to submit certificate request. Status code: {response.status_code}")

# download server certificate
response = requests.get(srv_cert_url,auth=auth)

if response.status_code == 200:
    with open(cer_file,"wb") as file:
        file.write(response.content)
        print("Server Certificate downloaded successfully.")
else:
    print(f"Failed to download certificate. Status code: {response.status_code}")

# download CA certificate
# ADCS url for download ca certificate
ca_cert_url = adcs_url + "certnew.cer?ReqID=CACert&Renewal=0&Enc=b64"

response = requests.get(ca_cert_url,auth=auth)
if response.status_code == 200:
    with open(ca_file,"wb") as file:
        file.write(response.content)
        print("CA Certificate downloaded successfully.")
else:
    print(f"Failed to download certificate. Status code: {response.status_code}")
