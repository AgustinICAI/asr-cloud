## Crear CSR para firmar mi dominio (a partir de un fichero de config)
openssl req -new -config certificado.config -out myserver.csr -keyout KEY.key

## Crearse una CA privada para firmar mi petición
openssl genrsa -des3 -out rootCA.key 4096
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt

## Firmar el CSR con mi CA privada
openssl x509 -req -in myserver.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out asr.es.crt -days 360 -sha256
 
 
 
 
 
## Hacer lo mismo en un mismo paso y de forma interactiva con OpenSSL
openssl req -x509 -newkey rsa:2048 -keyout KEY.key -out cert.pem -days 365 -nodes
