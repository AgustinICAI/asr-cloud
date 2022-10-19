## EXTRA 1. Escalado vertical de pods con VPA

VPA (o autoescalado vertical de pods) nos libera de la responsabilidad
de tener que conocer perfectamente los valores de CPU que 
tenemos que seleccionar para cada contenedor. De hecho, el auto-escalador
VPA nos recomienda valores de CPU y RAM, y límites, acorde
al histórico de uso. Además, evidentemente, puede hacer que
susodichos valores sean los que se utilicen en los nodos del
despliegue.

🚨 *Atención*: No deberíamos usar nunca un VPA y un HPA simultáneamente
sobre la misma métrica (CPU o memoria). La razón es sencilla, si
así fuera, ambos auto-escaladores intentarían responder al cambio
de demanda en la misma métrica y llevaría a un conflicto de 
responsabilidades. No obstante, sí que se pueden usar (y se
recomienda de hecho) en distintas, por ejemplo VPA en CPU o memoria
y el HPA en métricas personalizadas para evitar el solapamiento.


Si recuerdas, cuando hemos creado el cluster, hemos seleccionado
la opción de autoescalado vertical. Es por ello que VPA ya está
activo en nuestro cluster. Para comprobarlo, solo tenemos que
ejecutar el siguiente comando:

```shell
$ gcloud container clusters describe scaling-demo | grep ^verticalPodAutoscaling -A 1
```

Este comando nos debería devolver en terminal: `enabled: true`,
confirmando que está activo. Si por lo que fuera se nos olvidó 
activarlo con la creación del cluster, podemos hacerlo ahora de 
forma manual:

```shell
$ gcloud container clusters update $cluster_name \
    --enable-vertical-pod-autoscaling
```

Para comprobar las virtudes de VPA, vamos a desplegar un nuevo
servicio, `hello-server`:

```shell
$ kubectl create deployment hello-server \
    --image=gcr.io/google-samples/hello-app:1.0
```

Esto llevará unos minutos. Cuando acabe el despliegue, 
podremos asegurarnos de que todo ha ido bien mediante el
siguiente comando:

```shell
$ kubectl get deployment hello-server
```

A continuación, vamos a definir la mínima cantidad de CPU
necesaria por el despliegue `hello-server`. En el lenguaje
de K8s esto se conoce como *resource requests* (RR). Por ejemplo,
vamos a comenzar seleccionando un RR de 450 mili-CPU, i.e. 0.45 CPUs.
Esto se lleva a cabo mediante:

```shell
$ kubectl set resources deployment hello-server \
  --requests=cpu=450m
```

Ahora podemos inspeccionar el pod que sirve `hello-server`
y ver que la configuración de `Requests` es precisamente
la que acabamos de configurar:

```shell
$ kubectl describe pod hello-server | sed -n "/Containers:$/,/Conditions:/p"
```

En lo que sigue, vamos a usar el manifiesto de configuración del
VPA, [hello-vpa.yaml](hello-vpa.yaml):

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: hello-server-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind:       Deployment
    name:       hello-server
  updatePolicy:
    updateMode: "Off"
```

Este manifiesto generará un auto-esclador VPA para el 
despliegue `hello-server` con una política de actualización 
`Off`. Un VPA solo puede tener una de las siguientes tres
políticas de actualización:

- *Off*: Con esta configuración VPA solo generará recomendaciones
  basadas en datos históricos. Dichas recomendaciones no serán
  aplicadas, las tendremos que aplicar nosotros manualmente
- *Initial*: VPA generará recomendaciones y creará nuevos pods
  basadas en las mismas una sola vez, no cambiará el tamaño de los
  pods a posteriori
- *Auto*: VPA borrará y creará regularmente pods para que se cumplan
  las recomendaciones actualizadas regularmente
  
Conocido esto, apliquemos el manifiesto mencionado:

```shell
$ kubectl apply -f hello-vpa.yaml
```

Tras esperar un minuto, aproximadamente, podemos hacer una comprobación
del VPA mediante:

```shell
$ kubectl describe vpa hello-server-vpa
```

Dado que nuestro manifiesto especificaba una política de 
actualización modo `Off`, lo que podremos ver serán las recomendaciones
generadas por la VPA. Para ello, podemos fijarnos en la sección
`Container Recommendations` que debería aparecernos al final de
la respuesta del anterior comando. Ahí veremos diferentes
tipos de recomendación, cada uno de ellos con valores de CPU
y memoria. Si todo ha ido bien, veremos que el VPA nos está 
recomendando que bajemos la CPU RR a `25m`, en lugar del valor
previo, además de darnos un valor de cuanta memoria debería
requerirse. A partir de aquí, podríamos aplicar estas recomendaciones
manualmente. 

⚠️ Las recomendaciones dadas por el VPA vienen dadas en base
a los datos recolectados, por lo que para éstas sean lo más
útiles posibles, deberíamos esperar a recolectar aproximadamente 
unas 24h si estamos en el modo `Off`.

En lugar de aplicar las recomendaciones manualmente, vamos a 
proceder a cambiar la política de actualización del VPA.
Para ello ya tenemos preparado el manifiesto modificado
en [hello-vpa-auto.yaml](hello-vpa-auto.yaml):

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: hello-server-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind:       Deployment
    name:       hello-server
  updatePolicy:
    updateMode: "Auto"
```

Lo único que tenemos que hacer es actualizar el VPA
con el manifiesto mencionado mediante el siguiente comando:

```shell
$ kubectl apply -f hello-vpa-auto.yaml
```

Para que el VPA pueda adaptar el tamaño del pod, 
primero necesitará borra el pod y posteriormente recrearlo
con la nueva configuración de tamaño. 
Por configuración de defecto, VPA no va a borrar el 
último pod activo, que es el que estamos estudiando. Así
que necesitaremos al menos 2 réplicas para ver como el VPA
hace los cambios adecuados. Para ello, vamos a escalar
nosotros manualmente ahora el despliegue `hello-server` 
a dos réplicas:

```shell
$ kubectl scale deployment hello-server --replicas=2
```

A continuación, podemos monitorizar el comportamiento de los
pods mediante:

```shell
$ kubectl get pods -w
```

Esperamos hasta que veamos los pods `hello-server-xxx` en
el estado `terminating`. Esta es la señal de que nuestra VPA
ya está borrando y reconfigurando el tamaño de los pods.
Una vez que lo veamos podremos simplemente salir de la espera
pulsando `Ctrl + c` en nuestro terminal.


### 1.1. Comprobación de los autoescaladores VPA


Pasado unos minutos, el auto-escalador VPA habrá ya entrado
en juego y re-escalado los pods. Para ver si es así podemos
comprobarlo mediante:

```shell
$ kubectl describe pod hello-server | sed -n "/Containers:$/,/Conditions:/p"
```

Buscando el campo `Requests`, deberíamos ver ahora un valor inferior en 
cuanto a CPU se refiere, lo que significaría que el VPA ha entrado
en acción y ha hecho lo que debía (dada la falta de actividad).



## EXTRA 2. Auto aprovisionamiento de nodos

Los clusters de GKE de Google tienen una opción que es autoaprovionamiento de nodos.

##### Node auto-provisioning creates node pools based on the following information:
- CPU, memory and ephemeral storage resource requests.
- GPU requests
- Pending Pods' node affinities and label selectors.
- Pending Pods' node taints and tolerations.

El autoescalado NAP consiste en añadir nuevos nodos al pool
de nodos asociado al cluster, pero con el tamaño adecuado para
adaptarse a la demanda. En ausencia de NAP, el autoecalador
de cluster crearía nodos con las mismas características
de los ya existentes, no adaptándose así verticalmente a la
demanda. Es por ello que el NAP es tan conveniente para un
uso adecuado de los recursos, más aún cuando tenemos cargas
de trabajo que son secuenciales (por *batches*), ya que 
con este modo de escalamiento el pool está optimizado para
nuestro caso de uso específico.

Para activar NAP en nuestro cluster:

```shell
gcloud container clusters update $cluster_name \
    --enable-autoprovisioning \
    --min-cpu 1 \
    --min-memory 2 \
    --max-cpu 45 \
    --max-memory 160
```

Donde estamos especificando el mínimo y máximo número de recursos
de CPU y memoria. Recordemos que esta estrategia es aplicable
al cluster completo. El NAP puede tardar unos minutos en activarse,
y a pesar de ello, puede ser que en nuestro ejemplo no entre en
juego dado el estado actual de nuestro cluster.


