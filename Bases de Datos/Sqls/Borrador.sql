SET TRANSACTION ISOLATION
LEVEL SERIALIZABLE;

BEGIN TRANSACTION;

SELECT *
FROM Empleado
WHERE salario > 20000;

INSERT INTO Producto
(codigo, descripcion, precio_venta)
VALUES (237, 'Pepsi 3 litros', 42);

COMMIT TRANSACTION;




INSERT INTO Empleado
(legajo, nombre, salario)
VALUES (123, 'Roberto', 3000)