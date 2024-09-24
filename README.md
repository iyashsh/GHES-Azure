# GitHub Enterprise Server (GHES) on Azure with Terraform and Ansible

## Objective
This project automates the deployment and management of **GitHub Enterprise Server (GHES)** on **Microsoft Azure** using **Terraform** and **Ansible** to ensure high availability, compliance, and data recovery.

## Prerequisites
- Basic understanding of **Terraform** and **Ansible**.
- Azure account (Free or Paid).
- GitHub Enterprise Server trial version or license.
- Tools installed: **Terraform**, **Ansible**, **Azure CLI**, and **GitHub CLI**.

## System Requirements
- **Primary and Replica GHES Servers**:
  - 4 x86-64 vCPUs
  - 32 GB Memory
  - 200 GB Root Storage
  - 150 GB Attached (Data) Storage
- **Developer's Local Machine**:
  - 2 vCPUs
  - 8 GB Memory
  - 100 GB Disk Space

## Installation and Setup
Follow the steps below to set up the project and deploy GHES on Azure:

1. **Clone the repository**:
    ```bash
    git clone https://github.com/iyashsh/GHES-Azure
    cd GHES-Azure
    ```

2. **Azure Setup**:
    - Configure Azure CLI and authenticate your Azure account.
    - Create a Resource Group and Service Principal.

3. **Terraform Setup**:
    - Define and configure infrastructure in the Terraform files.

4. **Ansible Setup**:
    - Configure Ansible playbooks for automation tasks.


## Workflow and Best Practices
- The project follows **Infrastructure as Code (IaC)** principles, with **Terraform** used for provisioning Azure resources and **Ansible** for automating post-deployment tasks such as failover management and compliance monitoring.
- For best practices, it's recommended to store infrastructure code in a separate version control system, like **GitHub.com**, to avoid dependencies on the GHES server itself.

## Repository Structure
```plaintext
/GHES-Azure                      # Root directory of the infrastructure project
├── /terraform                   # Terraform configurations
├── /ansible                     # Ansible playbooks and configurations
├── /scripts                     # Any scripts for automating GHES tasks
├── .gitignore                   # Files to exclude from version control
└── README.md                    # Summarized documentation, for detail documentation check: [Dummies Guide](./doc/)
```

## How to Contribute
Contributions are welcome! Please follow the GitHub flow:
- Fork the repository.
- Create a new branch for your changes.
- Submit a pull request for review.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
