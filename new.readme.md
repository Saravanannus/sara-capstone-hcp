<h1>Capstone Project: ECS Deployment</h1>

<h3>Project Team</h3>
<ul>
    <li><strong>Jyoti </strong>Rani</li>
    <li><strong>Keren </strong>Priya</li>
    <li><strong>Saravanan </strong>B</li>
    <li>Vedarethinam <strong>Vennila</strong></li>
</ul>
<p>Students of PaCE@NTU enrolled in the SCTP Cloud Infrastructure Engineering course.</p>

---

<h3>Project Overview</h3>
<ul>
    <li><strong>Project Name</strong>: Capstone ECS Deployment</li>
    <li><strong>Repository</strong>: GitHub Repository</li>
</ul>
<p>This project automates the deployment of a Node.js application using Docker on Amazon ECS, utilizing GitHub Actions for Continuous Integration and Continuous Deployment (CI/CD) and Terraform for infrastructure provisioning.</p>

---

<h3>Project Objectives</h3>
<ul>
    <li>Implement a CI/CD pipeline using GitHub Actions for automated building, testing, and deployment of a Dockerized application to AWS ECS.</li>
    <li>Provision and manage AWS infrastructure using Terraform, ensuring reliable and scalable application deployment.</li>
</ul>

---

<h3>Architecture Diagram</h3>
<p>The architecture diagram below depicts the project's structure and interactions between components:</p>

<pre><code>+-------------------------------------+
|          GitHub Repository          |
|    +---------------------------+    |
|    |    Branching Strategies   |    |
|    |      (Main/Feature)      |     |
|    +---------------------------+    |
|                  |                  |
|                  |                  |
|                  v                  |
|    +---------------------------+    |
|    |     GitHub Actions CI/CD  |    |
|    |  (Continuous Deployment)  |    |
|    +---------------------------+    |
|                  |                  |
|                  v                  |
|    +---------------------------+    |
|        Amazon ECR (Docker Images)   |
|    +---------------------------+    |
|                  |                  |
|                  v                  |
|    +---------------------------+    |
|         Amazon ECS (Fargate)        |
|    +---------------------------+    |
|    |    Running Application    |    |
|    +---------------------------+    |
|                  |                  |
|                  v                  |
|    +---------------------------+    |
|       Monitoring & Logging      |   |
|    +---------------------------+    |
+-------------------------------------+</code></pre>
<p>The architecture consists of a Node.js application running in Docker containers on Amazon ECS, with a CI/CD pipeline configured through GitHub Actions.</p>

---

<h3>Getting Started</h3>
<h4>Tools and Technologies used:</h4>
<h4>Dependencies</h4>
<ul>
    <li>Node.js</li>
    <li>Express</li>
    <li>Jest (for testing)</li>
    <li>Docker</li>
</ul>

<h4>Application Structure</h4>
<pre><code>/ce6-capstone-grp1
|-- terraform
    |-- dev
        |-- infra
            |-- main.tf
            |-- provider.tf
            |-- version.tf
    |-- prod
        |-- infra
            |-- main.tf
            |-- provider.tf
            |-- version.tf
|-- .gitignore
|-- Dockerfile
|-- README.md
|-- index.js
|-- package.json
|-- package-lock.json
|-- sum.test.js
</code></pre>

---

<h3>Project Development Details</h3>
<h4>Steps Overview</h4>
<ol>
    <li><strong>Set Up GitHub Variables</strong>: Ensure that the following environment-specific variables are set in GitHub Repository Settings:
        <ul>
            <li>ECR_REPOSITORY (for both dev and prod)</li>
            <li>ECS_SERVICE (for both dev and prod)</li>
            <li>ECS_CLUSTER (for both dev and prod)</li>
            <li>AWS_REGION (for both dev and prod)</li>
        </ul>
    </li>
    <li><strong>Set up AWS credentials globally in GitHub Secrets</strong>:
        <ul>
            <li>AWS_ACCESS_KEY_ID</li>
            <li>AWS_SECRET_ACCESS_KEY</li>
        </ul>
    </li>
    <li><strong>Push Changes and Merge Feature Branch into Main</strong>:
        <ul>
            <li>Develop the feature in a feature branch and push the changes.</li>
            <li>Create a Pull Request (PR) to merge the feature branch into the main branch.</li>
            <li>Merge the PR into the main branch.</li>
        </ul>
    </li>
    <li><strong>Run Terraform Plan and Apply using HCP Terraform</strong>:
        <ul>
            <li>After changes are merged into the main branch, use HCP Terraform to plan and apply infrastructure changes.</li>
            <li>HCP Terraform should be integrated into the workflow to:
                <ul>
                    <li>Plan changes to AWS resources like ECS services, ECR repositories, etc.</li>
                    <li>Apply the infrastructure changes if the plan looks good.</li>
                </ul>
            </li>
        </ul>
    </li>
    <li><strong>Trigger GitHub Actions Manually</strong>:
        <ul>
            <li>Once the infrastructure is updated, trigger the GitHub Action workflow manually to deploy the ECS application.</li>
            <li>The GitHub Action should:
                <ul>
                    <li>Pull the latest image from the ECR_REPOSITORY.</li>
                    <li>Update the ECS service in the target environment.</li>
                </ul>
            </li>
        </ul>
    </li>
</ol>

---

<h3>Docker Setup for the Application</h3>
<p>The application is containerized using Docker. Below is the Dockerfile that describes how to build the application image.</p>

<h4>Dockerfile</h4>
<pre><code>FROM node:16-alpine
WORKDIR /my-app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD [ "node", "index.js" ]</code></pre>

<h4>Application Code (index.js)</h4>
<pre><code>'use strict';
const express = require('express');
const PORT = 8080;
const HOST = '0.0.0.0';
const app = express();

app.get('/', (req, res) => {
  res.send('Hello from ce6-capstone-grp1!');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);</code></pre>

---

<h3>CI/CD Pipeline</h3>
<h4>1. GitHub Actions Workflow for Continuous Deployment</h4>
<p>This workflow automates building, testing, and deploying a Dockerized application to Amazon ECS. It consists of two main jobs: one for building the Docker image and pushing it to Amazon ECR, and the other for deploying the application to the ECS cluster in both development and production environments.</p>
<h4>Continuous-Deploy.yml Workflow File</h4>
<p><strong>Trigger</strong>: The workflow is triggered manually (<code>workflow_dispatch</code>), allowing for on-demand deployments.</p>
<p><strong>Environment Variables</strong>: Set for easier reuse of names and identifiers like container names, regions, and repository names.</p>

<h4>Jobs Overview:</h4>
<ul>
    <li><strong>build-image</strong>: This job builds a Docker image, pushes it to Amazon ECR, and stores the image tag as an artifact.
        <ul>
            <li><strong>Steps</strong>:
                <ol>
                    <li>Checkout the code.</li>
                    <li>Install dependencies (Node.js and npm).</li>
                    <li>Run tests with <code>npm test</code>.</li>
                    <li>Configure AWS credentials using GitHub secrets.</li>
                    <li>Build the Docker image, tag it, and push it to Amazon ECR.</li>
                    <li>Save the image information for the deployment job.</li>
                </ol>
            </li>
        </ul>
    </li>
    <li><strong>deploy-dev and deploy-prod</strong>: 
<p>These jobs deploy the Docker image to ECS for the dev and prod environments, respectively.</p>

<h3>Steps:</h3>
<ol>
    <li>Download the image information artifact.</li>
    <li>Output the image URL.</li>
    <li>Retrieve the ECS task definition.</li>
    <li>Update the task definition with the new Docker image.</li>
    <li>Deploy the updated task definition to ECS.</li>
</ol>

<h3>Deployment Conditions:</h3>
<ul>
    <li>For production deployment, the job runs after a successful dev deployment.</li>
    <li>The task definitions for ECS services (<strong>web-dev</strong> and <strong>web-prod</strong>) are updated with the new image before deployment.</li>
</ul>

<h2>Terraform Infrastructure for ECS</h2>
<p>Terraform is used to provision and configure AWS infrastructure for the ECS service. The environment folders (<strong>dev/infra</strong> and <strong>prod/infra</strong>) contain configuration files to set up ECS clusters, security groups, and ECS services.</p>

<h3>Key Terraform Files:</h3>
<ul>
    <li><strong>provider.tf</strong>: Specifies the AWS provider and region.</li>
    <li><strong>version.tf</strong>: Sets the required Terraform and AWS provider versions.</li>
    <li><strong>main.tf</strong>: Contains the configuration for the ECS clusters, services, and task definitions.</li>
</ul>

<h2>Explanation of Branching Strategies</h2>

<h3>Main Branch:</h3>
<ul>
    <li>The primary branch where stable code resides.</li>
    <li>Represents the production-ready state of the application and should always be deployable.</li>
    <li>All changes merged into the main branch should have undergone testing and code review processes to ensure quality.</li>
    <li>Direct commits to the main branch are discouraged; feature branches should be created and merged via Pull Requests (PRs).</li>
</ul>

<h3>Feature Branch:</h3>
<ul>
    <li>Created to work on new features or bug fixes independently of the main codebase.</li>
    <li>Each feature branch is typically created from the latest main branch and should have a descriptive name related to the feature being developed.</li>
    <li>Once development is complete, a PR is created to merge the feature branch back into the main branch.</li>
    <li>This strategy allows for collaborative development, enabling multiple developers to work on different features simultaneously without interference.</li>
</ul>

<h2>Workflow Diagram</h2>
<p>Waiting for review to deploy to prod<br>After deployed to prod</p>

<!-- Image added here as Base64 -->
<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAIAAAB7GkOtAAAACXBIWXMAABcRAAAXEQHKJvM/AA..." alt="Workflow Diagram">

---

<h3>Future Improvements</h3>
<ul>
    <li>Implement automated rollback in case of deployment failures.</li>
    <li>Set up monitoring and alerting for the ECS services to track performance and failures.</li>
    <li>Enhance security measures, such as using AWS IAM roles and policies for fine-grained access control.</li>
</ul>

---

<h3>Challenges Faced</h3>
<ul>
    <li>Debugging CI/CD pipeline failures due to incorrect environment configurations.</li>
    <li>Managing Docker image versions and ensuring proper tagging.</li>
    <li>Ensuring smooth communication between different services and environments.</li>
    <li>Troubleshooting issues during deployment and automating processes effectively.</li>
</ul>

---

<h3>Conclusion</h3>
<p>This capstone project successfully automates the deployment of a Node.js application on AWS ECS, showcasing the power of CI/CD pipelines, containerization, and infrastructure as code. The skills acquired throughout this project will be invaluable for future cloud infrastructure projects and DevOps practices.</p>

</body>
</html>
