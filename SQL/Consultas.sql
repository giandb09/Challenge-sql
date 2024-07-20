-- Primera consulta
SELECT TOP (200) DisplayName, Location, Reputation -- Selecciona los primeros 200 nombres de usuario, ubicaciones y reputaciones
FROM Users -- De la tabla 'Users'
ORDER BY Reputation DESC -- Ordenados por reputación de forma descendente (mayor a menor)

-- Segunda consulta
SELECT TOP (200) p.Title, u.DisplayName -- Selecciona los primeros 200 títulos de publicaciones y nombres de usuario
FROM dbo.Posts p -- De la tabla 'Posts' alias 'p'
JOIN dbo.Users u ON p.OwnerUserId = u.Id -- Realiza un JOIN con la tabla 'Users' alias 'u' en donde 'OwnerUserId' de 'Posts' coincide con 'Id' de 'Users'
WHERE p.Title IS NOT NULL -- Filtra donde el título de la publicación no sea NULL
AND u.DisplayName IS NOT NULL; -- Y donde el nombre de usuario no sea NULL

-- Tercera consulta
SELECT TOP (200) u.DisplayName, AVG(CAST(p.Score AS FLOAT)) AS AverageScore -- Selecciona los primeros 200 nombres de usuario y el promedio de sus puntajes de publicaciones, convirtiendo el puntaje a FLOAT
FROM Users u -- De la tabla 'Users' alias 'u'
INNER JOIN Posts p ON u.Id = p.OwnerUserId -- Realiza un INNER JOIN con la tabla 'Posts' alias 'p' en donde 'Id' de 'Users' coincide con 'OwnerUserId' de 'Posts'
WHERE p.OwnerUserId IS NOT NULL -- Filtra donde 'OwnerUserId' no sea NULL
GROUP BY u.id, u.Displayname -- Agrupa los resultados por 'Id' y 'DisplayName' del usuario
ORDER BY AverageScore DESC -- Ordena los resultados por el promedio de puntaje de forma descendente

-- Cuarta consulta
SELECT TOP (200) u.DisplayName -- Selecciona los primeros 200 nombres de usuario
FROM Users u -- De la tabla 'Users' alias 'u'
WHERE u.id IN ( -- Donde el 'Id' del usuario esté en el siguiente subconsulta
    SELECT UserId -- Selecciona 'UserId'
        FROM Comments -- De la tabla 'Comments'
        GROUP BY UserId -- Agrupa por 'UserId'
        HAVING COUNT(*) > 100 -- Y filtra los grupos que tengan más de 100 comentarios
)

-- Quinta consulta
UPDATE Users -- Actualiza la tabla 'Users'
SET Location = 'unknown' -- Establece 'Location' como 'unknown'
WHERE Location IS NULL OR TRIM(Location) = '' -- Donde 'Location' sea NULL o vacío (después de eliminar los espacios en blanco)

PRINT 'La actualizacion se realizo existosamente. Se han actualizado' + CAST(@@ROWCOUNT AS VARCHAR(10)) + 'filas.' -- Imprime un mensaje indicando cuántas filas fueron actualizadas

SELECT TOP (200) Displayname, Location -- Selecciona los primeros 200 nombres de usuario y ubicaciones
FROM Users -- De la tabla 'Users'
WHERE Location = 'unknown' -- Donde la ubicación sea 'unknown'
ORDER BY DisplayName -- Ordena los resultados por nombre de usuario

-- Sexta consulta
DELETE Comments -- Elimina de la tabla 'Comments'
FROM Comments -- De la tabla 'Comments'
JOIN Users On Comments.UserId = Users.Id -- Realiza un JOIN con la tabla 'Users' en donde 'UserId' de 'Comments' coincide con 'Id' de 'Users'
WHERE Users.Reputation < 100; -- Donde la reputación del usuario sea menor a 100

DECLARE @DeletedCount INT; -- Declara una variable 'DeletedCount' de tipo entero
SET @DeletedCount = @@ROWCOUNT; -- Asigna a 'DeletedCount' el número de filas afectadas por la última instrucción
PRINT CAST(@DeletedCount AS VARCHAR) + ' comentarios fueron eliminados.' -- Imprime un mensaje indicando cuántos comentarios fueron eliminados

-- Séptima Consulta
SELECT OwnerUserId, COUNT(*) AS TotalPosts -- Selecciona 'OwnerUserId' y el conteo total de publicaciones
FROM Posts -- De la tabla 'Posts'
GROUP BY OwnerUserId; -- Agrupa por 'OwnerUserId'

SELECT UserId, COUNT(*) AS TotalComments -- Selecciona 'UserId' y el conteo total de comentarios
FROM Comments -- De la tabla 'Comments'
GROUP BY UserId; -- Agrupa por 'UserId'

SELECT UserId, COUNT(*) AS TotalBadges -- Selecciona 'UserId' y el conteo total de insignias
FROM Badges -- De la tabla 'Badges'
GROUP BY UserId; -- Agrupa por 'UserId'

SELECT u.DisplayName AS DisplayName, -- Selecciona 'DisplayName' como 'DisplayName'
    COALESCE(tp.TotalPosts, 0) AS TotalPosts, -- Selecciona el total de publicaciones o 0 si no hay
    COALESCE(tc.TotalComments, 0) AS TotalComments, -- Selecciona el total de comentarios o 0 si no hay
    COALESCE(tb.TotalBadges, 0) AS TotalBadges -- Selecciona el total de insignias o 0 si no hay
FROM Users u -- De la tabla 'Users' alias 'u'
LEFT JOIN ( -- Realiza un LEFT JOIN con la siguiente subconsulta
    SELECT OwnerUserId, COUNT(*) AS TotalPosts -- Selecciona 'OwnerUserId' y el conteo total de publicaciones
    FROM Posts -- De la tabla 'Posts'
    GROUP BY OwnerUserId -- Agrupa por 'OwnerUserId'
) tp ON u.Id = tp.OwnerUserId -- En donde 'Id' de 'Users' coincide con 'OwnerUserId'
LEFT JOIN ( -- Realiza un LEFT JOIN con la siguiente subconsulta
    SELECT UserId, COUNT(*) AS TotalComments -- Selecciona 'UserId' y el conteo total de comentarios
    FROM Comments -- De la tabla 'Comments'
    GROUP BY UserId -- Agrupa por 'UserId'
) tc ON u.Id = tc.UserId -- En donde 'Id' de 'Users' coincide con 'UserId'
LEFT JOIN ( -- Realiza un LEFT JOIN con la siguiente subconsulta
    SELECT UserId, COUNT(*) AS TotalBadges -- Selecciona 'UserId' y el conteo total de insignias
    FROM Badges -- De la tabla 'Badges'
    GROUP BY UserId -- Agrupa por 'UserId'
) tb ON u.Id = tb.UserId -- En donde 'Id' de 'Users' coincide con 'UserId'
ORDER BY u.DisplayName; -- Ordena los resultados por nombre de usuario

-- Octava consulta
SELECT TOP 10 -- Selecciona los primeros 10
    Title, -- Títulos
    Score -- Y puntajes
FROM 
    Posts -- De la tabla 'Posts'
ORDER BY 
    Score DESC; -- Ordenados por puntaje de forma descendente

-- Novena consulta
SELECT TOP 5 -- Selecciona los primeros 5
    Text, -- Textos
    CreationDate -- Y fechas de creación
FROM 
    Comments -- De la tabla 'Comments'
ORDER BY 
    CreationDate DESC; -- Ordenados por fecha de creación de forma descendente