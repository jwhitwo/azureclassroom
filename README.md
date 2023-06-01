# Azure Classroom
A framework for creating, managing, and using an Azure resources in the classroom.

## Overview

Azure Classroom provides a framework to enable the use of Azure within a teaching environment that is geared towards using Azure resources as part of the learning experience. 

It is helpful to be aware of other academic Azure benefits and services that are available, their strengths, and how Azure Classroom aims to fill gaps in other services.

- [Azure for Students](https://azure.microsoft.com/en-us/free/students/) provides free Azure resources and credits directly to eligible students *in their own subscription*.
- [Azure Lab Services](https://labs.azure.com/) is an Azure service that provides virtual machines in a lab environment that is controlled by the instructor.

The primary use case of Azure Classroom is to provide an instructor an Azure environment that is accessible by students so they have access to Azure services in addition to virtual machines. Azure Classroom *does not* utilize any of the [Azure for Students](https://azure.microsoft.com/en-us/free/students/) benefits.

[Microsoft Learn](https://learn.microsoft.com/en-us/) is a resource that provides documentation, training, and other resources that are helpful when developing lesson plans that utilize Azure in the classroom.

## Important Considerations

Prior to adopting the Azure Classroom Framework, it is important to be aware of the following considerations:

- **Subscription Type** - The framework uses a dedicated subscription for each class and it is recommended that the subscriptions should be part of an existing Enterprise Enrollment. Using a Pay-As-You-Go or non-enterprise enrollment is not recommended.
- **Student Benefits** - Using the framework does not impact [Azure for Students](https://azure.microsoft.com/en-us/free/students/) benefits, allowing those benefits to remain available for the individual students. Student credits cannot be applied.
- **Resource Access** - It is possible to create situations where students can access other students resources within the subscription. This may be desireable so the framework does not inherently prevent cross student access, nor does it enable it by default.
- **Cost** - Azure resources are billed at the normal cost within the enrollment and [Azure for Students](https://azure.microsoft.com/en-us/free/students/) credits cannot be applied. More information can be found at the [Cost Considerations](#cost-considerations) page.
- **Framework** - Azure Classrooms is a framework and not a service.  [Create a Classroom](create-classroom.md) provides a guide on how to put the framework into practice.

## Getting Started

Prior to starting deployment of Azure Classrooms it is recommended that you review the [Azure Classroom Framework](azure-classroom-framework.md). After reviewing the framework, ensure that you meet all the prerequisites for deployment. Once you are able to meet the prerequisites you can follow the [Create a Classroom](create-classroom.md) guide to deploy a classroom in Azure.

### Prerequisites

- Access to an empty Azure subscription that is a part of your enterprise enrollment (how to create a subscription)
- A [classroom information file](#class-json) that includes students and instructors that are part of your Azure tenant and have email addresses.
- Access to [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)
- Determine your [alert thresholds](#alert-options)

## Cost Considerations

The Azure Classroom framework utilizes a subscription within a schools Azure Enrollment. Azure utilization is billed according to the overall enrollment terms. [The Azure pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator/) can assist in developing cost estimates based on what Azure resources will be consumed.

It is important to note that student credits that are part of [Azure for Students](https://azure.microsoft.com/en-us/free/students/) cannot be applied to Azure Classroom subscriptions, and are available directly to students in their own subscriptions.

Another consideration related to cost is determining if student Azure consumption within a budget should be part of the grading rubric. The ability to deploy cloud resources within a defined budget can be considered as an important learning objective depending on the course.

There are no hard limits in place that prevent spending over a budget. Instead, the Azure Classroom framework relies on Azure Cost Management thresholds to alert both students and instructors of their usage. It is recommended that a budget plan be created based on course learning objectives and alerting is aligned to these objectives. 

| Learning Objective | Total Budget % |
| ------ | ------ |
| Module 1: Objective 1 | 10% |
| Module 2: Objective 2 | 20% |
| Module 3: Objective 3 | 30% |
| Module 4: Objective 4 | 40% |

[Cost Management for Azure](https://azure.microsoft.com/en-us/products/cost-management/) is available at no cost for Azure subscriptions and provides reporting, alerting and other budgeting features. Each student is provided their own resource group where budget alerts are set based on defined thresholds. 

## Alert Options

The framework utilized Azure resource group budget thresholds to alert students and instructors based on their consumption. Email alerts are sent whenever a threshold is crossed. *There is no hard limit that turns off Azure services when a threshold is crossed.*

Below is an example that alerts the student when they are 50% and 100% of the estimated budget for a module, and notify the student and the instructor when they are over budget for any given module. 

| Threshold | Total Budget % | Alert |
| ----- | ----- | ----- |
| Module 1: Halfway Warning | 5% | Student |
| Module 1: Full Budget Warning | 10% | Student |
| Module 1: Over Budget Warning | 12% | Student, Instructor |
| Module 2: Halfway Warning | 20% | Student |
| Module 2: Full Budget Warning | 30% | Student |
| Module 2: Over Budget Warning | 32% | Student, Instructor |
| Module 3: Halfway Warning | 45% | Student |
| Module 3: Full Budget Warning | 60% | Student |
| Module 3: Over Budget Warning | 62% | Student, Instructor |
| Module 4: Halfway Warning | 80% | Student |
| Module 4: Full Budget Warning | 100% | Student, Instructor |
| Module 4: Over Budget Warning | 102% | Student, Instructor |

(need to include link to a template used to set the alerts)

## Classroom Information File

Classroom information in the JSON format below will be needed as input to create the resource groups, assign permissions, and setup cost management. Every student and instructor record should contain an id, account and the instructor attributes. The account should match the account of the user in Azure Active Directory.

The example below has two users: John Doe (student) and Instructor Ian (instructor).

```JSON
{
    "class": "Class Name",
    "people": [
    {
        "id": "jdoe",
        "account": "jdoe@domain.edu",
        "instructor": false
    },
    {
        "id": "ian",
        "account": "ian@domain.edu",
        "instructor": true
    }
    ],
    "thresholds": [
    {
        "name": "Alert 1",
        "warning": 10,
        "notify-instructor": false
    },
    {
        "name": "Alert 2",
        "warning": 25,
        "notify-instructor": true
    }
    ]
}
```
An example classroom JSON file can be found [here](/examples/classroom.json).

A more detailed description of the fields can be found below:

| Field | Type | Description |
| ----- | ----- | ----- |
| class | string | A descriptive name of the classroom. |
| people | array | Contains all users of the Azure Classroom subscription. |
| people:id | string | A descriptive identifier for the user. |
| people:account | string | The account for the user. |
| people:instructor | boolean | True for instructors. |
| thresholds | array | Contains the thresholds used for alerting. |
| thresholds:name | string | A descriptive name of the threshold. |
| thresholds:warning | number | The percent of the individual student budget for the alert. |
| thresholds:notify-instructor | boolean | True if the alert should notify the instructor in addition to the student. |
