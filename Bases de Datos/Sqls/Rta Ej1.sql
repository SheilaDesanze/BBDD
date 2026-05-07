--1. Listar los nombres de los proveedores de la ciudad de La Plata.SELECT nombre FROM Proveedor WHERE ciudad = 'La Plata';--2. Listar los números de artículos cuyo precio sea inferior a $10.

SELECT codArt FROM articulo 
WHERE Precio < 10;

--3. Listar los responsables de los almacenes.

SELECT Responsable FROM Almacen;

--4. Listar los códigos de los materiales que provea el proveedor 10 y no los provea el proveedor 15.

SELECT CodMat FROM Provisto_Por 
WHERE CodProv = 10 
AND CodMat NOT IN (
					SELECT CodMat FROM Provisto_Por 
					WHERE CodProv = 15);

--5. Listar los números de almacenes que almacenan el artículo A.

SELECT NroAlmacen FROM tiene 
WHERE CodArt = 1;

--6. Listar los proveedores de Pergamino que se llamen Pérez.

SELECT * FROM Proveedor 
WHERE nombre LIKE '%Perez%'

--7. Listar los almacenes que contienen los artículos A y los artículos B (ambos).

SELECT almacen.* FROM almacen 
INNER JOIN tiene t1 ON almacen.Nro = t1.NroAlmacen 
INNER JOIN tiene t2 ON almacen.Nro = t2.NroAlmacen 
WHERE t1.CodArt = 1 
AND t2.CodArt = 2

---------------------------------

SELECT NroAlmacen
FROM Tiene
WHERE CodArt = 1
INTERSECT
SELECT NroAlmacen
FROM Tiene
WHERE CodArt = 2


--8. Listar los artículos que cuesten más de $100 o que estén compuestos por el material M1.

SELECT * from articulo as a1 
WHERE precio < 100 
OR EXISTS (
			select 1 from articulo as a2 
			inner join Compuesto_Por on Compuesto_Por.CodArt = a2.CodArt 
			WHERE Compuesto_Por.CodMat = 1 
			AND a1.CodArt = a2.CodArt)

--9. Listar los materiales, código y descripción, provistos por proveedores de la ciudad de Rosario.



--10. Listar el código, descripción y precio de los artículos que se almacenan en A1.

select * from articulo 
inner join tiene on tiene.CodArt = articulo.CodArt 
where tiene.NroAlmacen = 1

--11. Listar la descripción de los materiales que componen el artículo B.

select material.* from material 
inner join Compuesto_Por on Compuesto_Por.CodMat = material.CodMat 
where Compuesto_Por.CodArt = 2

--12. Listar los nombres de los proveedores que proveen los materiales al almacén que Martín Gómez tiene a su cargo.

SELECT proveedor.* FROM proveedor 
INNER JOIN Provisto_Por ON Provisto_Por.CodProv = Proveedor.CodProv 
INNER JOIN Compuesto_Por ON Compuesto_Por.CodMat = Provisto_Por.CodMat
INNER JOIN Tiene ON Tiene.CodArt = Compuesto_Por.CodArt
INNER JOIN Almacen ON Tiene.NroAlmacen = Almacen.Nro
WHERE Almacen.Responsable = 'Martín Gómez'

--13. Listar códigos y descripciones de los artículos compuestos por al menos un material provisto por el proveedor López.

SELECT * FROM articulo WHERE CodArt IN (select articulo.CodArt from Articulo
inner join Compuesto_Por on Compuesto_Por.CodArt = Articulo.CodArt
inner join Provisto_Por on Provisto_Por.CodMat = Compuesto_Por.CodMat
inner join Proveedor on Proveedor.CodProv = Provisto_Por.CodProv
WHERE proveedor.nombre LIKE '%BOEDO%')

--14. Hallar los códigos y nombres de los proveedores que proveen al menos un material que se usa en algún artículo cuyo precio es mayor a $100.

SELECT * FROM proveedor WHERE CodProv IN (SELECT CodProv FROM provisto_por WHERE CodMat IN (SELECT CodMat FROM compuesto_por WHERE compuesto_por.CodArt IN (SELECT CodArt FROM articulo WHERE precio > 100)))

--15. Listar los números de almacenes que tienen todos los artículos que incluyen el material con código 123.

SELECT * FROM Almacen 
WHERE NOT EXISTS (
					SELECT 1 FROM Articulo 
					INNER JOIN Compuesto_Por
					ON Compuesto_Por.CodArt = articulo.CodArt
					WHERE Compuesto_Por.CodMat = 1 AND NOT EXISTS (
										SELECT 1 FROM Tiene 
										WHERE tiene.CodArt = Articulo.CodArt
										AND tiene.NroAlmacen = Almacen.Nro
										))

										
SELECT * FROM almacen WHERE Nro NOT IN (SELECT NroAlmacen FROM (select almacen.Nro as NroAlmacen, a1.CodArt as CodArt from articulo as a1, almacen WHERE a1.CodArt IN (select Codart FROM Compuesto_Por WHERE CodMat = 1) EXCEPT (SELECT * FROM Tiene)) as t1)



SELECT * from Almacen WHERE nro in (
									SELECT NroAlmacen 
									FROM Tiene 
									WHERE Tiene.CodArt IN (select CodArt FROM Compuesto_Por WHERE Compuesto_Por.CodMat = 1)
									GROUP BY NroAlmacen 
									HAVING count(*) = (
														SELECT count(*) 
														FROM Articulo
														WHERE articulo.CodArt IN (select CodArt FROM Compuesto_Por WHERE Compuesto_Por.CodMat = 1)));

--16. Listar los proveedores de Capital Federal que sean únicos proveedores de algún material.


SELECT * FROM Proveedor
WHERE CodProv IN (
					SELECT CodProv FROM Provisto_Por
					WHERE CodProv IN (	SELECT CodProv FROM Proveedor
										WHERE Ciudad = 'CABA')
					AND CodMat IN (
									SELECT CodMat FROM Provisto_Por
									WHERE CodProv IN (	SELECT CodProv FROM Proveedor
														WHERE Ciudad = 'CABA')
									GROUP BY CodMat
									HAVING count(*) = 1)
					);
					select * from Provisto_Por

SELECT * FROM Proveedor
WHERE CodProv IN (SELECT CodProv FROM Provisto_Por WHERE CodProv IN (	SELECT CodProv FROM Proveedor
										WHERE Ciudad = 'CABA')
					AND CodMat NOT IN 
(SELECT p1.CodMat FROM Provisto_Por as p1, Provisto_Por as p2 WHERE 
									 CodProv IN (	SELECT CodProv FROM Proveedor
														WHERE Ciudad = 'CABA') AND p1.CodProv <> p2.CodProv AND p1.CodMat = p2.CodMat))

--17. Listar el/los artículo/s de mayor precio.

select * from Articulo WHERE Precio >= ALL (SELECT precio FROM Articulo)

SELECT * FROM Articulo WHERE Precio NOT IN (SELECT a1.precio FROM articulo as a1, articulo as a2 WHERE a1.precio < a2.precio)

--18. Listar el/los artículo/s de menor precio.

select * from Articulo WHERE Precio <= ALL (SELECT precio FROM Articulo)

SELECT * FROM Articulo WHERE Precio NOT IN (SELECT a1.precio FROM articulo as a1, articulo as a2 WHERE a1.precio > a2.precio)

--19. Listar el promedio de precios de los artículos en cada almacén.

SELECT almacen.nro, AVG(articulo.precio) FROM articulo 
INNER JOIN Tiene ON Tiene.CodArt = Articulo.CodArt 
INNER JOIN almacen ON Tiene.NroAlmacen = Almacen.Nro
GROUP BY Almacen.Nro

--20. Listar los almacenes que almacenan la mayor cantidad de artículos.

select nroalmacen, count(CodArt) from Tiene 
group by NroAlmacen
HAVING COUNT(CodArt) = (
	SELECT MAX(art_por_almacen)
	FROM (
		SELECT count(codart) as art_por_almacen
		from tiene
		group by nroalmacen
	) as subquery
)

--21. Listar los artículos compuestos por al menos 2 materiales.

select c1.CodArt from Compuesto_Por as c1, Compuesto_Por c2
WHERE c1.CodArt = c2.CodArt AND c1.CodMat <> c2.CodMat

--22. Listar los artículos compuestos por exactamente 2 materiales.

select c1.CodArt from Compuesto_Por as c1, Compuesto_Por c2
WHERE c1.CodArt = c2.CodArt AND c1.CodMat <> c2.CodMat
EXCEPT
(select c1.CodArt from Compuesto_Por as c1, Compuesto_Por c2, Compuesto_Por c3
WHERE c1.CodArt = c2.CodArt  
AND c2.CodArt = c3.CodArt 
AND c1.CodMat <> c2.CodMat
AND c1.CodMat <> c3.CodMat
AND c2.CodMat <> c3.CodMat)

--23. Listar los artículos que estén compuestos con hasta 2 materiales.


select CodArt from Compuesto_Por
EXCEPT
(select c1.CodArt from Compuesto_Por as c1, Compuesto_Por c2, Compuesto_Por c3
WHERE c1.CodArt = c2.CodArt  
AND c2.CodArt = c3.CodArt 
AND c1.CodMat <> c2.CodMat
AND c1.CodMat <> c3.CodMat
AND c2.CodMat <> c3.CodMat)

--24. Listar los artículos compuestos por todos los materiales.

SELECT * FROM articulo
WHERE NOT EXISTS (
					SELECT 1 FROM Material
					WHERE NOT EXISTS (
										SELECT 1 FROM Compuesto_Por
										WHERE Compuesto_Por.CodMat = Material.CodMat
										AND Compuesto_Por.CodArt = Articulo.CodArt))

										
SELECT * from articulo WHERE CodArt in (
									SELECT CodArt 
									FROM Compuesto_Por 
									GROUP BY CodArt 
									HAVING count(*) = (
														SELECT count(*) 
														FROM Material))
														
SELECT * FROM articulo WHERE CodArt NOT IN (SELECT CodArt FROM (select articulo.CodArt as CodArt, m1.CodMat as CodMat from articulo, material as m1 EXCEPT (SELECT * FROM Compuesto_Por)) as t1);

--25. Listar las ciudades donde existan proveedores que provean todos los materiales.
SELECT * FROM Proveedor WHERE CodProv NOT IN (SELECT CodProv FROM (select m1.CodMat as CodMat, Proveedor.CodProv as CodProv from material as m1, Proveedor EXCEPT (SELECT * FROM Provisto_Por)) as t1);
select * from proveedor
WHERE NOT EXISTS (
					SELECT 1 FROM Material
					WHERE NOT EXISTS (
										SELECT 1 FROM Provisto_Por
										WHERE Provisto_Por.CodMat = material.CodMat
										AND Provisto_Por.CodProv = Proveedor.CodProv))