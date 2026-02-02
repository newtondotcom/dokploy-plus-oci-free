# Dokploy Deployment on OCI Free Tier

This Terraform project deploys a Dokploy instance along with worker nodes, object storage, and cost monitoring in Oracle Cloud Infrastructure (OCI) Free Tier. **Dokploy** is an open-source platform to manage your app deployments and server configurations.

## Architecture

This project consists of three independent modules:

- **Dokploy Module**: Compute instances (master + workers), networking, and Docker Swarm cluster
- **S3 Module**: Object storage buckets with S3-compatible access for backups and media
- **Alert Module**: Budget monitoring and email notifications for cost control

Each module can be deployed, planned, or destroyed independently using the justfile commands.
All of them fall under [Oracle Free Tier](https://www.oracle.com/cloud/free/)

## Quick Start

1. **Set up OCI authentication** (see [Prerequisites](#prerequisites) section below)
2. **Prepare your keys**:
   - Generate or place your SSH public key in `./user/vm_ssh_key.pub`
   - Place your OCI API private key in `./user/oci_api_key.pem`
3. **Configure variables** in `terraform.tfvars` or via environment variables
4. **Deploy**:
   ```bash
   terraform init
   terraform plan
   ```

   Then apply all modules or select specific ones:
   ```bash
   # Deploy everything
   just apply
   
   # Or deploy individual modules
   just apply-s3       # Object storage only
   just apply-alert    # Budget alerts only
   just apply-dokploy  # Dokploy infrastructure only
   
   # View S3 secret keys after deployment
   just show-s3-keys
   ```

## About Dokploy

![Dokploy Logo](doc/dokploy-logo.webp)

Dokploy is an open-source deployment tool designed to simplify the management of servers, applications, and databases on your own infrastructure with minimal setup. It streamlines CI/CD pipelines, ensuring easy and consistent deployments.

For more information, visit the official page at [dokploy.com](https://dokploy.com).

![Dokploy Screenshot](doc/dokploy-screenshot.png)

## OCI Free Tier Overview

Oracle Cloud Infrastructure (OCI) offers a Free Tier with resources ideal for light workloads, such as the VM.Standard.A1.Flex. These resources are free as long as usage remains within the limits.

For detailed information about the free tier, visit [OCI Free Tier](https://www.oracle.com/cloud/free/).

*Note: Free Tier instances are subject to availability, and you might encounter "Out of Capacity" errors. To bypass this, upgrade to a paid account. This keeps your free-tier benefits but removes the capacity limitations, ensuring access to higher-tier resources if needed.*

## Prerequisites

Before you begin, ensure you have the following:

-   `tofu` installed
-   An Oracle Cloud Infrastructure (OCI) account with Free Tier resources available.
-   An SSH public key for accessing the instances.
-   Established API key authentication.

### API Key Authentication Setup

This project uses OCI authentication with API keys. Follow these steps to set up authentication:

#### Option 1: Create API Key via OCI Console

1. **Create API Key**:
   - Log in to the [OCI Console](https://cloud.oracle.com)
   - Navigate to: **Identity** → **Users** → Select your user → **API Keys** → **Add API Key**
   - Choose **Paste Public Key** or **Generate Key Pair**
   - If generating a key pair, save the private key securely (e.g., `./user/oci_api_key.pem`)
   - Copy the **Fingerprint** and **User OCID** from the API key details

#### Option 2: Create API Key via OCI CLI

1. **Install OCI CLI**:
   ```bash
   # macOS
   brew install oci-cli
   
   # Linux
   bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
   ```

2. **Configure OCI CLI**:
   ```bash
   oci setup config
   ```
   - Enter your **Tenancy OCID** when prompted
   - Enter your **User OCID** when prompted
   - Enter your **Region** (e.g., `eu-paris-1`)
   - Enter the path to your **Private Key** (e.g., `./user/oci_api_key.pem`)
   - Enter your **Fingerprint** when prompted

#### Get Required OCIDs

- **Tenancy OCID**: Navigate to **Profile** → **Tenancy: youruser** → **Tenancy information** → Copy the **OCID**
- **User OCID**: Navigate to **Identity** → **Users** → Select your user → **User Information** → Copy the **OCID**

#### Store Your Keys

1. **SSH Key** (for instance access):
   ```bash
   # Generate a new SSH key pair
   ssh-keygen -t ed25519 -f ./user/vm_ssh_key
   ```
   Or place your existing SSH public key in `./user/vm_ssh_key.pub`

2. **OCI API Key** (for Terraform):
   - Place your OCI API private key in `./user/oci_api_key.pem` (or update the path in variables)

> **Note**: The `/user` folder is recommended for storing dedicated SSH keys and OCI API keys. Make sure to add it to `.gitignore` to avoid committing sensitive keys. 

## Servers & Cluster

### Add Servers to Dokploy

To begin deploying applications, you need to add servers to your Dokploy cluster. A server in Dokploy is where your applications will be deployed and managed.

#### Steps to Add Servers:

1.  **Login to Dokploy Dashboard**:
    -   Access the Dokploy dashboard via the master instance's public IP address (check Terraform outputs after deployment)
    -   Use the login credentials configured during setup

2.  **Add SSH Keys**:
    -   On the left-hand menu, click on **SSH Keys** and add your private and public SSH key to connect to your servers

3.  **Navigate to Servers Section**:
    -   On the left-hand menu, click on **Servers** and then **Add Server**

4.  **Fill in Server Details**:
    -   **Server Name**: Give your server a meaningful name
    -   **IP Address**: Enter the public IP address of the instance (or private IP if using private networking)
    -   **SSH Key**: Select the previously created SSH key
    -   **Username**: Use `root` as the SSH user

5.  **Submit**:
    -   After filling out the necessary fields, click **Submit** to add the server

### Configure a Dokploy Cluster with new workers

After setting up the master Dokploy instance, you can expand your cluster by adding master or worker nodes. These worker instances will help distribute the workload for your deployments.

See more info about configuring your cluster on the [Dokploy Cluster Docs](https://docs.dokploy.com/docs/core/cluster#adding-nodes).

## Project Structure

This project is organized into three Terraform modules for better separation of concerns and independent management:

### Modules

#### 1. **S3 Module** (`modules/s3/`)
Manages Oracle Cloud Object Storage resources with S3-compatible access:
- Creates Standard and Archive tier storage buckets
- Generates S3-compatible access keys and secret keys for both buckets
- Provides S3 endpoint configuration for application integration
- **Use case**: Store backups, media files, application assets, and archive data

#### 2. **Alert Module** (`modules/alert/`)
Handles cost monitoring and billing alerts:
- Creates budget tracking for your OCI tenancy
- Configures alert rules to notify when spending begins (>$0.01)
- Sends email notifications when budget thresholds are reached
- **Use case**: Monitor costs and prevent unexpected charges on Free Tier

#### 3. **Dokploy Module** (`modules/dokploy/`)
Deploys the core Dokploy infrastructure:
- Provisions master and worker compute instances
- Sets up VCN, subnets, and security groups for networking
- Configures Docker Swarm cluster for container orchestration
- Distributes resources across availability domains for high availability
- **Use case**: Host and manage your applications with Dokploy's web interface

### Root Files

-   `bin/`: Contains bash scripts for setting up Dokploy on both the master instance and the worker instances.
    -   `dokploy-master.sh`: Script to install Dokploy on the master instance.
    -   `dokploy-worker.sh`: Script to configure necessary dependencies on worker instances.
-   `doc/`: Directory for images used in the README (e.g., screenshots of Dokploy setup).
-   `main.tf`: Root configuration that orchestrates all three modules.
-   `outputs.tf`: Aggregates outputs from all modules (dashboard URL, IPs, S3 credentials, etc.).
-   `providers.tf`: Declares the required cloud providers and versions, particularly for Oracle Cloud Infrastructure.
-   `variables.tf`: Defines input variables used across all modules.
-   `justfile`: Contains convenient commands for managing modules independently or together.

## Terraform Variables

Below are the key variables for deployment which are defined in `variables.tf`:

### OCI Provider Variables (Mandatory)

These variables are required for OCI provider authentication:

-   `tenancy_ocid`: The OCID of your tenancy. Find it: **Profile** → **Tenancy: youruser** → **Tenancy information** → **OCID**
-   `user_ocid`: The OCID of your OCI user. Find it: **Identity** → **Users** → Select your user → **User Information** → **OCID**
-   `fingerprint`: The fingerprint of your API key. Find it: **Identity** → **Users** → Select your user → **API Keys** → Copy the fingerprint
-   `private_key_path`: Path to your OCI API private key file (Default: `"./user/oci_api_key.pem"`)
-   `region`: OCI region where resources will be deployed (Default: `"eu-paris-1"`)

### Dokploy Configuration Variables

-   `ssh_public_key_path`: Path to the SSH public key file used to access the instances after deployment. (Default: `"./user/vm_ssh_key.pub"`)
-   `num_master_instances`: Number of Dokploy master instances to deploy. **Note: Dokploy only supports one master instance.** (Default: `1`)
-   `num_worker_instances`: Number of Dokploy worker instances to deploy. (Default: `1`)

### Automatic Configuration

The following values are automatically calculated based on Oracle Cloud Free Tier limits and the number of instances:

-   **Memory (memory_in_gbs)**: Automatically distributed as `24 GB / (num_master_instances + num_worker_instances)` to comply with free tier limits
-   **OCPUs**: Automatically distributed as `4 OCPUs / (num_master_instances + num_worker_instances)` to comply with free tier limits
-   **Boot Volume Size**: Automatically calculated as `200 GB / num_worker_instances` per instance
-   **Availability Domains**: Master and worker instances are automatically distributed evenly across all available availability domains in your region


### Important Note

**Dokploy only supports one master instance.** Setting `num_master_instances` to more than `1` is not supported by Dokploy.