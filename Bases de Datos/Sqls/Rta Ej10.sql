--Request (NoRequest, IP, Fecha, Hora, IDMetodo)
--Page (IP, WebPage, IDAmbiente)
--Método (ID, Clase, Metodo)
--Ambiente (ID, Descripción)
--Nota: El ambiente podrá ser Desarrollo, Testing o Producción. La función date() devuelve la fecha actual.
--Si se resta un valor entero a la función, restará días. El ejercicio consiste en indicar qué enunciado dio
--origen a cada una de las consultas:
--1)
-- Listar los distintos días, los distintos métodos y la última fecha en que se hizo requests por cada IP
SELECT P.IP, count(distinct fecha), count(distinct IDMetodo), max(fecha)
FROM Page P 
INNER JOIN Request R 
ON P.IP=R.IP
GROUP BY P.IP


--2)
--Los ambientes que hayan tenido un request en todas las páginas en la última semana
SELECT * FROM Ambiente A
WHERE id NOT IN (	SELECT idAmbiente
					FROM Page P
					WHERE NOT EXISTS (
										SELECT 1 FROM Request R
										WHERE R.IP=P.IP 
										AND fecha>= date()-7))

--3)
-- Días en los que hubo 10 o más requests entre las 00:00 y las 04:00, y que no haya hecho requests a una página en ambiente de desarrollo 

SELECT Fecha, count(*) FROM Request R
WHERE hora BETWEEN '00:00' AND '04:00'
AND NOT EXISTS (	SELECT 1 FROM Page P
					INNER JOIN Ambiente A 
					ON P.IDAmbiente = A.ID
					WHERE R.IP=P.IP 
					AND A.Descripcion='Desarrollo' )
GROUP BY fecha
HAVING count(*) >= 10

--4)
-- Mostrar la última fecha de cada página del tipo "www" en cada ambiente de la última semana que haya tenido un request todos los días. 'S'

SELECT W.WebPage, A.Descripcion, max(R.fecha), 'S' FROM Request R
INNER JOIN WebPage W 
ON R.IP=W.IP
INNER JOIN Ambiente A 
ON A.id=W.IDAmbiente
WHERE R.Fecha>=date()-7 AND W.Webpage LIKE 'www%'
GROUP BY W.WebPage, A.Descripcion
HAVING count(distinct fecha)>=7

--5)
-- Mostrar la última fecha que se hizo request de cada página del tipo FTP en cada ambiente, que haya tenido hasta 6 requests en la última semana, en el caso que no haya tenido request, mostrar como fecha "01/01/1900"


SELECT W.WebPage, A.Descripcion, max(case when R2.fecha is null then '01/01/1900' else R2.fecha end), 'N'
FROM WebPage W 
LEFT JOIN (	SELECT IP, max(fecha) FROM Request R
			GROUP BY IP ) R2 
ON R2.IP = W.IP
WHERE W.Webpage LIKE 'ftp%' 
AND NOT EXISTS (	SELECT 1 FROM Request R
					WHERE R.IP=W.IP and R.Fecha >= date() - 7
					GROUP BY R.IP
					HAVING count(*) >= 7)
GROUP BY W.WebPage, A.Descripcion

--6)
--Insertar en la tabla Page todos los métodos que se hayan ejecutado en los requests de los últimos 30 días para las IP que no se hayan insertado antes.

INSERT INTO Page
				(SELECT IP, 'Web ' + IDMetodo, '?'
				FROM request R
				WHERE NOT EXISTS (
									SELECT 1 FROM Page P
									WHERE R.IP = P.IP )
				AND IDMetodo IN (select ID from Metodo)
				AND fecha >= getdate()-30)