-- Comprobamos si el dataset se ha cargado correctamente
SELECT * FROM registro_aeropuerto LIMIT 5;

-- Verificamos la codificación de caracteres utilizada en la base de datos
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

SELECT *
FROM registro_aeropuerto
WHERE CAST(edad_anios AS INTEGER) = 0
  AND nivel_academico IS NOT NULL;


-- 2.1 Verificar valores únicos de estatura_cm
SELECT estatura_cm AS ec
FROM registro_aeropuerto
GROUP BY ec
ORDER BY ec ASC;

-- 2.2 Identificación de valores no numéricos o improbables:
-- valores menores a 50 cm, '-1' y '17070' → errores de registro
-- 2.3 Verificar cuántos registros se verán afectados
SELECT COUNT(*)
FROM registro_aeropuerto
WHERE CAST(REGEXP_REPLACE(TRIM(estatura_cm), '[^0-9\-]') AS INTEGER) <= 50
ORDER BY estatura_cm ASC;

-- 7.1 Conversión final del tipo de dato
ALTER TABLE registro_aeropuerto
ALTER COLUMN edad_anios TYPE INTEGER
USING CAST(TRIM(edad_anios) AS INTEGER);

-- Finalmente, vamos a revisar si hay valores nulos en las columnas del dataset
SELECT COUNT(*)
FROM registro_aeropuerto
WHERE NOT (registro_aeropuerto IS NOT NULL);

-- Observamos que ninguna columna tiene valores nulos, por lo que no es necesario realizar limpieza de datos en ese aspecto.
