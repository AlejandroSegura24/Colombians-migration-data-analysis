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
-- Pero antes, verificamos si hay valores no numéricos en esas columnas (edad_anios, estatura_cm, cantidad_de_personas)

-- Verificamos los valores únicos en la columna edad_anios
SELECT edad_anios AS ea
FROM registro_aeropuerto
GROUP BY edad_anios
ORDER BY edad_anios ASC

-- Observamos que hay valores incoherentes como '-1' y años mayores a 100, por lo que vamos a ver en que grupo de edad se encuentran esos registros
SELECT grupo_edad, edad_anios
FROM registro_aeropuerto
GROUP BY grupo_edad, edad_anios
ORDER BY grupo_edad, edad_anios ASC;

-- Al ver como se distribuyen los grupos de edad, podemos identificar que el valor '-1' corresponde al grupo 'DESCONOCIDO' y los valores mayores a 100 corresponden al grupo 'ADULTO MAYOR'
-- Por lo tanto, vamos a eliminar esos registros antes de convertir la columna edad_anios a tipo numérico
DELETE FROM registro_aeropuerto
WHERE edad_anios = '-1' OR CAST(edad_anios AS INTEGER) > 100;

-- Finalmente, vamos a revisar si hay valores nulos en las columnas del dataset
SELECT COUNT(*)
FROM registro_aeropuerto
WHERE NOT (registro_aeropuerto IS NOT NULL);

-- Observamos que ninguna columna tiene valores nulos, por lo que no es necesario realizar limpieza de datos en ese aspecto.
