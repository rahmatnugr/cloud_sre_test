# Solution for: WebSockets based Web/Mobile Chat App Migration to AWS

According to current condition and resources, the tech stacks that currently used to build Web/Mobile Chatapp on existing infrastructure inside on premise datacenter is shown on the table below:

| No. | Purpose                             | Technology/App   |
| --- | ----------------------------------- | ---------------- |
| 1   | Domain Name Resolving               | DNS Server       |
| 2   | Reverse proxy                       | Nginx (A)        |
| 3   | Serve static webpage (HTML and CSS) | Nginx (B)        |
| 4   | Websocket & Backend Processing      | NodeJS App       |
| 5   | Keeping client connectivity state   | Redis            |
| 6   | Keepping user account               | MySQL            |
| 7   | Firewall, NAT, Internet Gateway     | On-Prem Firewall |

All of that stack must be migrated to AWS Cloud, with these objective below:

- App should be Highly Available
- App should be Scalable
- App should be Highly Fault Tolerant

My approach to architect and design app for cloud migration implementation is:

- Modification to existing app should be minimum to none
- App should be migrated quickly
- App should be cloud agnostic. Wherever app will be hosted, app must be running, using Cloud Native approach, with tooling available on market/opensource world

Here is my proposed solution:

## Solution 1

Migrate to AWS and deploy most of servers using classic EC2 Instance with configured Auto Scaling Group. Static site stored inside S3 Bucket and delivered using CloudFront CDN. Cloudfront also delivering API and Websocket connection from origin load balancer. Here is the diagram of solution 1:

![](/solutions/images/HOOQ_cloud_sre_test-Solution_1.png)

Some of tech stack part will be subtituted with AWS services, described on table below:

### Subtituted Stack

| No. | Purpose                             | Old Tech Stack   | New Tech Stack                                              |
| --- | ----------------------------------- | ---------------- | ----------------------------------------------------------- |
| 1   | Domain Name Resolving               | DNS Server       | **AWS Route 53**                                            |
| 2   | Reverse proxy                       | Nginx (A)        | **AWS Application Load Balancer**                           |
| 3   | Serve static webpage (HTML and CSS) | Nginx (B)        | **AWS S3 & AWS Cloudfront**                                 |
| 4   | Websocket & Backend Processing      | NodeJS App       | **NodeJS App (bundled in an AMI, running in EC2 Instance)** |
| 5   | Keeping client connectivity state   | Redis            | **Redis AMI running in EC2 Instance**                       |
| 6   | Keepping user account               | MySQL            | **MySQL AMI running in EC2 Instance**                       |
| 7   | Firewall, NAT, Internet Gateway     | On-Prem Firewall | **AWS VPC, Internet Gateway, NAT Gateway, Subnet**          |

### Additional Stack

However, to create highly available, scalable, and fault tolerant, we need to add some service that help us achieve our goals:

| No. | Purpose              | New Tech Stack                |
| --- | -------------------- | ----------------------------- |
| 1   | Instance Autoscaling | AWS EC2 Autoscaling           |
| 2   | Certificate Manager  | AWS Certificate Manager (ACM) |
| 3   | Centralized Logging  | Amazon CloudWatch             |

### Tooling

We need some tooling for executing this migration. Here is tool that we gonna use:

| No. | Purpose                         | New Tech Stack                                        |
| --- | ------------------------------- | ----------------------------------------------------- |
| 1   | Bundling App to AMI             | Packer (Bundling Images), Ansible (Config Management) |
| 2   | Infrastructure Provisioning     | Terraform                                             |
| 3   | Upload static file to S3 Bucket | AWS CLI/Terraform                                     |

With this solution, app developer only need to change the app to be packed inside AMI, there is nothing changed in backend and frontend app codebase. App server is also will be auto scale thanks to AWS EC2 Autoscaling. Traffic from internet will be hitting AWS Cloudfront because it also could handle Websocket connection, being front facing delivery network for application load balancer and S3. Redis and MySQL also high available and fault tolerant because configured with cluster mode. But this solution also come with shortfall. AMI is big in file size, because it contains OS and kernel, so app update and deployment will be slow. Redis and MySQL server clusters also need to be managed by self.

So, I come with Solution 2.

## Solution 2

Instead using AMI for packaging, and EC2 for running instance, we moved backend app deployment to AWS ECS Fargate. AWS ECS Fargate using container image for packaging app, so app image size will be decreased compared with AMI file size. MySQL server changed to AWS Aurora for more scalable and better performance, and Redis server changed to AWS Elasticache for Redis. Here is the diagram:

![](/solutions/images/HOOQ_cloud_sre_test-Solution_2.png)

Some of tech stack part changed from Solution 1, described on table below:

### Subtituted Stack

| No. | Purpose                             | Old Tech Stack   | New Tech Stack                                                          |
| --- | ----------------------------------- | ---------------- | ----------------------------------------------------------------------- |
| 1   | Domain Name Resolving               | DNS Server       | **AWS Route 53**                                                        |
| 2   | Reverse proxy                       | Nginx (A)        | **AWS Application Load Balancer**                                       |
| 3   | Serve static webpage (HTML and CSS) | Nginx (B)        | **AWS S3 & AWS Cloudfront**                                             |
| 4   | Websocket & Backend Processing      | NodeJS App       | **NodeJS App (bundled in container image, running in AWS ECS Fargate)** |
| 5   | Keeping client connectivity state   | Redis            | **Amazon Elasticache for Redis**                                        |
| 6   | Keepping user account               | MySQL            | **Amazon RDS Aurora**                                                   |
| 7   | Firewall, NAT, Internet Gateway     | On-Prem Firewall | **AWS VPC, Internet Gateway, NAT Gateway, Subnet**                      |

Same with solution 1, we need to add some service that help us achieve our goals:

| No. | Purpose              | New Tech Stack                |
| --- | -------------------- | ----------------------------- |
| 1   | Instance Autoscaling | AWS ECS Autoscaling           |
| 2   | Certificate Manager  | AWS Certificate Manager (ACM) |
| 3   | Centralized Logging  | Amazon CloudWatch             |
| 4   | Container Registry   | AWS ECR                       |

### Tooling

We still need some tooling for executing this migration. Here is tool that we gonna use:

| No. | Purpose                         | New Tech Stack    |
| --- | ------------------------------- | ----------------- |
| 1   | Bundling App to container image | Docker            |
| 2   | Infrastructure Provisioning     | Terraform         |
| 3   | Upload static file to S3 Bucket | AWS CLI/Terraform |

With this solution, app deployment and update problem dissapear, because time to build container image and upload it to container registry will be faster compared to previous solution. Maintenance will also be easier because AWS ECS Fargate will automatically provision new resource when traffic is high, with autoscaling feature. Same with Amazon Aurora and Amazon Elasticache, because that two services are managed services, scaling and availability will be handled by AWS, so we no need to worry about scalability, availability, and fault tolerancy.

I choose Solution 2 to be implemented in Infrastructure-as-Code with Terraform: [here is the link](/solutions/terraform/).

However, there are some tool to host application on the cloud infrastructure to meet high availability, scalability, and fault tolerant requirement. One of the tool is container orchestration named Kubernetes. So, I designed next solution with Kubernetes implementation.

## Solution 3

Instead using AWS ECS Fargate, backend app deployment moved to AWS Elastic Kubernetes Service (EKS). Communication between backend app and database (Aurora and Elasticache) is using VPC Peering. Here is the diagram:

![](/solutions/images/HOOQ_cloud_sre_test-Solution_3.png)

Tech stack that changed from Solution 2 is only backend processing, described on table below:

### Subtituted Stack

| No. | Purpose                             | Old Tech Stack   | New Tech Stack                                                  |
| --- | ----------------------------------- | ---------------- | --------------------------------------------------------------- |
| 1   | Domain Name Resolving               | DNS Server       | **AWS Route 53**                                                |
| 2   | Reverse proxy                       | Nginx (A)        | **AWS Application Load Balancer**                               |
| 3   | Serve static webpage (HTML and CSS) | Nginx (B)        | **AWS S3 & AWS Cloudfront**                                     |
| 4   | Websocket & Backend Processing      | NodeJS App       | **NodeJS App (bundled in container image, AWS EKS)**            |
| 5   | Keeping client connectivity state   | Redis            | **Amazon Elasticache for Redis**                                |
| 6   | Keepping user account               | MySQL            | **Amazon RDS Aurora**                                           |
| 7   | Firewall, NAT, Internet Gateway     | On-Prem Firewall | **AWS VPC, VPC Peering, Internet Gateway, NAT Gateway, Subnet** |

Additional service that help us achieve our goals:

| No. | Purpose                  | New Tech Stack                           |
| --- | ------------------------ | ---------------------------------------- |
| 1   | Certificate Manager      | AWS Certificate Manager (ACM)            |
| 2   | Centralized Logging      | Amazon CloudWatch                        |
| 3   | Container Registry       | AWS ECR                                  |
| 4   | Kubernetes Control Plane | AWS EKS Control Plane (bundled with EKS) |

### Tooling

We still need some tooling for executing this migration. Here is tool that we gonna use:

| No. | Purpose                         | New Tech Stack    |
| --- | ------------------------------- | ----------------- |
| 1   | Bundling App to container image | Docker            |
| 2   | Infrastructure Provisioning     | Terraform         |
| 3   | Upload static file to S3 Bucket | AWS CLI/Terraform |
| 4   | App Deployment and Management   | kubectl, Helm     |

---

All above diagrams are accessible here: [draw.io](https://drive.google.com/file/d/1wDYrGmQ9Zd_guG8geJarMYNz1egOghnU/view?usp=sharing)
