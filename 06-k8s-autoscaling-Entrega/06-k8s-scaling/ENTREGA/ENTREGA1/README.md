## ENTREGA 1
Montar un job de K8S el cual lance artillery. Para ello será necesario:
- Generar un JOB de K8S definiendo a través de un fichero YAML usando la imagen base de artillery ([Imagen base Artillery](https://www.artillery.io/docs/guides/guides/docker))
- Al pod del job será necesario montarle un yaml con el escenario de pruebas que a su vez es otro yaml. Para ello, como paso previo, será necesario usar el objeto "configmap". El config map permite cargar configuración ya sea mediante clave valor, como también definir como valor el contenido de un fichero. [Cargar fichero en configmap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/.
- Al pod le montaremos en una ruta específica el fichero del configmap como un volumen [Montar un configmap en un POD](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#add-configmap-data-to-a-specific-path-in-the-volume)

- Por otro lado, al pod para indicarle los argumentos a lanzar, usaremos "command" en nuestro yaml de definición del job:
[Ejecución comandos en un pod] (https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/)

- Desplegar el job. Una vez hecho esto, la forma de seguir la ejecución será observando los logs de los pods. Para esto lo mejor será visitar el "logging" del propio GCP.


# ENTREGA
Será necesario entregar:
- El/los yaml del fichero configmap y del job. Vuestro profesor para corregir vuestra práctica lanzará:
```
kubectl apply -f <folder> #Folder del alumno con los yamls en su interior
```

- Entregar la salida que ha producido la ejecución del pod. Bien en los logs del propio POD o en el logging de Google
