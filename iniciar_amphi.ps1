# Función para verificar si un entorno de conda existe
function ExisteEntornoConda {
    param(
        [string]$nombreEntorno
    )
    # Lista los entornos de conda y busca el nombre especificado
    conda env list | Select-String -Pattern $nombreEntorno -Quiet
}

# Función para crear un entorno de conda a partir del entorno base
function CrearEntornoDesdeBase {
    param(
        [string]$nombreEntorno
    )
    Write-Host "Creando entorno '$nombreEntorno'"
    conda create --name $nombreEntorno python=3.11 pandas jupyter -y
    if ($?) {
        Write-Host "Entorno '$nombreEntorno' creado con éxito."
    } else {
        Write-Host "Error al crear el entorno '$nombreEntorno'."
        exit 1 # Sale del script con código de error
    }
}

# Función para activar un entorno de conda
function ActivarEntornoConda {
    param(
        [string]$nombreEntorno
    )
    Write-Host "Activando entorno '$nombreEntorno'..."
    conda activate $nombreEntorno
    if ($?) {
        Write-Host "Entorno '$nombreEntorno' activado."
    } else {
        Write-Host "Error al activar el entorno '$nombreEntorno'."
        exit 1
    }
}

# Función para instalar Amphi en un entorno
function InstalarAmphi {
    Write-Host "Instalando Amphi..."
    pip install amphi-etl duckdb openpyxl
    Write-Host "Amphi instalado con éxito." # Reemplaza con la salida real de la instalación
}

# Función para iniciar Amphi
function IniciarAmphi {
    Write-Host "Iniciando Amphi..."
    amphi start
    Write-Host "Amphi iniciado."  # Reemplaza con la salida real del inicio de Amphi
}

# Nombre del entorno
$nombreEntorno = "amphietl_env"

# 1. Verificar si ya existe un entorno con el nombre dado
if (ExisteEntornoConda -nombreEntorno $nombreEntorno) {
    Write-Host "Ya existe un entorno llamado '$nombreEntorno'."
    # Preguntar al usuario si desea activarlo y ejecutar Amphi
    $respuesta = Read-Host -Prompt "Deseas activarlo y ejecutar Amphi (s/n)?"
    if ($respuesta -eq "s") {
        ActivarEntornoConda -nombreEntorno $nombreEntorno
        IniciarAmphi
    } else {
        Write-Host "Operación cancelada."
    }
} else {
    Write-Host "No se encontró un entorno llamado '$nombreEntorno'."
    # Preguntar al usuario si desea crearlo0
    $respuesta = Read-Host -Prompt "Deseas crearlo (s/n)?"
    if ($respuesta -eq "s") {
        CrearEntornoDesdeBase -nombreEntorno $nombreEntorno
        ActivarEntornoConda -nombreEntorno $nombreEntorno
        InstalarAmphi
        # Crear la estructura de carpetas para los ETLs
        New-Item -Path "etl_project" -ItemType Directory
        New-Item -Path "etl_project/data" -ItemType Directory
        New-Item -Path "etl_project/data/raw" -ItemType Directory
        New-Item -Path "etl_project/data/staging" -ItemType Directory
        New-Item -Path "etl_project/data/processed" -ItemType Directory
        New-Item -Path "etl_project/data/notebooks" -ItemType Directory
        IniciarAmphi

    } else {
        Write-Host "Operación cancelada."
    }
}