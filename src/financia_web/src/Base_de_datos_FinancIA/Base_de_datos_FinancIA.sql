create database FinancIA;

use FinancIA;

--////////TABLA DE USUARIOS//////////

CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1),
    NombreCompleto VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Contraseña VARCHAR(255) NOT NULL,
    FechaRegistro DATE DEFAULT GETDATE()
);


--////////TABLA DE Categorías//////////

CREATE TABLE Categorias (
    CategoriaID INT PRIMARY KEY IDENTITY(1,1),
    NombreCategoria VARCHAR(50) NOT NULL,
    Tipo VARCHAR(10) NOT NULL -- 'Ingreso' o 'Egreso'
);



--////////TABLA DE Transacciones//////////

CREATE TABLE Transacciones (
    TransaccionID INT PRIMARY KEY IDENTITY(1,1),
    UsuarioID INT,
    CategoriaID INT,
    Monto DECIMAL(10,2) NOT NULL,
    FechaTransaccion DATE NOT NULL,
    Descripcion TEXT,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
);


--////////TABLA DE Presupuestos//////////


CREATE TABLE Presupuestos (
    PresupuestoID INT PRIMARY KEY IDENTITY(1,1),
    UsuarioID INT,
    CategoriaID INT,
    MontoLimite DECIMAL(10,2),
    Mes INT,
    Año INT,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
);




--////////TABLA DE ALERTAS//////////

CREATE TABLE Alertas (
    AlertaID INT PRIMARY KEY IDENTITY(1,1),
    UsuarioID INT,
    Mensaje TEXT,
    FechaAlerta DATETIME DEFAULT GETDATE(),
    Visto BIT DEFAULT 0,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);



--////////TABLA DE SUGERENCIAS FINANCIERAS//////////

CREATE TABLE SugerenciasFinancieras (
    SugerenciaID INT PRIMARY KEY IDENTITY(1,1),
    UsuarioID INT,
    FechaGenerada DATETIME DEFAULT GETDATE(),
    Contenido TEXT,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);





