docker run -d \
  --name mypg14-packer \
  -p 15432:5432 \
  -e PGDATABASE=wordpress \
  -e PGUSERNAME=wordpress \
  -e PGPASSWORD=vSTJ9876 \
  -e PGADMPWD=Foxconn456 \
  pg14-packer:latest
