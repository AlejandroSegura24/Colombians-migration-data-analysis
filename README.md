# ✈️ Análisis Exploratorio de Patrones de Viaje de Colombianos al Exterior

## Descripción

Este proyecto presenta un **Análisis Exploratorio de Datos (EDA)** sobre los patrones de viaje de la población colombiana al exterior. El objetivo principal es identificar y caracterizar los factores demográficos (edad, género, etnia, formación académica) que influyen en la elección del destino y comprender las dinámicas detrás de los flujos migratorios a través de aeropuertos internacionales.

El proceso analítico se desarrolló en tres etapas:

1. **SQL**: limpieza, normalización y transformación inicial de los datos, junto con un análisis preliminar mediante consultas agregadas y filtros demográficos.
2. **Python**: depuración adicional del dataset, creación de nuevas variables, análisis exploratorio más profundo y generación de visualizaciones para identificar patrones clave.
3. **Power BI**: construcción de un dashboard interactivo que permite explorar los resultados del análisis de forma dinámica, facilitando la interpretación de tendencias y comparaciones entre grupos poblacionales.

El proyecto integra diversas herramientas para ofrecer una visión clara, estructurada y basada en datos sobre el comportamiento de viaje de los colombianos hacia destinos internacionales.

## Fuentes de Datos

Los datos utilizados en este análisis provienen del portal oficial de **Datos Abiertos del Gobierno de Colombia**, específicamente del conjunto:

**Colombianos registrados en el exterior**:
[https://www.datos.gov.co/es/Estad-sticas-Nacionales/Colombianos-registrados-en-el-exterior/y399-rzwf/about_data](https://www.datos.gov.co/es/Estad-sticas-Nacionales/Colombianos-registrados-en-el-exterior/y399-rzwf/about_data)

Este dataset contiene información detallada sobre los flujos migratorios de colombianos hacia diferentes destinos internacionales, incluyendo variables demográficas, temporales y geográficas.

## Estructura del repositorio

- **`Notebooks/`**: Contiene los notebooks utilizados durante el proceso analítico.  
  - `Carga dataset a PostgreSQL.ipynb`: Notebook para la carga del dataset a una base de datos PostgreSQL utilizando Python.  
  - `EDA colombians migration.ipynb`: Notebook con el análisis exploratorio de datos, limpieza adicional, transformaciones y generación de visualizaciones.

- **`Power BI/`**: Carpeta destinada al reporte interactivo desarrollado en Power BI.  
  - `Migración Internacional Colombiana.pbix`: Dashboard final del análisis para consulta dinámica de los resultados.

- **`SQL/`**: Contiene los scripts SQL utilizados para la limpieza, transformación y análisis preliminar de los datos.  
  - `1 transformacion y limpieza.sql`: Script de normalización inicial, eliminación de inconsistencias y preparación del dataset.  
  - `2 analisis.sql`: Consultas analíticas para exploración de patrones demográficos y destinos.

- **`config.json`** *(no incluido en el repositorio)*: Archivo requerido para almacenar las credenciales de conexión a PostgreSQL.  
  Debe ser creado manualmente por el usuario siguiendo el formato indicado en el README.  
  No se incluye por motivos de seguridad.

- **`environment.yml`**: Archivo de entorno Conda que especifica las dependencias necesarias para ejecutar el proyecto (Python, bibliotecas de análisis y conexión a PostgreSQL).

- **`.gitignore`**: Archivo que indica qué elementos deben ser ignorados por Git (archivos temporales, entornos locales, outputs, etc.).

- **`LICENSE`**: Licencia del proyecto.

- **`README.md`**: Documento principal con la descripción del proyecto, instrucciones de instalación, uso y resultados.

## Instalación

Para replicar el análisis de datos y ejecutar correctamente los notebooks y scripts SQL, sigue los pasos:

### 1. Clonar el repositorio

```bash
git clone https://github.com/AlejandroSegura24/Colombians-migration-data-analysis.git
cd colombians-migration-data-analysis
```

### 2. Crear el entorno de Python

Se recomienda usar un entorno virtual con **Conda**:

```bash
conda env create -f environment.yml
conda activate env_colombians_migration
```

También puedes usar `venv` si lo prefieres.

### 3. Crear archivo `config.json` (obligatorio para conexión a PostgreSQL)

Este archivo **no viene incluido en el repositorio** por contener credenciales sensibles.
Debes crearlo manualmente en la **raíz del proyecto**, junto al `README.md`.

Crea un archivo llamado `config.json` y copia la siguiente estructura:

```json
{
  "api_keys": {
    "soda_token": "Agregar_token"
  },
  "database": {
    "user": "tu_usuario",
    "password": "tu_contraseña",
    "host": "localhost",
    "port": "5432",
    "dbname": "nombre_de_tu_base"
  }
}
```

Este archivo permite que los notebooks se conecten automáticamente a PostgreSQL para cargar datos, transformarlos y realizar consultas.

## Uso

Para ejecutar correctamente el proyecto y reproducir todo el análisis, sigue este flujo operativo:

### 1. Cargar el dataset en PostgreSQL

El primer paso consiste en insertar los datos originales en la base de datos.

1. Abre el notebook ubicado en `Notebooks/Carga dataset a PostgreSQL.ipynb`.
2. Configura tu archivo `config.json` con las credenciales correctas.
3. Ejecuta todas las celdas para:

   * Leer el dataset desde la fuente original.
   * Crear la tabla en PostgreSQL.
   * Insertar los registros.

---

### 2. Ejecutar los Scripts SQL

Dentro de la carpeta `Sql/` encontrarás dos archivos que deben ejecutarse **en orden**, ya sea desde pgAdmin o cualquier cliente SQL.

1. **`1 transformacion y limpieza.sql`**

   * Limpieza inicial del dataset.
   * Estandarización de campos.
   * Corrección de valores nulos y anomalías.

2. **`2 analisis.sql`**

   * Cruces entre variables demográficas.
   * Indicadores agregados.
   * Consultas exploratorias finales.

Los resultados generados sirven como base para la siguiente etapa en Python.

---

### 3. Análisis en Python

Una vez limpiados y transformados los datos en SQL:

1. Abre el notebook `Notebooks/EDA colombians migration.ipynb`.
2. Ejecuta las celdas para:

   * Cargar los datos procesados desde PostgreSQL.
   * Realizar transformaciones adicionales si son necesarias.
   * Generar gráficos descriptivos y análisis finales.

---

### 4. Dashboard de Power BI

Por último, abre el archivo ubicado en `PowerBI/`:

* `Migracion internacional Colombiana.pbix`

Desde allí podrás:

* **Analizar estacionalidad** mediante la visualización “Total de personas por mes y país”
* **Aplicar filtros dinámicos** por Año (2012–2025), Grupo Etario, País y Ciudad de Residencia.
* **Consultar métricas**, como el total de registros filtrados y tablas de edad promedio por mes y género.


## Resultados

Los resultados principales se resumen en los siguientes hallazgos:

* **Destinos Principales:** Estados Unidos, España y Venezuela son los países que concentran el mayor flujo de viajeros.
* **Perfil del Viajero:** El **Adulto en edad productiva** es el grupo que más viaja.
* **Motivación vs. Formación:** Se identificó una migración dual: existe un flujo importante de adultos con **alta formación** (búsqueda de oportunidades) y un flujo similar de adultos con **baja formación** (falta de oportunidades en el país).
* **Influencia Étnica:** La pertenencia étnica sí modifica el patrón de destino. El grupo **Afrodescendiente** lidera la movilidad y muestra una fuerte preferencia por **España**, mientras que el grupo **Indígena** se orienta más a países fronterizos como Venezuela y Ecuador.
* **Factores Familiares:** El viaje de los grupos etarios más jóvenes (primera infancia, adolescentes) replica los destinos de los adultos, confirmando que la **reunificación familiar** es un motor clave de la migración.

## Tecnologías usadas

- **Lenguaje de Programación:**  
  Python 3.10

- **Bases de Datos y Procesamiento SQL:**  
  PostgreSQL, pgAdmin  

- **Análisis y Manipulación de Datos:**  
  Pandas, NumPy

- **Visualización en Python:**  
  Matplotlib, Seaborn

- **Visualización Interactiva (BI):**  
  Microsoft Power BI

- **Entornos y Gestión de Dependencias:**  
  Conda, environment.yml

## Flujo del Proyecto

1. **Carga del Dataset a PostgreSQL**
   Se ejecuta el notebook **`Carga dataset a PostgreSQL.ipynb`**, donde:

   * Se consume la API de *datos.gov.co* usando un token.
   * Se limita la descarga a 200.000 registros.
   * Se normalizan campos tipo diccionario a JSON string.
   * Se carga la tabla **`registro_aeropuerto`** en PostgreSQL (una sola vez para evitar sobreescrituras).

2. **Limpieza y Transformación en SQL**
   Se ejecuta el archivo **`1 transformacion y limpieza.sql`**, donde se realizan:

   * Corrección de nombres de columnas con errores de codificación.
   * Identificación y tratamiento de valores inválidos en `edad_anios`, `estatura_cm` y `cantidad_de_personas`.
   * Imputación de nulos en columnas numéricas con base en reglas y contexto.
   * Conversión final de tipos (`INTEGER`, `DATE`).
   * Corrección de inconsistencias en nombres de países.
   * Extracción de latitud/longitud a partir de la columna JSON `localizacion`.

3. **Análisis SQL Descriptivo y Exploratorio**
   Se ejecuta **`Analisis dataset Aeropuertos.sql`**, donde se evalúan:

   * Países más frecuentes (origen y destino).
   * Grupos familiares vs. viajes individuales.
   * Distribución de rango de edad y principales destinos por grupo etario.
   * Relación entre nivel educativo, área de conocimiento y motivaciones migratorias.
   * Identificación de patrones iniciales para guiar el análisis en Python.

4. **Análisis Exploratorio Avanzado (EDA) en Python**
   Se continúa en el notebook asignado a EDA, donde se:

   * Se carga la tabla limpia desde PostgreSQL.
   * Se exploran variables clave (`grupo_edad`, `nivel_academico`, `pais`, `cantidad_de_personas`,`etnia_de_la_persona`) con visualizaciones.
   * Se identifican tendencias relevantes (países principales, patrones migratorios, grupos vulnerables).

5. **Construcción del Dashboard en Power BI**

   * Se importa la tabla limpia desde PostgreSQL.
   * Se construye un dashboard interactivo con filtros por **país**, **ciudad**, **año** y **grupo etario**.
   * Se representan patrones globales y segmentos clave identificados en el EDA.

## Conclusiones

El análisis muestra que la migración colombiana al exterior es un fenómeno multifactorial liderado por adultos en edad productiva, cuyas decisiones de destino responden a una combinación de **factores económicos** (oportunidad o necesidad), **dinámicas familiares** (reunificación) y **elementos culturales y sociales** (redes étnicas que influyen en la elección del país).

La formación académica y la pertenencia étnica introducen variaciones claras en los patrones migratorios: mientras los adultos con mayor formación tienden a migrar hacia países con mayores oportunidades profesionales, los grupos con menor formación se dirigen hacia destinos cercanos o con vínculos históricos.

Finalmente, el análisis también evidencia que los **lazos familiares** son un motor de movilidad: los viajes de niños, adolescentes y jóvenes replican, casi en su totalidad, los destinos elegidos por los adultos, reforzando el papel de la reunificación familiar como eje central en los flujos migratorios.

# Próximos Pasos

* **Corrección avanzada de caracteres corruptos (`�`)**
  Implementar una limpieza más profunda para estandarizar textos con problemas de codificación, especialmente en las columnas `ciudad_de_residencia` y `ciudad_de_nacimiento`, aplicando normalización Unicode y detección de caracteres inválidos.

* **Geolocalización precisa a nivel de ciudad**
  Reemplazar la latitud/longitud general del país por coordenadas específicas de **cada ciudad** registrada en el dataset, utilizando:

  * APIs de geocodificación (OpenStreetMap, Google Maps…).
  * Normalización previa del nombre de la ciudad para evitar valores ambiguos.
    Esto permitirá mapas más detallados en futuros análisis y dashboards.

* **Ampliar el EDA con modelos descriptivos adicionales**

  * Análisis temporal profundo por año/mes.
  * Detección de outliers en edad, estatura y grupos familiares.
  * Segmentación de migrantes por clústeres básicos (agrupamiento no supervisado).

* **Incorporar visualizaciones avanzadas en Power BI o Python**

  * Mapas geoespaciales con coordenadas corregidas.
  * Líneas de tiempo de migración.
  * Comparación por género, estado civil y nivel académico.

## Autor

* **Autor**: David Alejandro Segura
* **Correo**: davidalejandrocmbs@gmail.com

##  Licencia

Este proyecto está licenciado bajo la **Licencia MIT**, lo que permite su uso, modificación y distribución de manera libre, siempre y cuando se mantenga la atribución correspondiente al autor original.

Para más detalles, consulta el archivo **LICENSE** incluido en el repositorio.
