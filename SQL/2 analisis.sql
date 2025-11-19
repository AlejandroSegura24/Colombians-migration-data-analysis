-- Primeramente, vemos la estructura de la tabla
SELECT * FROM registro_aeropuerto LIMIT 10;

-- Ahora, realizamos un análisis de la tabla registro_aeropuerto

----- 1. Análisis por paises -----

-- 1.1 Número de registros por ciudad de nacimiento
SELECT ciudad_de_nacimiento, COUNT(*) AS total_por_pais
FROM registro_aeropuerto
GROUP BY ciudad_de_nacimiento
ORDER BY total_por_pais DESC
LIMIT 30;
-- Vemos que la mayoría de los registros provienen de Colombia, principalmente de ciudades como Bogotá, Cali y Medellín.

-- 1.2 Número de registros por país de destino
SELECT pais AS pais_destino, COUNT(*) AS total_por_pais_destino
FROM registro_aeropuerto
GROUP BY pais_destino
ORDER BY total_por_pais_destino DESC
LIMIT 30;
-- Observamos que los destinos más comunes son Estados Unidos, España y Venezuela.

-- 1.3 Número de registros por combinación de país de origen y destino
SELECT ciudad_de_nacimiento, pais AS pais_destino, COUNT(*) AS total_combinacion
FROM registro_aeropuerto
GROUP BY ciudad_de_nacimiento, pais_destino
ORDER BY total_combinacion DESC
LIMIT 30;
-- Esto nos muestra las rutas más frecuentes, como Bogotá a Estados Unidos y Cali a España.

-- 1.4 Pais de destino con mayor número de grupos familiares
SELECT pais AS pais_destino, COUNT(*) AS total_grupos_familiares, ARRAY_AGG(DISTINCT cantidad_de_personas ORDER BY cantidad_de_personas) AS grupos_distintos
FROM registro_aeropuerto
WHERE cantidad_de_personas <> 1
GROUP BY pais_destino
ORDER BY total_grupos_familiares DESC
LIMIT 30;
-- Aquí podemos ver que los grupos familiares más diversos tienden a viajar a países como Venezuela, Estados Unidos y España.

-- 1.5 Pais de destino con personas que viajan solas
SELECT pais AS pais_destino, COUNT(*) AS total_personas_solas
FROM registro_aeropuerto
WHERE cantidad_de_personas = 1
GROUP BY pais_destino
ORDER BY total_personas_solas DESC
LIMIT 30;
-- Este análisis revela que muchos individuos que viajan solos se dirigen a Estados Unidos, España, Venezuela y Ecuador.

----- 2. Análisis por características de los viajeros -----

-- 2.1 Número de registros por rango de edad

SELECT grupo_edad, CONCAT(MIN(edad_anios), ' - ',MAX(edad_anios)) AS rango_edad, COUNT(*) AS total_por_rango_edad
FROM registro_aeropuerto
GROUP BY grupo_edad
ORDER BY total_por_rango_edad DESC;
-- Vemos que el grupo de adultos (29 - 59 años) es el más numeroso, seguido por adultos mayores (60 - 99 años) y adultos jovenes (18 - 28 años).

-- 2.2 Promedio de edad por rango de edad
SELECT grupo_edad, ROUND(AVG(edad_anios)) AS promedio_anios,COUNT(*) AS total_por_rango_edad
FROM registro_aeropuerto
GROUP BY grupo_edad
ORDER BY total_por_rango_edad DESC;
-- Esto nos da una idea del promedio de edad dentro de cada grupo etario.

-- 2.3 Top 3 país de destino más común por rango de edad
SELECT grupo_edad, pais AS pais_destino, total_migrantes
FROM (
    SELECT grupo_edad, pais, COUNT(*) AS total_migrantes,ROW_NUMBER() 
               OVER (PARTITION BY grupo_edad
               ORDER BY COUNT(*) DESC
           ) AS pos
    FROM registro_aeropuerto
    GROUP BY grupo_edad, pais
)
WHERE pos <= 3
ORDER BY grupo_edad, total_migrantes DESC;
-- Aquí podemos ver como la mayoria de los grupos tiene los mismos destinos principales: Estados Unidos, España y Venezuela.

SELECT * FROM registro_aeropuerto LIMIT 10;