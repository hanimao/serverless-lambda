# Project Overview

This repository deploys a Node.js WebAPI and a SQL Server database on AWS. It also includes a CI/CD pipeline using GitHub Actions to automate deployment of code changes to the API. The infrastructure is designed to be modular, scalable, and extendable for future enhancements. Lambda was used to host the Node.js WebAPI and the API Gateway exposes HTTP endpoints for the Lambda function



# Table of Contents 

1. [Architecture Diagram](#architecture-diagram) 
2. [Getting Started](#getting-started)
3. [Terraform Infrastructure](#terraform-infrastructure)
4. [Services](#services)



# Architecture Diagram 

![architecture diagram](<images/architecture.drawio.svg>)

![serverless](images/app.png)


# Getting Started

## Prerequisites 

Before using this repository, ensure you have the following installed and configured on your machine:

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

 ## Configure AWS CLI

```bash
$ aws configure
AWS Access Key ID [None]: accesskey
AWS Secret Access Key [None]: secretkey
Default region name [None]: your region
Default output format [None]:
```

## Clone Repository 

```bash
git clone <repository-url>
```


## Lambda Deployment zip 

`Install dependencies locally:`

```bash 
npm install
```

`Zip the application code and node_modules:`

```bash 
zip -r deployment.zip .
```

# Terraform Infrastructure 

The AWS infrastructure was organised into reusable modules to build the infrastructure and this approach promotes the DRY (Don't Repeat Yourself) principle and makes your code scalable and maintainable. Terraform was used to provision the infrastructure, with the state backend securely hosted on AWS S3, enabling reliable tracking. 


## Terraform directory 

```text

serverless/
├── infra/
│   ├── environments/
│   │   ├── dev/
│   │   │   ├── backend.tf
│   │   │   ├── component.tf
│   │   │   ├── main.tf
│   │   │   ├── oidc.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── prod/
│   └── modules/
│       ├── api/
│       ├── database/
│       ├── lambda/
│       └── networking/
├── src/
│   └── handler/
│       ├── node_modules/
│       ├── index.js
│       ├── package-lock.json
│       └── package.json
├── .gitignore
├── .pre-commit-config
└── README.md
   
```


# Services


- **AWS Lambda**: A serverless compute service used to host the Node.js WebAPI. Lambda allows the application to run without provisioning or managing servers. It automatically scales based on traffic, and you only pay for the compute time consumed by your code.
- **API Gateway v2 (HTTP API)**: Exposes HTTP endpoints for the Lambda function, enabling clients to interact with the WebAPI. API Gateway handles routing, request validation, and security, providing a managed entry point for the API.
- **Amazon RDS (SQL Server)**: A fully managed relational database service used to store the application’s data. The SQL Server instance is provisioned with standard compute (`db.t3.medium`) and includes automated backups, monitoring, and maintenance. It is easily upgradable for future performance or availability requirements.
- **Terraform**: An Infrastructure-as-Code (IaC) tool used to define, provision, and manage AWS resources declaratively. Terraform ensures that the infrastructure is reproducible, version-controlled, and can be modified or extended with minimal effort.
- **GitHub Actions**: Provides the CI/CD pipeline to automatically build, test, and deploy changes to the Node.js WebAPI. When code is pushed to the main branch, the workflow packages the Lambda function, runs tests, and deploys the code to AWS, ensuring fast and reliable updates.
- **IAM Roles**:


