### Introducción

En el siguiente ejemplo vamos a profundizar un poco más en la automatización de los
despliegues de aplicaciones (interconectadas) mediante `gcloud`. En este proceso de
automatización vamos a introducir también algunos de los 12-factores (12F) que deben
componer una aplicación *nativa cloud* (*cloud native* en inglés), e.g., 
vamos a introducir la praxis de explicitar la configuración de la aplicación en un
fichero de parametrización, en este caso en concreto será [config.txt](config.ini), 
así como declarar todas las dependencias en un manifiesto, en nuestro caso será
[requirements.txt](requirements.txt). 


### La aplicación

Se trata de una aplicación sencilla escrita
en `python` (con `Flask`) la cual actúa como interfaz de comunicación con una 
base de datos `Redis`, ambos dos servicios desplegados en GCP. La idea es que la
aplicación `Flask` exponga:

- Métodp `POST` en el path `/`, que admita cargas `JSON` del tipo `{"name": "myName"}`
  que serán guardadas como entradas en la base de datos
    
- Método `GET` en el path `/`, que mostrará todos los registros guardados en la base
  de datos
    
- Método `POST` en el path `/reset`, que borrará la base da datos y mostrará 
  el índice a posteriori (que estará en blanco)
  

El código de la App está compuesto por los ficheros:

- [app.py](app.py): Código Python de la aplicación

- [requirements.txt](requirements.txt): Manifiesto de las dependencias necesarias

- [Dockerfile](Dockerfile): Fichero Docker donde se procede a la contenerización de la aplicación

Los pasos necesarios son (ver [deployment.sh](deployment.sh)):

1. Desplegar una VM en GCP con la imagen de Redis, la cual estará sirviendo a través del puerto
  (TCP) `6379`:
   
   ```shell
   gcloud compute instances create-with-container $redis_server \
      --machine-type="$machine_type" \
      --container-image="$redis_image" \
      --quiet
   ```
   Las opciones de configuración de la máquina y de la imagen vienen dadas en el fichero
   [config.txt](config.ini)


2. Definir una variable de entorno adicional `app_image_uri` se define como `app_image_uri="eu.gcr.io/$PROJECT/$app_img"`, siendo
  `$PROJECT` el UUID de nuestro proyecto, y `$app_img` el nombre de la imagen de nuestra
  aplicación, que viene explicitado en el archivo de configuración de despliegue [config.txt](config.ini)

   
3. Contenerizar la aplicación (haciendo `docker build`), pasándole como argumento de construcción
  la IP reservada para Redis, de manera que la App pueda establecer la conexión con ésta:
  ```shell
  docker build --tag $app_image_uri . 
  
  ```
  
  Antes de subir la imagen al registry de Google, vamos a probar que nuestra imagen corra correctamente con docker.
  ```shell
  docker run $app_image_uri
  ```
  ![alt text](images/error_environ.png)
  
  ¿Qué error da? ¿Por qué puede ser este error? ¿Cómo habría que corregirlo?

  
  
4. Publicar la imagen de la aplicación en nuestro `Container Registry` asociado al proyecto GCP:
  ```shell
  docker push "$app_image_uri"
  ```
  
  Si falla este paso, probablemente haya que lanzar el siguiente comando para conectar nuestra instalación docker con el registry de Google
  ```shell
  gcloud auth configure-docker
  ```

5. Desplegar una VM en GCP con la imagen de la aplicación:
   ```shell
    gcloud compute instances create-with-container $app_name \
    --machine-type=$machine_type \
    --container-image=$app_image_uri \
    --tags=app-server \
    --container-env=REDIS_IP_GCP=$REDIS_VM_IP
   ```

6. Crear regla de `firewall` para permitir tráfico de entrada en los puerto `5000` que es la que sirve el trafico (app.py)
  y `6379` (redis):
   ```shell
    gcloud compute firewall-rules create "default-allow-external-$app_port" \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:"$app_port" \
    --source-ranges=0.0.0.0/0 \
    --target-tags=app-server
   ```
  
Todo ello se podría haber ejecutado de forma automatica agregando todos los pasos en el siguiente script:
```shell
chmod a+x deployment.sh && ./deployment.sh
```
Esta podría ser nuestra primera infraestructura como código, pero veremos métodos más avanzados de hacer esto.

### Liberación de los recursos 
Para evitar incurrir en gastos innecesarios que acabarían con nuestros créditos
gratuitos, podemos proceder a la limpieza del proyecto ejecutando el script [clean.sh](clean-all.sh):

```shell
chmod a+x clean.sh && ./clean.sh
```
