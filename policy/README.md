# Introduction 
This repo contains the code to deploy the guardrails to enforce requirements.

Folders:

assignments - Contains the module to create the assignment resource at both manangement scope and subscription scope.
definitions - Custom policy definitions, inside this folder is a custom folder. This contains the json to define the policy.
exemptions - Contains the module to create the policy exemptions.
initistives - Contains the module to bundle policies into a policy set.

Example deployments
@ Management Group Scope
az deployment mg create --name deployMGMain --location UKSouth --management-group-id mglab1 --template-file ".\mgMain.bicep" --parameters ".\mgMain_params.json"

az deployment mg create --name deployMGMain --location UKSouth --management-group-id labs --template-file ".\mg_main.bicep" --parameters ".\mg_main_lab_params.json"

@ Subscripption scope - Currently no resources being deployed at sub level
az deployment sub create --template-file ".\sub_main.bicep" --parameters ".\sub_main_lab_params.json" --location "UKSouth"

@ Resource Group Scope
az deployment group create --resource-group "rg-bicep" --template-file ".\rg_main.bicep" --parameters ".\rg_main_lab_params.json"

Applying resource locks
az deployment mg create --name deployLocks --location UKSouth --management-group-id Prod --template-file ".\m_apply_all_locks.bicep" --parameters ".\rg_main_lab_params.json"

Delete individual lock
$resourceid = "/subscriptions/xxx-xxx-xxx-xxx/resourceGroups/rg-network-cg01/providers/Microsoft.Authorization/locks/rgReadOnlyLock"
Remove-AzResourceLock -LockId $resourceid -Force