## Distribute Load Testing Using GKE

## Before you begin


**Note:** Following services should be enabled in your project:
Cloud Build
Kubernetes Engine
Google App Engine Admin API 
Cloud Storage
```bash
    $ gcloud services enable \
        cloudbuild.googleapis.com \
        compute.googleapis.com \
        container.googleapis.com \
        containeranalysis.googleapis.com \
        containerregistry.googleapis.com 
```

## Load testing tasks

To deploy the load testing tasks, you first deploy a load testing master and then deploy a group of load testing workers. With these load testing workers, you can create a substantial amount of traffic for testing purposes. 

**Note:** Keep in mind that generating excessive amounts of traffic to external systems can resemble a denial-of-service attack. Be sure to review the Google Cloud Platform Terms of Service and the Google Cloud Platform Acceptable Use Policy.

## Load testing master

The first component of the deployment is the Locust master, which is the entry point for executing the load testing tasks described above. The Locust master is deployed with a single replica because we need only one master. 

The configuration for the master deployment specifies several elements, including the ports that need to be exposed by the container (`8089` for web interface, `5557` and `5558` for communicating with workers). This information is later used to configure the Locust workers. The following snippet contains the configuration for the ports:
```
    ports:
       - name: loc-master-web
         containerPort: 8089
         protocol: TCP
       - name: loc-master-p1
         containerPort: 5557
         protocol: TCP
       - name: loc-master-p2
         containerPort: 5558
         protocol: TCP
```
Next, we would deploy a Service to ensure that the exposed ports are accessible to other pods via `hostname:port` within the cluster, and referenceable via a descriptive port name. The use of a service allows the Locust workers to easily discover and reliably communicate with the master, even if the master fails and is replaced with a new pod by the deployment. The Locust master service also includes a directive to create an external forwarding rule at the cluster level (i.e. type of LoadBalancer), which provides the ability for external traffic to access the cluster resources. 

After you deploy the Locust master, you can access the web interface using the public IP address of the external forwarding rule. After you deploy the Locust workers, you can start the simulation and look at aggregate statistics through the Locust web interface.

## Load testing workers

The next component of the deployment includes the Locust workers, which execute the load testing tasks described above. The Locust workers are deployed by a single deployment that creates multiple pods. The pods are spread out across the Kubernetes cluster. Each pod uses environment variables to control important configuration information such as the hostname of the system under test and the hostname of the Locust master. 

After the Locust workers are deployed, you can return to the Locust master web interface and see that the number of slaves corresponds to the number of deployed workers.

## Setup

1. Use existing cluster

3. Build docker image and store it in your project's container registry
```bash
$ gcloud builds submit --tag gcr.io/$PROJECT/locust-tasks:latest docker-image/.
```

4. Replace [TARGET_HOST] and [PROJECT_ID] in locust-master-controller.yaml and locust-worker-controller.yaml with the deployed endpoint and project-id respectively.

6. Deploy Locust master and worker nodes:
```bash
kubectl apply -f kubernetes-config/locust-master-controller.yaml
kubectl apply -f kubernetes-config/locust-master-service.yaml
kubectl apply -f kubernetes-config/locust-worker-controller.yaml
```
7. Get the external ip of Locust master service (maybe you need to install yq) 
```
EXTERNAL_IP=$(kubectl get svc locust-master -o yaml | yq '.status.loadBalancer.ingress[0].ip') && echo $EXTERNAL_IP
```
8. Starting load testing
The Locust master web interface enables you to execute the load testing tasks against the system under test, as shown in the following image. Access the url as http://$EXTERNAL_IP:8089.

To begin, specify the total number of users to simulate and a rate at which each user should be spawned. Next, click Start swarming to begin the simulation. To stop the simulation, click **Stop** and the test will terminate. The complete results can be downloaded into a spreadsheet. 

