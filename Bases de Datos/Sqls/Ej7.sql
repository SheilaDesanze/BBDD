CREATE DATABASE Ejercicio_7;
GO
USE Ejercicio_7;
GO

CREATE TABLE Auto (
    matricula VARCHAR(10) PRIMARY KEY,
    modelo VARCHAR(50),
    año INT
);

CREATE TABLE Chofer (
    nroLicencia INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    fecha_ingreso DATE,
    telefono VARCHAR(20)
);

CREATE TABLE Cliente (
    nroCliente INT PRIMARY KEY,
    calle VARCHAR(50),
    nro INT,
    localidad VARCHAR(50)
);

CREATE TABLE Viaje (
    FechaHoraInicio DATETIME,
    FechaHoraFin DATETIME,
    nroLicencia INT FOREIGN KEY REFERENCES Chofer(nroLicencia),
    nroCliente INT FOREIGN KEY REFERENCES Cliente(nroCliente),
    matricula VARCHAR(10) FOREIGN KEY REFERENCES Auto(matricula),
    kmTotales INT,
    esperaTotal TIME,
    costoEspera FLOAT,
    costoKms FLOAT
);
