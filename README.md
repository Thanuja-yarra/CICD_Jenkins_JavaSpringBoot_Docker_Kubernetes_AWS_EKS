Spring Boot CI/CD: Jenkins, Docker Hub and Amazon EKS

This repository builds a Spring Boot application with Maven, creates a Docker image, pushes the image to Docker Hub, and deploys it to Amazon EKS.

Technology stack
Java 17
Maven
Jenkins Pipeline
Docker
Docker Hub
Amazon EKS
Kubernetes
Repository structure
.
├── Jenkinsfile-K8S-jan23
├── Dockerfile
├── pom.xml
├── src/
├── kubernetes/
│   ├── deployment.yaml
│   └── service.yaml
├── .gitignore
└── README.md

Prerequisites
Jenkins running on Ubuntu EC2.
Jenkins tools configured as jdk17 and maven.
Docker installed and accessible by the Jenkins user.
AWS CLI and kubectl installed.
An EC2 IAM role configured for EKS access.
An EKS cluster with the dev namespace.
A Docker Hub repository named my_app under your account.
Jenkins configuration

Create a Jenkins credential:

ID: docker-credentials
Type: Username with password
Username: Your Docker Hub username
Password: Your Docker Hub access token

Configure the pipeline job to use this repository and branch main.

Set Script Path to Jenkinsfile-K8S-jan23, or rename the file to Jenkinsfile and use that path.

AWS and Kubernetes configuration

Configure the EC2 IAM role with access to describe the EKS cluster and authorize it to deploy resources in the dev namespace.

Configure kubeconfig for the Jenkins user and verify:

kubectl get nodes
kubectl get namespace dev


Create the namespace if necessary using an authorized administrator identity:

kubectl create namespace dev

Pipeline stages
Checkout source code.
Verify installed tools.
Build the application with Maven.
Build Docker images with the Jenkins build number and latest tags.
Authenticate to Docker Hub.
Push both image tags.
Apply Kubernetes deployment manifests.
Update the deployed image.
Verify rollout status.
Docker image

The pipeline uses:

docker.io/thanuja/my_app:<BUILD_NUMBER>
docker.io/thanuja/my_app:latest


Update DOCKER_IMAGE in the Jenkinsfile to match your Docker Hub account and repository.

Important

Test the Maven build before deploying. Verify that target/springbootApp.jar exists, that the application listens on port 8085, and that the EKS worker nodes can pull the Docker Hub image.

Never commit credentials or secret configuration files to this repository.
