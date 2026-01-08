CREATE TABLE Distrito(
	DistritoID INT IDENTITY(1,1),
	DistritoName VARCHAR(25) NOT NULL,
	CONSTRAINT pk_Distrito PRIMARY KEY (DistritoID)
);

CREATE TABLE Canton(
	CantonID INT IDENTITY(1,1),
	CantonName VARCHAR(25) NOT NULL,
	DistritoID INT FOREIGN KEY REFERENCES Distrito(DistritoID),
	CONSTRAINT pk_Canton PRIMARY KEY (CantonID)
);

CREATE TABLE Provincia(
	ProvinciaID INT IDENTITY(1,1),
	ProvinciaName VARCHAR(25) NOT NULL,
	CantonID INT FOREIGN KEY REFERENCES Canton(CantonID),
	CONSTRAINT pk_Provincia PRIMARY KEY (ProvinciaID)
);

CREATE TABLE Direccion(
	DireccionID INT IDENTITY(1,1),
	Direccion1 VARCHAR(45) NOT NULL,
	Direccion2 VARCHAR(45) NULL,
	zipCode VARCHAR(8) NOT NULL,
	ProvinciaID INT FOREIGN KEY REFERENCES Provincia(ProvinciaID),
	CONSTRAINT pk_Direccion PRIMARY KEY (DireccionID)
);

CREATE TABLE Establecimiento(
	EstablecimientoID BIGINT IDENTITY(1,1),
	nombre VARCHAR(200) NOT NULL,
	CedulaJuridica VARCHAR(50) NOT NULL UNIQUE,
	tipo VARCHAR(20) NOT NULL,
	referencia_gps VARCHAR(100) NULL,
	telefono1 VARCHAR(20) NOT NULL,
	codigo_pais_tel1 VARCHAR(5) NOT NULL DEFAULT '+506',
	telefono2 VARCHAR(20) NULL,
	codigo_pais_tel2 VARCHAR(5) NULL,
	email VARCHAR(100) NOT NULL,
	sitio_web VARCHAR(200) NULL,
	Activo BIT NOT NULL DEFAULT 1,
	fecha_registro DATETIME2 NOT NULL DEFAULT GETDATE(),
	CONSTRAINT pk_Establecimiento PRIMARY KEY (EstablecimientoID)
);

CREATE TABLE RedSocial(
	RedSocialID INT,
	TipoRed VARCHAR(45) NULL,
	EstablecimientoID BIGINT FOREIGN KEY REFERENCES Establecimiento(EstablecimientoID),
	CONSTRAINT pk_RedSocial PRIMARY KEY (RedSocialID)
);

CREATE TABLE Clientes(
	ClienteID BIGINT IDENTITY(1,1),
	Nombre VARCHAR(100) NOT NULL,
	PrimerApellido VARCHAR(100) NOT NULL,
	SegundoApellido VARCHAR(100) NULL,
	fecha_nacimiento DATE NOT NULL,
	TipoIdentificacion VARCHAR(20) NOT NULL,
	NumeroIdentificacion VARCHAR(50) NOT NULL UNIQUE,
	pais_residencia_id INT NOT NULL,
	telefono1 VARCHAR(20) NOT NULL,
	codigo_pais_tel1 VARCHAR(5) NOT NULL,
	telefono2 VARCHAR(20) NULL,
	codigo_pais_tel2 VARCHAR(5) NULL,
	email VARCHAR(100) NOT NULL,
	fecha_registro DATETIME2 NOT NULL DEFAULT GETDATE(),
	CONSTRAINT pk_Clientes PRIMARY KEY (ClienteID)
);

CREATE TABLE DireccionCliente(
	DireccionID INT FOREIGN KEY REFERENCES Direccion(DireccionID),
	ClienteID BIGINT FOREIGN KEY REFERENCES Clientes(ClienteID),
	CONSTRAINT pk_DireccionCliente PRIMARY KEY (DireccionID, ClienteID)
);

CREATE TABLE EmpresasRecreacion(
	EmpresaID BIGINT IDENTITY(1,1),
	NombreEmpresa VARCHAR(200) NOT NULL,
	CedulaJuridica VARCHAR(50) NOT NULL UNIQUE,
	Email VARCHAR(100) NOT NULL,
	Telefono VARCHAR(20) NOT NULL,
	nombre_contacto VARCHAR(200) NOT NULL,
	descripcion_actividad VARCHAR(MAX) NULL,
	Precio DECIMAL(12,2) NOT NULL,
	Activo BIT NOT NULL DEFAULT 1,
	fecha_registro DATETIME2 NOT NULL DEFAULT GETDATE(),
	CONSTRAINT pk_EmpresasRecreacion PRIMARY KEY (EmpresaID)
);

CREATE TABLE DireccionEmpresas(
	DireccionID INT FOREIGN KEY REFERENCES Direccion(DireccionID),
	EmpresaID BIGINT FOREIGN KEY REFERENCES EmpresasRecreacion(EmpresaID),
	CONSTRAINT pk_DireccionEmpresas PRIMARY KEY (DireccionID, EmpresaID)
);

CREATE TABLE DireccionEstablecimientos(
	DireccionID INT FOREIGN KEY REFERENCES Direccion(DireccionID),
	EstablecimientoID BIGINT FOREIGN KEY REFERENCES Establecimiento(EstablecimientoID),
	CONSTRAINT pk_DireccionEstablecimientos PRIMARY KEY (DireccionID, EstablecimientoID)
);

CREATE TABLE Comodidades(
	ComodidadID BIGINT IDENTITY(1,1),
	Nombre VARCHAR(100) NOT NULL UNIQUE,
	CONSTRAINT pk_Comodidades PRIMARY KEY (ComodidadID)
);

CREATE TABLE TiposActividad(
	ActividadID BIGINT IDENTITY(1,1),
	Nombre VARCHAR(100) NOT NULL UNIQUE,
	CONSTRAINT pk_TiposActividad PRIMARY KEY (ActividadID)
);

CREATE TABLE EmpresaTipoActividad(
	EmpresaID BIGINT FOREIGN KEY REFERENCES EmpresasRecreacion(EmpresaID) ON DELETE CASCADE,
	ActividadID BIGINT FOREIGN KEY REFERENCES TiposActividad(ActividadID),
	CONSTRAINT pk_EmpresaTipoActividad PRIMARY KEY (EmpresaID, ActividadID)
);

CREATE TABLE Servicios(
	ServicioID BIGINT IDENTITY(1,1),
	Nombre VARCHAR(100) NOT NULL UNIQUE,
	Descripcion VARCHAR(MAX) NULL,
	CONSTRAINT pk_Servicios PRIMARY KEY (ServicioID)
);

CREATE TABLE EstablecimientoServicio(
	EstablecimientoID BIGINT FOREIGN KEY REFERENCES Establecimiento(EstablecimientoID) ON DELETE CASCADE,
	ServicioID BIGINT FOREIGN KEY REFERENCES Servicios(ServicioID),
	CONSTRAINT pk_EstablecimientoServicio PRIMARY KEY (EstablecimientoID, ServicioID)
);

CREATE TABLE TiposHabitacion(
	TipoHabitacionID BIGINT IDENTITY(1,1),
	EstablecimientoID BIGINT FOREIGN KEY REFERENCES Establecimiento(EstablecimientoID) ON DELETE CASCADE,
	Nombre VARCHAR(100) NOT NULL,
	Descripcion VARCHAR(MAX) NULL,
	TipoCama VARCHAR(20) NOT NULL,
	Precio DECIMAL(12,2) NOT NULL,
	fecha_registro DATETIME2 NOT NULL DEFAULT GETDATE(),
	CONSTRAINT pk_TiposHabitacion PRIMARY KEY (TipoHabitacionID)
);

CREATE TABLE Habitaciones(
	HabitacionID BIGINT IDENTITY(1,1),
	Numero VARCHAR(20) NOT NULL,
	TipoHabitacionID BIGINT FOREIGN KEY REFERENCES TiposHabitacion(TipoHabitacionID),
	Estado VARCHAR(20) NOT NULL,
	CONSTRAINT pk_Habitaciones PRIMARY KEY (HabitacionID)
);

CREATE TABLE Reservaciones(
	ReservacionID BIGINT IDENTITY(1,1),
	ClienteID BIGINT FOREIGN KEY REFERENCES Clientes(ClienteID),
	HabitacionID BIGINT FOREIGN KEY REFERENCES Habitaciones(HabitacionID),
	FechaIngreso DATETIME2 NOT NULL,
	FechaSalida DATE NOT NULL,
	CantidadPersonas TINYINT NOT NULL,
	PoseeVehiculo VARCHAR(20) NOT NULL,
	PlacaVehiculo VARCHAR(20) NULL,
	Estado VARCHAR(20) NOT NULL,
	fecha_registro DATETIME2 NOT NULL DEFAULT GETDATE(),
	CONSTRAINT pk_Reservaciones PRIMARY KEY (ReservacionID)
);

CREATE TABLE Facturas(
	FacturaID BIGINT IDENTITY(1,1),
	ReservacionID BIGINT FOREIGN KEY REFERENCES Reservaciones(ReservacionID),
	FechaEmision DATETIME2 NOT NULL,
	NumeroNoches INT NOT NULL,
	cargo_habitacion DECIMAL(12,2) NOT NULL,
	ImporteTotal DECIMAL(12,2) NOT NULL,
	MetodoPago VARCHAR(20) NOT NULL,
	CONSTRAINT pk_Facturas PRIMARY KEY (FacturaID)
);

CREATE TABLE FotosTipoHabitacion(
	FotoID BIGINT IDENTITY(1,1),
	TipoHabitacionID BIGINT FOREIGN KEY REFERENCES TiposHabitacion(TipoHabitacionID) ON DELETE CASCADE,
	UrlFoto VARCHAR(255) NOT NULL,
	Descripcion VARCHAR(200) NULL,
	CONSTRAINT pk_FotosTipoHabitacion PRIMARY KEY (FotoID)
);

CREATE TABLE ServiciosRecreacion(
	ServicioRecreacionID BIGINT IDENTITY(1,1),
	EmpresaID BIGINT FOREIGN KEY REFERENCES EmpresasRecreacion(EmpresaID) ON DELETE CASCADE,
	NombreServicio VARCHAR(200) NOT NULL,
	Descripcion VARCHAR(MAX) NULL,
	CONSTRAINT pk_ServiciosRecreacion PRIMARY KEY (ServicioRecreacionID)
);

CREATE TABLE TipoHabitacionComodidad(
	TipoHabitacionID BIGINT FOREIGN KEY REFERENCES TiposHabitacion(TipoHabitacionID) ON DELETE CASCADE,
	ComodidadID BIGINT FOREIGN KEY REFERENCES Comodidades(ComodidadID),
	CONSTRAINT pk_TipoHabitacionComodidad PRIMARY KEY (TipoHabitacionID, ComodidadID)
);