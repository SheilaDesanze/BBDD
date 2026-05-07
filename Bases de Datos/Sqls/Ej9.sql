CREATE DATABASE Ejercicio_9;
GO
USE Ejercicio_9;
GO

CREATE TABLE Persona (
    NroDoc INT PRIMARY KEY,
    Nombre VARCHAR(255),
    Dirección VARCHAR(255),
    FechaNac DATE,
    Sexo CHAR(1)
);

CREATE TABLE Progenitor (
    NroDoc INT,
    NroDocHijo INT,
    FOREIGN KEY (NroDoc) REFERENCES Persona(NroDoc),
    FOREIGN KEY (NroDocHijo) REFERENCES Persona(NroDoc)
);