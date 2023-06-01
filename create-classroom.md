# Create an Azure Classroom

The following steps follow the Azure Classroom framework to setup an existing Azure Subscription sp that can be used for teaching. In this example the a subscription named *class-subscription* exists where the user is a Owner.

## Step 1: Prepare

At the end of this step you will:
- Have a file [classroom.json](/examples/classroom.json) that contains your class information.
- Be able to connect to your subscription using the Powershell Azure Module.

### Create the classroom information file

Create the class classroom file named classroom.json that uses the JSON format outlined in the classroom information section of the [README](README.md#class-json). The [classroom template](examples/classroom.json) can be used to create your own Azure classroom. The users contained in the roster must have an account in your Azure tenant.

### Connect to Azure

- Connect to Azure and set the active subscription:
```PowerShell
Connect-AzAccount

Get-AzSubscription -SubscriptionName "class-subscription" | Select-AzSubscription
```
## Step 2: Create Resource Groups

-create an instructors resource group
-create the instructors action group, with email alerts to the instructors

-foreach student, create a resource group called rg-(id) and then
 - add the instructors as to the Owner role
 - add the student to the Contributor role
 - create a budget that includes
  - thresholds, some with actions to the ag-instructors, all to alert the (account)

- Add budget alerts for the entire subscription
 - trigger the ag-instructors action group



```PowerShell
$classroom = Get-Content .\classroom.json -Encoding UTF8 -Raw | ConvertFrom-Json
$instructors = @{}
$students = @{}
$thresholds = @{}

foreach($user in $roster)
{
    if(-Not $user.instructor)
    {
        $students[$user.id] = $user.account
        New-AzResourceGroup -Name "rg-$($user.id)" -Location "EastUS" -Tag @{prj="classroom"}
    }
    elseif($user.instructor)
    {
        $instructors[$user.id] = $user.account
    }
}

New-AzResourceGroup -Name "rg-instructors" -Location "EastUS" -Tag @{prj="classroom"}

```

## Step 4: Assign IAM Permissions

## Step 5: Create Alerting Thresholds
- Create action group that contains the instructors
```PowerShell
foreach($user in $roster)
{
    if($user.instructor)
    {
         New-AzResourceGroup -Name "rg-$($user.id)" -Location "EastUS" -Tag @{prj="classroom"}
         Set-AzActionGroup 
    }
}
```

## Optional Steps

## Option 1: Limit Student Permissions

## Option 2: Create Class Resource Group
