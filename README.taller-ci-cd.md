# Taller Jenkins CI/CD

Este archivo documenta el pipeline alterno para el taller sin modificar el `Jenkinsfile` original del repositorio.

## Archivo del taller

- Pipeline: [Jenkinsfile.taller-ci-cd](Jenkinsfile.taller-ci-cd)

## Qué hace el pipeline

1. `Checkout`
2. `Build`
3. `Test`
4. `Static Analysis (SonarQube)`
5. `Quality Gate (SonarQube)`
6. `Docker Build`
7. `Container Security Scan (Trivy)`
8. `Deploy` en `main` o `master`

## Requisitos

- Jenkins con plugins:
  - Git
  - Pipeline
  - Docker Pipeline
  - SonarQube Scanner
- SonarQube accesible desde Jenkins
- Trivy instalado en el agente Jenkins
- Docker disponible en el agente Jenkins

## Configuración del job

1. Crear un job tipo **Pipeline**
2. Seleccionar **Pipeline script from SCM**
3. Elegir **Git**
4. Apuntar al repositorio local o remoto
5. En **Script Path**, usar:

```text
Jenkinsfile.taller-ci-cd
```

6. Guardar y ejecutar

## Pasos exactos en Jenkins

### 1. Instalar plugins

En **Manage Jenkins > Plugins**, instala como mínimo:

- Git
- Pipeline
- Docker Pipeline
- SonarQube Scanner for Jenkins

### 2. Configurar SonarQube

1. Levanta SonarQube local o usa uno ya disponible.
2. En Jenkins ve a **Manage Jenkins > System**.
3. Busca la sección **SonarQube servers**.
4. Agrega un servidor con estos datos:
  - **Name**: `SonarQube`
  - **Server URL**: la URL de tu SonarQube
5. En **Credentials**, agrega el token de SonarQube.

### 3. Configurar el Quality Gate

En SonarQube:

1. Ve a **Quality Gates**.
2. Usa o crea un gate que falle si hay problemas de seguridad.
3. Ajusta la regla para que el pipeline falle si existen **Security Hotspots** sin revisar.

### 4. Preparar Trivy

En el agente de Jenkins debe existir el comando `trivy`.

Si no está instalado, el stage de escaneo fallará antes de continuar.

### 5. Crear el job

1. En Jenkins selecciona **New Item**.
2. Nombra el job.
3. Elige **Pipeline**.
4. En la sección **Pipeline** selecciona **Pipeline script from SCM**.
5. En **SCM**, elige **Git**.
6. En **Repository URL**, pon la ruta del repo o la URL remota.
7. En **Branches to build**, usa la rama correcta, por ejemplo:
  - `*/main`
  - o `*/master`
8. En **Script Path**, escribe:

```text
Jenkinsfile.taller-ci-cd
```

9. Guarda el job.

### 6. Ejecutar el pipeline

Haz clic en **Build Now**.

El orden esperado es:

1. Checkout
2. Build
3. Test
4. Static Analysis (SonarQube)
5. Quality Gate (SonarQube)
6. Docker Build
7. Container Security Scan (Trivy)
8. Deploy

### 7. Activar disparador automático

Para que Jenkins detecte cambios automáticamente, usa una de estas opciones:

- **GitHub webhook**: recomendado si el repo está en GitHub.
- **Poll SCM**: útil si estás en local y no quieres configurar webhook.

Ejemplo de polling en Jenkins:

```text
H/2 * * * *
```

Eso revisa cambios cada 2 minutos.

## Validación final del taller

Después de que el pipeline esté configurado:

1. Cambia un texto de la aplicación.
2. Haz commit.
3. Haz push.
4. Verifica que Jenkins ejecute nuevamente el pipeline.
5. Confirma que el contenedor se levanta correctamente si pasa las validaciones.

## Notas importantes

- El pipeline falla si SonarQube no aprueba el Quality Gate.
- El pipeline falla si Trivy encuentra vulnerabilidades `CRITICAL`.
- El despliegue ejecuta el contenedor localmente en el puerto 80.
- La limpieza final usa `deleteDir()` para evitar depender del plugin de Workspace Cleanup.

## Entregables sugeridos

- Captura de la configuración del job
- Captura de SonarQube
- Captura del escaneo Trivy
- Captura del deploy exitoso
- Captura del pipeline completo en verde
