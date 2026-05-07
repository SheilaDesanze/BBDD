CREATE DATABASE Ejercicio_2;
GO
use Ejercicio_2;
GO

CREATE TABLE Proveedor (
    NroProv INT PRIMARY KEY,
    NomProv VARCHAR(255),
    Categoria INT,
    CiudadProv VARCHAR(255)
);

CREATE TABLE Articulo (
    NroArt INT PRIMARY KEY,
    Descripcion VARCHAR(255),
    CiudadArt VARCHAR(255),
    Precio FLOAT
);

CREATE TABLE Cliente (
    NroCli INT PRIMARY KEY,
    NomCli VARCHAR(255),
    CiudadCli VARCHAR(255)
);

CREATE TABLE Pedido (
    NroPed INT PRIMARY KEY,
    NroArt INT FOREIGN KEY REFERENCES Articulo(NroArt),
    NroCli INT FOREIGN KEY REFERENCES Cliente(NroCli),
    NroProv INT FOREIGN KEY REFERENCES Proveedor(NroProv),
    FechaPedido DATE,
    Cantidad INT,
    PrecioTotal FLOAT
);

CREATE TABLE Stock (
    NroArt INT FOREIGN KEY REFERENCES Articulo(NroArt),
    fecha DATE,
    cantidad INT,
    PRIMARY KEY (NroArt, fecha)
);