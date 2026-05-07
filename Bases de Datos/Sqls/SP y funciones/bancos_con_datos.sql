CREATE DATABASE Bancos;
GO

USE Bancos
GO

CREATE TABLE pais (
	pais CHAR(50) PRIMARY KEY
)

CREATE TABLE banco (
	id INT PRIMARY KEY,
	nombre VARCHAR(50),
	pais CHAR(50)
)

CREATE TABLE moneda (
	id CHAR(2) PRIMARY KEY,
	descripcion VARCHAR(50),
	valorOro DECIMAL(18, 3),
	valorPetroleo DECIMAL(18, 3)
)

CREATE TABLE persona (
	pasaporte CHAR(15) PRIMARY KEY,
	codigoFiscal INT,
	nombre VARCHAR(50)
)

CREATE TABLE cuenta (
	monto DECIMAL(18, 3),
	idBanco INT NOT NULL,
	idMoneda CHAR(2) NOT NULL,
	idPersona CHAR(15) NOT NULL,
	CONSTRAINT PK_Persona PRIMARY KEY (
		idBanco,
		idMoneda,
		idPersona
	)
)

CREATE TABLE opera (
	idBanco INT NOT NULL,
	idMoneda CHAR(2) NOT NULL,
	cambioCompra DECIMAL(18, 3),
	cambioVenta DECIMAL(18, 3),
	CONSTRAINT PK_Opera PRIMARY KEY (
		idBanco,
		idMoneda
	)
)
GO

ALTER TABLE cuenta ADD CONSTRAINT fk_banco_idBanco FOREIGN KEY (idBanco) REFERENCES Banco (id) ON
DELETE CASCADE ON
UPDATE CASCADE

ALTER TABLE cuenta ADD CONSTRAINT fk_banco_idMoneda FOREIGN KEY (idMoneda) REFERENCES Moneda (id) ON
DELETE CASCADE ON
UPDATE CASCADE

ALTER TABLE cuenta ADD CONSTRAINT fk_banco_idPersona FOREIGN KEY (idPersona) REFERENCES Persona (pasaporte) ON
DELETE CASCADE ON
UPDATE CASCADE

ALTER TABLE opera ADD CONSTRAINT fk_opera_idBanco FOREIGN KEY (idBanco) REFERENCES Banco (id) ON
DELETE CASCADE ON
UPDATE CASCADE

ALTER TABLE opera ADD CONSTRAINT fk_opera_idMoneda FOREIGN KEY (idMoneda) REFERENCES Moneda (id) ON
DELETE CASCADE ON
UPDATE CASCADE

go
INSERT INTO pais (pais) VALUES ('Argentina')
INSERT INTO pais (pais) VALUES ('USA')
INSERT INTO pais (pais) VALUES ('Uruguay')
INSERT INTO pais (pais) VALUES ('España')
INSERT INTO pais (pais) VALUES ('Alemania')
INSERT INTO pais (pais) VALUES ('Suiza')
INSERT INTO banco (id, nombre, pais) VALUES ('1', 'Banco Nacion', 'Argentina')
INSERT INTO banco (id, nombre, pais) VALUES ('2', 'Banco Montevideo', 'Uruguay')
INSERT INTO banco (id, nombre, pais) VALUES ('3', 'Banco Ciudad', 'Argentina')
INSERT INTO banco (id, nombre, pais) VALUES ('4', 'City Bank', 'USA')
INSERT INTO banco (id, nombre, pais) VALUES ('5', 'Switzerland Bank', 'Suiza')
INSERT INTO banco (id, nombre, pais) VALUES ('6', 'BBVA', 'España')
INSERT INTO moneda (id, descripcion, valorOro, valorPetroleo) VALUES ('AR', 'Peso Argentino','2', '1')
INSERT INTO moneda (id, descripcion, valorOro, valorPetroleo) VALUES ('UY', 'Peso Uruguayo','5', '2.5')
INSERT INTO moneda (id, descripcion, valorOro, valorPetroleo) VALUES ('US', 'Dolar', '1','1.5')
INSERT INTO moneda (id, descripcion, valorOro, valorPetroleo) VALUES ('EU', 'Euro', '2', '1')
INSERT INTO persona (pasaporte, codigoFiscal, nombre) VALUES ('1', '1234', 'Bill Gates')
INSERT INTO persona (pasaporte, codigoFiscal, nombre) VALUES ('2', '12112', 'Carlos Slim')
INSERT INTO persona (pasaporte, codigoFiscal, nombre) VALUES ('3', '2325', 'Lionel Messi')
INSERT INTO persona (pasaporte, codigoFiscal, nombre) VALUES ('4', '01243', 'Diego Maradona')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('100000', '4', 'US', '1')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('20000', '5', 'EU', '1')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('15000', '2', 'US', '1')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('50000', '4', 'US', '2')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('35000', '5', 'US', '2')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('2000', '1', 'AR', '3')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('10000', '4', 'US', '3')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('15000', '5', 'US', '3')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('15000', '5', 'US', '4')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('2000', '2', 'AR', '3')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('10000', '3', 'US', '3')
INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES ('15000', '6', 'US', '3')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('1', 'US', '1', '1')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('2', 'US', '1', '1')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('3', 'US', '1', '1')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('4', 'US', '1', '1')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('5', 'US', '1', '1')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('6', 'US', '1', '1')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('1', 'EU', '2', '2')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('2', 'EU', '2', '2')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('3', 'EU', '3', '3')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('4', 'EU', '2', '2')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('5', 'EU', '2.2','2.2')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('6', 'EU', '2.2','2.5')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('1', 'AR', '5', '5')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('3', 'AR', '5.5', '5.5')
INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('2', 'AR', '7', '7')

INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) 
VALUES ('1', 'UY', '3', '3'),('2', 'UY', '2', '2')

--Analizar situacion
--INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES ('99', 'AR', '7', '7')
