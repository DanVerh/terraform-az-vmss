# Azure VMSS with Terraform
This Terraform code is used to create a configured Azure Virtual Machine Scale Set.

# Scaling
- Virtual Machines are scaled here depending on both metrics and schedule.

# Load balancer
- Load Balancer here is balancing traffic between all instances of the VMSS backend pool.
- Port 80 is used as frontend and backend port of load balancer.
- Health probe is set on port 80 and / path.

# Configuration
- Configuration is done using the Custom Extension.
- Automatic Update is enabled in VMSS, soevery machine will be effected immedieately after new VM is created or script is updated.
- Script is located in Azure BLOB
