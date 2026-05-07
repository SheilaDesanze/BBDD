CREATE DATABASE transacciones_8;
GO
USE transacciones_8;
GO

CREATE TABLE Producto (
    codigo INT PRIMARY KEY,
    descripcion VARCHAR(255),
    precio_venta FLOAT,
    precio_costo FLOAT
);

CREATE TABLE Empleado (
    legajo INT PRIMARY KEY,
    nombre VARCHAR(255),
    salario FLOAT
);

CREATE TABLE Cliente (
    idCli INT PRIMARY KEY,
    nombre VARCHAR(255),
    categoria INT
);