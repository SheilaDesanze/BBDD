USE Bancos
GO

--4-Crear una funcion que devuelva el valor oro de una moneda. La misma debe recibir como parametro el codigo de la moneda y devolver el valor -1 para el caso en que la moneda no exista. Escribir la sentencia que prueba el correcto funcionamiento.

ALTER FUNCTION valorOro (@CodMon char(2))
RETURNS decimal(18, 3)
AS 
BEGIN
	RETURN (SELECT valorOro FROM moneda WHERE id = @CodMon);
END

GO
SELECT * FROM moneda WHERE id LIKE '_r'

select * from moneda
select dbo.valorOro('UY')



--5-Crear una funcion que retorne el pasaporte y el nombre de las personas que tienen cuenta en todos los bancos.Personas -> tal que no exista banco -> en la que no tenga cuenta. Escribir la sentencia que prueba el correcto funcionamiento.

CREATE FUNCTION cuenta_en_todos ()
RETURNS TABLE
AS 
RETURN
(
	SELECT * FROM persona
	WHERE NOT EXISTS (
						SELECT 1 FROM banco
						WHERE NOT EXISTS (
											SELECT 1 FROM cuenta
											WHERE cuenta.idBanco = banco.id
											AND cuenta.idPersona = persona.pasaporte ))
)

SELECT * from dbo.cuenta_en_todos()

--6-Crear un SP que muestre por pantalla a las personas que tienen mas de 2 cuentas en dolares en bancos extranjeros. Escribir la sentencia que prueba el correcto funcionamiento.
GO
ALTER PROCEDURE sp_mas_de_2 
AS
BEGIN
	SELECT cuenta.idPersona FROM persona 
	INNER JOIN cuenta
	ON cuenta.idPersona = persona.pasaporte
	WHERE cuenta.idMoneda = 'US'
	GROUP BY cuenta.idPersona
	HAVING count(distinct cuenta.idBanco) > 2;
END;
GO
EXEC dbo.sp_mas_de_2;
GO
--7-Crear un SP que reciba por parametro un pasaporte y muestre las cuentas asociadas a la misma. Si el pasaporte no existe, mostrar un mensaje de error. Escribir la sentencia que prueba el correcto funcionamiento.
GO
ALTER PROCEDURE sp_cuentas_asociadas (@pasaporte INT)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM persona WHERE pasaporte = @pasaporte)
		SELECT * FROM cuenta
		INNER JOIN persona
		ON cuenta.idPersona = persona.pasaporte
		WHERE persona.pasaporte = @pasaporte
	ELSE
		PRINT 'No se ha encontrado el usuario'
END
GO
EXEC sp_cuentas_asociadas 1222

--8-Crear un Trigger que realice el respaldo de los datos de un Banco cuando el mismo es eliminado. El trigger no debe permitir que se eliminen bancos que operan con la moneda "PESO ARGENTINO". Se debe crear una tabla "banco_respaldo"Escribir las sentencias que prueban el correcto funcionamiento.


CREATE TABLE [dbo].[banco_respaldo](
	[id] [int] NOT NULL PRIMARY KEY,
	[nombre] [varchar](50),
	[pais] [char](50),
)
GO

CREATE TRIGGER no_eliminar ON banco
INSTEAD OF DELETE
AS
BEGIN
	INSERT INTO banco_respaldo
	SELECT * FROM deleted
	WHERE id NOT IN (
					SELECT idBanco FROM opera 
					WHERE idMoneda = 'AR');
	DELETE FROM banco WHERE id IN (	SELECT id FROM deleted 
									WHERE id NOT IN (
													SELECT idBanco FROM opera 
													WHERE idMoneda = 'AR'));
END

DELETE FROM banco WHERE id IN (1, 2, 3, 4);

select * from banco
inner join opera
on opera.idBanco = banco.id

select * from banco_respaldo

--9-Crear un Trigger que actualice el id de moneda en las tablas opera y cuenta para cuando un codigo de moneda sea actualizado en la tabla moneda. Escribir la sentencia que prueba el correcto funcionamiento.
GO
CREATE TRIGGER tr_moneda_opera ON moneda
FOR UPDATE
AS
BEGIN
    IF UPDATE(id)
    BEGIN
        UPDATE opera
        SET opera.idMoneda = i.id
        FROM inserted i
        INNER JOIN deleted d ON i.id = d.id
        WHERE opera.idMoneda = d.id;

        UPDATE cuenta
        SET cuenta.idMoneda = i.id
        FROM inserted i
        INNER JOIN deleted d ON i.id = d.id
        WHERE cuenta.idMoneda = d.id;
    END;
END
GO


create trigger t_update_moneda on moneda for update
as
begin
declare @idMonedaViejo varchar(2);
declare @idMonedaNuevo varchar(2);

select @idMonedaViejo=d.id from deleted d;
select @idMonedaNuevo=i.id from inserted i;

update opera set idMoneda=@idMonedaNuevo where idMoneda=@idMonedaViejo;
update cuenta set idMoneda=@idMonedaNuevo where idMoneda=@idMonedaViejo;

end

select * from moneda
select * from cuenta
select * from opera

update moneda set id = 'UD' where id = 'US'