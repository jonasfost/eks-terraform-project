# cloud-security-project

My company wants to introduce a new line of business to allow customers to upload and view photos online. The Application will be using a Nodejs and Mongo Database stack. I have been asked to develop a PoC to demonstrate the application to senior executives. 

The following are the requirements:

- CICD for Docker Container Image Building and Publishing: Use the files from the image-app folder in google drive and establish a process to build and publish the app as a container image to your docker hub private repository. Image build should trigger on push to a branch called image-app-build. Image build must be integrated with vulnerability scans.
- KS Cluster via Github action: Establish a deployment pipeline to deploy the image application to EKS using github action and the image stored in your docker hub private registry. The EKS application should be accessible using e.g https://poc.fojilabs.com
- EKS Cluster Monitoring: Implement a WAF to protect your application from common web attacks.
- EKS Cluster Monitoring: Implement EKS Cluster Monitoring using open-source platforms like Prometheus and Grafana to provide visibility about your cluster health and workloads.
- Application Synthetic monitoring: Establish a process to monitor the performance and availability of your application. We will use cloudwatch synthetics for this.



