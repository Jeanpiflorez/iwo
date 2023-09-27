-- Adminer 4.3.1 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP DATABASE IF EXISTS `renal`;
CREATE DATABASE `renal` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `renal`;

DROP TABLE IF EXISTS `acceso_vascular`;
CREATE TABLE `acceso_vascular` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` text NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `actividad`;
CREATE TABLE `actividad` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` text NOT NULL,
  `costo` float(18,2) DEFAULT NULL,
  `iva` tinyint(3) unsigned DEFAULT NULL,
  `impuesto` tinyint(3) unsigned DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `agenda`;
CREATE TABLE `agenda` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `medio_cita` tinyint(3) unsigned NOT NULL,
  `tipo_cita` tinyint(3) unsigned NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `especialidad_id` int(10) unsigned NOT NULL,
  `medico_id` int(11) NOT NULL,
  `consultorio_id` smallint(5) unsigned DEFAULT NULL,
  `consulta_id` int(10) unsigned DEFAULT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `consulta_id_unique_idx` (`consulta_id`),
  KEY `medico_id_idx` (`medico_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `consultorio_id_idx` (`consultorio_id`),
  KEY `especialidad_id_idx` (`especialidad_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `antecedente`;
CREATE TABLE `antecedente` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` text NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `articulo`;
CREATE TABLE `articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `maestro_articulo_id` int(10) unsigned NOT NULL,
  `codigo_barras` varchar(211) NOT NULL,
  `codigo_qr` varchar(211) NOT NULL,
  `descripcion` varchar(64) NOT NULL,
  `empaque` varchar(32) NOT NULL,
  `tipo_articulo_id` int(10) unsigned NOT NULL,
  `sub_categoria_id` smallint(5) unsigned NOT NULL,
  `unidad_id` int(10) unsigned NOT NULL,
  `iva` decimal(4,2) NOT NULL,
  `proveedor_tercero_id` int(10) unsigned NOT NULL,
  `dias_uso` smallint(5) unsigned NOT NULL,
  `impuesto` decimal(4,2) NOT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `unidad_id_idx` (`unidad_id`),
  KEY `tipo_articulo_id_idx` (`tipo_articulo_id`),
  KEY `maestro_articulo_id_idx` (`maestro_articulo_id`),
  KEY `sub_categoria_id_idx` (`sub_categoria_id`),
  KEY `proveedor_tercero_id_idx` (`proveedor_tercero_id`),
  CONSTRAINT `articulo_maestro_articulo_id_maestro_articulo_id` FOREIGN KEY (`maestro_articulo_id`) REFERENCES `maestro_articulo` (`id`),
  CONSTRAINT `articulo_proveedor_tercero_id_tercero_id` FOREIGN KEY (`proveedor_tercero_id`) REFERENCES `tercero` (`id`),
  CONSTRAINT `articulo_sub_categoria_id_sub_categoria_id` FOREIGN KEY (`sub_categoria_id`) REFERENCES `sub_categoria` (`id`),
  CONSTRAINT `articulo_tipo_articulo_id_tipo_articulo_id` FOREIGN KEY (`tipo_articulo_id`) REFERENCES `tipo_articulo` (`id`),
  CONSTRAINT `articulo_unidad_id_unidad_id` FOREIGN KEY (`unidad_id`) REFERENCES `unidad` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `auditoria`;
CREATE TABLE `auditoria` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tabla` varchar(63) NOT NULL,
  `registro_id` bigint(20) DEFAULT NULL,
  `accion` varchar(63) NOT NULL,
  `fecha` datetime NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `auditoria_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `autoguardado`;
CREATE TABLE `autoguardado` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registro_id` bigint(20) NOT NULL,
  `plantilla` varchar(67) NOT NULL,
  `datos` text,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `registro_id_idx` (`registro_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `bodega`;
CREATE TABLE `bodega` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(32) NOT NULL,
  `ubicacion` varchar(64) NOT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `bodega_articulo`;
CREATE TABLE `bodega_articulo` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `bodega_id` smallint(5) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `cantidad_minima` mediumint(8) unsigned DEFAULT NULL,
  `cantidad_maxima` mediumint(8) unsigned DEFAULT NULL,
  `cantidad` float(18,2) DEFAULT NULL,
  `costo_actual` float(18,2) DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bodega_id_idx` (`bodega_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  CONSTRAINT `bodega_articulo_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `bodega_articulo_bodega_id_bodega_id` FOREIGN KEY (`bodega_id`) REFERENCES `bodega` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `bodega_personal`;
CREATE TABLE `bodega_personal` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `bodega_id` smallint(5) unsigned NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bodega_id_idx` (`bodega_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `bodega_personal_bodega_id_bodega_id` FOREIGN KEY (`bodega_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `bodega_personal_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `bodega_punto_venta`;
CREATE TABLE `bodega_punto_venta` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `bodega_id` smallint(5) unsigned NOT NULL,
  `punto_venta_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bodega_id_idx` (`bodega_id`),
  KEY `punto_venta_id_idx` (`punto_venta_id`),
  CONSTRAINT `bodega_punto_venta_bodega_id_bodega_id` FOREIGN KEY (`bodega_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `bodega_punto_venta_punto_venta_id_punto_venta_id` FOREIGN KEY (`punto_venta_id`) REFERENCES `punto_venta` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `caja`;
CREATE TABLE `caja` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fecha_apertura` datetime NOT NULL,
  `fecha_cierre` datetime DEFAULT NULL,
  `personal_user_id` int(11) NOT NULL,
  `valor` float(18,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `caja_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `caja_transaccion`;
CREATE TABLE `caja_transaccion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `transaccion_contable_id` int(10) unsigned NOT NULL,
  `caja_id` int(10) unsigned NOT NULL,
  `tipo` tinyint(3) unsigned NOT NULL,
  `concepto_id` smallint(5) unsigned NOT NULL,
  `tercero_id` int(10) unsigned NOT NULL,
  `valor` float(18,2) NOT NULL,
  `descripcion` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `caja_id_idx` (`caja_id`),
  KEY `transaccion_contable_id_idx` (`transaccion_contable_id`),
  KEY `concepto_id_idx` (`concepto_id`),
  KEY `tercero_id_idx` (`tercero_id`),
  CONSTRAINT `caja_transaccion_caja_id_caja_id` FOREIGN KEY (`caja_id`) REFERENCES `caja` (`id`),
  CONSTRAINT `caja_transaccion_concepto_id_concepto_id` FOREIGN KEY (`concepto_id`) REFERENCES `concepto` (`id`),
  CONSTRAINT `caja_transaccion_tercero_id_tercero_id` FOREIGN KEY (`tercero_id`) REFERENCES `tercero` (`id`),
  CONSTRAINT `caja_transaccion_transaccion_contable_id_transaccion_contable_id` FOREIGN KEY (`transaccion_contable_id`) REFERENCES `transaccion_contable` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `cancelacion`;
CREATE TABLE `cancelacion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(64) NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `categoria`;
CREATE TABLE `categoria` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(32) NOT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `causa_cancelacion_programa`;
CREATE TABLE `causa_cancelacion_programa` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(64) NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `centro_remision`;
CREATE TABLE `centro_remision` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `descripcion` varchar(64) NOT NULL,
  `municipio_id` int(11) NOT NULL,
  `nivel` smallint(5) unsigned DEFAULT NULL,
  `codigo_habilitacion` bigint(20) NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `municipio_id_idx` (`municipio_id`),
  CONSTRAINT `centro_remision_municipio_id_municipio_id` FOREIGN KEY (`municipio_id`) REFERENCES `municipio` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `ciclo`;
CREATE TABLE `ciclo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(17) DEFAULT NULL,
  `periocidad` varchar(17) DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `cobertura`;
CREATE TABLE `cobertura` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(63) DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `cobertura` (`id`, `descripcion`, `activa`) VALUES
(1,	'REGIMEN CONTRIBUTIVO',	1),
(2,	'REGIMEN SUBSIDIADO',	1),
(3,	'VINCULADO',	1),
(4,	'PARTICULAR',	1),
(5,	'OTRO',	1);

DROP TABLE IF EXISTS `concepto`;
CREATE TABLE `concepto` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(32) NOT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `consulta`;
CREATE TABLE `consulta` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `prestador_id` int(10) unsigned DEFAULT NULL,
  `entidad_id` int(10) unsigned NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `consultorio_id` smallint(5) unsigned DEFAULT NULL,
  `regimen` tinyint(4) DEFAULT NULL,
  `servicio_id` int(10) unsigned DEFAULT NULL,
  `paciente_id` int(10) unsigned NOT NULL,
  `tipo_cita` tinyint(4) NOT NULL,
  `fecha_solicitud` date DEFAULT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `autorizacion` varchar(31) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL,
  `plan_id` int(10) unsigned DEFAULT NULL,
  `copago_id` int(10) unsigned DEFAULT NULL,
  `pago` int(11) NOT NULL,
  `valor_consulta` int(11) NOT NULL,
  `observacion` varchar(127) DEFAULT NULL,
  `factura` int(11) DEFAULT NULL,
  `t_paciente` varchar(1) DEFAULT NULL,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `centro_remision_id` bigint(20) unsigned DEFAULT NULL,
  `fecha_registro` datetime DEFAULT NULL,
  `fecha_admision` datetime DEFAULT NULL,
  `sede_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `factura_unique_index_idx` (`factura`,`t_paciente`),
  KEY `prestador_id_idx` (`prestador_id`),
  KEY `entidad_id_idx` (`entidad_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `paciente_id_idx` (`paciente_id`),
  KEY `historia_id_idx` (`historia_id`),
  KEY `copago_id_idx` (`copago_id`),
  KEY `servicio_id_idx` (`servicio_id`),
  KEY `centro_remision_id_idx` (`centro_remision_id`),
  KEY `consultorio_id_idx` (`consultorio_id`),
  KEY `plan_id_idx` (`plan_id`),
  KEY `fecha` (`fecha`),
  KEY `sede_id_idx` (`sede_id`),
  CONSTRAINT `consulta_centro_remision_id_centro_remision_id` FOREIGN KEY (`centro_remision_id`) REFERENCES `centro_remision` (`id`),
  CONSTRAINT `consulta_constraint_id` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`),
  CONSTRAINT `consulta_consultorio_id_consultorio_id` FOREIGN KEY (`consultorio_id`) REFERENCES `consultorio` (`id`),
  CONSTRAINT `consulta_copago_id_copago_id` FOREIGN KEY (`copago_id`) REFERENCES `copago` (`id`),
  CONSTRAINT `consulta_entidad_id_entidad_id` FOREIGN KEY (`entidad_id`) REFERENCES `entidad` (`id`),
  CONSTRAINT `consulta_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`),
  CONSTRAINT `consulta_paciente_id_paciente_id` FOREIGN KEY (`paciente_id`) REFERENCES `paciente` (`id`),
  CONSTRAINT `consulta_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `consulta_plan_id_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `plan` (`id`),
  CONSTRAINT `consulta_prestador_id_prestador_id` FOREIGN KEY (`prestador_id`) REFERENCES `prestador` (`id`),
  CONSTRAINT `consulta_servicio_id_servicio_id` FOREIGN KEY (`servicio_id`) REFERENCES `servicio` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `consulta_cancelacion`;
CREATE TABLE `consulta_cancelacion` (
  `consulta_id` int(10) unsigned NOT NULL DEFAULT '0',
  `cancelacion_id` int(10) unsigned NOT NULL DEFAULT '0',
  `observacion` varchar(150) NOT NULL,
  `reporta_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`consulta_id`,`cancelacion_id`),
  KEY `reporta_id_idx` (`reporta_id`),
  KEY `consulta_cancelacion_cancelacion_id_cancelacion_id` (`cancelacion_id`),
  CONSTRAINT `consulta_cancelacion_cancelacion_id_cancelacion_id` FOREIGN KEY (`cancelacion_id`) REFERENCES `cancelacion` (`id`),
  CONSTRAINT `consulta_cancelacion_consulta_id_consulta_id` FOREIGN KEY (`consulta_id`) REFERENCES `consulta` (`id`),
  CONSTRAINT `consulta_cancelacion_reporta_id_personal_user_id` FOREIGN KEY (`reporta_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `consulta_cups`;
CREATE TABLE `consulta_cups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `consulta_id` int(10) unsigned NOT NULL,
  `cups_id` int(10) unsigned NOT NULL,
  `valor` int(11) NOT NULL,
  `fecha` datetime NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `consulta_id_idx` (`consulta_id`),
  KEY `cups_id_idx` (`cups_id`),
  KEY `personal_user_id_idx` (`personal_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `consulta_inatencion`;
CREATE TABLE `consulta_inatencion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `consulta_id` int(10) unsigned DEFAULT NULL,
  `inatencion_id` int(10) unsigned DEFAULT NULL,
  `observacion` varchar(150) NOT NULL,
  `reporta_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `consulta_id` (`consulta_id`),
  KEY `consulta_id_idx` (`consulta_id`),
  KEY `reporta_id_idx` (`reporta_id`),
  KEY `inatencion_id_idx` (`inatencion_id`),
  CONSTRAINT `consulta_inatencion_consulta_id_consulta_id` FOREIGN KEY (`consulta_id`) REFERENCES `consulta` (`id`),
  CONSTRAINT `consulta_inatencion_inatencion_id_inatencion_id` FOREIGN KEY (`inatencion_id`) REFERENCES `inatencion` (`id`),
  CONSTRAINT `consulta_inatencion_reporta_id_personal_user_id` FOREIGN KEY (`reporta_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `consulta_kru`;
CREATE TABLE `consulta_kru` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `nitrogeno_urinario` decimal(5,2) DEFAULT NULL,
  `volumen_urinario` decimal(5,2) DEFAULT NULL,
  `bun_pre` decimal(5,2) DEFAULT NULL,
  `bun_post` decimal(5,2) DEFAULT NULL,
  `bun` decimal(5,2) DEFAULT NULL,
  `tiempo` tinyint(2) DEFAULT NULL,
  `kru` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_kru_historia_id_historia_id` (`historia_id`),
  KEY `personal_kru_personal_user_id_personal_user_id` (`personal_user_id`),
  CONSTRAINT `historia_kru_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`),
  CONSTRAINT `personal_kru_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `consulta_ktv`;
CREATE TABLE `consulta_ktv` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `peso_predialisis` decimal(5,2) DEFAULT NULL,
  `peso_postdialisis` decimal(5,2) DEFAULT NULL,
  `nitrogeno_ureico_pre_dialisis` decimal(5,2) DEFAULT NULL,
  `nitrogeno_ureico_post_dialisis` decimal(5,2) DEFAULT NULL,
  `ultrafiltrado_volumen` decimal(5,2) DEFAULT NULL,
  `horas` decimal(5,2) DEFAULT NULL,
  `ktv` decimal(5,2) DEFAULT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `volumen_orina` int(11) DEFAULT NULL,
  `volumen_liquido_dializado` int(11) DEFAULT NULL,
  `depuracion_creatinina` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `consulta_id_idx` (`historia_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `consulta_ktv_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `historia_ktv_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `consulta_nota`;
CREATE TABLE `consulta_nota` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `consulta_id` int(10) unsigned NOT NULL,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `tipo` smallint(6) NOT NULL,
  `fecha` datetime NOT NULL,
  `evolucion` text,
  `fecha_desconexion` datetime DEFAULT NULL,
  `evolucion_desconexion_enfermero` text,
  `suministro_medico` text,
  `observaciones` text,
  `fecha_registro` datetime DEFAULT NULL,
  `personal_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `consulta_id_idx` (`consulta_id`),
  KEY `personal_id_idx` (`personal_id`),
  KEY `historia_id_idx` (`historia_id`),
  CONSTRAINT `consulta_nota_consulta_id_consulta_id` FOREIGN KEY (`consulta_id`) REFERENCES `consulta` (`id`),
  CONSTRAINT `consulta_nota_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`),
  CONSTRAINT `consulta_nota_personal_id_personal_user_id` FOREIGN KEY (`personal_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `consulta_procedimiento`;
CREATE TABLE `consulta_procedimiento` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `consulta_id` int(10) unsigned NOT NULL,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `fecha_registro` datetime DEFAULT NULL,
  `personal_id` int(11) DEFAULT NULL,
  `tipos_procedimiento` int(11) DEFAULT NULL,
  `opciones_cateter` int(11) DEFAULT NULL,
  `descripcion_procedimiento` varchar(255) DEFAULT NULL,
  `posicion` int(11) DEFAULT NULL,
  `tipo_anestesia` int(11) DEFAULT NULL,
  `complicaciones` varchar(255) DEFAULT NULL,
  `sangrado` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `consulta_id_idx` (`consulta_id`),
  KEY `personal_id_idx` (`personal_id`),
  KEY `historia_id_idx` (`historia_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `consultorio`;
CREATE TABLE `consultorio` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(63) NOT NULL,
  `minutos` smallint(5) unsigned NOT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `consultorio_medico`;
CREATE TABLE `consultorio_medico` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `consultorio_id` smallint(5) unsigned DEFAULT NULL,
  `medico_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `consultorio_medico_unique_index_idx` (`consultorio_id`,`medico_id`),
  KEY `consultorio_id_idx` (`consultorio_id`),
  KEY `medico_id_idx` (`medico_id`),
  CONSTRAINT `consultorio_medico_consultorio_id_consultorio_id` FOREIGN KEY (`consultorio_id`) REFERENCES `consultorio` (`id`),
  CONSTRAINT `consultorio_medico_medico_id_personal_user_id` FOREIGN KEY (`medico_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `contrato`;
CREATE TABLE `contrato` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `empresa_id` int(10) unsigned NOT NULL,
  `proyecto_id` mediumint(8) unsigned NOT NULL,
  `fecha` datetime NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_final` date NOT NULL,
  `objetivos` text NOT NULL,
  `texto_preliminar` text NOT NULL,
  `texto_posterior` text NOT NULL,
  `personal_contratista_id` int(11) NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `estado` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_contratista_id_idx` (`personal_contratista_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `empresa_id_idx` (`empresa_id`),
  KEY `proyecto_id_idx` (`proyecto_id`),
  CONSTRAINT `contrato_empresa_id_empresa_id` FOREIGN KEY (`empresa_id`) REFERENCES `empresa` (`id`),
  CONSTRAINT `contrato_personal_contratista_id_personal_user_id` FOREIGN KEY (`personal_contratista_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `contrato_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `contrato_proyecto_id_proyecto_id` FOREIGN KEY (`proyecto_id`) REFERENCES `proyecto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `contrato_concepto`;
CREATE TABLE `contrato_concepto` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contrato_id` int(10) unsigned NOT NULL,
  `concepto_id` smallint(5) unsigned NOT NULL,
  `descripcion` text,
  `unidad_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) DEFAULT NULL,
  `precio_unitario` float(18,2) NOT NULL,
  `anular` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contrato_id_idx` (`contrato_id`),
  KEY `concepto_id_idx` (`concepto_id`),
  KEY `unidad_id_idx` (`unidad_id`),
  CONSTRAINT `contrato_concepto_concepto_id_concepto_id` FOREIGN KEY (`concepto_id`) REFERENCES `concepto` (`id`),
  CONSTRAINT `contrato_concepto_contrato_id_contrato_id` FOREIGN KEY (`contrato_id`) REFERENCES `contrato` (`id`),
  CONSTRAINT `contrato_concepto_unidad_id_unidad_id` FOREIGN KEY (`unidad_id`) REFERENCES `unidad` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `contrato_concepto_pago`;
CREATE TABLE `contrato_concepto_pago` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contrato_pago_id` int(10) unsigned NOT NULL,
  `contrato_concepto_id` int(10) unsigned NOT NULL,
  `cantidad_ejecutada` float(18,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contrato_pago_id_idx` (`contrato_pago_id`),
  KEY `contrato_concepto_id_idx` (`contrato_concepto_id`),
  CONSTRAINT `contrato_concepto_pago_contrato_concepto_id_contrato_concepto_id` FOREIGN KEY (`contrato_concepto_id`) REFERENCES `contrato_concepto` (`id`),
  CONSTRAINT `contrato_concepto_pago_contrato_pago_id_contrato_pago_id` FOREIGN KEY (`contrato_pago_id`) REFERENCES `contrato_pago` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `contrato_pago`;
CREATE TABLE `contrato_pago` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contrato_id` int(10) unsigned NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `anular` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `contrato_id_idx` (`contrato_id`),
  CONSTRAINT `contrato_pago_contrato_id_contrato_id` FOREIGN KEY (`contrato_id`) REFERENCES `contrato` (`id`),
  CONSTRAINT `contrato_pago_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `copago`;
CREATE TABLE `copago` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(17) DEFAULT NULL,
  `valor` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `cotizacion`;
CREATE TABLE `cotizacion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pedido_compra_id` int(10) unsigned DEFAULT NULL,
  `tercero_id` int(10) unsigned NOT NULL,
  `vigencia_dias` int(10) unsigned DEFAULT NULL,
  `modalidad_pago_id` smallint(5) unsigned NOT NULL,
  `fecha` datetime NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `estado` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `tercero_id_idx` (`tercero_id`),
  KEY `pedido_compra_id_idx` (`pedido_compra_id`),
  KEY `modalidad_pago_id_idx` (`modalidad_pago_id`),
  CONSTRAINT `cotizacion_modalidad_pago_id_modalidad_pago_id` FOREIGN KEY (`modalidad_pago_id`) REFERENCES `modalidad_pago` (`id`),
  CONSTRAINT `cotizacion_pedido_compra_id_pedido_compra_articulo_id` FOREIGN KEY (`pedido_compra_id`) REFERENCES `pedido_compra_articulo` (`id`),
  CONSTRAINT `cotizacion_pedido_compra_id_pedido_compra_id` FOREIGN KEY (`pedido_compra_id`) REFERENCES `pedido_compra` (`id`),
  CONSTRAINT `cotizacion_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `cotizacion_tercero_id_tercero_id` FOREIGN KEY (`tercero_id`) REFERENCES `tercero` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `cotizacion_articulo`;
CREATE TABLE `cotizacion_articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cotizacion_id` int(10) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) NOT NULL,
  `precio_unitario` float(18,2) NOT NULL,
  `anular` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cotizacion_id_idx` (`cotizacion_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  CONSTRAINT `cotizacion_articulo_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `cotizacion_articulo_cotizacion_id_cotizacion_id` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `cotizacion_venta`;
CREATE TABLE `cotizacion_venta` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `empresa_id` int(10) unsigned NOT NULL,
  `plan_id` int(10) unsigned NOT NULL,
  `tercero_id` int(10) unsigned NOT NULL,
  `punto_venta_id` int(10) unsigned NOT NULL,
  `valor` float(18,2) NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `factura_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id_idx` (`plan_id`),
  KEY `tercero_id_idx` (`tercero_id`),
  KEY `empresa_id_idx` (`empresa_id`),
  KEY `punto_venta_id_idx` (`punto_venta_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `factura_id_idx` (`factura_id`),
  CONSTRAINT `cotizacion_venta_empresa_id_empresa_id` FOREIGN KEY (`empresa_id`) REFERENCES `empresa` (`id`),
  CONSTRAINT `cotizacion_venta_factura_id_factura_id` FOREIGN KEY (`factura_id`) REFERENCES `factura` (`id`),
  CONSTRAINT `cotizacion_venta_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `cotizacion_venta_plan_id_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `plan` (`id`),
  CONSTRAINT `cotizacion_venta_punto_venta_id_punto_venta_id` FOREIGN KEY (`punto_venta_id`) REFERENCES `punto_venta` (`id`),
  CONSTRAINT `cotizacion_venta_tercero_id_tercero_id` FOREIGN KEY (`tercero_id`) REFERENCES `tercero` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `cotizacion_venta_articulo`;
CREATE TABLE `cotizacion_venta_articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cotizacion_venta_id` int(10) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) NOT NULL,
  `descuento` smallint(5) unsigned NOT NULL,
  `precio_unitario` float(18,2) NOT NULL,
  `valor` float(18,2) NOT NULL,
  `anular` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cotizacion_venta_id_idx` (`cotizacion_venta_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  CONSTRAINT `ccci` FOREIGN KEY (`cotizacion_venta_id`) REFERENCES `cotizacion_venta` (`id`),
  CONSTRAINT `cotizacion_venta_articulo_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `cotizacion_venta_gestion`;
CREATE TABLE `cotizacion_venta_gestion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cotizacion_venta_id` int(10) unsigned NOT NULL,
  `descripcion` text NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cotizacion_venta_id_idx` (`cotizacion_venta_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `cotizacion_venta_gestion_cotizacion_venta_id_cotizacion_venta_id` FOREIGN KEY (`cotizacion_venta_id`) REFERENCES `cotizacion_venta` (`id`),
  CONSTRAINT `cotizacion_venta_gestion_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `ctc`;
CREATE TABLE `ctc` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `consulta_id` int(10) unsigned DEFAULT NULL,
  `historia_medicamento_id` int(10) unsigned DEFAULT NULL,
  `historia_cups_id` int(10) unsigned DEFAULT NULL,
  `riesgo_inminente` tinyint(4) NOT NULL,
  `caso_clinico` text NOT NULL,
  `uso_medicamentos_pos` tinyint(1) NOT NULL,
  `uso_tecnologia_procedimiento_pos` tinyint(1) NOT NULL,
  `justificacion` text NOT NULL,
  `indicaciones` text NOT NULL,
  `efecto_esperado` text NOT NULL,
  `tiempo_esperado` int(11) NOT NULL,
  `efecto_secundario` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `historia_medicamento_unique_index_idx` (`historia_medicamento_id`),
  UNIQUE KEY `historia_cups_id` (`historia_cups_id`),
  KEY `consulta_id` (`consulta_id`),
  CONSTRAINT `ctc_historia_medicamento_id_historia_medicamento_id` FOREIGN KEY (`historia_medicamento_id`) REFERENCES `historia_medicamento` (`id`),
  CONSTRAINT `ctc_ibfk_1` FOREIGN KEY (`consulta_id`) REFERENCES `consulta` (`id`),
  CONSTRAINT `ctc_ibfk_2` FOREIGN KEY (`historia_cups_id`) REFERENCES `historia_cups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `ctc_medicamento`;
CREATE TABLE `ctc_medicamento` (
  `ctc_id` int(10) unsigned NOT NULL DEFAULT '0',
  `medicamento_id` int(10) unsigned NOT NULL DEFAULT '0',
  `dosis_diaria` float(18,2) NOT NULL,
  `tiempo_dias` float(18,2) NOT NULL,
  PRIMARY KEY (`ctc_id`,`medicamento_id`),
  KEY `ctc_medicamento_medicamento_id_medicamento_id` (`medicamento_id`),
  CONSTRAINT `ctc_medicamento_ctc_id_ctc_id` FOREIGN KEY (`ctc_id`) REFERENCES `ctc` (`id`),
  CONSTRAINT `ctc_medicamento_medicamento_id_medicamento_id` FOREIGN KEY (`medicamento_id`) REFERENCES `medicamento` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `cuenta`;
CREATE TABLE `cuenta` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cuenta_maestra_id` int(10) unsigned NOT NULL,
  `codigo` int(10) unsigned NOT NULL,
  `descripcion` text NOT NULL,
  `activa` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cuenta_maestra_id_idx` (`cuenta_maestra_id`),
  CONSTRAINT `cuenta_cuenta_maestra_id_cuenta_maestra_id` FOREIGN KEY (`cuenta_maestra_id`) REFERENCES `cuenta_maestra` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `cuenta_maestra`;
CREATE TABLE `cuenta_maestra` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `codigo` int(10) unsigned NOT NULL,
  `descripcion` text NOT NULL,
  `activa` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `cups`;
CREATE TABLE `cups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(6) DEFAULT NULL,
  `descripcion` text,
  `genero` tinyint(4) NOT NULL,
  `tipo_edad_inicio` tinyint(4) NOT NULL,
  `edad_inicio` smallint(6) NOT NULL,
  `tipo_edad_fin` tinyint(4) NOT NULL,
  `edad_fin` smallint(6) NOT NULL,
  `archivo_rips` varchar(2) NOT NULL,
  `procedimiento` tinyint(1) NOT NULL,
  `tipo_procedimiento` tinyint(4) NOT NULL,
  `finalidad` tinyint(4) NOT NULL,
  `pos` tinyint(1) NOT NULL,
  `repetido` tinyint(4) NOT NULL,
  `ambito` varchar(2) NOT NULL,
  `estancia` varchar(1) NOT NULL,
  `unico` varchar(1) NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `departamento`;
CREATE TABLE `departamento` (
  `id` int(11) NOT NULL DEFAULT '0',
  `descripcion` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `despacho`;
CREATE TABLE `despacho` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pedido_articulo_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `transaccion_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pedido_articulo_id_idx` (`pedido_articulo_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `transaccion_id_idx` (`transaccion_id`),
  CONSTRAINT `despacho_pedido_articulo_id_pedido_articulo_id` FOREIGN KEY (`pedido_articulo_id`) REFERENCES `pedido_articulo` (`id`),
  CONSTRAINT `despacho_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `despacho_transaccion_id_transaccion_id` FOREIGN KEY (`transaccion_id`) REFERENCES `transaccion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `devolucion`;
CREATE TABLE `devolucion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `despacho_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) DEFAULT NULL,
  `observacion` text NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `transaccion_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `despacho_id_idx` (`despacho_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `transaccion_id_idx` (`transaccion_id`),
  CONSTRAINT `devolucion_despacho_id_despacho_id` FOREIGN KEY (`despacho_id`) REFERENCES `despacho` (`id`),
  CONSTRAINT `devolucion_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `devolucion_transaccion_id_transaccion_id` FOREIGN KEY (`transaccion_id`) REFERENCES `transaccion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `devolucion_compra`;
CREATE TABLE `devolucion_compra` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ingreso_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) DEFAULT NULL,
  `observacion` text NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `transaccion_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ingreso_id_idx` (`ingreso_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `transaccion_id_idx` (`transaccion_id`),
  CONSTRAINT `devolucion_compra_ingreso_id_ingreso_id` FOREIGN KEY (`ingreso_id`) REFERENCES `ingreso` (`id`),
  CONSTRAINT `devolucion_compra_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `devolucion_compra_transaccion_id_transaccion_id` FOREIGN KEY (`transaccion_id`) REFERENCES `transaccion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `diagnostico`;
CREATE TABLE `diagnostico` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(4) NOT NULL,
  `descripcion` text NOT NULL,
  `genero` tinyint(4) NOT NULL,
  `tipo_edad_inicio` tinyint(4) NOT NULL,
  `edad_inicio` smallint(6) NOT NULL,
  `tipo_edad_fin` tinyint(4) NOT NULL,
  `edad_fin` smallint(6) NOT NULL,
  `patologia` varchar(3) DEFAULT NULL,
  `grupo_mortalidad` smallint(6) NOT NULL,
  `capitulo` varchar(3) DEFAULT NULL,
  `id_sugrupo` mediumint(9) NOT NULL,
  `sivigila` mediumint(9) NOT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `dialisis`;
CREATE TABLE `dialisis` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `consulta_id` int(10) unsigned NOT NULL,
  `autorizacion` varchar(31) DEFAULT NULL,
  `filtro` varchar(31) DEFAULT NULL,
  `bomba` mediumint(8) unsigned NOT NULL,
  `tiempo` time NOT NULL,
  `ultrafiltrado` mediumint(8) unsigned NOT NULL,
  `anticoagulacion` mediumint(8) unsigned NOT NULL,
  `sodio` mediumint(8) unsigned NOT NULL,
  `potacio` mediumint(8) unsigned NOT NULL,
  `temperatura_maquina` decimal(3,1) DEFAULT NULL,
  `ultrafiltracion_hora_perfil` decimal(3,1) DEFAULT NULL,
  `sodio_perfilado` decimal(3,1) DEFAULT NULL,
  `hepatitis_b` char(1) DEFAULT NULL,
  `hiv` char(1) DEFAULT NULL,
  `hepatitis_c` char(1) DEFAULT NULL,
  `camara_coagulada` char(7) DEFAULT NULL,
  `linea_coagulada` char(7) DEFAULT NULL,
  `filtro_coagulado` char(7) DEFAULT NULL,
  `dolor` char(2) DEFAULT NULL,
  `rubor` char(2) DEFAULT NULL,
  `costra` char(2) DEFAULT NULL,
  `calor` char(2) DEFAULT NULL,
  `exudado` char(2) DEFAULT NULL,
  `pun_dificil` char(2) DEFAULT NULL,
  `sangrado` char(2) DEFAULT NULL,
  `hematoma` char(2) DEFAULT NULL,
  `bajo_flujo` char(2) DEFAULT NULL,
  `infeccion` char(2) DEFAULT NULL,
  `hipotencion` char(2) DEFAULT NULL,
  `calambre` char(2) DEFAULT NULL,
  `arritmia` char(2) DEFAULT NULL,
  `vomito` char(2) DEFAULT NULL,
  `cefalea` char(2) DEFAULT NULL,
  `complicaciones` text,
  `acceso_vascular_id` smallint(5) unsigned NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `consulta_id_idx` (`consulta_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `acceso_vascular_id_idx` (`acceso_vascular_id`),
  CONSTRAINT `Dialisis_acceso_vascular_id_acceso_vascular_id` FOREIGN KEY (`acceso_vascular_id`) REFERENCES `acceso_vascular` (`id`),
  CONSTRAINT `Dialisis_consulta_id_consulta_id` FOREIGN KEY (`consulta_id`) REFERENCES `consulta` (`id`),
  CONSTRAINT `Dialisis_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `dialisiscontrol`;
CREATE TABLE `dialisiscontrol` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dialisis_id` int(10) unsigned NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `sistolica` smallint(5) unsigned DEFAULT NULL,
  `diastolica` smallint(5) unsigned DEFAULT NULL,
  `tension_arterial` varchar(7) DEFAULT NULL,
  `frecuencia_cardiaca` smallint(6) DEFAULT NULL,
  `frecuencia_respiratoria` smallint(6) DEFAULT NULL,
  `temperatura` decimal(3,1) DEFAULT NULL,
  `bomba` mediumint(8) unsigned DEFAULT NULL,
  `presion_del_dializado` mediumint(8) unsigned DEFAULT NULL,
  `presion_venosa` mediumint(8) unsigned DEFAULT NULL,
  `ultrafiltracion_programada` mediumint(8) unsigned DEFAULT NULL,
  `ultrafiltracion_acumulada` mediumint(8) unsigned DEFAULT NULL,
  `ultrafiltracion_h_perfil` mediumint(8) unsigned DEFAULT NULL,
  `solucion_salina` mediumint(8) unsigned DEFAULT NULL,
  `heparina_bolo` mediumint(8) unsigned DEFAULT NULL,
  `obsevaciones` text,
  `fecha_registro` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dialisis_id_idx` (`dialisis_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `DialisisControl_dialisis_id_Dialisis_id` FOREIGN KEY (`dialisis_id`) REFERENCES `dialisis` (`id`),
  CONSTRAINT `DialisisControl_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `empresa`;
CREATE TABLE `empresa` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_documento` varchar(3) NOT NULL,
  `numero_documento` varchar(14) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `direccion` varchar(32) NOT NULL,
  `representante_legal` text NOT NULL,
  `representante_legal_tipo_documento` varchar(2) DEFAULT NULL,
  `representante_legal_numero_documento` varchar(15) DEFAULT NULL,
  `representante_firma` varchar(255) DEFAULT NULL,
  `telefono` bigint(20) NOT NULL,
  `telefono_dos` bigint(20) DEFAULT NULL,
  `celular` bigint(20) NOT NULL,
  `celular_dos` bigint(20) DEFAULT NULL,
  `otro_contacto` varchar(128) DEFAULT NULL,
  `correo_electronico` varchar(63) DEFAULT NULL,
  `regimen_factura` varchar(63) DEFAULT NULL,
  `municipio_id` int(11) NOT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `resolucion_id` int(10) unsigned NOT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `municipio_id_idx` (`municipio_id`),
  KEY `resolucion_id_idx` (`resolucion_id`),
  CONSTRAINT `empresa_municipio_id_municipio_id` FOREIGN KEY (`municipio_id`) REFERENCES `municipio` (`id`),
  CONSTRAINT `empresa_resolucion_id_resolucion_id` FOREIGN KEY (`resolucion_id`) REFERENCES `resolucion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `entidad`;
CREATE TABLE `entidad` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `codigo_eps` varchar(10) NOT NULL,
  `nit` varchar(12) NOT NULL,
  `nombre` varchar(63) NOT NULL,
  `tarifario_id` int(10) unsigned DEFAULT NULL,
  `tipo_contratacion` int(11) NOT NULL,
  `tiempo_cita` int(11) NOT NULL,
  `valor_consulta` int(11) NOT NULL,
  `requiere_autorizacion` tinyint(1) NOT NULL,
  `cobertura_id` int(10) unsigned DEFAULT NULL,
  `codigo_ihospital` varchar(4) NOT NULL,
  `tipo_regimen_4505` varchar(1) NOT NULL,
  `tipo_fuente_4505` varchar(3) NOT NULL,
  `citas_internet_mes` tinyint(4) NOT NULL,
  `solicitud_por_referencia` tinyint(1) NOT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cobertura_id_idx` (`cobertura_id`),
  KEY `tarifario_id_idx` (`tarifario_id`),
  CONSTRAINT `entidad_cobertura_id_cobertura_id` FOREIGN KEY (`cobertura_id`) REFERENCES `cobertura` (`id`),
  CONSTRAINT `entidad_tarifario_id_tarifario_id` FOREIGN KEY (`tarifario_id`) REFERENCES `tarifario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `escala_yesavage`;
CREATE TABLE `escala_yesavage` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned NOT NULL,
  `puntaje_uno` mediumint(9) DEFAULT NULL,
  `puntaje_dos` mediumint(9) DEFAULT NULL,
  `puntaje_tres` mediumint(9) DEFAULT NULL,
  `puntaje_cuatro` mediumint(9) DEFAULT NULL,
  `puntaje_cinco` mediumint(9) DEFAULT NULL,
  `puntaje_seis` mediumint(9) DEFAULT NULL,
  `puntaje_siete` mediumint(9) DEFAULT NULL,
  `puntaje_ocho` mediumint(9) DEFAULT NULL,
  `puntaje_nueve` mediumint(9) DEFAULT NULL,
  `puntaje_diez` mediumint(9) DEFAULT NULL,
  `puntaje_once` mediumint(9) DEFAULT NULL,
  `puntaje_doce` mediumint(9) DEFAULT NULL,
  `puntaje_trece` mediumint(9) DEFAULT NULL,
  `puntaje_catorce` mediumint(9) DEFAULT NULL,
  `puntaje_quince` mediumint(9) DEFAULT NULL,
  `sumatoria_total` bigint(20) DEFAULT NULL,
  `clasificacion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  CONSTRAINT `escala_yesavage_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `especialidad`;
CREATE TABLE `especialidad` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(128) NOT NULL,
  `solicitud_por_referencia` tinyint(1) NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `estadio`;
CREATE TABLE `estadio` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `estadio` varchar(63) NOT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `evento_adverso`;
CREATE TABLE `evento_adverso` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_reporta` datetime DEFAULT NULL,
  `personal_reporta_id` int(11) NOT NULL,
  `fecha_plan_mejora` datetime DEFAULT NULL,
  `personal_plan_mejora_id` int(11) DEFAULT NULL,
  `paciente_id` int(10) unsigned NOT NULL,
  `prestador_id` int(10) unsigned NOT NULL,
  `fecha_suceso` date NOT NULL,
  `estado` int(2) DEFAULT NULL,
  `descripcion_suceso` text,
  `correctivo_inmediato` text,
  `barreras_administrativas` tinyint(1) DEFAULT NULL,
  `barreras_humanas` tinyint(1) DEFAULT NULL,
  `barreras_fisicas` tinyint(1) DEFAULT NULL,
  `barreras_naturales` tinyint(1) DEFAULT NULL,
  `barreras_descripcion` tinyint(1) DEFAULT NULL,
  `falta_conocimiento` tinyint(1) DEFAULT NULL,
  `omision_olvido` tinyint(1) DEFAULT NULL,
  `violacion_conciente` tinyint(1) DEFAULT NULL,
  `accidente` tinyint(1) DEFAULT NULL,
  `falla_comunicacion` tinyint(1) DEFAULT NULL,
  `monitorizar_observar_actuar` tinyint(1) DEFAULT NULL,
  `toma_decision_incorrecta` tinyint(1) DEFAULT NULL,
  `buscar_ayuda` tinyint(1) DEFAULT NULL,
  `falta_capacitacion_entrenamiento` tinyint(1) DEFAULT NULL,
  `otra` tinyint(1) DEFAULT NULL,
  `otra_descripcion` text,
  `plan_mejora` text,
  `unidad_ubicacion` text NOT NULL,
  `factores_organizacion_gerencia` tinyint(1) DEFAULT NULL,
  `factores_individuo` tinyint(1) DEFAULT NULL,
  `factores_tarea_tecnologia` tinyint(1) DEFAULT NULL,
  `factores_paciente` tinyint(1) DEFAULT NULL,
  `factores_equipo_trabajo` tinyint(1) DEFAULT NULL,
  `factores_ambiente` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `paciente_id` (`paciente_id`),
  KEY `personal_reporta_id` (`personal_reporta_id`),
  KEY `personal_plan_mejora_id` (`personal_plan_mejora_id`),
  KEY `prestador_id` (`prestador_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `evolucion_consulta`;
CREATE TABLE `evolucion_consulta` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `consulta_id` int(10) unsigned DEFAULT NULL,
  `anular` tinyint(1) DEFAULT NULL,
  `remision` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  KEY `consulta_id_idx` (`consulta_id`),
  CONSTRAINT `evolucion_consulta_consulta_id_consulta_id` FOREIGN KEY (`consulta_id`) REFERENCES `consulta` (`id`),
  CONSTRAINT `evolucion_consulta_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `factura`;
CREATE TABLE `factura` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `numero_factura` varchar(10) NOT NULL,
  `prestador_id` int(10) unsigned NOT NULL,
  `resolucion_id` int(10) unsigned NOT NULL,
  `concepto` text NOT NULL,
  `valor` int(10) unsigned NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `prestador_id_idx` (`prestador_id`),
  KEY `resolucion_id_idx` (`resolucion_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `factura_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `factura_prestador_id_prestador_id` FOREIGN KEY (`prestador_id`) REFERENCES `prestador` (`id`),
  CONSTRAINT `factura_resolucion_id_resolucion_id` FOREIGN KEY (`resolucion_id`) REFERENCES `resolucion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `factura_actividad`;
CREATE TABLE `factura_actividad` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `factura_id` int(10) unsigned NOT NULL,
  `actividad_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) NOT NULL,
  `observacion` text,
  `precio_unitario` float(18,2) NOT NULL,
  `iva` decimal(4,2) NOT NULL,
  `total_iva` float(18,2) NOT NULL,
  `impuesto` decimal(4,2) NOT NULL,
  `total_impuesto` float(18,2) NOT NULL,
  `anular` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `factura_id_idx` (`factura_id`),
  KEY `actividad_id_idx` (`actividad_id`),
  CONSTRAINT `factura_actividad_actividad_id_actividad_id` FOREIGN KEY (`actividad_id`) REFERENCES `actividad` (`id`),
  CONSTRAINT `factura_actividad_factura_id_factura_id` FOREIGN KEY (`factura_id`) REFERENCES `factura` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `factura_articulo`;
CREATE TABLE `factura_articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `factura_id` int(10) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) NOT NULL,
  `precio_unitario` float(18,2) NOT NULL,
  `iva` decimal(4,2) NOT NULL,
  `total_iva` float(18,2) NOT NULL,
  `impuesto` decimal(4,2) NOT NULL,
  `total_impuesto` float(18,2) NOT NULL,
  `descuento` decimal(4,2) NOT NULL,
  `total_descuento` float(18,2) NOT NULL,
  `valor_parcial` float(18,2) NOT NULL,
  `transaccion_id` int(10) unsigned NOT NULL,
  `personal_venta_id` int(11) NOT NULL,
  `anular` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `factura_id_idx` (`factura_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  KEY `transaccion_id_idx` (`transaccion_id`),
  KEY `personal_venta_id_idx` (`personal_venta_id`),
  CONSTRAINT `factura_articulo_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `factura_articulo_factura_id_factura_id` FOREIGN KEY (`factura_id`) REFERENCES `factura` (`id`),
  CONSTRAINT `factura_articulo_personal_venta_id_personal_user_id` FOREIGN KEY (`personal_venta_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `factura_articulo_transaccion_id_transaccion_id` FOREIGN KEY (`transaccion_id`) REFERENCES `transaccion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `factura_consulta`;
CREATE TABLE `factura_consulta` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `factura_id` int(10) unsigned NOT NULL,
  `consulta_id` int(10) unsigned DEFAULT NULL,
  `consecutivo_entidad` int(10) unsigned NOT NULL,
  `anulado` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `factura_id_idx` (`factura_id`),
  KEY `consulta_id_idx` (`consulta_id`),
  CONSTRAINT `factura_consulta_consulta_id_consulta_id` FOREIGN KEY (`consulta_id`) REFERENCES `consulta` (`id`),
  CONSTRAINT `factura_consulta_factura_id_factura_id` FOREIGN KEY (`factura_id`) REFERENCES `factura` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `factura_consulta_anulada`;
CREATE TABLE `factura_consulta_anulada` (
  `factura_consulta_id` int(10) unsigned NOT NULL DEFAULT '0',
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`factura_consulta_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `factura_consulta_anulada_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `factura_pago`;
CREATE TABLE `factura_pago` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `factura_id` int(10) unsigned NOT NULL,
  `modalidad_pago_id` smallint(5) unsigned NOT NULL,
  `recibe` decimal(11,2) NOT NULL,
  `cambio` decimal(11,2) NOT NULL,
  `valor` decimal(11,2) NOT NULL,
  `caja_transaccion_id` int(10) unsigned DEFAULT NULL,
  `factura_anulada_id` int(10) unsigned DEFAULT NULL,
  `tipo` tinyint(3) unsigned DEFAULT NULL,
  `marca` varchar(16) DEFAULT NULL,
  `ultimos_digitos` mediumint(8) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `factura_id_idx` (`factura_id`),
  KEY `modalidad_pago_id_idx` (`modalidad_pago_id`),
  KEY `caja_transaccion_id_idx` (`caja_transaccion_id`),
  KEY `factura_anulada_id_idx` (`factura_anulada_id`),
  CONSTRAINT `factura_pago_caja_transaccion_id_caja_transaccion_id` FOREIGN KEY (`caja_transaccion_id`) REFERENCES `caja_transaccion` (`id`),
  CONSTRAINT `factura_pago_factura_anulada_id_factura_id` FOREIGN KEY (`factura_anulada_id`) REFERENCES `factura` (`id`),
  CONSTRAINT `factura_pago_factura_id_factura_id` FOREIGN KEY (`factura_id`) REFERENCES `factura` (`id`),
  CONSTRAINT `factura_pago_modalidad_pago_id_modalidad_pago_id` FOREIGN KEY (`modalidad_pago_id`) REFERENCES `modalidad_pago` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `folstein`;
CREATE TABLE `folstein` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned NOT NULL,
  `en_que_ano_estamos` mediumint(9) DEFAULT NULL,
  `en_que_estacion` mediumint(9) DEFAULT NULL,
  `en_que_dia_fecha` mediumint(9) DEFAULT NULL,
  `en_que_mes` mediumint(9) DEFAULT NULL,
  `en_que_dia_de_la_semana` mediumint(9) DEFAULT NULL,
  `en_que_hospital_o_lugar_estamos` mediumint(9) DEFAULT NULL,
  `en_que_piso_o_planta_sala_servicio` mediumint(9) DEFAULT NULL,
  `en_que_pueblo_ciudad` mediumint(9) DEFAULT NULL,
  `en_que_provincia_estamos` mediumint(9) DEFAULT NULL,
  `en_que_pais_o_nacion_autonomia` mediumint(9) DEFAULT NULL,
  `recuerdo_inmediato` mediumint(9) DEFAULT NULL,
  `atencion_calculo` mediumint(9) DEFAULT NULL,
  `recuerdo_diferido` mediumint(9) DEFAULT NULL,
  `lenguaje` mediumint(9) DEFAULT NULL,
  `sumatoria_total` bigint(20) DEFAULT NULL,
  `clasificacion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  CONSTRAINT `folstein_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `formato`;
CREATE TABLE `formato` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(64) NOT NULL,
  `modulo` varchar(32) NOT NULL,
  `plantilla` varchar(32) NOT NULL,
  `opciones` text,
  `media_carta` tinyint(1) NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `formula`;
CREATE TABLE `formula` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_paciente` varchar(255) NOT NULL,
  `texto` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `formulario`;
CREATE TABLE `formulario` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(32) NOT NULL,
  `version` varchar(10) NOT NULL,
  `objetivo` varchar(32) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `formulario_diligenciado`;
CREATE TABLE `formulario_diligenciado` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `formulario_id` int(10) unsigned NOT NULL,
  `fecha` datetime NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `personal_aprueba_id` int(11) DEFAULT NULL,
  `fecha_aprueba` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `formulario_id_idx` (`formulario_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `personal_aprueba_id_idx` (`personal_aprueba_id`),
  CONSTRAINT `formulario_diligenciado_formulario_id_formulario_id` FOREIGN KEY (`formulario_id`) REFERENCES `formulario` (`id`),
  CONSTRAINT `formulario_diligenciado_personal_aprueba_id_personal_user_id` FOREIGN KEY (`personal_aprueba_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `formulario_diligenciado_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `historia`;
CREATE TABLE `historia` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nefrologo_especialista` varchar(30) DEFAULT NULL,
  `fecha_inicio_atencion` datetime DEFAULT NULL,
  `fecha_fin_enfermero` datetime DEFAULT NULL,
  `fecha_inicio_medico` datetime DEFAULT NULL,
  `fecha_fin_atencion` datetime DEFAULT NULL,
  `peso` double(18,2) DEFAULT NULL,
  `talla` double(18,2) DEFAULT NULL,
  `imc` double(18,2) DEFAULT NULL,
  `perimetro_abdominal` smallint(5) unsigned DEFAULT NULL,
  `cintura_pelvica` int(11) DEFAULT NULL,
  `tension_arterial` varchar(7) DEFAULT NULL,
  `frecuencia_cardiaca` smallint(6) DEFAULT NULL,
  `frecuencia_respiratoria` smallint(6) DEFAULT NULL,
  `temperatura` smallint(6) DEFAULT NULL,
  `glasgow` smallint(6) DEFAULT NULL,
  `enfermero_id` int(11) DEFAULT NULL,
  `finalidad_consulta` int(11) DEFAULT NULL,
  `causa_externa` int(11) DEFAULT NULL,
  `motivo_consulta` text,
  `enfermedad_actual` text,
  `triage_id` int(10) unsigned DEFAULT NULL,
  `morinsky_green_uno` tinyint(3) DEFAULT NULL,
  `morinsky_green_dos` tinyint(3) DEFAULT NULL,
  `morinsky_green_tres` tinyint(3) DEFAULT NULL,
  `morinsky_green_cuatro` tinyint(3) DEFAULT NULL,
  `ayudas_diagnosticas` text,
  `embarazada` tinyint(4) DEFAULT NULL,
  `cabeza` tinyint(4) DEFAULT NULL,
  `ojos` tinyint(4) DEFAULT NULL,
  `oidos` tinyint(4) DEFAULT NULL,
  `nariz` tinyint(4) DEFAULT NULL,
  `boca` tinyint(4) DEFAULT NULL,
  `garganta` tinyint(4) DEFAULT NULL,
  `cuello` tinyint(4) DEFAULT NULL,
  `torax` tinyint(4) DEFAULT NULL,
  `corazon` tinyint(4) DEFAULT NULL,
  `pulmon` tinyint(4) DEFAULT NULL,
  `abdomen` tinyint(4) DEFAULT NULL,
  `pelvis` tinyint(4) DEFAULT NULL,
  `tacto_rectal` tinyint(4) DEFAULT NULL,
  `genitourinario` tinyint(4) DEFAULT NULL,
  `extremidades_superiores` tinyint(4) DEFAULT NULL,
  `extremidades_inferiores` tinyint(4) DEFAULT NULL,
  `espalda` tinyint(4) DEFAULT NULL,
  `piel` tinyint(4) DEFAULT NULL,
  `endocrino` tinyint(4) DEFAULT NULL,
  `sistema_nervioso` tinyint(4) DEFAULT NULL,
  `cabeza_texto_explicativo` text,
  `ojos_texto_explicativo` text,
  `oidos_texto_explicativo` text,
  `nariz_texto_explicativo` text,
  `boca_texto_explicativo` text,
  `garganta_texto_explicativo` text,
  `cuello_texto_explicativo` text,
  `torax_texto_explicativo` text,
  `corazon_texto_explicativo` text,
  `pulmon_texto_explicativo` text,
  `abdomen_texto_explicativo` text,
  `pelvis_texto_explicativo` text,
  `tacto_rectal_texto_explicativo` text,
  `genitourinario_texto_explicativo` text,
  `extremidades_superiores_texto_explicativo` text,
  `extremidades_inferiores_texto_explicativo` text,
  `espalda_texto_explicativo` text,
  `piel_texto_explicativo` text,
  `endocrino_texto_explicativo` text,
  `sistema_nervioso_texto_explicativo` text,
  `medico_general_id` int(11) DEFAULT NULL,
  `diagnostico_ingreso_id` int(11) DEFAULT NULL,
  `diagnostico_ingreso_dos_id` int(11) DEFAULT NULL,
  `diagnostico_ingreso_tres_id` int(11) DEFAULT NULL,
  `diagnostico_ingreso_cuatro_id` int(11) DEFAULT NULL,
  `diagnostico_id` int(11) DEFAULT NULL,
  `diagnostico_dos_id` int(11) DEFAULT NULL,
  `diagnostico_tres_id` int(11) DEFAULT NULL,
  `diagnostico_cuatro_id` int(11) DEFAULT NULL,
  `diagnostico_cinco_id` int(11) DEFAULT NULL,
  `diagnostico_seis_id` int(11) DEFAULT NULL,
  `diagnostico_siete_id` int(11) DEFAULT NULL,
  `tipo_diagnostico` tinyint(4) DEFAULT NULL,
  `tipo_diagnostico_dos` tinyint(4) DEFAULT NULL,
  `tipo_diagnostico_tres` tinyint(4) DEFAULT NULL,
  `tipo_diagnostico_cuatro` tinyint(4) DEFAULT NULL,
  `tipo_diagnostico_cinco` tinyint(4) DEFAULT NULL,
  `tipo_diagnostico_seis` tinyint(4) DEFAULT NULL,
  `tipo_diagnostico_siete` tinyint(4) DEFAULT NULL,
  `tipo_diabetes` smallint(6) DEFAULT NULL,
  `tipo_hemodialisis` int(3) DEFAULT NULL,
  `horas_dialisis` decimal(5,2) DEFAULT NULL,
  `sesiones_semanales` decimal(5,2) DEFAULT NULL,
  `prescripcion_dialisis` int(1) DEFAULT NULL,
  `dp_recambios` int(5) DEFAULT NULL,
  `dp_concentracion_1` int(10) DEFAULT NULL,
  `dp_concentracion_2` int(10) DEFAULT NULL,
  `dp_concentracion_3` int(10) DEFAULT NULL,
  `dp_volumen` double(18,2) DEFAULT NULL,
  `cantidad_tr` int(3) DEFAULT NULL,
  `revision_por_sistemas` text,
  `sintomas_generales` text,
  `piel_y_faneras` text,
  `organos_de_los_sentidos` text,
  `musculoesqueletico` text,
  `hematologico_y_linforreticular` text,
  `cardiovascular` text,
  `respiratorio` text,
  `digestivo` text,
  `genitourinario_rs` text,
  `psiquiatrico` text,
  `analisis_y_conducta` text,
  `dias_incapacidad` smallint(6) DEFAULT NULL,
  `fecha_incapacidad` date DEFAULT NULL,
  `orden_de_cirugia` tinyint(1) DEFAULT NULL,
  `orden_de_medicamentos` tinyint(1) DEFAULT NULL,
  `solicitud_de_insumos` tinyint(1) DEFAULT NULL,
  `ordenes_medicas` tinyint(1) DEFAULT NULL,
  `examen_fisico` tinyint(1) DEFAULT NULL,
  `apoyos_dx` tinyint(1) DEFAULT NULL,
  `diagnosticos` tinyint(1) DEFAULT NULL,
  `signos_vitales` tinyint(1) DEFAULT NULL,
  `prioritaria` tinyint(1) DEFAULT NULL,
  `medico_especialista_id` int(11) DEFAULT NULL,
  `vivo` tinyint(1) DEFAULT '1',
  `conducta` tinyint(4) DEFAULT NULL,
  `centro_remision_id` bigint(20) unsigned DEFAULT NULL,
  `estadio_id` smallint(5) unsigned DEFAULT NULL,
  `consulta_id` int(10) unsigned DEFAULT NULL,
  `tabaquismo` tinyint(3) unsigned DEFAULT NULL,
  `actividad_fisica` tinyint(3) unsigned DEFAULT NULL,
  `diabetes_familiar` smallint(3) unsigned DEFAULT NULL,
  `receta_medicamentos_hipertension` tinyint(3) unsigned DEFAULT NULL,
  `come_frutas_verduras` tinyint(3) unsigned DEFAULT NULL,
  `glucosa_alta_anteriormente` tinyint(3) unsigned DEFAULT NULL,
  `test_findrisk` tinyint(3) unsigned DEFAULT NULL,
  `test_framingham` tinyint(3) unsigned DEFAULT NULL,
  `glucometria_ayunas` tinyint(3) DEFAULT NULL,
  `tasa_de_filtracion` decimal(5,2) DEFAULT NULL,
  `cockcroft_gault` decimal(5,2) DEFAULT NULL,
  `nota_enfermeria` text,
  `mdrd` decimal(5,2) DEFAULT NULL,
  `factor_riesgo_cardiovascular` tinyint(3) DEFAULT NULL,
  `recomendaciones` text,
  `formula_medica` text,
  `resultado_riesgo_renal` tinyint(3) DEFAULT NULL,
  `texto_riesgo_renal` varchar(127) DEFAULT NULL,
  `tipo_especialidad` tinyint(6) DEFAULT NULL,
  `programacion_id` int(10) unsigned DEFAULT NULL,
  `barthel` tinyint(1) DEFAULT NULL,
  `yesavage` tinyint(1) DEFAULT NULL,
  `folstein` tinyint(1) DEFAULT NULL,
  `resultado_anterior` tinyint(1) DEFAULT NULL,
  `historial_evolucion` tinyint(1) DEFAULT NULL,
  `historial_signos_vitales` tinyint(1) DEFAULT NULL,
  `fecha_diagnostico_erc` date DEFAULT NULL,
  `fecha_trr` date DEFAULT NULL,
  `etiologia_erc` int(11) DEFAULT NULL,
  `tasa_filtracion_glomerular` decimal(5,2) DEFAULT NULL,
  `modo_inicio_trr` int(11) DEFAULT NULL,
  `modalidad_actual_trr` int(11) DEFAULT NULL,
  `fecha_modalidad_actual` date DEFAULT NULL,
  `peritonitis_infecciosa` int(11) DEFAULT NULL,
  `fecha_peritonitis_primero` date DEFAULT NULL,
  `fecha_peritonitis_segundo` date DEFAULT NULL,
  `fecha_peritonitis_tercero` date DEFAULT NULL,
  `infeccion_hepatitis_b` int(11) DEFAULT NULL,
  `fecha_infeccion_hepatitis_b` date DEFAULT NULL,
  `infeccion_hepatitis_c` int(11) DEFAULT NULL,
  `fecha_infeccion_hepatitis_c` date DEFAULT NULL,
  `vacuna_hepatitis_b` int(11) DEFAULT NULL,
  `fecha_vacuna_hepatitisb_1` date DEFAULT NULL,
  `fecha_vacuna_hepatitisb_2` date DEFAULT NULL,
  `fecha_vacuna_hepatitisb_3` date DEFAULT NULL,
  `vih` int(11) DEFAULT NULL,
  `fecha_vih` date DEFAULT NULL,
  `ultimo_titulo_anticuerpo` double(18,2) DEFAULT NULL,
  `fecha_anticuerpo` date DEFAULT NULL,
  `transplante_renal` int(11) DEFAULT NULL,
  `fecha_transplante_renal` date DEFAULT NULL,
  `tipo_donante` int(11) DEFAULT NULL,
  `confirma_rechazo_trr` int(11) DEFAULT NULL,
  `rechazo_trasplante_renal` date DEFAULT NULL,
  `confirma_retorno_trr` int(11) DEFAULT NULL,
  `retorno_terapia_reemplazo_renal` date DEFAULT NULL,
  `apto_transplante_renal` int(11) DEFAULT NULL,
  `causas_contraindicaciones` int(11) DEFAULT NULL,
  `contraindicacion_na` int(11) DEFAULT NULL,
  `paciente_transplantado` int(11) DEFAULT NULL,
  `contraindicacion_transplantado` varchar(255) DEFAULT NULL,
  `fecha_contraindicacion` date DEFAULT NULL,
  `lista_espera` int(11) DEFAULT NULL,
  `fecha_lista_espera` date DEFAULT NULL,
  `confirma_diuresis` int(11) DEFAULT NULL,
  `medicacion_actual` text,
  `diuresis` double(18,2) DEFAULT NULL,
  `ultrafiltracion` double(18,2) DEFAULT NULL,
  `covid19_pregunta_1` int(2) DEFAULT NULL,
  `covid19_pregunta_2` int(2) DEFAULT NULL,
  `covid19_pregunta_3` int(2) DEFAULT NULL,
  `covid19_pregunta_4` int(2) DEFAULT NULL,
  `covid19_sintoma_1` int(2) DEFAULT NULL,
  `covid19_sintoma_2` int(2) DEFAULT NULL,
  `covid19_sintoma_3` int(2) DEFAULT NULL,
  `covid19_sintoma_4` int(2) DEFAULT NULL,
  `covid19_sintoma_5` int(2) DEFAULT NULL,
  `covid19_sintoma_6` int(2) DEFAULT NULL,
  `peso_seco` int(11) DEFAULT NULL,
  `fecha_peritonitis_actual` date DEFAULT NULL,
  `fecha_peritonitis_anteriores` date DEFAULT NULL,
  `episodio_peritonitis_mes` int(11) DEFAULT NULL,
  `episodio_peritonitis_acumuladas` int(11) DEFAULT NULL,
  `tipos_procedimiento` int(11) DEFAULT NULL,
  `opciones_cateter` int(11) DEFAULT NULL,
  `descripcion_procedimiento` text,
  `posicion` int(11) DEFAULT NULL,
  `tipo_anestesia` int(11) DEFAULT NULL,
  `complicaciones` text,
  `sangrado` int(11) DEFAULT NULL,
  `horas_por_sesiones` decimal(5,2) DEFAULT NULL,
  `fecha_ingreso_unidad_renal` date DEFAULT NULL,
  `desistimiento_terapia_dialitica` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `resultado` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `resultado_2` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `resultado_3` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `resultado_4` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `fecha_resultado` date DEFAULT NULL,
  `fecha_resultado_2` date DEFAULT NULL,
  `fecha_resultado_3` date DEFAULT NULL,
  `fecha_resultado_4` date DEFAULT NULL,
  `enfermedad_neoplasica` int(1) DEFAULT NULL,
  `menor_cinco_anos_evolucion` int(1) DEFAULT NULL,
  `menor_dos_anos_evolucion` int(1) DEFAULT NULL,
  `tumores_localizados` int(1) DEFAULT NULL,
  `enfermedades_comorbilidades` int(2) DEFAULT NULL,
  `mala_adherencia_tratamientos` text,
  `red_apoyo_familiar_social` text,
  `formato_consentimiento` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `lista_chequeo_seguridad` int(1) unsigned DEFAULT NULL,
  `diligencio_consentimiento_informado` int(1) unsigned DEFAULT NULL,
  `recomendacion_procedimiento` text,
  PRIMARY KEY (`id`),
  KEY `diagnostico_id_idx` (`diagnostico_id`),
  KEY `diagnostico_dos_id_idx` (`diagnostico_dos_id`),
  KEY `diagnostico_tres_id_idx` (`diagnostico_tres_id`),
  KEY `diagnostico_cuatro_id_idx` (`diagnostico_cuatro_id`),
  KEY `diagnostico_ingreso_id_idx` (`diagnostico_ingreso_id`),
  KEY `diagnostico_ingreso_dos_id_idx` (`diagnostico_ingreso_dos_id`),
  KEY `diagnostico_ingreso_tres_id_idx` (`diagnostico_ingreso_tres_id`),
  KEY `diagnostico_ingreso_cuatro_id_idx` (`diagnostico_ingreso_cuatro_id`),
  KEY `enfermero_id_idx` (`enfermero_id`),
  KEY `medico_general_id_idx` (`medico_general_id`),
  KEY `medico_especialista_id_idx` (`medico_especialista_id`),
  KEY `triage_id_idx` (`triage_id`),
  KEY `centro_remision_id_idx` (`centro_remision_id`),
  KEY `estadio_id_idx` (`estadio_id`),
  KEY `diagnostico_cinco_id` (`diagnostico_cinco_id`),
  KEY `diagnostico_seis_id` (`diagnostico_seis_id`),
  KEY `diagnostico_siete_id` (`diagnostico_siete_id`),
  KEY `programacion_id_idx` (`programacion_id`),
  KEY `folstein` (`folstein`),
  CONSTRAINT `historia_centro_remision_id_centro_remision_id` FOREIGN KEY (`centro_remision_id`) REFERENCES `centro_remision` (`id`),
  CONSTRAINT `historia_diagnostico_cuatro_id_diagnostico_id` FOREIGN KEY (`diagnostico_cuatro_id`) REFERENCES `diagnostico` (`id`),
  CONSTRAINT `historia_diagnostico_dos_id_diagnostico_id` FOREIGN KEY (`diagnostico_dos_id`) REFERENCES `diagnostico` (`id`),
  CONSTRAINT `historia_diagnostico_id_diagnostico_id` FOREIGN KEY (`diagnostico_id`) REFERENCES `diagnostico` (`id`),
  CONSTRAINT `historia_diagnostico_ingreso_cuatro_id_diagnostico_id` FOREIGN KEY (`diagnostico_ingreso_cuatro_id`) REFERENCES `diagnostico` (`id`),
  CONSTRAINT `historia_diagnostico_ingreso_dos_id_diagnostico_id` FOREIGN KEY (`diagnostico_ingreso_dos_id`) REFERENCES `diagnostico` (`id`),
  CONSTRAINT `historia_diagnostico_ingreso_id_diagnostico_id` FOREIGN KEY (`diagnostico_ingreso_id`) REFERENCES `diagnostico` (`id`),
  CONSTRAINT `historia_diagnostico_ingreso_tres_id_diagnostico_id` FOREIGN KEY (`diagnostico_ingreso_tres_id`) REFERENCES `diagnostico` (`id`),
  CONSTRAINT `historia_diagnostico_tres_id_diagnostico_id` FOREIGN KEY (`diagnostico_tres_id`) REFERENCES `diagnostico` (`id`),
  CONSTRAINT `historia_enfermero_id_personal_user_id` FOREIGN KEY (`enfermero_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `historia_estadio_id_estadio_id` FOREIGN KEY (`estadio_id`) REFERENCES `estadio` (`id`),
  CONSTRAINT `historia_ibfk_1` FOREIGN KEY (`diagnostico_cinco_id`) REFERENCES `diagnostico` (`id`),
  CONSTRAINT `historia_ibfk_2` FOREIGN KEY (`diagnostico_seis_id`) REFERENCES `diagnostico` (`id`),
  CONSTRAINT `historia_ibfk_3` FOREIGN KEY (`diagnostico_siete_id`) REFERENCES `diagnostico` (`id`),
  CONSTRAINT `historia_ibfk_4` FOREIGN KEY (`programacion_id`) REFERENCES `programacion` (`id`),
  CONSTRAINT `historia_medico_especialista_id_personal_user_id` FOREIGN KEY (`medico_especialista_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `historia_medico_general_id_personal_user_id` FOREIGN KEY (`medico_general_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `historia_triage_id_triage_id` FOREIGN KEY (`triage_id`) REFERENCES `triage` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `historia_antecedente`;
CREATE TABLE `historia_antecedente` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned NOT NULL,
  `antecedente_id` int(10) unsigned NOT NULL,
  `confirma` tinyint(1) NOT NULL,
  `conoce_fecha` int(1) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  KEY `antecedente_id_idx` (`antecedente_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `historia_antecedentes`;
CREATE TABLE `historia_antecedentes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned NOT NULL DEFAULT '0',
  `tipo` tinyint(4) DEFAULT NULL,
  `fecha` date NOT NULL,
  `texto` text,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`,`historia_id`),
  KEY `historia_antecedentes_historia_id_historia_id` (`historia_id`),
  CONSTRAINT `historia_antecedentes_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `historia_control_neumonologico`;
CREATE TABLE `historia_control_neumonologico` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cn_fecha_control_anual_neumologia` varchar(20) DEFAULT NULL,
  `cn_fecha_espirometria_pre_pos_broncodilatador` varchar(20) DEFAULT NULL,
  `cn_fev1_pre_broncodilatador` varchar(500) DEFAULT NULL,
  `cn_fev1_pos_broncodilatador` varchar(500) DEFAULT NULL,
  `cn_fev1_fvc_pre_broncodilatador` varchar(500) DEFAULT NULL,
  `cn_fev1_fvc_pos_broncodilatador` varchar(500) DEFAULT NULL,
  `cn_porcentaje_cambio` varchar(500) DEFAULT NULL,
  `cn_clasificacion_espirometria_gold` varchar(500) DEFAULT NULL,
  `cn_test_6_minutos_pre_rehabilitacion` varchar(500) DEFAULT NULL,
  `cn_fecha_6_minutos_pre_rehabilitacion` varchar(20) DEFAULT NULL,
  `cn_escala_borg` varchar(500) DEFAULT NULL,
  `cn_fecha_inicio_rehabil_pulmonar` varchar(20) DEFAULT NULL,
  `cn_numero_sesiones_rehabil_pulmonar` varchar(20) DEFAULT NULL,
  `cn_fecha_fin_rehabil_pulmonar` varchar(20) DEFAULT NULL,
  `cn_test_6_minutos_pos_rehabilitacion` varchar(20) DEFAULT NULL,
  `cn_escala_borg_pos` varchar(500) DEFAULT NULL,
  `cn_numero_exacerbaciones_ultimo_anio` varchar(20) DEFAULT NULL,
  `cn_ultima_exacerbacion` varchar(50) DEFAULT NULL,
  `cn_requrio_hospitalizacion` varchar(20) DEFAULT NULL,
  `cn_clasificacion_epoc` varchar(20) DEFAULT NULL,
  `cn_disnea` varchar(500) DEFAULT NULL,
  `cn_realiza_activida_fisica` varchar(20) DEFAULT NULL,
  `cn_encuesta_calidad_vida_cat` varchar(20) DEFAULT NULL,
  `cn_escala_bodex_puntuacion` varchar(500) DEFAULT NULL,
  `cn_escala_bodex_cuartil` varchar(500) DEFAULT NULL,
  `cn_escala_bode_puntuacion` varchar(500) DEFAULT NULL,
  `cn_escala_bode_cuartil` varchar(20) DEFAULT NULL,
  `cn_supervivencia` varchar(500) DEFAULT NULL,
  `cn_tos` varchar(5) DEFAULT NULL,
  `cn_flema` varchar(5) DEFAULT NULL,
  `cn_pecho_oprimido` varchar(5) DEFAULT NULL,
  `cn_falta_aliento` varchar(5) DEFAULT NULL,
  `cn_limitacion_tareas` varchar(5) DEFAULT NULL,
  `cn_problemas_salir_casa` varchar(5) DEFAULT NULL,
  `cn_duermo_profundo` varchar(5) DEFAULT NULL,
  `cn_tengo_energia` varchar(5) DEFAULT NULL,
  `historia_epoc_id` int(10) NOT NULL,
  `historia_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_epoc_id` (`historia_epoc_id`),
  KEY `historia_epoc_id_2` (`historia_epoc_id`),
  KEY `historia_id` (`historia_id`),
  CONSTRAINT `epoc_control` FOREIGN KEY (`historia_epoc_id`) REFERENCES `historia_epoc` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `historia_cups`;
CREATE TABLE `historia_cups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned NOT NULL,
  `cups_id` int(10) unsigned NOT NULL,
  `fecha` datetime NOT NULL,
  `cantidad` float(18,2) DEFAULT NULL,
  `texto_explicativo` text,
  `especialidad_id` int(10) unsigned DEFAULT NULL,
  `anular` tinyint(1) DEFAULT NULL,
  `paquete` tinyint(4) DEFAULT NULL,
  `procedimiento` int(2) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  KEY `cups_id_idx` (`cups_id`),
  KEY `especialidad_id` (`especialidad_id`),
  CONSTRAINT `historia_cups_cups_id_cups_id` FOREIGN KEY (`cups_id`) REFERENCES `cups` (`id`),
  CONSTRAINT `historia_cups_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`),
  CONSTRAINT `historia_cups_ibfk_1` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidad` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `historia_epoc`;
CREATE TABLE `historia_epoc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `expocision_factor_riesgo` varchar(500) DEFAULT NULL,
  `exposicio_tabaco_fumar` varchar(10) DEFAULT NULL,
  `exposicion_tabaco_humo_ajeno` varchar(10) DEFAULT NULL,
  `exposicion_ocupacional_polvos_humos_sustancias_quimicas` varchar(10) DEFAULT NULL,
  `contaminacion_aire_interiores` varchar(10) DEFAULT NULL,
  `asma_infancia` varchar(10) DEFAULT NULL,
  `eventos_vida_fetal_primeros_anios` varchar(10) DEFAULT NULL,
  `deficit_alfa` varchar(10) DEFAULT NULL,
  `factor_riesgo_otro` varchar(700) DEFAULT NULL,
  `infeccion_respiratoria_infancia` varchar(500) DEFAULT NULL,
  `exposicion_tabaco` varchar(500) DEFAULT NULL,
  `tiempo_exposicion_tabaco` varchar(50) DEFAULT NULL,
  `exposicion_humo` varchar(100) DEFAULT NULL,
  `exposicioin_laboral` varchar(500) DEFAULT NULL,
  `bajo_peso_nacer` varchar(500) DEFAULT NULL,
  `tuberculosis_pulmonar` varchar(500) DEFAULT NULL,
  `vapeo` varchar(10) DEFAULT NULL,
  `tipo_exposicion_tabaco` varchar(500) DEFAULT NULL,
  `tiempo_exposicion_humo` varchar(500) DEFAULT NULL,
  `tipo_exposicion_laboral` varchar(500) DEFAULT NULL,
  `tipo_exposicion_laboral_otra` varchar(500) DEFAULT NULL,
  `tiempo_exposicion_laboral` varchar(500) DEFAULT NULL,
  `numero_cigarrillos_fumados` int(11) DEFAULT NULL,
  `anios_fumando` int(11) DEFAULT NULL,
  `resultado` varchar(500) DEFAULT NULL,
  `clasificacion_indice_tabaquico` varchar(500) DEFAULT NULL,
  `fecha_espirometria_pre_pos_broncodilatador` varchar(500) DEFAULT NULL,
  `fev1_pre_broncodilatador` varchar(500) DEFAULT NULL,
  `fev1_pos_broncodilatador` varchar(500) DEFAULT NULL,
  `fev1_fvc_pre_broncodilatador` varchar(500) DEFAULT NULL,
  `fev1_fvc_pos_broncodilatador` varchar(500) DEFAULT NULL,
  `porcentaje_cambi` varchar(500) DEFAULT NULL,
  `clasificacion_espirometria_gold` varchar(500) DEFAULT NULL,
  `test_caminata` varchar(500) DEFAULT NULL,
  `numero_exacerbaciones` varchar(500) DEFAULT NULL,
  `ultima_exacerbacion` varchar(500) DEFAULT NULL,
  `requrio_hospitalizacion` varchar(500) DEFAULT NULL,
  `clasificacion_epoc` varchar(500) DEFAULT NULL,
  `fecha_diagnostico_epoc` varchar(50) DEFAULT NULL,
  `disnea` varchar(500) DEFAULT NULL,
  `actividad_fisica` varchar(500) DEFAULT NULL,
  `escala_bodex_puntuacion` varchar(500) DEFAULT NULL,
  `escala_bodex_cuartil` varchar(500) DEFAULT NULL,
  `escala_bode_puntuacion` varchar(500) DEFAULT NULL,
  `escala_bode_cuartil` varchar(500) DEFAULT NULL,
  `supervivencia` varchar(500) DEFAULT NULL,
  `ip_fecha_ingreso_programa` varchar(20) DEFAULT NULL,
  `ip_fecha_espirometria_pre_pos_broncodilatador` varchar(20) DEFAULT NULL,
  `ip_fev1_pre_broncodilatador` varchar(500) DEFAULT NULL,
  `ip_fev1_pos_broncodilatador` varchar(500) DEFAULT NULL,
  `ip_fev1_fvc_pre_broncodilatador` varchar(500) DEFAULT NULL,
  `ip_fev1_fvc_pos_broncodilatador` varchar(500) DEFAULT NULL,
  `ip_porcentaje_cambio` varchar(20) DEFAULT NULL,
  `ip_clasificacion_espirometria_gold` varchar(500) DEFAULT NULL,
  `ip_test_6_minutos_pre_rehabilitacion` varchar(500) DEFAULT NULL,
  `ip_fecha_6_minutos_pre_rehabilitacion` varchar(20) DEFAULT NULL,
  `ip_escala_borg` varchar(500) DEFAULT NULL,
  `ip_fecha_inicio_rehabil_pulmonar` varchar(20) DEFAULT NULL,
  `ip_numero_sesiones_rehabil_pulmonar` varchar(500) DEFAULT NULL,
  `ip_fecha_fin_rehabil_pulmonar` varchar(20) DEFAULT NULL,
  `ip_test_6_minutos_pos_rehabilitacion` varchar(20) DEFAULT NULL,
  `ip_fecha_6_minutos_pos_rehabilitacion` varchar(100) DEFAULT NULL,
  `ip_escala_borg_pos` varchar(500) DEFAULT NULL,
  `ip_numero_exacerbaciones_ultimo_anio` varchar(500) DEFAULT NULL,
  `ip_ultima_exacerbacion` varchar(500) DEFAULT NULL,
  `ip_requrio_hospitalizacion` varchar(20) DEFAULT NULL,
  `ip_clasificacion_epoc` varchar(500) DEFAULT NULL,
  `ip_disnea` varchar(500) DEFAULT NULL,
  `ip_realiza_activida_fisica` varchar(500) DEFAULT NULL,
  `ip_escala_bodex_puntuacion` varchar(500) DEFAULT NULL,
  `ip_escala_bodex_cuartil` varchar(500) DEFAULT NULL,
  `ip_escala_bode_puntuacion` varchar(500) DEFAULT NULL,
  `ip_escala_bode_cuartil` varchar(500) DEFAULT NULL,
  `ip_supervivencia` varchar(500) DEFAULT NULL,
  `ip_tos` varchar(5) DEFAULT NULL,
  `ip_flema` varchar(5) DEFAULT NULL,
  `ip_pecho_oprimido` varchar(5) DEFAULT NULL,
  `ip_falta_aliento` varchar(5) DEFAULT NULL,
  `ip_limitacion_tareas` varchar(5) DEFAULT NULL,
  `ip_problemas_salir_casa` varchar(5) DEFAULT NULL,
  `ip_duermo_profundo` varchar(5) DEFAULT NULL,
  `ip_tengo_energia` varchar(5) DEFAULT NULL,
  `historia_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id` (`historia_id`),
  CONSTRAINT `historia_id_epoc` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `historia_hospitalizacion`;
CREATE TABLE `historia_hospitalizacion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned NOT NULL,
  `personal_id` int(10) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `hospitalizacion` text,
  PRIMARY KEY (`id`),
  KEY `historia_hospitalizacion_historia_id` (`historia_id`),
  KEY `historia_hospitalizacion_personal_id` (`personal_id`),
  CONSTRAINT `historia_hospitalizacion_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`),
  CONSTRAINT `historia_hospitalizacion_personal_id` FOREIGN KEY (`personal_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `historia_insumo`;
CREATE TABLE `historia_insumo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `insumo_id` int(10) unsigned DEFAULT NULL,
  `cantidad` int(10) unsigned DEFAULT NULL,
  `texto_explicativo` text,
  `anular` tinyint(1) NOT NULL,
  `paquete` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  KEY `insumo_id_idx` (`insumo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `historia_medicamento`;
CREATE TABLE `historia_medicamento` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned NOT NULL,
  `medicamento_id` int(10) unsigned NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `via_id` int(10) unsigned DEFAULT NULL,
  `ciclo_id` int(10) unsigned DEFAULT NULL,
  `dosis` float(18,2) DEFAULT NULL,
  `tiempo` float(18,2) DEFAULT NULL,
  `cantidad` float(18,2) DEFAULT NULL,
  `texto_explicativo` text,
  `paquete` tinyint(1) DEFAULT NULL,
  `anular` tinyint(1) DEFAULT NULL,
  `suspender` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  KEY `medicamento_id_idx` (`medicamento_id`),
  KEY `ciclo_id_idx` (`ciclo_id`),
  CONSTRAINT `historia_medicamento_ciclo_id_ciclo_id` FOREIGN KEY (`ciclo_id`) REFERENCES `ciclo` (`id`),
  CONSTRAINT `historia_medicamento_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`),
  CONSTRAINT `historia_medicamento_medicamento_id_medicamento_id` FOREIGN KEY (`medicamento_id`) REFERENCES `medicamento` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `historia_procedimiento`;
CREATE TABLE `historia_procedimiento` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `procedimiento_id` int(10) unsigned DEFAULT NULL,
  `cantidad` int(10) unsigned DEFAULT NULL,
  `texto_explicativo` text,
  `anular` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  KEY `procedimiento_id_idx` (`procedimiento_id`),
  CONSTRAINT `historia_procedimiento_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`),
  CONSTRAINT `historia_procedimiento_procedimiento_id_cups_id` FOREIGN KEY (`procedimiento_id`) REFERENCES `cups` (`id`),
  CONSTRAINT `historia_procedimiento_procedimiento_id_procedimiento_id` FOREIGN KEY (`procedimiento_id`) REFERENCES `procedimiento` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `historia_resultado`;
CREATE TABLE `historia_resultado` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned NOT NULL DEFAULT '0',
  `resultado_id` int(10) unsigned NOT NULL DEFAULT '0',
  `resultado` text,
  `fecha` date NOT NULL,
  `hora` time DEFAULT NULL,
  PRIMARY KEY (`id`,`historia_id`,`resultado_id`),
  KEY `historia_resultado_resultado_id_resultado_id` (`resultado_id`),
  KEY `historia_resultado_historia_id_historia_id` (`historia_id`),
  CONSTRAINT `historia_resultado_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`),
  CONSTRAINT `historia_resultado_resultado_id_resultado_id` FOREIGN KEY (`resultado_id`) REFERENCES `resultado` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `inatencion`;
CREATE TABLE `inatencion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` text NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `indice_barthel`;
CREATE TABLE `indice_barthel` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned NOT NULL,
  `puntaje_comer` mediumint(9) DEFAULT NULL,
  `puntaje_trasladarse_entre_la_silla_y_la_cama` mediumint(9) DEFAULT NULL,
  `puntaje_aseo_personal` mediumint(9) DEFAULT NULL,
  `puntaje_uso_del_retrete` mediumint(9) DEFAULT NULL,
  `puntaje_banarse_o_ducharse` mediumint(9) DEFAULT NULL,
  `puntaje_desplazarse` mediumint(9) DEFAULT NULL,
  `puntaje_subir_y_bajar_escaleras` mediumint(9) DEFAULT NULL,
  `puntaje_vestirse_y_desvestirse` mediumint(9) DEFAULT NULL,
  `puntaje_control_de_heces` mediumint(9) DEFAULT NULL,
  `puntaje_control_de_orina` mediumint(9) DEFAULT NULL,
  `sumatoria_total` bigint(20) DEFAULT NULL,
  `clasificacion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  CONSTRAINT `indice_barthel_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `indice_charlson`;
CREATE TABLE `indice_charlson` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(1) unsigned DEFAULT NULL,
  `indice_charlson` int(1) DEFAULT NULL,
  `infarto_miocardio` int(1) DEFAULT NULL,
  `insuficiencia_cardiaca_congestiva` int(1) DEFAULT NULL,
  `enfermedad_vascular_periferica` int(1) DEFAULT NULL,
  `enfermedad_cerebrovascular` int(1) DEFAULT NULL,
  `demencia` int(1) DEFAULT NULL,
  `enfermedad_pulmonar_cronica` int(1) DEFAULT NULL,
  `patologia_tejido_conectivo` int(1) DEFAULT NULL,
  `enfermedad_ulcerosa` int(1) DEFAULT NULL,
  `patologia_hepatica` int(1) DEFAULT NULL,
  `diabetes_mellitus` int(1) DEFAULT NULL,
  `hemiplejia` int(1) DEFAULT NULL,
  `patologia_renal_moderada_grave` int(1) DEFAULT NULL,
  `tumor_solido` int(1) DEFAULT NULL,
  `leucemias` int(1) DEFAULT NULL,
  `linfomas_malignos` int(1) DEFAULT NULL,
  `sida` int(1) DEFAULT NULL,
  `puntuacion_charlson` int(1) DEFAULT NULL,
  `supervivencia_estimada` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `indice_charlson_historia_id_historia_id` (`historia_id`),
  CONSTRAINT `indice_charlson_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `ingreso`;
CREATE TABLE `ingreso` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `orden_de_compra_articulo_id` int(10) unsigned NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `cantidad` float(18,2) DEFAULT NULL,
  `transaccion_id` int(10) unsigned NOT NULL,
  `observaciones` varchar(191) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `orden_de_compra_articulo_id_idx` (`orden_de_compra_articulo_id`),
  KEY `transaccion_id_idx` (`transaccion_id`),
  CONSTRAINT `ingreso_orden_de_compra_articulo_id_orden_de_compra_articulo_id` FOREIGN KEY (`orden_de_compra_articulo_id`) REFERENCES `orden_de_compra_articulo` (`id`),
  CONSTRAINT `ingreso_transaccion_id_transaccion_id` FOREIGN KEY (`transaccion_id`) REFERENCES `transaccion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `insumo`;
CREATE TABLE `insumo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(6) DEFAULT NULL,
  `descripcion` text,
  `estado` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `insumos`;
CREATE TABLE `insumos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(6) DEFAULT NULL,
  `descripcion` text,
  `tipo` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `maestro_articulo`;
CREATE TABLE `maestro_articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `medicamento`;
CREATE TABLE `medicamento` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `articulo_id` int(10) unsigned DEFAULT NULL,
  `codigo` varchar(25) NOT NULL,
  `descripcion_codigo_atc` varchar(64) NOT NULL,
  `principio_activo` varchar(512) NOT NULL,
  `concentracion` varchar(32) NOT NULL,
  `forma_farmaceutica` varchar(16) NOT NULL,
  `cum` varchar(25) NOT NULL,
  `producto` text NOT NULL,
  `presentacion_comercial` varchar(252) NOT NULL,
  `fabricante_importador` text NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `indicaciones` text,
  `efecto_esperado` text,
  `efecto_secundario` text,
  `efectos_adversos` text,
  `pos` tinyint(1) NOT NULL,
  `control` tinyint(1) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `articulo_id` (`articulo_id`),
  CONSTRAINT `medicamento_ibfk_1` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `modalidad_pago`;
CREATE TABLE `modalidad_pago` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(32) NOT NULL,
  `credito` tinyint(1) DEFAULT NULL,
  `debito_caja` tinyint(1) DEFAULT NULL,
  `tarjeta` tinyint(1) DEFAULT NULL,
  `factura_anulada` tinyint(1) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `municipio`;
CREATE TABLE `municipio` (
  `id` int(11) NOT NULL DEFAULT '0',
  `departamento_id` int(11) NOT NULL,
  `descripcion` varchar(32) NOT NULL,
  `codigo` varchar(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `departamento_id_idx` (`departamento_id`),
  CONSTRAINT `municipio_departamento_id_departamento_id` FOREIGN KEY (`departamento_id`) REFERENCES `departamento` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `nefrologia`;
CREATE TABLE `nefrologia` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `indice_de_karnofsky` int(1) unsigned DEFAULT NULL,
  `escala_karnofsky` int(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nefrologia_historia_id_historia_id` (`historia_id`),
  CONSTRAINT `nefrologia_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `nutricion`;
CREATE TABLE `nutricion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `apetito` tinyint(3) unsigned DEFAULT NULL,
  `intolerancias` text,
  `habito_intestinal` tinyint(3) unsigned DEFAULT NULL,
  `masticacion` tinyint(3) unsigned DEFAULT NULL,
  `deglucion` tinyint(3) unsigned DEFAULT NULL,
  `sintomas_gastrointestinales` text,
  `complemento_suplemento_nutricional` text,
  `alimentos_favoritos` text,
  `alimentos_rechazados` text,
  `actividad_fisica` text NOT NULL,
  `alcohol` tinyint(3) unsigned DEFAULT NULL,
  `cigarrillos` tinyint(3) unsigned DEFAULT NULL,
  `desayuno` text,
  `nueves` text,
  `almuerzo` text,
  `onces` text,
  `cena` text,
  `refrigerio` text,
  `diagnostico_nutricional` text,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  CONSTRAINT `nutricion_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `ocupacion`;
CREATE TABLE `ocupacion` (
  `id` int(11) NOT NULL DEFAULT '0',
  `descripcion` varchar(95) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `opcion`;
CREATE TABLE `opcion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pregunta_id` int(10) unsigned NOT NULL,
  `descripcion` text NOT NULL,
  `valor` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `opcion_formulario_diligenciado`;
CREATE TABLE `opcion_formulario_diligenciado` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `formulario_diligenciado_id` int(10) unsigned NOT NULL,
  `opcion_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `formulario_diligenciado_id_idx` (`formulario_diligenciado_id`),
  CONSTRAINT `offi` FOREIGN KEY (`formulario_diligenciado_id`) REFERENCES `formulario_diligenciado` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `orden_cirugia`;
CREATE TABLE `orden_cirugia` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `hosp_prequirurgica` tinyint(4) DEFAULT NULL,
  `hosp_posquirurgica` tinyint(4) DEFAULT NULL,
  `tipo_anestesia` tinyint(4) DEFAULT NULL,
  `suministros` text,
  `recomendaciones` text,
  `riesgos` text,
  `formula_medica_libre` text,
  `historia_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  CONSTRAINT `orden_cirugia_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `orden_de_compra`;
CREATE TABLE `orden_de_compra` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pedido_compra_id` int(10) unsigned DEFAULT NULL,
  `cotizacion_id` int(10) unsigned DEFAULT NULL,
  `bodega_id` smallint(5) unsigned NOT NULL,
  `modalidad_pago_id` smallint(5) unsigned NOT NULL,
  `fecha` datetime NOT NULL,
  `tercero_id` int(10) unsigned NOT NULL,
  `tiempo_de_entrega` tinyint(3) unsigned NOT NULL,
  `factura_de_venta` varchar(24) DEFAULT NULL,
  `personal_user_id` int(11) NOT NULL,
  `personal_user_autoriza_id` int(11) NOT NULL,
  `fecha_autoriza` datetime NOT NULL,
  `estado` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tercero_id_idx` (`tercero_id`),
  KEY `pedido_compra_id_idx` (`pedido_compra_id`),
  KEY `cotizacion_id_idx` (`cotizacion_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `modalidad_pago_id_idx` (`modalidad_pago_id`),
  KEY `bodega_id_idx` (`bodega_id`),
  CONSTRAINT `orden_de_compra_bodega_id_bodega_id` FOREIGN KEY (`bodega_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `orden_de_compra_cotizacion_id_cotizacion_id` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizacion` (`id`),
  CONSTRAINT `orden_de_compra_modalidad_pago_id_modalidad_pago_id` FOREIGN KEY (`modalidad_pago_id`) REFERENCES `modalidad_pago` (`id`),
  CONSTRAINT `orden_de_compra_pedido_compra_id_pedido_compra_id` FOREIGN KEY (`pedido_compra_id`) REFERENCES `pedido_compra` (`id`),
  CONSTRAINT `orden_de_compra_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `orden_de_compra_tercero_id_tercero_id` FOREIGN KEY (`tercero_id`) REFERENCES `tercero` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `orden_de_compra_articulo`;
CREATE TABLE `orden_de_compra_articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `orden_de_compra_id` int(10) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `precio_unitario` float(18,2) NOT NULL,
  `cantidad` float(18,2) NOT NULL,
  `observaciones` varchar(191) NOT NULL,
  `anular` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `orden_de_compra_id_idx` (`orden_de_compra_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  CONSTRAINT `orden_de_compra_articulo_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `orden_de_compra_articulo_orden_de_compra_id_orden_de_compra_id` FOREIGN KEY (`orden_de_compra_id`) REFERENCES `orden_de_compra` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `orden_de_compra_articulo_transaccion`;
CREATE TABLE `orden_de_compra_articulo_transaccion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `orden_de_compra_articulo_id` int(10) unsigned NOT NULL,
  `transaccion_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `orden_de_compra_articulo_id_idx` (`orden_de_compra_articulo_id`),
  KEY `transaccion_id_idx` (`transaccion_id`),
  CONSTRAINT `oooi` FOREIGN KEY (`orden_de_compra_articulo_id`) REFERENCES `orden_de_compra_articulo` (`id`),
  CONSTRAINT `otti` FOREIGN KEY (`transaccion_id`) REFERENCES `transaccion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `paciente`;
CREATE TABLE `paciente` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_documento` varchar(3) NOT NULL,
  `numero_documento` varchar(12) NOT NULL,
  `nombres` varchar(127) NOT NULL,
  `apellidos` varchar(127) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `genero` tinyint(4) DEFAULT NULL,
  `raza` tinyint(4) DEFAULT NULL,
  `condicion` tinyint(4) DEFAULT NULL,
  `municipio_id` int(11) DEFAULT NULL,
  `otra` tinyint(1) NOT NULL,
  `ubicacion` varchar(127) DEFAULT NULL,
  `estado_civil` int(11) NOT NULL,
  `ocupacion_id` int(11) DEFAULT NULL,
  `codigo_nivel_educativo` tinyint(4) DEFAULT NULL,
  `direccion` varchar(128) NOT NULL,
  `zona` varchar(1) DEFAULT NULL,
  `estrato` tinyint(4) DEFAULT NULL,
  `telefono` bigint(20) DEFAULT NULL,
  `celular` bigint(20) DEFAULT NULL,
  `correo_electronico` varchar(63) DEFAULT NULL,
  `grupo` tinyint(4) DEFAULT NULL,
  `rh` tinyint(4) DEFAULT NULL,
  `estadio_id` smallint(5) unsigned DEFAULT NULL,
  `acompanante_nombres` varchar(127) NOT NULL,
  `acompanante_apellidos` varchar(127) NOT NULL,
  `acompanante_telefono` bigint(20) DEFAULT NULL,
  `responsable_nombres` varchar(127) DEFAULT NULL,
  `responsable_apellidos` varchar(127) DEFAULT NULL,
  `responsable_telefono` int(20) DEFAULT NULL,
  `reponsable_direccion` varchar(140) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(2) DEFAULT NULL,
  `egreso` text,
  `fecha_egreso` date DEFAULT NULL,
  `fecha_ultima_terapia` date DEFAULT NULL,
  `fecha_transplante` date DEFAULT NULL,
  `abandono_terapia` text,
  `causa_egreso` int(1) DEFAULT NULL,
  `programa_ingresa` int(11) DEFAULT NULL,
  `tipo_muerte` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `paciente_unique_index_idx` (`tipo_documento`,`numero_documento`),
  KEY `municipio_id_idx` (`municipio_id`),
  KEY `ocupacion_id_idx` (`ocupacion_id`),
  KEY `estadio_id_idx` (`estadio_id`),
  KEY `paciente_login_frk_numero_documento` (`numero_documento`),
  CONSTRAINT `paciente_estadio_id_estadio_id` FOREIGN KEY (`estadio_id`) REFERENCES `estadio` (`id`),
  CONSTRAINT `paciente_municipio_id_municipio_id` FOREIGN KEY (`municipio_id`) REFERENCES `municipio` (`id`),
  CONSTRAINT `paciente_ocupacion_id_ocupacion_id` FOREIGN KEY (`ocupacion_id`) REFERENCES `ocupacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `paciente_login`;
CREATE TABLE `paciente_login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_documento` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `pass` varchar(500) NOT NULL,
  `token` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `numero_documento` (`numero_documento`),
  CONSTRAINT `paciente_login_frk_numero_documento` FOREIGN KEY (`numero_documento`) REFERENCES `paciente` (`numero_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `paciente_programacion`;
CREATE TABLE `paciente_programacion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `paciente_id` int(10) unsigned DEFAULT NULL,
  `programacion_id` int(10) unsigned NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `programacion_id_idx` (`programacion_id`),
  KEY `paciente_id_idx` (`paciente_id`),
  CONSTRAINT `paciente_programacion_paciente_id_paciente_id` FOREIGN KEY (`paciente_id`) REFERENCES `paciente` (`id`),
  CONSTRAINT `paciente_programacion_programacion_id_programacion_id` FOREIGN KEY (`programacion_id`) REFERENCES `programacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `paciente_programacion_cups`;
CREATE TABLE `paciente_programacion_cups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `paciente_programacion_id` int(10) unsigned NOT NULL,
  `cups_id` int(10) unsigned DEFAULT NULL,
  `descripcion` text NOT NULL,
  `fecha` date NOT NULL,
  `solicitado` tinyint(1) DEFAULT NULL,
  `cumplido` tinyint(1) DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `paciente_programacion_id_idx` (`paciente_programacion_id`),
  KEY `cups_id_idx` (`cups_id`),
  CONSTRAINT `paciente_programacion_cups_cups_id_cups_id` FOREIGN KEY (`cups_id`) REFERENCES `cups` (`id`),
  CONSTRAINT `pppi` FOREIGN KEY (`paciente_programacion_id`) REFERENCES `paciente_programacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `paciente_telemedicina`;
CREATE TABLE `paciente_telemedicina` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_documento` varchar(3) NOT NULL,
  `numero_documento` varchar(12) NOT NULL,
  `nombres` varchar(127) NOT NULL,
  `apellidos` varchar(127) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `genero` tinyint(4) DEFAULT NULL,
  `cobertura_id` int(10) unsigned NOT NULL,
  `ubicacion_servicio` int(9) DEFAULT NULL,
  `entidad_id` int(10) unsigned NOT NULL,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `ordenes_medicas` tinyint(1) DEFAULT NULL,
  `solicitud_de_insumos` tinyint(1) DEFAULT NULL,
  `orden_de_medicamentos` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cobertura_id` (`cobertura_id`),
  KEY `entidad_id` (`entidad_id`),
  KEY `historia_id` (`historia_id`),
  CONSTRAINT `FK1_cobertura_idx` FOREIGN KEY (`cobertura_id`) REFERENCES `cobertura` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK2_entidad_id2` FOREIGN KEY (`entidad_id`) REFERENCES `entidad` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK3_historia_id2` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `pedido`;
CREATE TABLE `pedido` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fecha` datetime NOT NULL,
  `bodega_id` smallint(5) unsigned NOT NULL,
  `consulta_id` int(10) unsigned DEFAULT NULL,
  `proyecto_id` mediumint(8) unsigned DEFAULT NULL,
  `personal_solicita_id` int(11) NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `estado` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `personal_solicita_id_idx` (`personal_solicita_id`),
  KEY `bodega_id_idx` (`bodega_id`),
  KEY `proyecto_id_idx` (`proyecto_id`),
  KEY `consulta_id` (`consulta_id`),
  CONSTRAINT `pedido_bodega_id_bodega_id` FOREIGN KEY (`bodega_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`consulta_id`) REFERENCES `consulta` (`id`),
  CONSTRAINT `pedido_personal_solicita_id_personal_user_id` FOREIGN KEY (`personal_solicita_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `pedido_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `pedido_proyecto_id_proyecto_id` FOREIGN KEY (`proyecto_id`) REFERENCES `proyecto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `pedido_articulo`;
CREATE TABLE `pedido_articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pedido_id` int(10) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `concepto_id` smallint(5) unsigned NOT NULL,
  `cantidad` float(18,2) NOT NULL,
  `anular` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pedido_id_idx` (`pedido_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  KEY `concepto_id_idx` (`concepto_id`),
  CONSTRAINT `pedido_articulo_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `pedido_articulo_concepto_id_concepto_id` FOREIGN KEY (`concepto_id`) REFERENCES `concepto` (`id`),
  CONSTRAINT `pedido_articulo_pedido_id_pedido_id` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `pedido_compra`;
CREATE TABLE `pedido_compra` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fecha` datetime NOT NULL,
  `bodega_id` smallint(5) unsigned NOT NULL,
  `personal_solicita_id` int(11) NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `estado` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `personal_solicita_id_idx` (`personal_solicita_id`),
  KEY `bodega_id_idx` (`bodega_id`),
  CONSTRAINT `pedido_compra_bodega_id_bodega_id` FOREIGN KEY (`bodega_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `pedido_compra_personal_solicita_id_personal_user_id` FOREIGN KEY (`personal_solicita_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `pedido_compra_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `pedido_compra_articulo`;
CREATE TABLE `pedido_compra_articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pedido_compra_id` int(10) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `concepto_id` smallint(5) unsigned NOT NULL,
  `cantidad` float(18,2) NOT NULL,
  `anular` tinyint(1) NOT NULL,
  `estado` tinyint(4) NOT NULL,
  `personal_user_id` int(11) DEFAULT NULL,
  `cantidad_autorizada` float(18,2) DEFAULT NULL,
  `fecha_autorizada` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pedido_compra_id_idx` (`pedido_compra_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `concepto_id_idx` (`concepto_id`),
  CONSTRAINT `pedido_compra_articulo_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `pedido_compra_articulo_concepto_id_concepto_id` FOREIGN KEY (`concepto_id`) REFERENCES `concepto` (`id`),
  CONSTRAINT `pedido_compra_articulo_pedido_compra_id_pedido_compra_id` FOREIGN KEY (`pedido_compra_id`) REFERENCES `pedido_compra` (`id`),
  CONSTRAINT `pedido_compra_articulo_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `pedido_externo`;
CREATE TABLE `pedido_externo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `tercero_id` int(10) unsigned NOT NULL,
  `factura_id` int(10) unsigned DEFAULT NULL,
  `historia_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `tercero_id_idx` (`tercero_id`),
  KEY `factura_id_idx` (`factura_id`),
  CONSTRAINT `pedido_externo_factura_id_factura_id` FOREIGN KEY (`factura_id`) REFERENCES `factura` (`id`),
  CONSTRAINT `pedido_externo_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `pedido_externo_tercero_id_tercero_id` FOREIGN KEY (`tercero_id`) REFERENCES `tercero` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `pedido_externo_articulo`;
CREATE TABLE `pedido_externo_articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pedido_externo_id` int(10) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) NOT NULL,
  `factura_articulo_id` int(10) unsigned NOT NULL,
  `anular` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pedido_externo_id_idx` (`pedido_externo_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  KEY `factura_articulo_id_idx` (`factura_articulo_id`),
  CONSTRAINT `pedido_externo_articulo_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `pedido_externo_articulo_factura_articulo_id_factura_articulo_id` FOREIGN KEY (`factura_articulo_id`) REFERENCES `factura_articulo` (`id`),
  CONSTRAINT `pedido_externo_articulo_pedido_externo_id_pedido_externo_id` FOREIGN KEY (`pedido_externo_id`) REFERENCES `pedido_externo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `personal`;
CREATE TABLE `personal` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `nombre` varchar(127) NOT NULL,
  `cargo` varchar(45) NOT NULL,
  `especialidad` text NOT NULL,
  `tipo` int(11) NOT NULL,
  `registro_medico` varchar(12) NOT NULL,
  `firma` varchar(255) DEFAULT NULL,
  `cups_primera_id` int(10) unsigned DEFAULT NULL,
  `cups_control_id` int(10) unsigned DEFAULT NULL,
  `personal_endosa_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `cups_primera_id_idx` (`cups_primera_id`),
  KEY `cups_control_id_idx` (`cups_control_id`),
  KEY `personal_endosa_id` (`personal_endosa_id`),
  CONSTRAINT `personal_cups_control_id_cups_id` FOREIGN KEY (`cups_control_id`) REFERENCES `cups` (`id`),
  CONSTRAINT `personal_cups_primera_id_cups_id` FOREIGN KEY (`cups_primera_id`) REFERENCES `cups` (`id`),
  CONSTRAINT `personal_ibfk_1` FOREIGN KEY (`personal_endosa_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `personal_especialidad`;
CREATE TABLE `personal_especialidad` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `personal_user_id` int(11) NOT NULL,
  `especialidad_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `especialidad_id_idx` (`especialidad_id`),
  CONSTRAINT `personal_especialidad_especialidad_id_especialidad_id` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidad` (`id`),
  CONSTRAINT `personal_especialidad_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `personal_prestador`;
CREATE TABLE `personal_prestador` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `personal_user_id` int(11) NOT NULL,
  `prestador_id` int(10) unsigned NOT NULL,
  `administrador` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_prestador_unique_index_idx` (`personal_user_id`,`prestador_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `prestador_id_idx` (`prestador_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `personal_punto_venta`;
CREATE TABLE `personal_punto_venta` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `personal_user_id` int(11) NOT NULL,
  `punto_venta_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `punto_venta_id_idx` (`punto_venta_id`),
  CONSTRAINT `personal_punto_venta_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `personal_punto_venta_punto_venta_id_punto_venta_id` FOREIGN KEY (`punto_venta_id`) REFERENCES `punto_venta` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `plan`;
CREATE TABLE `plan` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(63) NOT NULL,
  `entidad_id` int(10) unsigned DEFAULT NULL,
  `tipo_contratacion` smallint(6) NOT NULL,
  `programacion_id` int(10) unsigned DEFAULT NULL,
  `valor_paquete` int(10) unsigned DEFAULT NULL,
  `monto_maximo` int(10) unsigned DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entidad_id_idx` (`entidad_id`),
  KEY `programacion_id_idx` (`programacion_id`),
  CONSTRAINT `plan_entidad_id_entidad_id` FOREIGN KEY (`entidad_id`) REFERENCES `entidad` (`id`),
  CONSTRAINT `plan_programacion_id_programacion_id` FOREIGN KEY (`programacion_id`) REFERENCES `programacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `plan_articulo`;
CREATE TABLE `plan_articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `plan_id` int(10) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `valor` decimal(11,2) NOT NULL,
  `valor_anterior` decimal(11,2) NOT NULL,
  `personal_registra_id` int(11) NOT NULL,
  `fecha_registra` datetime NOT NULL,
  `personal_modifica_id` int(11) NOT NULL,
  `fecha_modifica` datetime NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id_idx` (`plan_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  KEY `personal_registra_id_idx` (`personal_registra_id`),
  KEY `personal_modifica_id_idx` (`personal_modifica_id`),
  CONSTRAINT `plan_articulo_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `plan_articulo_personal_modifica_id_personal_user_id` FOREIGN KEY (`personal_modifica_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `plan_articulo_personal_registra_id_personal_user_id` FOREIGN KEY (`personal_registra_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `plan_articulo_plan_id_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `plan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `plan_cups`;
CREATE TABLE `plan_cups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `plan_id` int(10) unsigned DEFAULT NULL,
  `cups_id` int(10) unsigned DEFAULT NULL,
  `costo` int(10) unsigned NOT NULL,
  `precio` int(10) unsigned NOT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id_idx` (`plan_id`),
  KEY `cups_id_idx` (`cups_id`),
  CONSTRAINT `plan_cups_cups_id_cups_id` FOREIGN KEY (`cups_id`) REFERENCES `cups` (`id`),
  CONSTRAINT `plan_cups_plan_id_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `plan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `pregunta`;
CREATE TABLE `pregunta` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `formulario_id` int(10) unsigned NOT NULL,
  `descripcion` text NOT NULL,
  `tipo` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `formulario_id_idx` (`formulario_id`),
  CONSTRAINT `pregunta_formulario_id_formulario_id` FOREIGN KEY (`formulario_id`) REFERENCES `formulario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `prescripcion_dialisis_peritoneal`;
CREATE TABLE `prescripcion_dialisis_peritoneal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `numero_recambios` int(5) DEFAULT NULL,
  `concentracion_1` int(10) DEFAULT NULL,
  `concentracion_2` int(10) DEFAULT NULL,
  `concentracion_3` int(10) DEFAULT NULL,
  `numero_horas` int(11) DEFAULT NULL,
  `ktv_esperado` decimal(5,2) DEFAULT NULL,
  `personal_id` int(11) DEFAULT NULL,
  `fecha_registro` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_id` (`personal_id`),
  KEY `prescripcion_dialisis_peritoneal_constraint_historia_id` (`historia_id`),
  CONSTRAINT `prescripcion_dialisis_peritoneal_constraint_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`),
  CONSTRAINT `prescripcion_dialisis_peritoneal_personal_id` FOREIGN KEY (`personal_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `prescripcion_hemodialisis`;
CREATE TABLE `prescripcion_hemodialisis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `tiempo` int(11) DEFAULT NULL,
  `numero_sesiones_semanal` int(11) DEFAULT NULL,
  `tipo_dialisador` int(3) DEFAULT NULL,
  `ultrafiltracion` double(18,2) DEFAULT NULL,
  `ktv_esperado` decimal(5,2) DEFAULT NULL,
  `personal_id` int(11) DEFAULT NULL,
  `fecha_registro` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_id` (`personal_id`),
  KEY `prescripcion_hemodialisis_constraint_historia_id` (`historia_id`),
  CONSTRAINT `prescripcion_hemodialisis_constraint_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`),
  CONSTRAINT `prescripcion_hemodialisis_personal_id` FOREIGN KEY (`personal_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `prestador`;
CREATE TABLE `prestador` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_documento` varchar(3) NOT NULL,
  `numero_documento` varchar(12) NOT NULL,
  `codigo_habilitacion` bigint(20) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `direccion` varchar(32) NOT NULL,
  `cuenta_de_cobro` text NOT NULL,
  `representante_legal` text NOT NULL,
  `telefono` bigint(20) DEFAULT NULL,
  `municipio_id` int(11) NOT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  `resolucion_id` int(10) unsigned DEFAULT NULL,
  `sede_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `municipio_id_idx` (`municipio_id`),
  KEY `resolucion_id` (`resolucion_id`),
  KEY `sede_id` (`sede_id`),
  CONSTRAINT `prestador_ibfk_1` FOREIGN KEY (`resolucion_id`) REFERENCES `resolucion` (`id`),
  CONSTRAINT `prestador_ibfk_2` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`),
  CONSTRAINT `prestador_municipio_id_municipio_id` FOREIGN KEY (`municipio_id`) REFERENCES `municipio` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `prestador_entidad`;
CREATE TABLE `prestador_entidad` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `prestador_id` int(10) unsigned NOT NULL,
  `entidad_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `prestador_id_idx` (`prestador_id`),
  KEY `entidad_id_idx` (`entidad_id`),
  CONSTRAINT `prestador_entidad_entidad_id_entidad_id` FOREIGN KEY (`entidad_id`) REFERENCES `entidad` (`id`),
  CONSTRAINT `prestador_entidad_prestador_id_prestador_id` FOREIGN KEY (`prestador_id`) REFERENCES `prestador` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `prestador_sede`;
CREATE TABLE `prestador_sede` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `prestador_id` int(10) unsigned NOT NULL,
  `sede_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sede_id_idx_1` (`sede_id`),
  KEY `prestador_sede_constraint_prestador_id` (`prestador_id`),
  CONSTRAINT `prestador_sede_constraint_id` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`),
  CONSTRAINT `prestador_sede_constraint_prestador_id` FOREIGN KEY (`prestador_id`) REFERENCES `prestador` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `procedimiento`;
CREATE TABLE `procedimiento` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(6) DEFAULT NULL,
  `descripcion` text,
  `tarifario_id` int(10) unsigned DEFAULT NULL,
  `nivel` int(10) unsigned DEFAULT NULL,
  `cups_id` int(10) unsigned DEFAULT NULL,
  `estado` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tarifario_id_idx` (`tarifario_id`),
  KEY `cups_id_idx` (`cups_id`),
  CONSTRAINT `procedimiento_cups_id_cups_id` FOREIGN KEY (`cups_id`) REFERENCES `cups` (`id`),
  CONSTRAINT `procedimiento_tarifario_id_tarifario_id` FOREIGN KEY (`tarifario_id`) REFERENCES `tarifario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `programacion`;
CREATE TABLE `programacion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` text,
  `duracion_meses` int(10) unsigned DEFAULT NULL,
  `cita_cada_cuando_en_meses` int(10) unsigned DEFAULT NULL,
  `estadio` int(10) unsigned DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  `estadio_id` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `estadio_id` (`estadio_id`),
  CONSTRAINT `programacion_ibfk_1` FOREIGN KEY (`estadio_id`) REFERENCES `estadio` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `programacion_cups`;
CREATE TABLE `programacion_cups` (
  `programacion_id` int(10) unsigned NOT NULL DEFAULT '0',
  `cups_id` int(10) unsigned NOT NULL DEFAULT '0',
  `fecha` datetime NOT NULL,
  `cantidad` float(18,2) DEFAULT NULL,
  `texto_explicativo` text,
  `paquete` tinyint(4) DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`programacion_id`,`cups_id`),
  KEY `programacion_cups_cups_id_cups_id` (`cups_id`),
  CONSTRAINT `programacion_cups_cups_id_cups_id` FOREIGN KEY (`cups_id`) REFERENCES `cups` (`id`),
  CONSTRAINT `programacion_cups_programacion_id_programacion_id` FOREIGN KEY (`programacion_id`) REFERENCES `programacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `programa_cancelacion`;
CREATE TABLE `programa_cancelacion` (
  `paciente_programacion_id` int(10) unsigned NOT NULL DEFAULT '0',
  `causa_cancelacion_programa_id` int(10) unsigned DEFAULT NULL,
  `observacion` varchar(150) NOT NULL,
  `reporta_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`paciente_programacion_id`),
  KEY `reporta_id_idx` (`reporta_id`),
  KEY `causa_cancelacion_programa_id_idx` (`causa_cancelacion_programa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `programa_dialisis`;
CREATE TABLE `programa_dialisis` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `consulta_id` int(10) unsigned DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `estado` tinyint(3) unsigned NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `consulta_id_idx` (`consulta_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `programa_dialisis_consulta_id_consulta_id` FOREIGN KEY (`consulta_id`) REFERENCES `consulta` (`id`),
  CONSTRAINT `programa_dialisis_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `proyecto`;
CREATE TABLE `proyecto` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `empresa_id` int(10) unsigned NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `ubicacion` varchar(64) NOT NULL,
  `municipio_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `empresa_id_idx` (`empresa_id`),
  KEY `municipio_id_idx` (`municipio_id`),
  CONSTRAINT `proyecto_empresa_id_empresa_id` FOREIGN KEY (`empresa_id`) REFERENCES `empresa` (`id`),
  CONSTRAINT `proyecto_municipio_id_municipio_id` FOREIGN KEY (`municipio_id`) REFERENCES `municipio` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `proyecto_concepto`;
CREATE TABLE `proyecto_concepto` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `proyecto_id` mediumint(8) unsigned NOT NULL,
  `concepto_id` smallint(5) unsigned NOT NULL,
  `presupuesto` int(10) unsigned NOT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `proyecto_id_idx` (`proyecto_id`),
  KEY `concepto_id_idx` (`concepto_id`),
  CONSTRAINT `proyecto_concepto_concepto_id_concepto_id` FOREIGN KEY (`concepto_id`) REFERENCES `concepto` (`id`),
  CONSTRAINT `proyecto_concepto_proyecto_id_proyecto_id` FOREIGN KEY (`proyecto_id`) REFERENCES `proyecto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `proyecto_transaccion`;
CREATE TABLE `proyecto_transaccion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `proyecto_id` mediumint(8) unsigned NOT NULL,
  `transaccion_id` int(10) unsigned NOT NULL,
  `concepto_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `proyecto_id_idx` (`proyecto_id`),
  KEY `transaccion_id_idx` (`transaccion_id`),
  KEY `concepto_id_idx` (`concepto_id`),
  CONSTRAINT `proyecto_transaccion_concepto_id_concepto_id` FOREIGN KEY (`concepto_id`) REFERENCES `concepto` (`id`),
  CONSTRAINT `proyecto_transaccion_proyecto_id_proyecto_id` FOREIGN KEY (`proyecto_id`) REFERENCES `proyecto` (`id`),
  CONSTRAINT `proyecto_transaccion_transaccion_id_articulo_id` FOREIGN KEY (`transaccion_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `proyecto_transaccion_transaccion_id_transaccion_id` FOREIGN KEY (`transaccion_id`) REFERENCES `transaccion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `psicologia`;
CREATE TABLE `psicologia` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `dependencia_padre` tinyint(1) DEFAULT NULL,
  `dependencia_madre` tinyint(1) DEFAULT NULL,
  `dependencia_hermanos` tinyint(1) DEFAULT NULL,
  `dependencia_hijos` tinyint(1) DEFAULT NULL,
  `dependencia_nietos` tinyint(1) DEFAULT NULL,
  `dependencia_otros` tinyint(1) DEFAULT NULL,
  `cual_dependencia` varchar(100) DEFAULT NULL,
  `figura_autoridad` tinyint(1) DEFAULT NULL,
  `cual_figura_autoridad` varchar(100) DEFAULT NULL,
  `intrafamiliares_padre` tinyint(1) DEFAULT NULL,
  `intrafamiliares_madre` tinyint(1) DEFAULT NULL,
  `intrafamiliares_conyuge` tinyint(1) DEFAULT NULL,
  `intrafamiliares_hijos` tinyint(1) DEFAULT NULL,
  `intrafamiliares_nietos` tinyint(1) DEFAULT NULL,
  `intrafamiliares_otros` tinyint(1) DEFAULT NULL,
  `familiar_padre` tinyint(1) DEFAULT NULL,
  `familiar_madre` tinyint(1) DEFAULT NULL,
  `familiar_conyuge` tinyint(1) DEFAULT NULL,
  `familiar_hijos` tinyint(1) DEFAULT NULL,
  `familiar_nietos` tinyint(1) DEFAULT NULL,
  `familiar_otros` tinyint(1) DEFAULT NULL,
  `familiar_nombre` text,
  `familiar_parentesco` text,
  `familiar_edad` int(11) DEFAULT NULL,
  `familiar_estado_civil` tinyint(1) DEFAULT NULL,
  `familiar_convive` tinyint(1) DEFAULT NULL,
  `familiar_estudio` tinyint(1) DEFAULT NULL,
  `familiar_ocupacion` text,
  `familiar_empresa` text,
  `familiar_ingreso` int(11) DEFAULT NULL,
  `familiar_nombre_uno` text,
  `familiar_parentesco_uno` text,
  `familiar_edad_uno` int(11) DEFAULT NULL,
  `familiar_estado_civil_uno` tinyint(1) DEFAULT NULL,
  `familiar_convive_uno` tinyint(1) DEFAULT NULL,
  `familiar_estudio_uno` tinyint(1) DEFAULT NULL,
  `familiar_ocupacion_uno` text,
  `familiar_empresa_uno` text,
  `familiar_ingreso_uno` int(11) DEFAULT NULL,
  `conviviente_compania` tinyint(1) DEFAULT NULL,
  `conviviente_conyugue` int(11) DEFAULT NULL,
  `conviviente_hijos` int(11) DEFAULT NULL,
  `conviviente_padres` int(11) DEFAULT NULL,
  `conviviente_nietos` int(11) DEFAULT NULL,
  `conviviente_otros_familiares` int(11) DEFAULT NULL,
  `barrio_emergencia` tinyint(4) DEFAULT NULL,
  `alcantarillado` tinyint(4) DEFAULT NULL,
  `agua` tinyint(4) DEFAULT NULL,
  `comparte_habitacion` tinyint(4) DEFAULT NULL,
  `gas` tinyint(4) DEFAULT NULL,
  `luz` tinyint(4) DEFAULT NULL,
  `cocina_lena` tinyint(4) DEFAULT NULL,
  `mascota` tinyint(4) DEFAULT NULL,
  `otros` tinyint(4) DEFAULT NULL,
  `vivienda` int(11) NOT NULL,
  `ducharse` tinyint(4) NOT NULL,
  `caminar_solo` tinyint(4) NOT NULL,
  `vestirse` tinyint(4) NOT NULL,
  `comer` tinyint(4) NOT NULL,
  `otros_diarios` tinyint(4) NOT NULL,
  `trabajo_habitual` tinyint(4) NOT NULL,
  `quehaceres_domesticos` tinyint(4) NOT NULL,
  `actividades_livianas` tinyint(4) NOT NULL,
  `hacer_compras` tinyint(4) NOT NULL,
  `actividades_recreativas` tinyint(4) NOT NULL,
  `medicarse` tinyint(4) NOT NULL,
  `otros_instrumentales` int(11) NOT NULL,
  `relacion_unidad` tinyint(1) DEFAULT NULL,
  `relacion_apoyo` tinyint(1) DEFAULT NULL,
  `relacion_independencia` tinyint(1) DEFAULT NULL,
  `relacion_conflicto` tinyint(1) DEFAULT NULL,
  `relacion_estabilidad` tinyint(1) DEFAULT NULL,
  `relacion_colaboracion` tinyint(1) DEFAULT NULL,
  `relacion_lejana` tinyint(1) DEFAULT NULL,
  `comunicacion_abierta_dinamica` tinyint(1) DEFAULT NULL,
  `comunicacion_respetuosa` tinyint(1) DEFAULT NULL,
  `comunicacion_falta_respeto` tinyint(1) DEFAULT NULL,
  `comunicacion_decisiones_consenso` tinyint(1) DEFAULT NULL,
  `comunicacion_no_hay` tinyint(1) DEFAULT NULL,
  `animo_depresion` tinyint(1) DEFAULT NULL,
  `animo_alegria` tinyint(1) DEFAULT NULL,
  `animo_tristeza` tinyint(1) DEFAULT NULL,
  `animo_melancolia` tinyint(1) DEFAULT NULL,
  `animo_euforia` tinyint(1) DEFAULT NULL,
  `animo_neutro` tinyint(1) DEFAULT NULL,
  `animo_estres` tinyint(1) DEFAULT NULL,
  `animo_insomnio` tinyint(1) DEFAULT NULL,
  `animo_preocupado` tinyint(1) DEFAULT NULL,
  `animo_letargo` tinyint(1) DEFAULT NULL,
  `proyecto_vida` varchar(100) DEFAULT NULL,
  `hobbies` varchar(100) DEFAULT NULL,
  `tiempo_libre` varchar(100) DEFAULT NULL,
  `cuantos_integrantes` int(11) DEFAULT NULL,
  `cuantos_trabajan` int(11) DEFAULT NULL,
  `cuantos_desempleados` int(11) DEFAULT NULL,
  `cuantos_escolar` int(11) DEFAULT NULL,
  `cuantos_ancianos` int(11) DEFAULT NULL,
  `cuantos_pensionados` int(11) DEFAULT NULL,
  `valores` text,
  `imagen_paciente` text,
  `pregunta_proyecta_superar` text,
  `pregunta_impacto_personal` text,
  `pregunta_impacto_familiar` text,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  CONSTRAINT `psicologia_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `punto_venta`;
CREATE TABLE `punto_venta` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(63) DEFAULT NULL,
  `direccion` varchar(63) DEFAULT NULL,
  `telefono_uno` varchar(63) DEFAULT NULL,
  `telefono_dos` varchar(63) DEFAULT NULL,
  `municipio_id` int(11) NOT NULL,
  `resolucion_id` int(10) unsigned NOT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `municipio_id_idx` (`municipio_id`),
  KEY `resolucion_id_idx` (`resolucion_id`),
  CONSTRAINT `punto_venta_municipio_id_municipio_id` FOREIGN KEY (`municipio_id`) REFERENCES `municipio` (`id`),
  CONSTRAINT `punto_venta_resolucion_id_resolucion_id` FOREIGN KEY (`resolucion_id`) REFERENCES `resolucion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `remision`;
CREATE TABLE `remision` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned NOT NULL,
  `servicio_remision_id` int(10) unsigned NOT NULL,
  `codigo` varchar(15) DEFAULT NULL,
  `justificacion` text NOT NULL,
  `responsable_tipo_documento` varchar(2) DEFAULT NULL,
  `responsable_numero_documento` int(20) DEFAULT NULL,
  `responsable_nombre` text,
  `responsable_apellido` text,
  `responsable_fecha_nacimiento` date DEFAULT NULL,
  `responsable_direccion` text,
  `responsable_telefono` int(15) DEFAULT NULL,
  `responsable_municipio_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `historia_id_idx` (`historia_id`),
  KEY `servicio_remision_id_idx` (`servicio_remision_id`),
  KEY `remision_responsable_municipio_id_municipio_id` (`responsable_municipio_id`),
  CONSTRAINT `remision_historia_id_historia_id` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`),
  CONSTRAINT `remision_responsable_municipio_id_municipio_id` FOREIGN KEY (`responsable_municipio_id`) REFERENCES `municipio` (`id`),
  CONSTRAINT `remision_servicio_remision_id_servicio_remision_id` FOREIGN KEY (`servicio_remision_id`) REFERENCES `servicio_remision` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `resolucion`;
CREATE TABLE `resolucion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `numero` bigint(20) unsigned NOT NULL,
  `fecha` date NOT NULL,
  `prefijo` varchar(6) NOT NULL,
  `numero_inicial` int(10) unsigned NOT NULL,
  `numero_final` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `resultado`;
CREATE TABLE `resultado` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(35) NOT NULL,
  `tipo` tinyint(4) NOT NULL,
  `categoria` tinyint(4) NOT NULL,
  `unidad` varchar(15) NOT NULL,
  `campo_inicial_resolucion_4505` tinyint(4) DEFAULT NULL,
  `campo_resultado_resolucion_4505` tinyint(4) DEFAULT NULL,
  `campo_resultado_resolucion_2463` tinyint(4) DEFAULT NULL,
  `grafico` tinyint(1) NOT NULL,
  `valor_maximo` decimal(10,2) DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  `valor_normal_minimo` decimal(10,2) DEFAULT NULL,
  `valor_normal_maximo` decimal(10,2) DEFAULT NULL,
  `valor_minimo` decimal(10,2) DEFAULT NULL,
  `cups_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `resultados_laboratorios`;
CREATE TABLE `resultados_laboratorios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cod_entidad` int(10) NOT NULL,
  `nom_entidad` varchar(255) NOT NULL,
  `tipo_documento` varchar(255) NOT NULL,
  `num_documento` varchar(15) NOT NULL,
  `nombre_paciente` varchar(255) NOT NULL,
  `resultado_id` int(10) NOT NULL,
  `cod_cups` varchar(255) NOT NULL,
  `resultado` text NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `estado` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `resultado_cups`;
CREATE TABLE `resultado_cups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `resultado_id` int(10) unsigned NOT NULL,
  `cups_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `resultado_id` (`resultado_id`),
  KEY `cups_id` (`cups_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `sede`;
CREATE TABLE `sede` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(64) NOT NULL,
  `direccion` varchar(32) NOT NULL,
  `municipio_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `municipio_id_idx` (`municipio_id`),
  CONSTRAINT `sede_municipio_id_municipio_id` FOREIGN KEY (`municipio_id`) REFERENCES `municipio` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `seguimiento_paciente`;
CREATE TABLE `seguimiento_paciente` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) unsigned NOT NULL,
  `prestador_id` int(11) unsigned NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `fecha_seguimiento` date DEFAULT NULL,
  `factores_riesgo_seguimiento` tinyint(4) DEFAULT NULL,
  `especialidad_seguimiento` tinyint(4) DEFAULT NULL,
  `tipo_seguimiento` tinyint(4) DEFAULT NULL,
  `inasistencia_seguimiento` tinyint(4) DEFAULT NULL,
  `comunicacion_seguimiento` tinyint(4) DEFAULT NULL,
  `motivo_fallida_seguimiento` tinyint(4) DEFAULT NULL,
  `gestion_seguimiento` text,
  `educacion_seguimiento` int(2) DEFAULT NULL,
  `observacion_educacion` text,
  `compromiso_seguimiento` int(2) DEFAULT NULL,
  `observacion_compromiso` text,
  `fuera_meta_seguimiento` int(2) DEFAULT NULL,
  `otro_plan` text,
  `plan` int(11) DEFAULT NULL,
  `hospitalizado_seguimiento` text,
  `referencia_seguimiento` text,
  PRIMARY KEY (`id`),
  KEY `seguimiento_paciente_paciente_id_paciente_id` (`paciente_id`),
  KEY `seguimiento_paciente_prestador_id_prestador_id` (`prestador_id`),
  KEY `seguimiento_paciente_personal_user_id_personal_user_id` (`personal_user_id`),
  CONSTRAINT `seguimiento_paciente_paciente_id_paciente_id` FOREIGN KEY (`paciente_id`) REFERENCES `paciente` (`id`),
  CONSTRAINT `seguimiento_paciente_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `seguimiento_paciente_prestador_id_prestador_id` FOREIGN KEY (`prestador_id`) REFERENCES `prestador` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `servicio`;
CREATE TABLE `servicio` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` text NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `servicio_remision`;
CREATE TABLE `servicio_remision` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` text NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `sf_guard_forgot_password`;
CREATE TABLE `sf_guard_forgot_password` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `unique_key` varchar(255) DEFAULT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`),
  CONSTRAINT `sf_guard_forgot_password_user_id_sf_guard_user_id` FOREIGN KEY (`user_id`) REFERENCES `sf_guard_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `sf_guard_group`;
CREATE TABLE `sf_guard_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `sf_guard_group_permission`;
CREATE TABLE `sf_guard_group_permission` (
  `group_id` bigint(20) NOT NULL DEFAULT '0',
  `permission_id` bigint(20) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`group_id`,`permission_id`),
  KEY `sf_guard_group_permission_permission_id_sf_guard_permission_id` (`permission_id`),
  CONSTRAINT `sf_guard_group_permission_group_id_sf_guard_group_id` FOREIGN KEY (`group_id`) REFERENCES `sf_guard_group` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sf_guard_group_permission_permission_id_sf_guard_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `sf_guard_permission` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `sf_guard_permission`;
CREATE TABLE `sf_guard_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `sf_guard_remember_key`;
CREATE TABLE `sf_guard_remember_key` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `remember_key` varchar(32) DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`),
  CONSTRAINT `sf_guard_remember_key_user_id_sf_guard_user_id` FOREIGN KEY (`user_id`) REFERENCES `sf_guard_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `sf_guard_user`;
CREATE TABLE `sf_guard_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email_address` varchar(255) NOT NULL,
  `username` varchar(128) NOT NULL,
  `algorithm` varchar(128) NOT NULL DEFAULT 'sha1',
  `salt` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `is_super_admin` tinyint(1) DEFAULT '0',
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_address` (`email_address`),
  UNIQUE KEY `username` (`username`),
  KEY `is_active_idx_idx` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `sf_guard_user_group`;
CREATE TABLE `sf_guard_user_group` (
  `user_id` bigint(20) NOT NULL DEFAULT '0',
  `group_id` bigint(20) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`user_id`,`group_id`),
  KEY `sf_guard_user_group_group_id_sf_guard_group_id` (`group_id`),
  CONSTRAINT `sf_guard_user_group_group_id_sf_guard_group_id` FOREIGN KEY (`group_id`) REFERENCES `sf_guard_group` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sf_guard_user_group_user_id_sf_guard_user_id` FOREIGN KEY (`user_id`) REFERENCES `sf_guard_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `sf_guard_user_permission`;
CREATE TABLE `sf_guard_user_permission` (
  `user_id` bigint(20) NOT NULL DEFAULT '0',
  `permission_id` bigint(20) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`user_id`,`permission_id`),
  KEY `sf_guard_user_permission_permission_id_sf_guard_permission_id` (`permission_id`),
  CONSTRAINT `sf_guard_user_permission_permission_id_sf_guard_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `sf_guard_permission` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sf_guard_user_permission_user_id_sf_guard_user_id` FOREIGN KEY (`user_id`) REFERENCES `sf_guard_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `signos_vitales_dialisis`;
CREATE TABLE `signos_vitales_dialisis` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `historia_id` int(10) unsigned DEFAULT NULL,
  `tension_arterial_ingreso` varchar(7) DEFAULT NULL,
  `frecuencia_cardiaca_ingreso` smallint(6) DEFAULT NULL,
  `frecuencia_respiratoria_ingreso` smallint(6) DEFAULT NULL,
  `temperatura_ingreso` smallint(6) DEFAULT NULL,
  `peso_ingreso` double(18,2) DEFAULT NULL,
  `ultrafiltracion` double(18,2) DEFAULT NULL,
  `tension_arterial_egreso` varchar(7) DEFAULT NULL,
  `frecuencia_cardiaca_egreso` smallint(6) DEFAULT NULL,
  `frecuencia_respiratoria_egreso` smallint(6) DEFAULT NULL,
  `temperatura_egreso` smallint(6) DEFAULT NULL,
  `peso_egreso` double(18,2) DEFAULT NULL,
  `tension_arterial_durante_uno` varchar(7) DEFAULT NULL,
  `tension_arterial_durante_dos` varchar(7) DEFAULT NULL,
  `tension_arterial_durante_tres` varchar(7) DEFAULT NULL,
  `tension_arterial_durante_cuatro` varchar(7) DEFAULT NULL,
  `tension_arterial_durante_cinco` varchar(7) DEFAULT NULL,
  `tension_arterial_durante_seis` varchar(7) DEFAULT NULL,
  `tension_arterial_durante_siete` varchar(7) DEFAULT NULL,
  `tension_arterial_durante_ocho` varchar(7) DEFAULT NULL,
  `fecha_tensiones` date DEFAULT NULL,
  `hora_tension_uno` time DEFAULT NULL,
  `hora_tension_dos` time DEFAULT NULL,
  `hora_tension_tres` time DEFAULT NULL,
  `hora_tension_cuatro` time DEFAULT NULL,
  `hora_tension_cinco` time DEFAULT NULL,
  `hora_tension_seis` time DEFAULT NULL,
  `hora_tension_siete` time DEFAULT NULL,
  `hora_tension_ocho` time DEFAULT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `historia_id_idx` (`historia_id`),
  CONSTRAINT `signos_vitales_dialisis_ibfk_2` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `signos_vitales_dialisis_ibfk_3` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `solicitud_referencia`;
CREATE TABLE `solicitud_referencia` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sede_id` int(10) unsigned NOT NULL,
  `entidad_id` int(10) unsigned NOT NULL,
  `especialidad_id` int(10) unsigned NOT NULL,
  `tipo_documento` varchar(3) NOT NULL,
  `numero_documento` varchar(12) NOT NULL,
  `nombres` varchar(127) NOT NULL,
  `apellidos` varchar(127) NOT NULL,
  `genero` tinyint(4) NOT NULL,
  `telefono` bigint(20) DEFAULT NULL,
  `celular` bigint(20) DEFAULT NULL,
  `observaciones` text,
  `fecha_registro` datetime NOT NULL,
  `gestion_observaciones` text,
  `personal_user_id` int(11) DEFAULT NULL,
  `fecha_gestion` datetime DEFAULT NULL,
  `estado` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sede_id_idx` (`sede_id`),
  KEY `entidad_id_idx` (`entidad_id`),
  KEY `especialidad_id_idx` (`especialidad_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `solicitud_referencia_entidad_id_entidad_id` FOREIGN KEY (`entidad_id`) REFERENCES `entidad` (`id`),
  CONSTRAINT `solicitud_referencia_especialidad_id_especialidad_id` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidad` (`id`),
  CONSTRAINT `solicitud_referencia_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `solicitud_referencia_sede_id_sede_id` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `sub_categoria`;
CREATE TABLE `sub_categoria` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `categoria_id` smallint(5) unsigned NOT NULL,
  `descripcion` varchar(32) NOT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `categoria_id_idx` (`categoria_id`),
  CONSTRAINT `sub_categoria_categoria_id_categoria_id` FOREIGN KEY (`categoria_id`) REFERENCES `categoria` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tarifario`;
CREATE TABLE `tarifario` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` text,
  `clasificacion` varchar(12) NOT NULL,
  `estado` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tercero`;
CREATE TABLE `tercero` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_documento` varchar(3) NOT NULL,
  `numero_documento` varchar(12) NOT NULL,
  `nombres` varchar(255) NOT NULL,
  `telefono` varchar(10) DEFAULT NULL,
  `telefono_dos` varchar(10) DEFAULT NULL,
  `celular` varchar(10) DEFAULT NULL,
  `celular_dos` varchar(10) DEFAULT NULL,
  `direccion` varchar(127) NOT NULL,
  `nombre_contacto` varchar(192) DEFAULT NULL,
  `representante_legal` varchar(192) DEFAULT NULL,
  `representante_legal_tipo_documento` varchar(2) DEFAULT NULL,
  `representante_legal_numero_documento` varchar(15) DEFAULT NULL,
  `municipio_id` int(11) NOT NULL,
  `correo_electronico` varchar(192) NOT NULL,
  `proveedor` tinyint(1) DEFAULT NULL,
  `cliente` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `municipio_id_idx` (`municipio_id`),
  CONSTRAINT `tercero_municipio_id_municipio_id` FOREIGN KEY (`municipio_id`) REFERENCES `municipio` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tipo_articulo`;
CREATE TABLE `tipo_articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(192) NOT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tipo_transaccion`;
CREATE TABLE `tipo_transaccion` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(120) NOT NULL,
  `tipo` tinyint(3) unsigned DEFAULT NULL,
  `tipo_calculo_precio` tinyint(3) unsigned DEFAULT NULL,
  `activa` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tipo_venta`;
CREATE TABLE `tipo_venta` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(63) DEFAULT NULL,
  `activa` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `transaccion`;
CREATE TABLE `transaccion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bodega_id` smallint(5) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `tipo_transaccion_id` smallint(5) unsigned NOT NULL,
  `precio_unitario` float(18,2) NOT NULL,
  `cantidad` float(18,2) NOT NULL,
  `observaciones` varchar(191) NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bodega_id_idx` (`bodega_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  KEY `tipo_transaccion_id_idx` (`tipo_transaccion_id`),
  CONSTRAINT `transaccion_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `transaccion_bodega_id_bodega_id` FOREIGN KEY (`bodega_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `transaccion_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`),
  CONSTRAINT `transaccion_tipo_transaccion_id_tipo_transaccion_id` FOREIGN KEY (`tipo_transaccion_id`) REFERENCES `tipo_transaccion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `transaccion_contable`;
CREATE TABLE `transaccion_contable` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cuenta_id` int(10) unsigned NOT NULL,
  `tipo_id` tinyint(3) unsigned NOT NULL,
  `valor` float(18,2) NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cuenta_id_idx` (`cuenta_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `transaccion_contable_cuenta_id_cuenta_id` FOREIGN KEY (`cuenta_id`) REFERENCES `cuenta` (`id`),
  CONSTRAINT `transaccion_contable_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `traslado`;
CREATE TABLE `traslado` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bodega_origen_id` smallint(5) unsigned NOT NULL,
  `bodega_destino_id` smallint(5) unsigned NOT NULL,
  `personal_user_id` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bodega_origen_id_idx` (`bodega_origen_id`),
  KEY `bodega_destino_id_idx` (`bodega_destino_id`),
  KEY `personal_user_id_idx` (`personal_user_id`),
  CONSTRAINT `traslado_bodega_destino_id_bodega_id` FOREIGN KEY (`bodega_destino_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `traslado_bodega_origen_id_bodega_id` FOREIGN KEY (`bodega_origen_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `traslado_personal_user_id_personal_user_id` FOREIGN KEY (`personal_user_id`) REFERENCES `personal` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `traslado_articulo`;
CREATE TABLE `traslado_articulo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `traslado_id` int(10) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) DEFAULT NULL,
  `transaccion_origen_id` int(10) unsigned NOT NULL,
  `transaccion_destino_id` int(10) unsigned NOT NULL,
  `anular` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `transaccion_origen_id_idx` (`transaccion_origen_id`),
  KEY `transaccion_destino_id_idx` (`transaccion_destino_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  KEY `traslado_id_idx` (`traslado_id`),
  CONSTRAINT `traslado_articulo_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `traslado_articulo_transaccion_destino_id_transaccion_id` FOREIGN KEY (`transaccion_destino_id`) REFERENCES `transaccion` (`id`),
  CONSTRAINT `traslado_articulo_transaccion_origen_id_transaccion_id` FOREIGN KEY (`transaccion_origen_id`) REFERENCES `transaccion` (`id`),
  CONSTRAINT `traslado_articulo_traslado_id_traslado_id` FOREIGN KEY (`traslado_id`) REFERENCES `traslado` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `traslado_bodega`;
CREATE TABLE `traslado_bodega` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bodega_origen_id` smallint(5) unsigned NOT NULL,
  `bodega_destino_id` smallint(5) unsigned NOT NULL,
  `articulo_id` int(10) unsigned NOT NULL,
  `cantidad` float(18,2) DEFAULT NULL,
  `transaccion_origen_id` int(10) unsigned NOT NULL,
  `transaccion_destino_id` int(10) unsigned NOT NULL,
  `fecha_registro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bodega_origen_id_idx` (`bodega_origen_id`),
  KEY `bodega_destino_id_idx` (`bodega_destino_id`),
  KEY `transaccion_origen_id_idx` (`transaccion_origen_id`),
  KEY `transaccion_destino_id_idx` (`transaccion_destino_id`),
  KEY `articulo_id_idx` (`articulo_id`),
  CONSTRAINT `traslado_bodega_articulo_id_articulo_id` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`),
  CONSTRAINT `traslado_bodega_bodega_destino_id_bodega_id` FOREIGN KEY (`bodega_destino_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `traslado_bodega_bodega_origen_id_bodega_id` FOREIGN KEY (`bodega_origen_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `traslado_bodega_transaccion_destino_id_transaccion_id` FOREIGN KEY (`transaccion_destino_id`) REFERENCES `transaccion` (`id`),
  CONSTRAINT `traslado_bodega_transaccion_origen_id_transaccion_id` FOREIGN KEY (`transaccion_origen_id`) REFERENCES `transaccion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `triage`;
CREATE TABLE `triage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(32) NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `unidad`;
CREATE TABLE `unidad` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(192) NOT NULL,
  `abreviatura` varchar(4) NOT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `valora_riesgo`;
CREATE TABLE `valora_riesgo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `numero_documento` varchar(12) NOT NULL,
  `edad` smallint(5) unsigned NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` tinyint(3) unsigned NOT NULL,
  `peso` decimal(5,2) NOT NULL,
  `estatura` smallint(5) unsigned NOT NULL,
  `perimetro_abdominal` smallint(5) unsigned NOT NULL,
  `actividad_fisica` tinyint(3) unsigned NOT NULL,
  `come_frutas_verduras` tinyint(3) unsigned NOT NULL,
  `receta_medicamentos_hipertension` tinyint(3) unsigned NOT NULL,
  `glucosa_alta_anteriormente` tinyint(3) unsigned NOT NULL,
  `diabetes_familiar` tinyint(3) unsigned NOT NULL,
  `diabetico` tinyint(3) unsigned NOT NULL,
  `dato_colesterol_total` tinyint(3) unsigned NOT NULL,
  `colesterol_total` decimal(5,2) DEFAULT NULL,
  `colesterol_hdl` decimal(5,2) DEFAULT NULL,
  `consume_algun_derivado_tabaco` tinyint(3) unsigned NOT NULL,
  `tension_arterial` smallint(5) unsigned NOT NULL,
  `fecha_registro` datetime DEFAULT NULL,
  `test_findrisk` smallint(5) unsigned NOT NULL,
  `test_framingham` smallint(5) unsigned NOT NULL,
  `resultado_estado_nutricional` varchar(31) DEFAULT NULL,
  `resultado_abdominal` varchar(31) NOT NULL,
  `resultado_riesgo_cardiovascular` smallint(5) unsigned NOT NULL,
  `resultado_riesgo_diabetes` smallint(5) NOT NULL,
  `desistimiento_terapia_dialitica` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `via`;
CREATE TABLE `via` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` text,
  `activo` tinyint(1) NOT NULL,
  `remision` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- 2023-06-13 16:21:57