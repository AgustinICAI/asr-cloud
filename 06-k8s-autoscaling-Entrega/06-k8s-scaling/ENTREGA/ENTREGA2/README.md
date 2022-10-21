## ENTREGA 2
Montar un job de K8S el cual lance ab. Para ello será necesario:
- Generar una imagen docker sobre la que se instalará Apachebench(ab). Para ello partir de una imagen base docker de "ubuntu" y sobre esta, instalar lo necesesario en el Dockerfile para que tenga instalado el comando "ab".

- Taguear vuestra imagen al registry que tengais en Google. "-t gcr.io/$PROJECT/ab:v.0.0.1"

- Hacer docker push

Una vez generada la imagen con Apachebench, será necesario definir un job, el cual lance nuestra imagen. Al yaml del job será necesario configurarlo para que tenga de parámetros de entrada:
- ab -n 10000 -c 10 "http://localhost/index.html"
Para indicarle al pod los argumentos a lanzar, usaremos "command" en nuestro yaml de definición del job:
[Ejecución comandos en un pod] (https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/)

- Desplegar el job. Una vez hecho esto, la forma de seguir la ejecución será observando los logs de los pods. Para esto lo mejor será visitar el "logging" del propio GCP.


# ENTREGA
Será necesario entregar:
- el Dockerfile de vuestra imagen ab y el yaml del job. Vuestro profesor para corregir vuestra práctica lanzará:
```
docker build .
kubectl apply -f job.yaml #Folder del alumno con los yamls en su interior
```
- Entregar la salida que ha producido la ejecución del pod. Bien en los logs del propio POD o en el logging de Google
