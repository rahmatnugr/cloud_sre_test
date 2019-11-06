# Solution for: Migration Web/Mobile chat with WebSockets to AWS

## Solution 1
Migrate to AWS and deploy most of servers using classic EC2 Instance with configured Auto Scaling Group. Static site stored inside S3 Bucket and delivered using CloudFront CDN. 

![](/solutions/images/HOOQ_cloud_sre_test-Solution_1.png)
  
## Solution 2
Backend App deployment moved to AWS Fargate. MySQL server changed to AWS Aurora for more scalable and better performance. Redis server changed to AWS Elasticache for Redis. 

![](/solutions/images/HOOQ_cloud_sre_test-Solution_2.png)

## Solution 3
Backend App deployment moved to AWS Elastic Kubernetes Service. Communication between backend app and database (aurora and elasticache) is using VPC Peering. 

![](/solutions/images/HOOQ_cloud_sre_test-Solution_3.png)


Diagram are accessible here: [draw.io](https://drive.google.com/file/d/1wDYrGmQ9Zd_guG8geJarMYNz1egOghnU/view?usp=sharing)