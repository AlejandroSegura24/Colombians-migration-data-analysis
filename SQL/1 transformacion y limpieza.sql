-- Verificamos si la tabla se cargó correctamente
SELECT * FROM registro_aeropuerto LIMIT 5;

-- Contamos el número total de registros cargados
SELECT COUNT(*) AS total_registros
FROM registro_aeropuerto;

-- Como primer paso, vamos a revisar si hay valores nulos en las columnas del dataset
-- Contamos cuántos valores NULL hay por columna
SELECT 
    SUM(CASE WHEN pa_s IS NULL THEN 1 ELSE 0 END) AS null_pais,
    SUM(CASE WHEN c_digo_iso_pa_s IS NULL THEN 1 ELSE 0 END) AS null_codigo_iso_pais,
    SUM(CASE WHEN ciudad_de_residencia IS NULL THEN 1 ELSE 0 END) AS null_ciudad_de_residencia,
    SUM(CASE WHEN oficina_de_registro IS NULL THEN 1 ELSE 0 END) AS null_oficina_de_registro,
    SUM(CASE WHEN grupo_edad IS NULL THEN 1 ELSE 0 END) AS null_grupo_edad,
    SUM(CASE WHEN edad_a_os IS NULL THEN 1 ELSE 0 END) AS null_edad_anios,
    SUM(CASE WHEN rea_conocimiento IS NULL THEN 1 ELSE 0 END) AS null_area_conocimiento,
    SUM(CASE WHEN sub_area_conocimiento IS NULL THEN 1 ELSE 0 END) AS null_sub_area_conocimiento,
    SUM(CASE WHEN nivel_acad_mico IS NULL THEN 1 ELSE 0 END) AS null_nivel_academico,
    SUM(CASE WHEN estado_civil IS NULL THEN 1 ELSE 0 END) AS null_estado_civil,
    SUM(CASE WHEN g_nero IS NULL THEN 1 ELSE 0 END) AS null_genero,
    SUM(CASE WHEN etnia_de_la_persona IS NULL THEN 1 ELSE 0 END) AS null_etnia_de_la_persona,
    SUM(CASE WHEN estatura_cm IS NULL THEN 1 ELSE 0 END) AS null_estatura_cm,
    SUM(CASE WHEN ciudad_de_nacimiento IS NULL THEN 1 ELSE 0 END) AS null_ciudad_de_nacimiento,
    SUM(CASE WHEN localizaci_n IS NULL THEN 1 ELSE 0 END) AS null_localizacion,
    SUM(CASE WHEN fecha_de_registro IS NULL THEN 1 ELSE 0 END) AS null_fecha_de_registro,
    SUM(CASE WHEN cantidad_de_personas IS NULL THEN 1 ELSE 0 END) AS null_cantidad_de_personas
FROM registro_aeropuerto;
-- Observamos que ninguna columna tiene valores nulos, por lo que no es necesario realizar limpieza de datos en ese aspecto.

-- Ahora, verificamos la codificación de caracteres utilizada en la base de datos
SHOW SERVER_ENCODING;

-- La codificación es UTF8 pero algunos nombres de las columnas con tildes no se muestran correctamente, asi que vamos a renombrar esas columnas para evitar problemas futuros.
-- Listamos las columnas de la tabla para identificar cuáles necesitan ser renombradas
SELECT column_name 
FROM information_schema.columns
WHERE table_name = 'registro_aeropuerto';

-- Renombramos las columnas con tildes o caracteres especiales
ALTER TABLE registro_aeropuerto
    RENAME COLUMN "pa_s" TO pais;
ALTER TABLE registro_aeropuerto
    RENAME COLUMN "c_digo_iso_pa_s" TO codigo_iso_pais;
ALTER TABLE registro_aeropuerto
    RENAME COLUMN "edad_a_os" TO edad_anios;
ALTER TABLE registro_aeropuerto
    RENAME COLUMN "rea_conocimiento" TO area_conocimiento;
ALTER TABLE registro_aeropuerto
    RENAME COLUMN "nivel_acad_mico" TO nivel_academico;
ALTER TABLE registro_aeropuerto
    RENAME COLUMN "g_nero" TO genero;
ALTER TABLE registro_aeropuerto
    RENAME COLUMN "localizaci_n" TO localizacion;

-- Verificamos que las columnas hayan sido renombradas correctamente
SELECT column_name 
FROM information_schema.columns
WHERE table_name = 'registro_aeropuerto';

-- Ahora, verificamos el tipo de datos de cada columna para asegurarnos de que sean los correctos
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'registro_aeropuerto';

-- Observamos que algunas columnas que deberían ser de tipo numérico están como texto, por lo que vamos a convertirlas
-- Pero antes, verificamos si hay valores no numéricos en esas columnas (edad_anios, estatura_cm, cantidad_de_personas) y al final las convertimos a tipo numérico.

-- 1. Limpieza y transformación de la columna 'edad_anios'
-- 1.1 Verificar valores únicos de edad
SELECT edad_anios
FROM registro_aeropuerto
GROUP BY edad_anios
ORDER BY edad_anios ASC;

-- 1.2 Revisar cómo se distribuyen los valores por grupo de edad
SELECT grupo_edad, edad_anios
FROM registro_aeropuerto
GROUP BY grupo_edad, edad_anios
ORDER BY grupo_edad, edad_anios ASC;

-- 1.3 Identificación:
-- '-1'  → grupo 'DESCONOCIDO'
-- '>= 100' → valores improbables para viajeros (error de registro)
-- Valores inconsistentes en el grupo 'PRIMERA INFANCIA' (0-5 años) con edades mayores a 5 años, se hara el arreglo despues convertir la columna a tipo numérico.

-- 1.4 Verificar cuántos registros se verán afectados
SELECT COUNT(*)
FROM registro_aeropuerto
WHERE TRIM(edad_anios) = '-1'
   OR CAST(TRIM(edad_anios) AS INTEGER) >= 100;

-- 1.5 Limpieza: reemplazar datos inválidos con NULL, no se eliminarán registros para aprovechar toda la información posible
UPDATE registro_aeropuerto
SET edad_anios = NULL
WHERE TRIM(edad_anios) = '-1'
   OR CAST(TRIM(edad_anios) AS INTEGER) >= 100;

-- 1.6 Volver a verificar valores únicos
SELECT edad_anios
FROM registro_aeropuerto
GROUP BY edad_anios
ORDER BY edad_anios ASC;

-- 1.7 Verificar campos que podrían indicar errores de registros con edades entre 0 y 3 años
SELECT *
FROM registro_aeropuerto
WHERE CAST(edad_anios AS INTEGER) BETWEEN 0 AND 3;

-- 1.8 Corregir área, subárea de conocimiento y nivel académico para edades entre 0 y 3 años
UPDATE registro_aeropuerto
SET 
    area_conocimiento = 'NINGUNA',
    sub_area_conocimiento = 'NINGUNA'
WHERE CAST(edad_anios AS INTEGER) BETWEEN 0 AND 3
  AND (
        area_conocimiento <> 'NINGUNA'
        OR sub_area_conocimiento <> 'NINGUNA'
      );
UPDATE registro_aeropuerto
SET nivel_academico = 'NO INDICA'
WHERE CAST(edad_anios AS INTEGER) BETWEEN 0 AND 3
  AND nivel_academico NOT IN ('NINGUNO', 'NO INDICA', 'PRIMARIA');

-- 1.9 Verificación final de los cambios realizados
SELECT *
FROM registro_aeropuerto
WHERE CAST(edad_anios AS INTEGER) BETWEEN 0 AND 3;

-- 2. Limpieza y transformación de la columna 'estatura_cm'
-- 2.1 Verificar valores únicos de estatura_cm
SELECT estatura_cm AS ec
FROM registro_aeropuerto
GROUP BY ec
ORDER BY ec ASC;

-- 2.2 Identificación de valores no numéricos o improbables:
-- valores menores a 50 cm, '-1' y '17070' → errores de registro

-- 2.3 Verificar cuántos registros se verán afectados
SELECT COUNT(*) AS total_registros_menor_igual_50
FROM registro_aeropuerto
WHERE
    CAST(
        REGEXP_REPLACE(TRIM(estatura_cm), '[^0-9\-]', '', 'g')
    AS INTEGER
    ) <= 50;

-- 2.4 Imputar NULL en los registros con estatura inválida
UPDATE registro_aeropuerto
SET estatura_cm = NULL
WHERE
    CAST(
        REGEXP_REPLACE(TRIM(estatura_cm), '[^0-9\-]', '', 'g')
    AS INTEGER
    ) <= 50
    OR TRIM(estatura_cm) = '-1'
    OR TRIM(estatura_cm) = '17070';

-- 2.5 Verificar valores únicos después de la limpieza
SELECT estatura_cm AS ec
FROM registro_aeropuerto
GROUP BY ec
ORDER BY ec ASC;

-- 2.6 Verificar si la estatura desde 50 cm hasta 100 cm tiene sentido en el contexto del dataset
SELECT grupo_edad, estatura_cm
FROM registro_aeropuerto
WHERE
    CAST(
        REGEXP_REPLACE(TRIM(estatura_cm), '[^0-9\-]', '', 'g')
    AS INTEGER
    ) BETWEEN 50 AND 100;

--2.7 Las estaturas entre 50 cm y 100 cm no corresponden al grupo de edad correspondiente, por lo que se imputará 'PRIMERA INFANCIA' a esos registros
UPDATE registro_aeropuerto
SET grupo_edad = 'PRIMERA INFANCIA'
WHERE
    CAST(
        REGEXP_REPLACE(TRIM(estatura_cm), '[^0-9\-]', '', 'g')
    AS INTEGER
    ) BETWEEN 50 AND 100;

--2.8 Verificación final de los cambios realizados
SELECT grupo_edad, estatura_cm
FROM registro_aeropuerto
WHERE
    CAST(
        REGEXP_REPLACE(TRIM(estatura_cm), '[^0-9\-]', '', 'g')
    AS INTEGER
    ) BETWEEN 50 AND 100;

-- 3. Limpieza y transformación de la columna 'cantidad_de_personas'
-- 3.1 Verificar valores únicos de cantidad_de_personas
SELECT cantidad_de_personas
FROM registro_aeropuerto
GROUP BY cantidad_de_personas
ORDER BY cantidad_de_personas ASC;

-- 3.2 No hay inconsistencias aparentes, asi que no es necesario realizar limpieza en esta columna.

-- Ahora, procederemos a convertir las columnas 'edad_anios', 'estatura_cm' y 'cantidad_de_personas' a tipo numérico.
ALTER TABLE registro_aeropuerto
    ALTER COLUMN edad_anios TYPE INTEGER
    USING CAST(TRIM(edad_anios) AS INTEGER);
ALTER TABLE registro_aeropuerto
    ALTER COLUMN estatura_cm TYPE INTEGER
    USING CAST(TRIM(estatura_cm) AS INTEGER);
ALTER TABLE registro_aeropuerto
    ALTER COLUMN cantidad_de_personas TYPE INTEGER
    USING CAST(TRIM(cantidad_de_personas) AS INTEGER);

-- Verificamos que las columnas hayan sido convertidas correctamente
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'registro_aeropuerto';

-- Ahora, haremos el cambio de la columnas 'edad_anios' a 'grupo_edad' basado en los siguientes rangos:
-- '0-5'   → 'PRIMERA INFANCIA'
-- '6-11'  → 'INFANCIA'
-- '12-17' → 'ADOLESCENCIA'
-- '18-28' → 'ADULTOS JOVENES'
-- '29-59' → 'ADULTOS'
-- '60-99' → 'ADULTOS MAYORES'
UPDATE registro_aeropuerto
SET grupo_edad = 
    CASE 
        WHEN edad_anios BETWEEN 0 AND 5 THEN 'PRIMERA INFANCIA'
        WHEN edad_anios BETWEEN 6 AND 11 THEN 'INFANCIA'
        WHEN edad_anios BETWEEN 12 AND 17 THEN 'ADOLESCENCIA'
        WHEN edad_anios BETWEEN 18 AND 28 THEN 'ADULTOS JOVENES'
        WHEN edad_anios BETWEEN 29 AND 59 THEN 'ADULTOS'
        WHEN edad_anios BETWEEN 60 AND 99 THEN 'ADULTOS MAYORES'
        ELSE 'DESCONOCIDO'
    END;

-- Ahora, las columnas 'localizacion' y 'fecha_de_registro' deben ser convertidas a tipos adecuados (BOOLEAN y DATE respectivamente)
-- 1. Ver los datos de la columna 'localizacion' para identificar los valores presentes
SELECT localizacion
FROM registro_aeropuerto
GROUP BY localizacion
ORDER BY localizacion ASC;

-- 1.1 Los datos estan en formato JSON, asi que, vamos a crear dos columnas nuevas
ALTER TABLE registro_aeropuerto
ADD COLUMN latitud NUMERIC,
ADD COLUMN longitud NUMERIC;

-- 1.2 Extraer latitud y longitud del campo 'localizacion' y almacenarlos en las nuevas columnas
UPDATE registro_aeropuerto
SET
    latitud = (localizacion::json->>'latitude')::NUMERIC,
    longitud = (localizacion::json->>'longitude')::NUMERIC;

-- 1.3 Verificar que los datos se hayan extraído correctamente
SELECT localizacion, latitud, longitud
FROM registro_aeropuerto
LIMIT 5;

-- 1.4 Eliminar la columna 'localizacion' original
ALTER TABLE registro_aeropuerto
DROP COLUMN localizacion;

-- 2. Conversión de la columna 'fecha_de_registro' a tipo DATE
-- 2.1 Ver los datos de la columna 'fecha_de_registro' para identificar
SELECT fecha_de_registro
FROM registro_aeropuerto
GROUP BY fecha_de_registro
ORDER BY fecha_de_registro ASC;

-- 2.2 Convertir la columna 'fecha_de_registro' a tipo DATE
ALTER TABLE registro_aeropuerto
    ALTER COLUMN fecha_de_registro TYPE DATE
    USING TO_DATE(TRIM(fecha_de_registro), 'YYYY-MM');

-- 2.3 Verificar que la conversión se haya realizado correctamente y el tipo de dato sea DATE
SELECT fecha_de_registro
FROM registro_aeropuerto
LIMIT 5;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'registro_aeropuerto';

-- Verificamos nuevamente el dataset para asegurarnos de que todo esté en orden
SELECT * FROM registro_aeropuerto LIMIT 5;

-- En la columna 'pais', verificamos si hay valores inconsistentes o erróneos
SELECT pais
FROM registro_aeropuerto
GROUP BY pais
ORDER BY pais ASC;

SELECT oficina_de_registro
FROM registro_aeropuerto
GROUP BY oficina_de_registro
ORDER BY oficina_de_registro ASC;


-- Los nombres de ESPAÑA y CURAZAO tienen inconcistencias con su escritura, asi que los corregimos
UPDATE registro_aeropuerto
    SET pais = 'ESPAÑA'
    WHERE pais LIKE 'ESPA�A';
UPDATE registro_aeropuerto
    SET pais = 'CURACAO'
    WHERE pais LIKE 'CURA�AO';

-- Verificamos nuevamente los valores únicos en la columna 'pais' después de las correcciones
SELECT pais
FROM registro_aeropuerto
GROUP BY pais
ORDER BY pais ASC;

-- Ahora el dataset está limpio y transformado correctamente, listo para su análisis posterior en el siguiente documento SQL.