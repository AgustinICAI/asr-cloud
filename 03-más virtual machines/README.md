## 💻 QuickLab I: Creación y despliegue de contenedores en GCP

* Creación y despliegue de un microservicio con Flask que nos permite la inserción y borrado de registros mediante una API sencilla en una base de datos *in-memory* (redis). El objetivo de este ejemplo es el de mostrar la estructura típica de una aplicación con varios microservicios, y la gestión de su despliegue de manera programática (pero aún manual) en la nube mediate Google SDK. 


## 💻 QuickLab II: SuperMario auto-escalable

* Creación y despliegue de una aplicación dada (como Docker Image) con autoescalado y balanceado de carga. El objetivo es ir un paso más allá del ejemplo anterior, y mostrar lo conveniente que es la contenerización de aplicaciones para su despliegue en una infraestructura autoescalable según la utilización del servicio. Para ello tendremos que crear un grupo de instancias gestionadas que se desplieguen con la imagen de la aplicación en el arranque, y que autoescalen a medida que sea necesario acorde a un umbral de utilización. Para servir la aplicación con una única IP a nuestros poténciales clientes, tendremos que crear un balanceado de carga (con *Cloud Load Balancer*) que hará la el enrutamiento correcto a la VM adecuada.  

