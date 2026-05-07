CREATE DATABASE Ejercicio_3;
GO

USE Ejercicio_3;
GO

CREATE TABLE Proveedor (
    idProveedor INT PRIMARY KEY,
    nombre VARCHAR(255),
    respdCivil VARCHAR(255),
    cuit VARCHAR(255)
);

CREATE TABLE Producto (
    idProducto INT PRIMARY KEY,
    nombre VARCHAR(255),
    descrip VARCHAR(255),
    estado VARCHAR(255),
    idProveedor INT FOREIGN KEY REFERENCES Proveedor(idProveedor)
);

CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY,
    nombre VARCHAR(255),
    respIVA VARCHAR(255),
    CUIL VARCHAR(255)
);

CREATE TABLE Direccion (
    idDir INT PRIMARY KEY,
    idCliente INT FOREIGN KEY REFERENCES Cliente(idCliente),
    calle VARCHAR(255),
    nro VARCHAR(255),
    piso VARCHAR(255),
    dpto VARCHAR(255)
);

CREATE TABLE Vendedor (
    idEmpleado INT PRIMARY KEY,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    DNI VARCHAR(255)
);

CREATE TABLE Venta (
    nroFactura INT PRIMARY KEY,
    idCliente INT FOREIGN KEY REFERENCES Cliente(idCliente),
    fecha DATE,
    idVendedor INT FOREIGN KEY REFERENCES Vendedor(idEmpleado)
);

CREATE TABLE Detalle_venta (
    nroFactura INT FOREIGN KEY REFERENCES Venta(nroFactura),
    nro INT,
    idProducto INT FOREIGN KEY REFERENCES Producto(idProducto),
    cantidad INT,
    precioUnitario FLOAT,
    PRIMARY KEY (nroFactura, nro)
);
