--1. Indique la cantidad de productos que tiene la empresa.

select * from producto

--2. Indique la cantidad de productos en estado 'en stock' que tiene la empresa.

select * from producto where estado = 'En stock'

--3. Indique los productos que nunca fueron vendidos.

select * from Producto
where Producto.idProducto NOT IN (SELECT idProducto FROM Detalle_venta)

--4. Indique la cantidad de unidades que fueron vendidas de cada producto.

select idproducto, sum(cantidad) FROM Detalle_venta
group by idProducto

--5. Indique cual es la cantidad promedio de unidades vendidas de cada producto.

select idProducto, avg(cantidad) from Detalle_venta
group by idProducto

--6. Indique quien es el vendedor con mas ventas realizadas.


SELECT idVendedor, COUNT(nrofactura) AS cantidad_ventas
FROM venta
GROUP BY idVendedor
HAVING COUNT(nrofactura) = (
    SELECT MAX(ventas_por_proveedor)
    FROM (
        SELECT COUNT(nrofactura) AS ventas_por_proveedor
        FROM venta
        GROUP BY idVendedor
    ) AS subquery
);

WITH facturas AS(SELECT idVendedor, COUNT(distinct nrofactura) AS cantidad_ventas
FROM venta 
GROUP BY idVendedor)
SELECT * from facturas
WHERE cantidad_ventas >= ALL (select cantidad_ventas from facturas);


--7. Indique todos los productos de lo que se hayan vendido más de 15.000 unidades.

select idProducto, sum(cantidad) from Detalle_venta
group by idProducto
having sum(cantidad) > 15000

--8. Indique quien es el vendedor con mayor volumen de ventas.


select idvendedor, sum(cantidad) as volumen_ventas from venta
inner join Detalle_venta
on Detalle_venta.nroFactura = venta.nroFactura
group by idVendedor
having sum(cantidad) = (
	SELECT MAX(ventas_por_vendedor)
	FROM (
		SELECT SUM(cantidad) as ventas_por_vendedor
		from venta
		inner join Detalle_venta
		on Detalle_venta.nroFactura = venta.nroFactura 
		group by idVendedor
	) as t1
)