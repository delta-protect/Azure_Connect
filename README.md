# Azure_Connect

This script facilitates Azure service principal creation via Azure CLI. This PowerShell script helps users to select an Azure subscription interactively and create a service principal with specific roles assigned to it.

## Prerequisites

* Azure CLI installed and configured.
* User must be logged in to Azure CLI.

## Usage

1. Login to Azure CLI:
Ensure you are logged in to Azure CLI using:

´´´powershell
az login
´´´

2. Running the Script:
Execute the script in a PowerShell environment.

3. Select Azure Subscription:

* The script lists all available Azure subscriptions.
* Navigate through the list using the up and down arrow keys.
* Press Enter to select the desired subscription.

4. Service Principal Creation:

* The script creates a service principal for the selected subscription.
* The service principal is assigned the roles with IDs acdd72a7-3385-48ef-bd42-f606fba81ae7 and 39bc4728-0917-49c7-9d2c-d95423bc2eb4.

5. Output:

* The script outputs the details of the created service principal.