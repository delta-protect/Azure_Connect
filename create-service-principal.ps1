# CAMBIAR Ó DEJAR ESTE NOMBRE:
$APP_NAME = "Apolo-Delta"

function Select-AzureSubscription {
    # Enlistar subscripciones:
    $jsonOutput = az account list --all --output json | ConvertFrom-Json

    # Prepara las subscripciones + ID para enlistar en pantalla:
    $options = @()
    foreach ($sub in $jsonOutput) {
        $options += "$($sub.name) - $($sub.id)"
    }

    $selectedIndex = 0

		# Función para desplegar en pantalla suscripciones disponibles para seleccionar:
    function Display-Menu {
        Clear-Host
        for ($i = 0; $i -lt $options.Length; $i++) {
            if ($i -eq $selectedIndex) {
                Write-Host " > $($i + 1). $($options[$i]) < " -ForegroundColor Cyan
            }
            else {
                Write-Host "   $($i + 1). $($options[$i])"
            }
        }
    }

    Display-Menu

    while ($true) {
        $keyInfo = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        switch ($keyInfo.VirtualKeyCode) {
            38 { # Flecha arriba
                if ($selectedIndex -gt 0) { $selectedIndex-- }
            }
            40 { # Flecha abajo
                if ($selectedIndex -lt $Options.Length - 1) { $selectedIndex++ }
            }
        }
        # Capturar tecla "Enter":
        if ($keyInfo.VirtualKeyCode -eq 13 -or $keyInfo.Character -eq [char]13) {
            break
        }
        Display-Menu
    }

    # Almacena la suscripción seleccionada en una variable (Contiene el ID)
    $selectedSubscription = $options[$selectedIndex] -split ' - ' | Select-Object -Last 1
    return $selectedSubscription
}

# Verificar si el usuario está autenticado en Azure CLI
$loggedIn = az account show --output json | ConvertFrom-Json -ErrorAction SilentlyContinue

if ($loggedIn) {
    Write-Host "User is logged in to Azure CLI."
} else {
    Write-Host "User is not logged in to Azure CLI. Please log in before proceeding."
    exit
}

# SELECCION DE SUSCRIPCION
$selectedSubscriptionId = Select-AzureSubscription

# Confirmación al usuario:
Write-Host "[i] You selected subscription ID: $selectedSubscriptionId"

# CREACION DE SUSCRIPCIÓN
$jsonServicePrincipal = az ad sp create-for-rbac -n $APP_NAME --role acdd72a7-3385-48ef-bd42-f606fba81ae7 --role 39bc4728-0917-49c7-9d2c-d95423bc2eb4 --scopes /subscriptions/$selectedSubscriptionId | ConvertFrom-Json

$apoloServicePrincipal = @{
    appId = $jsonServicePrincipal.appId
    password = $jsonServicePrincipal.password
    tenant = $jsonServicePrincipal.tenant
    subscriptionId = $selectedSubscriptionId
} | ConvertTo-Json

# Guardar el JSON en un archivo
$apoloServicePrincipal | Out-File -FilePath "apolo-service-principal.json"

Write-Output $apoloServicePrincipal
