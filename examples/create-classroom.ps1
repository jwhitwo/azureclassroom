$region = "EastUS"

$classroom = Get-Content .\classroom.json -Encoding UTF8 -Raw | ConvertFrom-Json
$instructors = @{}
$students = @{}
$thresholds = @{}

# parse the classroom.json file and create a list of instructors and students
foreach($user in $classroom.people)
{
    if(-Not $user.instructor)
    {
        # if the user is not an instructor, add to the $students list
        $students[$user.id] = $user.account
    }
    elseif($user.instructor)
    {
        # if the user is an instructor, add to the $instructors list
        $instructors[$user.id] = $user.account
    }
}

# pasrse the classroom.json file and create a list of thresholds
foreach($threshold in $classroom.thresholds)
{
    $thresholds[$threshold.name] = $threshold
}

# create a resource group for each student
foreach($user in $students.GetEnumerator())
{
    New-AzResourceGroup -Name "rg-$($user.Name)" -Location $region -Tag @{prj="classroom"}
    # set user as contributor on their resource group
    New-AzRoleAssignment -ObjectId $user.Value -RoleDefinitionName "Contributor" -ResourceGroupName "rg-$($user.Name)"
    # set the instructors as owner on the student's resource group
    foreach($instructor in $instructors.GetEnumerator())
    {
        New-AzRoleAssignment -ObjectId $instructor.Value -RoleDefinitionName "Owner" -ResourceGroupName "rg-$($user.Name)"
    }
}

# create a resource group for the instructors
New-AzResourceGroup -Name "rg-instructors" -Location "EastUS" -Tag @{prj="classroom"}
foreach($instructor in $instructors.GetEnumerator())
{
    New-AzRoleAssignment -ObjectId $instructor.Value -RoleDefinitionName "Owner" -ResourceGroupName "rg-instructors"
}