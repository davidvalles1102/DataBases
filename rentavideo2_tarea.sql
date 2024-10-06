CREATE DATABASE rentavideo
on
(NAME = 'rentavideo',
	FILENAME = 'C:\SQLData\rentavideo',
	SIZE =10, 
	MAXSIZE = 20, 
	FILEGROWTH = 10)
	LOG ON
	(NAME = 'rentavideo_log',
	FILENAME = 'C:\SQLData\rentavideo_log.ldf',
	SIZE =9, 
	MAXSIZE = 15,
	FILEGROWTH = 5);
GO

USE rentavideo;
GO
select * from sys.tables;

create table clientes(
Nombres varchar(200),
Apellidos varchar(200),
DUI numeric(10) primary key not null,
Fecha_afiliacion date,
Edad numeric(2)/*que no se pase de 2 digitos*/
);

create table tipos(
CodT varchar(4)  primary key not null,
Nombre_Tipo varchar(20)
);

create table categorias(
CodC varchar(4) primary key not null,
Categorias varchar(30)
);

create table peliculas(
CodP varchar(4) primary key not null,
Nombre varchar(100),
CodT varchar(4) foreign key references tipos(CodT),
CodC varchar(4) foreign key references categorias(CodC),
Fecha_Ingreso date,
Diponible numeric(3) /*podria ser de tipo char, 2 caracteres para si o no, pero aca va cantidad*/
);

create table rentas(
CodR varchar(4) primary key not null,
CodP varchar(4) foreign key references peliculas(CodP),
DUI numeric(10) foreign key references clientes(DUI),
Fecha_Ingreso date,
Fecha_Devolucion date,
Cobro decimal(18,2),/*18 digitos entero y 2 decimales*/
Mora decimal(18,2)
);

-- ====================== katherine    ======================================================================
-- 1 - Mostrar el nombre de los clientes que tengan más de 25 años, ordenados de manera descendente según la edad:
SELECT Nombres, Apellidos, Edad
FROM clientes
WHERE Edad > 25
ORDER BY Edad DESC;

-- 2 - Mostrar el nombre de los clientes que tengan entre 18 y 26 años:
SELECT Nombres, Apellidos, Edad
FROM clientes
WHERE Edad BETWEEN 18 AND 26;

-- ======================    JC        ======================================================================

-- 3 - Mostrar todas las categorías de la tabla categoría, pero no mostrar Suspenso ni Drama:
SELECT Categorias
FROM categorias
WHERE Categorias NOT IN ('Suspenso', 'Drama');

-- 4 - Mostrar clientes que tienen mora:
SELECT clientes.Nombres, clientes.Apellidos, rentas.Mora
FROM clientes
JOIN rentas ON clientes.DUI = rentas.DUI
WHERE rentas.Mora > 0;

-- ========================== Edwin =========================================================================
-- 7 - Modifique la categoría Juegos por Games

update categorias set categorias = 'Games' where categorias = 'Juegos';
select * from categorias;

UPDATE Categorias 
SET categorias = CASE 
                    WHEN CodC = 'C001' THEN 'Comedia'
                    WHEN CodC = 'C002' THEN 'Infantiles'
                    WHEN CodC = 'C003' THEN 'Suspenso'
                    WHEN CodC = 'C004' THEN 'Drama'
                    WHEN CodC = 'C005' THEN 'Accion'
                    WHEN CodC = 'C006' THEN 'Juegos'
                    WHEN CodC = 'C007' THEN 'Sonidos'
                    WHEN CodC = 'C008' THEN 'Romance'
                    WHEN CodC = 'C009' THEN 'Terror'
                    WHEN CodC = 'C010' THEN 'Anime'
                 END
WHERE CodC IN ('C001', 'C002', 'C003', 'C004', 'C005', 'C006', 'C007', 'C008', 'C009', 'C010');

-- 8 - Modifique la fecha de ingreso a 13 de abril 2022 y la cantidad disponible a 10 de la película de ACE Ventura(en una sola consulta)

select * from peliculas where Nombre = 'Ace Ventura';
update peliculas set Fecha_Ingreso = '2003-04-13', Diponible = 10 where nombre = 'Ace Ventura';
select * from peliculas;

exec sp_help peliculas;

/* join */

select * from categorias;
select * from peliculas;
select * from tipos;

select c.categorias as categoria_pelicula, p.nombre as nombre_pelicula from categorias c 
inner join peliculas p on c.CodC = p.CodC order by categorias asc;

select c.categorias as categoria_pelicula, p.nombre as nombre_pelicula, t.Nombre_Tipo from categorias c 
inner join peliculas p on c.CodC = p.CodC
inner join tipos t on p.CodT = t.CodT order by categorias asc;

-- ======================DAVID Y MELVIN======================================================================

-- 5 - Mostrar los clientes y las fechas en que se han afiliado entre abril y junio del año 2008:
SELECT Nombres, Apellidos, Fecha_afiliacion
FROM clientes
WHERE Fecha_afiliacion BETWEEN '2008-04-01' AND '2008-06-30';

-- 6 - Mostrar el top 3 de películas que tienen más existencias disponibles en el renta video:
SELECT TOP 3 Nombre, Diponible
FROM peliculas
ORDER BY Diponible DESC;

select * from peliculas;

-- 9 -Mostrar los nombres de las películas que comiencen con la letra A:
SELECT Nombre
FROM peliculas
WHERE Nombre LIKE 'A%';

-- 10 - Eliminar las rentas que realizó Pedro Arias Rivas Cisneros:
DELETE FROM rentas
WHERE DUI = (SELECT DUI FROM clientes WHERE Nombres = 'Pedro Arias' AND Apellidos = 'Rivas Cisneros');