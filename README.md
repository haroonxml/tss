## FintechOS
FintechOSAzureTemplate

<a href="https://azuredeploy.net/" target="_blank">
    <img src="https://raw.githubusercontent.com/valentindumitrescu/FintechOS/ftos_core/deploytoazure.png"/>
</a>


This template deploys FintechOS


## Solution overview and deployed resources

This is an overview of the solution

The following resources are deployed as part of the solution.

- A storage account to host virtual machine disks
- A virtual network and a subnet.
- A virtual machine. Default size is B2ms
- One SQL Database. Deafult size is S0 Standard
- FintechOS Portal
- FintechOS Designer


## Deployment steps

Click the "deploy to Azure" button at the beginning of this document and fillin the required data. 
You need to change default values to avoid conflict with already existing resources.

The following communication ports to virtual machine are opened during deployment in order to accept connections from any location to virtual machine and application:
Http: 80; Https: 443; RDP: 3389

## Usage

The username and password filled in during deployment can be used to logon into virtual machine and Microsoft SQL server.
Default UserName is: "FTOSadmin"
Default password is "change_FTOSpassword".

You can connect to the application by accessing the following urls:

	http://'virtualmachinepublicname'/FTOS_portal for FintechOS Portal
	http://'virtualmachinepublicname'/FTOS_designer for FintechOS Designer

Virtual machine name is build using the information filled in the parameters page for "virtualmachine_name".
Example if you filled in virtualmachine_name: "fintechossrv" and the resource group is in "West Europe", the virtualmachinepublicname	(fqdn) will be:fintechossrv.westeurope.cloudapp.azure.com
	
	
