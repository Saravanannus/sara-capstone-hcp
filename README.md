


## List of AWS Resources used in this Project: ##

**1. GitHub Actions** – Automates the CI/CD pipeline.

**2. Amazon ECR** – Stores Docker images for different environments (dev, stage, prod).

**3. Amazon ECS Fargate** – Runs containerized services without managing infrastructure.

**4. Security Group** – Manages network access, allowing HTTP traffic on port 8080.


**6. VPC and Public Subnets** – Provides networking and connectivity for the ECS tasks.

**7. IAM Roles and Policies** – Manages access to AWS resources from ECS and GitHub Actions.

### Architecture

**1.** Source Code Management:
GitHub hosts the code and triggers workflows on specific events like pull requests or merges.

**2.** CI/CD Workflow:
GitHub Actions handles the CI/CD process with distinct workflows for:

- **Development (DEV)** environment
- **Production (PROD)** environment

**3.** Infrastructure as Code (IaC):
Terraform Cloud manages the infrastructure definitions for both environments.

**4.** Cloud Provider:
AWS hosts the deployed resources such as ECR,ECS &Fargate,etc.. for the DEV and PROD environments.

## Workflow Explanation

**1. Workflow Invocation:**

- GitHub triggers the workflow on code commits or pull requests.

- The workflow file defines the stages: build, test, plan, and deploy.

**2. DEV and PROD Environments:**

- Separate workflows ensure that changes are validated in DEV before reaching PROD.

- The **Terraform Cloud** plan is applied to the respective AWS environment after successful tests.

## Folder Structure


## Usage Instructions

**1. Setup Terraform Cloud:**

- Link Terraform Cloud with your repository.
- Define workspaces for dev and prod.


**3. Triggering Workflows:**

- Push code to the dev branch to trigger the DEV workflow.

- Test -> Build -> deploy to dev -> After Approval -> deploy to prod

- Merge to main to trigger the PROD workflow.


#### 4. Networking and Security:

Each ECS cluster is deployed within a VPC using public subnets and security groups.
The security group allows HTTP traffic on port 8080 to access the running containers.

### Architecture Flow for ECS with GitHub Actions CI/CD


#### 2. AWS ECR (Elastic Container Registry)

- Stores Docker images, tagged with versions like latest or commit SHA (:abc123).

- GitHub Actions authenticates and pushes images to specific repositories (dev or prod).


#### 4. AWS Fargate Tasks & Services

ECS services run **Node.js containers** inside **Fargate tasks.**

Each service is exposed on **port 8080.**

#### 5. Networking Components

**VPC with Public Subnets:** Each cluster resides inside a Virtual Private Cloud (VPC) with public-facing subnets.

**Security Groups:** Allow **inbound HTTP traffic on port 8080** and permit all outbound traffic.

#### 6. Deployment Flow

**Push to GitHub → Build Image → Push to ECR → Deploy to ECS (Dev or Prod)**

**Terraform Installed:** 

- Ensure Terraform is installed on your local machine for infrastructure provisioning.

**AWS CLI:**

- Install the AWS CLI for managing AWS resources.

**Deployment Steps:**

**1.** Clone the Repository
Start by cloning this repository to your local machine:

 Copy code
git clone https://github.com/your-username/your-repo.git
cd your-repo

**2.** Build the Docker Image
This project is containerized using Docker. The Dockerfile is already provided, which defines how the application is built. You can build the Docker image locally by running:

docker build -t your-application-name .
If you want to test the application locally, run the container by running code:

docker run -p 8080:8080 your-application-name

This will expose the application on http://localhost:8080.


**5.** Health Check & Monitoring
We recommend adding a health check endpoint (e.g., /health) to your application so ECS can verify the status of your service. 

ECS will periodically send health check requests to this endpoint and ensure the application is running smoothly.

Set up CloudWatch for logging and monitoring ECS tasks:

ECS logs can be streamed to CloudWatch to track any errors or important application events.You can also set up CloudWatch Alarms to monitor the health of your ECS service, such as task failures or high CPU/memory usage.

**6.** Ingress Traffic & Security Considerations
For security purposes, ensure that ingress traffic is only allowed from specific IP ranges or secured over HTTPS. The ECS service security group currently allows traffic from all sources (0.0.0.0/0), but for production environments, it’s recommended to restrict access. Limit to specific trusted IP addresses or regions.Enforce HTTPS by integrating AWS Certificate Manager (ACM) with Application Load Balancer (ALB) or CloudFront for SSL/TLS termination.

**Summary:**

This project leverages Docker for containerization, Terraform for AWS resource management, and GitHub Actions for automating the deployment pipeline. By following the steps outlined above, your Node.js application will be deployed on ECS using AWS Fargate, and the pipeline will automatically rebuild and deploy any changes pushed to the main branch.Make sure to monitor the application’s logs and performance in CloudWatch and ensure security best practices by restricting ingress traffic and enforcing HTTPS for production environments.
