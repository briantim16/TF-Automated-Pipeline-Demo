# Introduction 
This project creates an Azure DevOps Project, imports a sample Repository, sets up deployment pipelines for multiple target environments (dev and prod) and creates all the backend Azure components.  The point of the demonstration is to show how to use pipelines and credentials to target environments to maintain DRY coding principles; removing the need for multiple repos for multiple environments, no need for sharing credentials with developers that can leak/wind up getting misused, etc…  There are deployment options that can get the demo closer to “real” production or make it work with potentially limited resources; like only having one Azure Subscription to work with vs. multiple.  Once deployed, the demo can be used to do some Terraform dev work just to show/see how it functions in real production.

It is not advisable to use this code in production.  Several security choices have been made for the sake of easy deployment and demonstration that make this a less than ideal production deployment.  It is possible to modify this deployment to make it production ready.  Making those changes is well beyond the scope of this demo.

# Getting Started

Requirements:

•	At least one, preferably two, Azure Subscription(s) that you have “Owner” access to

•	Azure DevOps Organization that you have the ability to create, manage, delete Projects

•	Terraform, Azure CLI, and VS Code installed on your local machine and/or an existing VM – instructions follow on how to set this up if you haven’t previously installed and done this part

If you do not have access to multiple Azure Subscriptions, don’t worry.  That’s not a deal breaker.  All the code and deployments will work with only one Subscription, it is just one step removed from showing the true power of this type of deployment.  Ideally, you have two subscriptions to use for maximum “wow” factor.  

# Build and Test

This demo creates a number of Azure resources.  In the interest of full disclosure, running through the steps below will create two Azure Resource Groups, two Storage Accounts (w/containers), two Key Vaults, two SPN’s (w/”Contributor” permissions to the target Subscription(s)), and the Demo itself will generate a single Azure Resource Group when you run either the “prod” or “dev” pipelines – up to two RG’s if you run both “apply” pipelines.  The storage accounts are not connected to any networks and have anonymous access disabled, they are public facing as is required for the demo to work.  Ideally, you will follow the instructions at the very end of this document to clean up/destroy all these resources with the same automation that created them.  Total cost of this environment (as of Q1 2025) is less than $50/mo on a pay-as-you-go account.  Additional cost will be incurred if you deploy a VM to run all your Terraform code and will vary depending on the VM sku.

Environment Prep

All of the instructions, code, etc… can be deployed from your personal workstation or an Azure VM with a Windows-based OS.  Recommended method is to create a new Azure VM with the latest Windows client OS image.  This allows maximum flexibility and the VM can simply be deleted when you’re done and/or if problems arise that are too complex/cumbersome to troubleshoot.  You can always delete the VM and start over, it’s much more challenging to reimage your personal workstation.

Terraform install/setup

•	If you created a new Azure VM<br>
> Copy “tf-demo.zip” to the VM<br>
> Create an Azure Storage account or leverage an existing<br>
>	    Create a container and upload “tf-demo.zip”<br>
 >   	Log into the Azure Portal while remoted into the newly created VM<br>
  >  	Navigate to the storage account/container and download “tf-demo.zip”<br>
   > 	Extract “tf-demo” to C:\ and it will extract the folders and their contents<br>

•	If you are using your own workstation
        Extract “tf-demo.zip” to c:\ if you want to follow the instructions below without modification; otherwise you will need to manage your path with supplied commands

Once tf-demo.zip has been extracted and folders created, log into your Azure VM or continue with your workstation (whichever option is appropriate):
•	Download latest Windows Terraform package from the Hashicorp website
       	Extract Terraform executable into a folder
            Recommended “C:\Terraform”
        Add the folder to your System Environment Path
        	Note: if you don’t know how to do this, search “modify System Environment Path on Windows 11” in your preferred search engine.  There are ample instructions out there on how to do this

•	Update PowerShell and install Azure extensions
    	Open a PowerShell window as “Administrator” and execute each of the following commands:
        	“Install-Module -Name PowerShellGet -Force”
	        “Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser”
	        “Install-Module -Name Az -Repository PSGallery -Force”
	        “Update-Module -Name Az -Force”

•	Download and install the latest Azure CLI package from Microsoft
    	Can be done via PowerShell, download MSI package, etc…
            Here is the PowerShell command: “Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'”

•	Install VS Code – download latest image from web
    	Optional, but strongly recommended: install VS Code extensions
	        Hashicorp Terraform
	        Azure Terraform
	        PowerShell

•	Verify Terraform/CLI is functioning
    	Open VS Code, open the folder “C:\tf-demo\Code”
	    Open a Terminal window, change directory to “c:…\Code\verify”
	    Log into your Azure account: “az login --use-device-code”
	        If you have multiple Azure subscriptions, ensure you have changed your context to the appropriate subscription and have “Contributor” or “Owner” permissions
	    At the PowerShell Terminal window prompt, type: “terraform init” and hit “enter”
	        This initializes Terraform
	    At the PowerShell Terminal window prompt, type: “terraform plan” and hit “enter”
	        This will show you an output of what Terraform is going to do, indicating it’s going to create a single resource, name, location, etc…
    	At the PowerShell Terminal window prompt, type: “terraform apply -auto-approve” and hit “enter”
        	This will deploy the Resource Group to your Azure subscription
	    Verify in Azure that you can now see the “MCAPS-TF-Validate” Resource Group
	    Return to your PowerShell window, At the PowerShell prompt, type: “terraform destroy -auto-approve” and hit “enter”
	        This will delete the “MCAPS-TF-Validate” Resource Group
	    Congratulations, Terraform is now setup and functioning properly

ADO setup
•	Log into ADO
•	Create a Personal Access Token and save it in a safe/secure location
	    How to create a PAT: https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows
	    Required PAT Scopes – DO NOT just grant full control of everything to the PAT, that is a huge security risk and completely unnecessary for the demo to function. You will need to expand to "show all scopes" in order to assign all required:
	        Agent Pools: Read & manage
            Build: Read & execute
	        Code: Read, write, & manage
	        Deployment Groups: Read & manage
	        Environment: Read & manage
	        Identity: Read & manage
	        Member Entitlement Management: Read & write
	        Pipeline Resources: Use & manage
	        Project and Team: Read, write, & manage
	        Release: Read, write, execute, & manage
            Service Connections: Read, query, & manage
	        Variable Groups: Read, create, & manage
•	Retrieve your Azure DevOps organization url:
	    https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/organization-management?view=azure-devops

Azure setup

•	Open VS Code, open the folder “c:\tf-demo\Code\”
•	In VSCode, open the following files:
    	../terraform/adobuild/terraform.tfvars
    	../terraform/azureprep/terraform.tfvars
•	Follow the instructions in the comments for each file – no other changes need to be made to any files in the demo.  Making additional changes will result in unknown behavior and is not recommended.
•	SAVE YOUR CHANGES
•	Open a Terminal window, change directory to “c:…\Code\CreateAzResources”
•	If you haven’t continued from the previous steps above, log into your Azure account: “az login --use-device-code”, otherwise, skip this step
    	If you have multiple Azure subscriptions, ensure you have changed your context to the appropriate subscription and have “Contributor” or “Owner” permissions
•	At the PowerShell Terminal window prompt, type: “terraform init” and hit “enter”
    	This initializes Terraform
•	At the PowerShell Terminal window prompt, type: “terraform apply -auto-approve” and hit “enter”
    	This will generate two Azure Resource Groups, two Azure Storage Accounts, two Key Vaults, a number of Key Vault secrets, and two Azure SPN’s and apply “Contributor” permissions to the target subscription(s).
o	IF Terraform fails creating a resource, try running the “terraform apply -auto-approve” again, sometimes the Azure/Terraform automation doesn’t get all the automatic ‘depends on’ logic right the first time
o	Open your Azure Portal and verify you now have two Resource Groups:
    	"MCAPS-prod-demo" – w/storage account: prodstoragetfdemo and a Key Vault w/multiple secrets
    	"MCAPS-dev-demo" – w/storage account: devstoragetfdemo and a Key Vault w/multiple secrets

Deploying

•	Open VS Code, open the C:…\Code\Demo folder
	    If you have not done so already, follow the instructions above to get your environment setup and/or follow the readme.md file
•	Open a Terminal window in VS Code, change directory to “c:…\Code\Demo”
•	Log into your Azure tenant and set context to the appropriate Subscription
	    az login --use-device-code
•	In the terminal type: “terraform init” and hit “enter”
•	In the terminal type: “terraform plan”
	    Note: you do not need to specify the terraform.tfvars file because Terraform is smart enough to look for and use that file if it is present in the directory
	    This will run and validate the plan but will not deploy anything
	    If the plan successfully executes move onto the next step
•	In the terminal type: “terraform apply -auto-approve”
	    This will run and apply the Terraform code to your ADO environment
	    NOTE: if there are 401 errors when Terraform is attempting to build the environment, this is likely due to improper permissions on the Personal Access Token, double check that the appropriate scope/permissions have been granted to the PAT and try again.
•	Log into ADO and verify the new ADO Project is visible
	    Run the pipelines, verify in the Azure portal that the appropriate resources are being created, deleted, etc…
        NOTE: you will likely need to approve resource access the first time you run a pipeline, simply approve the request and the pipeline will execute, this is a one-time approval
•	If desired, you can connect to the repo generated by the Demo, create a branch, make some updates, commit, and push with the pipelines – this is purely optional

CLEAN UP YOUR ENVIRONMENT

•	When you are done, clean up the resources from the terminal:
	    Type: “terraform destroy -auto-approve” and hit “enter”
	        This will delete all ADO resources previously deployed by the Demo

•	In the Terminal window, change directory to “c:…\Code\CreateAzResources”
	    Run “terraform init”
	    Run “terraform destroy -auto-approve”, this will destroy the Service Principals, Storage Accounts, Key Vaults and Resource Groups

•	Log into your Azure Portal – manually locate and delete the Resource Group(s) deployed by the ADO pipeline(s)


