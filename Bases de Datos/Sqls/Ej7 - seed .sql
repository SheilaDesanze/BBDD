USE Ejercicio_7;
GO

INSERT INTO Auto	(matricula, modelo, año)
VALUES 
					('ABC-123', 'Ford Fiesta', 2015), 
					('DEF-456', 'Chevrolet Corsa', 2017), 
					('GHI-789', 'Renault Clio', 2018), 
					('JKL-012', 'Toyota Corolla', 2019), 
					('MNO-345', 'Volkswagen Gol', 2020);

INSERT INTO Chofer	(nroLicencia, nombre, apellido, fecha_ingreso, telefono)
VALUES
					(123456, 'Juan', 'Pérez', '2021-01-01', '011-1234-5678'), 
					(234567, 'María', 'García', '2021-02-01', '011-2345-6789'), 
					(345678, 'Pedro', 'López', '2021-03-01', '011-3456-7890'), 
					(456789, 'Ana', 'Rodríguez', '2021-04-01', '011-4567-8901'), 
					(567890, 'Carlos', 'Sánchez', '2021-05-01', '011-5678-9012');

INSERT INTO Cliente	(nroCliente, calle, nro, localidad ) 
VALUES 
					(1001, 'San Martín', 1234, 'Buenos Aires'), 
					(1002, 'Rivadavia', 5678, 'Rosario'), 
					(1003, 'Belgrano', 9101, 'Córdoba'), 
					(1004, 'Sarmiento', 1122, 'Mendoza'), 
					(1005, 'Pueyrredón', 3344, 'Salta');

INSERT INTO Viaje	(FechaHoraInicio, FechaHoraFin, nroLicencia, nroCliente, matricula, kmTotales, esperaTotal, costoEspera, costoKms)
VALUES 
					('2021-06-05 18:00:00', '2021-06-05 18:30:00', 123456, 1001, 'ABC-123', 10, 5, 50.0, 20.0), 
					('2021-06-05 18:15:00', '2021-06-05 18:45:00', 234567, 1002, 'DEF-456', 15, 10, 60.0, 25.0), 
					('2021-06-05 18:30:00', '2021-06-05 19:00:00', 345678, 1003, 'GHI-789', 20, 15, 70.0, 30.0), 
					('2021-06-05 18:45:00', '2021-06-05 19:15:00', 456789, 1004, 'JKL-012', 25, 20, 80.0, 35.0), 
					('2021-06-05 19:00:00', '2021-06-05 19:30:00', 567890, 1005, 'MNO-345', 30, 25, 90.0, 40.0), 
					('2021-06-05 19:15:00', '2021-06-05 19:45:00', 123456, 1002, 'ABC-123', 35, 30, 100.0, 45.0), 
					('2021-06-05 19:30:00', '2021-06-05 20:00:00', 234567, 1003, 'DEF-456', 40, 35, 110.0, 50.0), 
					('2021-06-05 19:45:00', '2021-06-05 20:15:00', 345678, 1004, 'GHI-789', 45, 40, 120.0, 55.0), 
					('2021-06-05 20:00:00', '2021-06-05 20:30:00', 456789, 1005, 'JKL-012', 50, 45, 130.0, 60.0), 
					('2021-06-05 20:15:00', '2021-06-05 20:45:00', 567890, 1001, 'MNO-345', 55, 50, 140.0, 65.0);
					
					
--8. Indique el costo promedio de los viajes realizados por cada auto.

select (kmTotales * costoKms) as PrecioXKms 
from viaje

--9. Indique el costo total de los viajes realizados por cada chofer en el último mes.