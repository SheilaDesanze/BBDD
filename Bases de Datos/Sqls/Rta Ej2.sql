--1. Hallar el código (nroProv) de los proveedores que proveen el artículo a146.

select proveedor.NroProv from proveedor
inner join Pedido
on pedido.NroProv = Proveedor.NroProv
where pedido.NroArt = 146

--2. Hallar los clientes (nomCli) que solicitan artículos provistos por p015.

select * from Cliente
inner join Pedido
on pedido.NroCli = cliente.NroCli
where pedido.NroProv = 15

--3. Hallar los clientes que solicitan algún item provisto por proveedores con categoría mayor que 4.

select * from Cliente
inner join Pedido
on pedido.NroCli = cliente.NroCli
inner join Proveedor
on pedido.NroProv = Proveedor.NroProv
where proveedor.Categoria > 4


--4. Hallar los pedidos en los que un cliente de Rosario solicita artículos producidos en la ciudad de Mendoza.

SELECT * FROM Pedido
INNER JOIN Cliente
ON Cliente.NroCli = Pedido.NroCli
INNER JOIN Articulo
ON Articulo.NroArt = Pedido.NroArt
WHERE Articulo.CiudadArt = 'Mendoza'
AND Cliente.CiudadCli = 'Rosario'

--5. Hallar los pedidos en los que el cliente c23 solicita artículos solicitados por el cliente c30.


SELECT * FROM Pedido
WHERE NroCli = 1
AND NroArt IN (
				SELECT NroArt FROM Pedido
				WHERE NroCli = 7)

SELECT DISTINCT p1.* FROM pedido as p1, pedido as p2
where p1.NroCli = 1
AND p2.NroCli = 7
AND p1.NroArt = p2.NroArt

--6. Hallar los proveedores que suministran todos los artículos cuyo precio es superior al precio promedio de los artículos que se producen en La Plata.


SELECT * FROM Proveedor
WHERE NOT EXISTS (
					SELECT * FROM Articulo
					WHERE Precio > (SELECT AVG(Precio) FROM Articulo)
					AND NOT EXISTS (
									SELECT 1 FROM Pedido
									WHERE Proveedor.NroProv = Pedido.NroProv
									AND Articulo.NroArt = Pedido.NroArt
									))

--7. Hallar la cantidad de artículos diferentes provistos por cada proveedor que provee a todos los clientes de Junín.


SELECT NroProv, count(DISTINCT NroArt) FROM Pedido
WHERE NroProv IN (
					SELECT NroProv FROM Proveedor
					WHERE NOT EXISTS (
										SELECT 1 FROM Cliente
										WHERE CiudadCli = 'Rosario'
										AND NOT EXISTS (
															SELECT 1 FROM Pedido
															WHERE Pedido.NroCli = Cliente.NroCli
															AND Pedido.NroProv = Proveedor.NroProv
															))
					)
AND NroCli IN (SELECT NroCli FROM Cliente WHERE CiudadCli = 'Rosario')
GROUP BY NroProv

SELECT Pedido.NroProv, count(DISTINCT NroArt) FROM Pedido
INNER JOIN Cliente
ON Cliente.NroCli = Pedido.NroCli
INNER JOIN (
			SELECT NroProv FROM Proveedor
			WHERE NOT EXISTS (
								SELECT 1 FROM Cliente
								WHERE CiudadCli = 'Rosario'
								AND NOT EXISTS (
													SELECT 1 FROM Pedido p1
													WHERE p1.NroCli = Cliente.NroCli
													AND p1.NroProv = Proveedor.NroProv
													))
			) cociente
ON cociente.NroProv = Pedido.NroProv
WHERE Cliente.CiudadCli = 'Rosario'
GROUP BY Pedido.NroProv

--8. Hallar los nombres de los proveedores cuya categoría sea mayor que la de todos los proveedores que proveen el artículo “cuaderno”.


SELECT * FROM Proveedor
WHERE Categoria > ALL (
						SELECT Categoria FROM Proveedor
						INNER JOIN Pedido
						ON Pedido.NroProv = Proveedor.NroProv
						WHERE Pedido.NroArt = (	SELECT NroArt FROM Articulo
												WHERE Descripcion = 'Cuaderno')
						)

--9. Hallar los proveedores que han provisto más de 1000 unidades entre los artículos A001y A100.


SELECT NroProv FROM Pedido
WHERE NroArt = 1
OR NroArt = 100
GROUP BY NroProv
HAVING SUM(cantidad) > 1000

--10. Listar la cantidad y el precio total de cada artículo que han pedido los Clientes a sus proveedores entre las fechas 01-01-2004 y 31-03-2004 (se requiere visualizar Cliente, Articulo, Proveedor, Cantidad y Precio).


SELECT NroCli, NroArt, NroProv, SUM(Cantidad), SUM(PrecioTotal) FROM Pedido
WHERE FechaPedido > '2004-01-01'
AND FechaPedido < '2004-03-31'
GROUP BY NroCli, NroArt, NroProv

--11. Idem anterior y que además la Cantidad sea mayor o igual a 1000 o el Precio sea mayor a $ 1000.


SELECT NroCli, NroArt, NroProv, SUM(Cantidad), SUM(PrecioTotal) FROM Pedido
WHERE FechaPedido > '2004-01-01'
AND FechaPedido < '2004-03-31'
GROUP BY NroCli, NroArt, NroProv
HAVING SUM(Cantidad) >= 1000
OR SUM(PrecioTotal) >= 1000

--12. Listar la descripción de los artículos en donde se hayan pedido en el día más del stock existente para ese mismo día.


SELECT DISTINCT descripcion FROM Articulo
INNER JOIN (SELECT NroArt, FechaPedido, SUM(Cantidad) as CantidadPedida FROM Pedido
GROUP BY NroArt, FechaPedido
HAVING SUM(Cantidad) > (SELECT Stock.cantidad FROM Stock
						WHERE Stock.NroArt = Pedido.NroArt
						AND Stock.fecha = (
						SELECT MAX(Stock.fecha) FROM Stock 
						WHERE Stock.fecha <= Pedido.FechaPedido
						))) as pedido_excedente
ON pedido_excedente.NroArt = Articulo.NroArt

--13. Listar los datos de los proveedores que hayan pedido de todos los artículos en un mismo día. Verificar sólo en el último mes de pedidos.



SELECT * FROM Proveedor 
WHERE NroProv IN (
					SELECT NroProv FROM (
											SELECT FechaPedido, Proveedor.NroProv, count(DISTINCT NroArt) as nropedidos
											FROM Pedido
											INNER JOIN Proveedor
											ON Proveedor.NroProv = Pedido.NroProv
											GROUP BY FechaPedido, Proveedor.NroProv
											HAVING count(DISTINCT NroArt) = (select count(*) from Articulo)
											AND MONTH(FechaPedido) = (SELECT MAX(MONTH(FechaPedido)) FROM Pedido)
											AND YEAR(FechaPedido) = (SELECT MAX(YEAR(FechaPedido)) FROM Pedido)) as t1)


											select * from pedido order by nroprov, nroart
											select nroprov, count(distinct nroart) from pedido group by nroprov order by nroprov
											select count(*) from articulo

--14. Listar los proveedores a los cuales no se les haya solicitado ningún artículo en el último mes, pero sí se les haya pedido en el mismo mes del año anterior.


SELECT DISTINCT NroProv FROM Pedido
WHERE NroProv NOT IN (	SELECT NroProv FROM Pedido
						WHERE MONTH(FechaPedido) = MONTH(GETDATE())
						AND YEAR(FechaPedido) = YEAR(GETDATE()))
INTERSECT
SELECT NroProv FROM Pedido
WHERE MONTH(FechaPedido) = MONTH(GETDATE()) 
AND YEAR(FechaPedido) = YEAR(GETDATE()) - 1

SELECT DISTINCT NroProv FROM Pedido
WHERE NroProv NOT IN (	SELECT NroProv FROM Pedido
						WHERE MONTH(FechaPedido) = MONTH(GETDATE())
						AND YEAR(FechaPedido) = YEAR(GETDATE()))
AND NroProv IN (
SELECT NroProv FROM Pedido
WHERE MONTH(FechaPedido) = MONTH(GETDATE()) 
AND YEAR(FechaPedido) = YEAR(GETDATE()) - 1)

--15. Listar los nombres de los clientes que hayan solicitado más de un artículo cuyo precio sea superior a $100 y que correspondan a proveedores de Capital Federal. Por ejemplo, se considerará si se ha solicitado el artículo a2 y a3, pero no si solicitaron 5 unidades del articulo a2.


SELECT p1.* FROM Pedido as p1, Pedido as p2
WHERE p1.NroProv IN (	SELECT NroProv FROM Proveedor
						WHERE CiudadProv = 'Corrientes'
						)
AND p2.NroProv IN (	SELECT NroProv FROM Proveedor
						WHERE CiudadProv = 'Corrientes'
						)
AND p1.NroCli = p2.NroCli
AND p1.NroArt IN (	SELECT NroArt FROM Articulo
					WHERE Precio > 100)
AND p2.NroArt IN (	SELECT NroArt FROM Articulo
					WHERE Precio > 100)
AND p1.NroArt <> p2.NroArt
