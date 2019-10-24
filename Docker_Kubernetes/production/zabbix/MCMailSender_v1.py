#!/usr/bin/python2.7
# -*- code: utf-8 -*-
import urllib2
import sys, httplib

def mcMailSender(serveraddr,callmethod,mcuserid,mcpasswd,mailtoaddr,mailsub,mailbody,mailsenderaddr):
#define soap send message.
	SoapMessage = '''<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Header>
    <AuthenticationSoapHeader xmlns="http://tempuri.org/">
      <UserId>%s</UserId>
      <Password>%s</Password>
    </AuthenticationSoapHeader>
  </soap12:Header>
  <soap12:Body>
    <SendGroupMails xmlns="http://tempuri.org/">
      <To>%s</To>
      <Cc>%s</Cc>
      <Subject>%s</Subject>
      <Body>%s</Body>
      <SmtpID>%s</SmtpID>
      <SmtpPassowrd>%s</SmtpPassowrd>
      <SmtpAddress>%s</SmtpAddress>
      <NoteAddress>%s</NoteAddress>
      <NotesPassword>%s</NotesPassword>
    </SendGroupMails>
  </soap12:Body>
</soap12:Envelope>'''
	SoapMessage = SoapMessage % (mcuserid,mcpasswd,mailtoaddr,mailtoaddr,mailsub,mailbody,mcuserid,mcpasswd,mailsenderaddr,mailsenderaddr,mcpasswd)
	##We are using "msgcenter.cesbg.efoxconn.com" as WebService
	webservice = httplib.HTTP(serveraddr)
	##Define the header format.
	webservice.putrequest("POST",callmethod)
	webservice.putheader("Host",serveraddr)
	webservice.putheader("Content-type", "application/soap+xml; charset=\"utf-8\"")
	webservice.putheader("Content-length", "%d" % len(SoapMessage))
	webservice.putheader("X-Forwarded-For", "10.67.50.225")
	webservice.putheader("SOAPAction", "\"http://msgcenter.cesbg.efoxconn.com/Messaging.asmx?op=SendGroupMails\"") 
	##Send server blank to finish the header submit.
	webservice.endheaders()
	print SoapMessage
	webservice.send(SoapMessage)
	statuscode, statusmessage, header = webservice.getreply()
	print "Response: ", statuscode, statusmessage 
	print "headers: ", header 
	print webservice.getfile().read() 
	with open('/var/log/zabbix/alertsender.log','a') as f:
		f.write(mailbody)
		f.write(SoapMessage)
	return statuscode

serveraddr = "msgcenter.cesbg.efoxconn.com"
callmethod = "/Messaging.asmx"
mcuserid = "zabbixalert"
mcpasswd = "Zabbix@Foxconn123"
mailtoaddr = sys.argv[1]
mailsub = sys.argv[2]
mailbody = """%s"""
mailbody = mailbody % (sys.argv[3])
mailsenderaddr = "zabbixalert@mail.foxconn.com"
try:
	mcResult = mcMailSender(serveraddr,callmethod,mcuserid,mcpasswd,mailtoaddr,mailsub,mailbody,mailsenderaddr)
except Exception, e:
	print e
