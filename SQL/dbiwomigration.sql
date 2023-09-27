-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-06-2023 a las 23:46:13
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `dbiwomigration`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbldatosdestino`
--

CREATE TABLE `tbldatosdestino` (
  `Nombre_Migracion` varchar(20) NOT NULL COMMENT 'Nombre de la migración llave primaria para relación con tblDatosOrigen.',
  `host` varchar(20) DEFAULT NULL COMMENT 'Host de el servidor de destino',
  `puerto` int(5) DEFAULT NULL COMMENT 'puerto del server de destino ',
  `nombre_Db` varchar(20) DEFAULT NULL COMMENT 'Nombre de la base de datos de destino',
  `nombre_Usuario` varchar(20) DEFAULT NULL COMMENT 'Nombre del usuario de la base de datos de destino',
  `contraseña` varchar(20) DEFAULT NULL COMMENT 'contraseña para conectarse a la base de datos de destino'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbldatosdestino`
--

INSERT INTO `tbldatosdestino` (`Nombre_Migracion`, `host`, `puerto`, `nombre_Db`, `nombre_Usuario`, `contraseña`) VALUES
('migración de prueba', '134.890.7.7.0', 3306, 'migracion', 'root', '123456'),
('prueba', '134.890.7.7.0', 3306, 'migracion', 'root', '123456');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbldatosorigen`
--

CREATE TABLE `tbldatosorigen` (
  `Nombre_Migracion` varchar(20) NOT NULL COMMENT 'Nombre que se le da a la migración esta se relaciona con la base de datos de tblDatosDestino',
  `host` varchar(20) DEFAULT NULL COMMENT 'Host del server de origen.',
  `puerto` int(5) DEFAULT NULL COMMENT 'puerto del server de origen.',
  `nombre_Db` varchar(20) DEFAULT NULL COMMENT 'nombre de la base de datos de origen',
  `nombre_Usuario` varchar(20) DEFAULT NULL COMMENT 'nombre del usuario de origen',
  `contraseña` varchar(20) DEFAULT NULL COMMENT 'contraseña de la base de datos de origen'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbldatosorigen`
--

INSERT INTO `tbldatosorigen` (`Nombre_Migracion`, `host`, `puerto`, `nombre_Db`, `nombre_Usuario`, `contraseña`) VALUES
('migración de prueba', '125.531.7.8.9', 4456, 'NESYS', 'root', '123456'),
('prueba', '125.531.7.8.9', 4456, 'NESYS', 'root', '123456');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tbldatosdestino`
--
ALTER TABLE `tbldatosdestino`
  ADD PRIMARY KEY (`Nombre_Migracion`);

--
-- Indices de la tabla `tbldatosorigen`
--
ALTER TABLE `tbldatosorigen`
  ADD PRIMARY KEY (`Nombre_Migracion`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tbldatosorigen`
--
ALTER TABLE `tbldatosorigen`
  ADD CONSTRAINT `tbldatosorigen_ibfk_1` FOREIGN KEY (`Nombre_Migracion`) REFERENCES `tbldatosdestino` (`Nombre_Migracion`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
