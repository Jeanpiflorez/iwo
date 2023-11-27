<?php
//error_reporting(0);
//Funciónes para conectarse a las bases de datos de iwo, renal y nesys ****************************************

function conectarbd(){
    $host = "localhost";
    $dbuser = "root";
    $password = "";
    $dbname = "dbiwomigration";
    $port = 3306;
    try {
        $dsn = "mysql:host=$host;port=$port;dbname=$dbname;charset=utf8";
        $conexion = new PDO($dsn, $dbuser, $password);
        $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $conexion;
    } catch (PDOException $e) {
        // Registrar el error en un archivo de registro o notificarlo de manera segura
        // en lugar de mostrarlo en pantalla.
        error_log("Error en la conexión a la base de datos: " . $e->getMessage());
        // Lanzar una excepción personalizada o retornar un valor que indique un error.
        throw new Exception("Error en la conexión a la base de datos.");
    }
}

function conectarBdOrigen($migracion){
    $conexpro = conectarbd();
    $migracion = $conexpro->quote($migracion);
    $query = "SELECT host, puerto, nombre_Db, nombre_Usuario, contraseña FROM  tbldatosorigen WHERE Nombre_Migracion = $migracion";
    $statement = $conexpro->query($query);
    $result = $statement->fetch(PDO::FETCH_ASSOC);
    $host = $result['host'];
    $dbuser = $result['nombre_Usuario'];
    $password = $result['contraseña'];
    $dbname = $result['nombre_Db'];
    $port = $result['puerto'];
    try {
        $dsn = "mysql:host=$host;port=$port;dbname=$dbname;charset=utf8";
        $conexionOrigen = new PDO($dsn, $dbuser, $password);
        $conexionOrigen->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $conexionOrigen;
    } catch (PDOException $e) {
        // Registrar el error en un archivo de registro o notificarlo de manera segura
        // en lugar de mostrarlo en pantalla.
        error_log("Error en la conexión a la base de datos: " . $e->getMessage());
        // Lanzar una excepción personalizada o retornar un valor que indique un error.
        throw new Exception("Error en la conexión a la base de datos.");
    }
}

function conectarBdDestino($migracion){
    $conexpro = conectarbd();
    $migracion = $conexpro->quote($migracion);
    $query = "SELECT host, puerto, nombre_Db, nombre_Usuario, contraseña FROM  tbldatosdestino WHERE Nombre_Migracion = $migracion";
    $statement = $conexpro->query($query);
    $result = $statement->fetch(PDO::FETCH_ASSOC);
    $host = $result['host'];
    $dbuser = $result['nombre_Usuario'];
    $password = $result['contraseña'];
    $dbname = $result['nombre_Db'];
    $port = $result['puerto'];
    try {
        $dsn = "mysql:host=$host;port=$port;dbname=$dbname;charset=utf8";
        $conexionDestino = new PDO($dsn, $dbuser, $password);
        $conexionDestino->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $conexionDestino;
    } catch (PDOException $e) {
        // Registrar el error en un archivo de registro o notificarlo de manera segura
        // en lugar de mostrarlo en pantalla.
        error_log("Error en la conexión a la base de datos: " . $e->getMessage());
        // Lanzar una excepción personalizada o retornar un valor que indique un error.
        throw new Exception("Error en la conexión a la base de datos.");
    }
}

/******************************************************* END CONECTION *******************************************/

if(isset($_POST['action'])){
    $action = $_POST['action'];
    switch($action){
/* ------ PARAMETROS GENERALES PARA FUNCIONAMIENTO APLICACIÓN IWO ---------- */
        case 'confirm':
            $mensaje = confirm();
            break;
        case 'guardatos':
            $mensaje = guardatos();
            break;
        case 'fillSelected':
            $mensaje = selected();
            break;

/* -------------------- TABLAS 1er NIVEL ---------------------------------- */

        case 'antecedente_especial':
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, CASE WHEN activo = 0 THEN 2 ELSE activo END AS activo FROM antecedente",
                "queryDes" => "antecedente_especial (id, descripcion, estado)",
                "tableName"=> "antecedente_especial"
            );
            $mensaje =  processMigration($datosArreglo);
            break;

        case "bodega":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, ubicacion, 'No hay descripción' AS activa FROM bodega",
                "queryDes" => "bodega (id, nombre, direccion, descripcion)",
                "tableName"=> "bodega",
            );
            $mensaje =  processMigration($datosArreglo);
            break;

        case "categoria":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, activo FROM categoria",
                "queryDes" => "categoria (id, descripcion, nombre)",
                "tableName"=> "categoria",
                //revisar la logica de estas tablas en la parte de nombre
            );
            $mensaje =  processMigration($datosArreglo);
            break;

/* Seguir el siguiente case en caso de que alguna otra tabla
necesite que se ingrese registros */

        case "cobertura":
            $addrecords = addRecords();
            if($addrecords){
                $mensaje1 = "Se agregaron los registros exitosamente". PHP_EOL;
            }else{
                $mensaje1 = "Hubo un error al insertar los datos " . PHP_EOL;
                $mensaje = $mensaje1;
                return $mensaje;
            }
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion FROM cobertura",
                "queryDes" => "cobertura (id, descripcion)",
                "tableName"=> "cobertura",
            );
            $mensaje2 =  processMigration($datosArreglo);
            $deleteRecords = deleteRecords();
            if($deleteRecords){
                $mensaje3 = "Se eliminaron los registros exitosamente". PHP_EOL;
            }else{
                $mensaje3 = "Hubo un error al eliminar los registros insertados previamente " . PHP_EOL;
            }
            $mensaje  = $mensaje1 . " " . $mensaje2 . " " . $mensaje3;
            break;

        case "copago":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, valor, fecha_inicio, fecha_fin, '1' AS estado FROM copago",
                "queryDes" => "copago (id, descripcion, valor, fecha_inicio, fecha_fin, estado)",
                "tableName"=> "copago",
            );
            $mensaje =  processMigration($datosArreglo);
            break;

        case"departamento":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, id AS codigo FROM departamento",
                "queryDes" => "departamento (id, nombre, codigo)",
                "tableName" => "departamento"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        /* case"especialidad":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, CASE WHEN activo = 0 THEN 2 ELSE activo END AS activo FROM especialidad",
                "queryDes" => "especialidad (id, nombre, estado)",
                "tableName" => "especialidad"
            );
            $mensaje = processMigration($datosArreglo);
            break; */

        case"estadio": 
            $datosArreglo = array (
                "queryOri" =>"SELECT id, estadio, CASE WHEN activa = 0 THEN 2 ELSE activa END AS activa FROM estadio",
                "queryDes" => "estadio (id, nombre, estado)",
                "tableName" => "estadio"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "inatencion":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion FROM inatencion",
                "queryDes" => "inatencion (id, descripcion)",
                "tableName" => "inatencion"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"insumo":
            $datosArreglo = array (
                "queryOri" =>"SELECT id, codigo, descripcion, CASE WHEN estado = 0 THEN 2 ELSE estado END AS estado FROM insumo",
                "queryDes" => "insumo (id, codigo, descripcion, estado)",
                "tableName" => "insumo"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"medicamento":
            $datosArreglo = array (
                "queryOri" =>"SELECT id, codigo, descripcion_codigo_atc, principio_activo, concentracion, forma_farmaceutica, indicaciones, efecto_esperado, efecto_secundario, efectos_adversos, pos, 'insulina', CASE WHEN activo = 0 THEN 2 ELSE activo END AS activo FROM medicamento",
                "queryDes" =>"medicamento (id, codigo, descripcion_codigo_atc, principio_activo, concentracion, forma_farmaceutica, indicaciones, efecto_esperado, efecto_secundario, efectos_adversos, pos, insulina, estado)",
                "tableName" => "medicamento"
                //preguntar por el campo insulina -> se retiro el campo cum,  presentacion_comercial, fabricante_importador, fecha_vencimiento,
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"motivo_cancelacion":
            $datosArreglo = array (
                "queryOri" =>"SELECT id, descripcion FROM cancelacion",
                "queryDes" => "motivo_cancelacion (id, descripcion)",
                "tableName" => "motivo_cancelacion"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"ocupacion":
            $datosArreglo = array (
                "queryOri" =>"SELECT id, descripcion FROM ocupacion",
                "queryDes" => "ocupacion (id, descripcion)",
                "tableName" => "ocupacion"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        /* case"permisos":
            $datosArreglo = array (
                "queryOri" =>"SELECT id, name, description, 'web' AS guard_name, created_at, updated_at FROM sf_guard_permission",
                "queryDes" => "permisos (id, nombre, descripcion, guard_name, created_at, updated_at)",
                "tableName" => "permisos"
            );
            $mensaje = processMigration($datosArreglo);
            break; */

        case "resolucion":
            $datosArreglo = array(
                "queryOri" => "SELECT id, numero, fecha, prefijo, numero_inicial, numero_final from resolucion",
                "queryDes" => "resolucion (id, numero, fecha, prefijo, numero_inicial, numero_final)",
                "tableName" => "resolucion"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "sede":
            $datosArreglo =array(
                "queryOri" => "SELECT id, nombre, direccion FROM sede",
                "queryDes" => "sede (id, nombre, descripcion)",
                "tableName" => "sede"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        /* case "servicio":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, CASE WHEN activo = 0 THEN 2 ELSE activo END AS activo FROM servicio",
                "queryDes" => "servicio (id, descripcion, estado)",
                "tableName" => "servicio"
            );
            $mensaje = processMigration($datosArreglo);
            break; */

        case "servicio_remision":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, CASE WHEN activo = 0 THEN 2 ELSE activo END AS activo FROM servicio_remision",
                "queryDes" => "servicio_remision (id, descripcion, estado)",
                "tableName" => "servicio_remision"
            );
            $mensaje = processMigration($datosArreglo);
            break;

            case "users":
                $datosArreglo = array(
                    "queryOri" => "SELECT s.id, p.nombre, s.email_address, '$2y$10\$MoC6NAZvSCoqeIvtLp2jfuR3Fxi/DwcD6aCOaNQLprfJ4yHVqetMG' AS password, s.created_at FROM sf_guard_user s JOIN personal p ON s.id = p.user_id",
                    "queryDes" => "users(id, name, email, password, created_at)",
                    "tableName" => "users"
                );
                $mensaje = processMigration($datosArreglo);
                break;
/* -------------------- TABLAS 2do NIVEL ---------------------------------- */

        case 'diagnostico'://Cambiar este case de posición
            $datosArreglo = [
                "queryOri" => "SELECT id, codigo, descripcion, if(genero = 0, 3, genero) AS genero, edad_inicio, edad_fin, patologia, grupo_mortalidad, capitulo, id_sugrupo, sivigila, CASE WHEN activa = 0 THEN 2 ELSE activa END AS activa, CASE WHEN tipo_edad_inicio = 0 THEN NULL ELSE tipo_edad_inicio END AS tipo_edad_inicio, CASE WHEN tipo_edad_fin = 0 THEN NULL ELSE tipo_edad_fin END AS tipo_edad_fin  FROM diagnostico",
                "queryDes" => "diagnostico (id, codigo, descripcion, genero_id, edad_inicio, edad_fin, patologia, grupo_mortalidad, capitulo, subgrupo_id, sivigila, estado, tiempo_edad_inicio_id, tiempo_edad_fin_id)",
                "tableName"=> "diagnostico"
            ];
            $mensaje =  processMigration($datosArreglo); 
            break;

        case"municipio":
            $datosArreglo = array(
                "queryOri" => "SELECT id, departamento_id, descripcion, codigo FROM municipio",
                "queryDes" => "municipio (id, departamento_id, nombre, codigo)",
                "tableName" => "municipio"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"programa":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, duracion_meses, cita_cada_cuando_en_meses, estadio_id, CASE WHEN activa = 0 THEN 2 ELSE activa END AS activa FROM programacion ",
                "queryDes" => "programa (id, descripcion, duracion_programa, cita_por_mes, estadio_id, estado)",
                "tableName" => "programa"
            );
            $mensaje = processMigration($datosArreglo);
            break;

            /* case "usuario_permiso":
                $datosArreglo = array(
                    "queryOri" => "SELECT  FROM sf_guard_user_permision",
                );
                $mensaje = processMigration($datosArreglo);
                break; */

        case "usuario_rol":
            $datosArreglo = array(
                "queryOri" => "SELECT user_id, 'App\Models\Usuario' AS model_type, CASE WHEN tipo IN (1, 2, 5, 7, 8, 9, 10, 11) THEN 2 WHEN tipo = 6 THEN 4 ELSE tipo END AS tipo FROM personal WHERE user_id IN (SELECT p.user_id FROM personal p LEFT JOIN sf_guard_user s ON p.user_id = s.id) AND tipo != 4",
                "queryDes" => "usuario_rol (usuario_id, model_type, rol_id)",
                "tableName" => "usuario_rol"
            );
            $mensaje = processMigration($datosArreglo);
            break;
/* -------------------- TABLAS 3er NIVEL ---------------------------------- */

        case"cups":
            $datosArreglo = array(
                "queryOri" => "SELECT id, codigo, descripcion, '3' AS genero, edad_inicio, edad_fin, archivo_rips, procedimiento, CASE WHEN tipo_procedimiento = 0 THEN NULL ELSE tipo_procedimiento END AS tipo_procedimiento, finalidad, pos, repetido, ambito, estancia, unico, CASE WHEN activo = 0 THEN 2 ELSE activo END AS activo, CASE WHEN tipo_edad_inicio = 0 THEN NULL ELSE tipo_edad_inicio END AS tipo_edad_inicio, CASE WHEN tipo_edad_fin = 0 THEN NULL ELSE tipo_edad_fin END AS tipo_edad_fin FROM cups",
                "queryDes" => "cups (id, codigo, descripcion, genero_id, edad_inicio, edad_fin, archivo_rips, procedimiento, tipo_procedimiento_id, finalidad, pos, repetidos, ambito, estancia, unico, estado, tiempo_inicio_id, tiempo_fin_id)",
                "tableName" => "cups",
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "entidad":
            $datosArreglo = array(
                "queryOri" => "SELECT id, codigo_eps, nit, nombre, tipo_contratacion, tiempo_cita, valor_consulta, requiere_autorizacion, cobertura_id, solicitud_por_referencia, CASE WHEN activa = 0 THEN 2 ELSE activa END AS activa, citas_internet_mes, 'logo.png' AS logo, codigo_ihospital, '0' AS telefono, '0' AS direccion FROM entidad",
                "queryDes"  => "entidad (id, codigo_eps, nit, nombre, tipo_contratacion_id, tiempo_cita, valor_consulta, requiere_autorizacion, cobertura_id, solicitud_referencia, estado, cita_internet_mes, logo, codigo_interface, telefono, direccion)",
                "tableName" => "entidad"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "paciente":
            $datosArreglo = array(
                "queryOri" => "SELECT id, 
                                        CASE 
                                            WHEN tipo_documento = 'CC' THEN 1
                                            WHEN tipo_documento = 'TI' THEN 2
                                            WHEN tipo_documento = 'RC' THEN 3
                                            WHEN tipo_documento = 'CE' THEN 4
                                            WHEN tipo_documento = 'PA' THEN 5
                                            WHEN tipo_documento = 'AS' THEN 6
                                            WHEN tipo_documento = 'MS' THEN 7
                                            WHEN tipo_documento = 'NV' THEN 8
                                            WHEN tipo_documento = 'SC' THEN 9
                                            WHEN tipo_documento = 'CD' THEN 10
                                            WHEN tipo_documento = 'PE' THEN 11
                                        END AS tipo_documento, numero_documento,
                                        SUBSTRING_INDEX(nombres, ' ', 1) AS primer_nombre,
                                        CASE 
                                            WHEN LENGTH(nombres) - LENGTH(REPLACE(nombres, ' ', '')) >= 1
                                            THEN SUBSTRING_INDEX(SUBSTRING_INDEX(nombres, ' ', -1), ' ', 1)
                                            ELSE NULL END AS segundo_nombre,
                                            SUBSTRING_INDEX(apellidos, ' ', 1) AS primer_apellido,
                                        CASE 
                                            WHEN LENGTH(apellidos) - LENGTH(REPLACE(apellidos, ' ', '')) >= 1
                                            THEN SUBSTRING_INDEX(SUBSTRING_INDEX(apellidos, ' ', -1), ' ', 1)
                                            ELSE NULL END AS segundo_apellido,  
                                        fecha_nacimiento, genero, CASE WHEN raza = 7 THEN 6 WHEN i = 8 THEN 6 ELSE raza END AS raza, condicion, municipio_id, ubicacion, estado_civil, codigo_nivel_educativo, direccion, 
                                        CASE 
                                            WHEN zona = 'U' THEN 1
                                            WHEN zona = 'R' THEN 2
                                        END AS zona, estrato, telefono, celular, correo_electronico, rh, estadio_id, acompanante_nombres, acompanante_apellidos, acompanante_telefono, ocupacion_id FROM paciente",
                "queryDes" => "paciente (id, tipo_documento_id, numero_documento, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, genero_id, etnia_id, condicion_id, municipio_id, ubicacion, estado_civil, codigo_nivel_educativo, direccion, zona, estrato, telefono, celular, correo_electronico, rh, estadio_id, acompañante_nombres, acompañante_apellidos, acompañante_telefono, ocupacion_id)",
                "tableName" => "paciente"
                //hay que pasar esta tabla por el procedimiento de separar el nombre.
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "plan":
            $datosArreglo = array (
                "queryOri" => "SELECT id, descripcion, tipo_contratacion, programacion_id, valor_paquete, monto_maximo, CASE WHEN activa = 0 THEN 2 ELSE activa END AS activa FROM plan",
                "queryDes" => "plan (id, descripcion, tipo_contratacion_id, programa_id, valor_paquete, monto_maximo, estado)",
                "tableName" => "plan"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "prestador":
            $datosArreglo = array(
                "queryOri" => "SELECT id,   CASE 
                                                WHEN tipo_documento = 'CC' THEN 1
                                                WHEN tipo_documento = 'TI' THEN 2
                                                WHEN tipo_documento = 'RC' THEN 3
                                                WHEN tipo_documento = 'CE' THEN 4
                                                WHEN tipo_documento = 'PA' THEN 5
                                                WHEN tipo_documento = 'AS' THEN 6
                                                WHEN tipo_documento = 'MS' THEN 7
                                                WHEN tipo_documento = 'NV' THEN 8
                                                WHEN tipo_documento = 'SC' THEN 9
                                                WHEN tipo_documento = 'CD' THEN 10
                                                WHEN tipo_documento = 'PE' THEN 11
                                                WHEN tipo_documento = 'NIT' THEN 12
                                            END AS tipo_documento, 
                                            numero_documento, codigo_habilitacion, nombre, direccion, cuenta_de_cobro, representante_legal, telefono, municipio_id, logo, CASE WHEN activa = 0 THEN 2 ELSE activa END AS activa, resolucion_id FROM prestador",
                "queryDes" => "prestador (id, tipo_documento_id, numero_documento, codigo_habilitacion, nombre, direccion, cuenta_de_cobro, representante_legal, telefono, municipio_id, logo, estado, resolucion_id)",
                "tableName" => "prestador"
            );
            $mensaje = processMigration($datosArreglo);
            break;
/* -------------------- TABLAS 4to NIVEL ---------------------------------- */

        case "entidad_prestador":
            $datosArreglo = array (
                "queryOri" => "SELECT id, prestador_id, entidad_id FROM prestador_entidad",
                "queryDes" => "entidad_prestador (id, prestador_id, entidad_id)",
                "tableName" => "entidad_prestador"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"historia":
            $datosArreglo = array(
                "queryOri" => "SELECT id, motivo_consulta, enfermedad_actual, causa_externa, analisis_y_conducta, conducta, recomendaciones, formula_medica, dias_incapacidad, fecha_incapacidad, orden_de_cirugia, orden_de_medicamentos, ordenes_medicas, solicitud_de_insumos, cockcroft_gault, test_findrisk, barthel, yesavage, folstein, mala_adherencia_tratamientos, desistimiento_terapia_dialitica, tension_arterial, frecuencia_cardiaca, frecuencia_respiratoria, temperatura, peso, talla, imc, perimetro_abdominal, cintura_pelvica, estadio_id, red_apoyo_familiar_social, factor_riesgo_cardiovascular, tipo_diabetes FROM historia",
                "queryDes" => "historia (id, motivo_consulta, enfermedad_actual, causa_externa_id, analisis_y_conducta, conducta, recomendaciones, recomendaciones_no_farmacologicas, dias_incapacidad, fecha_incapacidad, orden_cirugia, orden_medicamentos, ordenes_medicas, solicitud_insumos, tasa_filtracion, test_findrisk, indice_barthel, escala_yesavage, mmse_folstein, mala_adherencia, desistimiento_terapia_dialitica, tension_arterial, frecuencia_cardiaca, frecuencia_respiratoria, temperatura, peso, talla, imc, perimetro_abdominal, cintura_pelvica, estadio_id, red_apoyo, factor_riesgo_cardiovascular, tipo_diabetes)",
                "tableName" => "historia"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "laboratorio":
            $datosArreglo = array(
                "queryOri" => "SELECT id, nombre, tipo, categoria, unidad, grafico, valor_maximo, CASE WHEN activa = 0 THEN 2 ELSE activa END AS activa, valor_normal_minimo, valor_normal_maximo, valor_minimo, cups_id FROM resultado", 
                "queryDes" => "laboratorio (id, nombre, tipo_resultado, categoria, unidad, grafico, valor_maximo, estado, valor_normal_minimo, valor_normal_maximo, valor_minimo, cups_id)",
                "tableName" => "laboratorio"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "plan_cups":
            $datosArreglo = array(
                "queryOri" => "SELECT id, plan_id, cups_id, costo, precio, CASE WHEN activa = 0 THEN 2 ELSE activa END AS activa FROM plan_cups",
                "queryDes" => "plan_cups (id, plan_id, cups_id, costo, precio, estado)",
                "tableName" => "plan_cups"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "prestador_sede":
            $datosArreglo = array(
                "queryOri" => "SELECT id, prestador_id, sede_id FROM prestador_sede",
                "queryDes" => "prestador_sede (id, prestador_id, sede_id)",
                "tableName" => "prestador_sede"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "usuario":
            $datosArreglo = array(
                "queryOri" => "SELECT
                                    p.user_id,
                                    p.cargo,
                                    p.registro_medico,
                                    p.firma,
                                    p.cups_primera_id,
                                    p.cups_control_id, 
                                    p.nombre,
                                    s.email_address,
                                    s.username,
                                    '1' AS tipo_documento,
                                    '$2y$10\$MoC6NAZvSCoqeIvtLp2jfuR3Fxi/DwcD6aCOaNQLprfJ4yHVqetMG' AS password, 
                                    CASE WHEN is_active = 0 THEN 2 WHEN is_active IS NULL THEN 2 ELSE is_active END AS is_active,
                                    DATE(s.created_at) AS created_at,
                                    DATE(s.updated_at) AS updated_at,
                                    'html.png' AS foto,
                                    '0' AS telefono,
                                    '0' AS direccion,
                                    '0000-00-00' AS fecha_nacimiento,
                                    '3' AS genero_id
                                FROM personal p
                                LEFT JOIN
                                sf_guard_user s ON p.user_id = s.id",
                "queryDes" => "usuario (id, cargo, registro_medico, firma, cups_primero_id, cups_control_id,  email,  numero_documento, tipo_documento_id, password, estado, created_at, updated_at, foto, telefono, direccion, fecha_nacimiento, genero_id, nombres, apellidos)",
                "tableName" => "usuario"
            );
            $mensaje = processMigration($datosArreglo);
            break;
/* -------------------- TABLAS 5to NIVEL ---------------------------------- */

        case "admision":
            $datosArreglo = array(
                "queryOri" => "SELECT c.id, CASE WHEN c.prestador_id IS NULL THEN 1 ELSE c.prestador_id END AS prestador_id, c.entidad_id, c.personal_user_id, c.consultorio_id, 
                CASE
                    WHEN servicio_id IS NULL THEN 1
                    WHEN tipo_cita = 0 THEN 1
                    WHEN tipo_cita = 3 THEN 2
                    WHEN tipo_cita = 4 THEN 3
                    WHEN tipo_cita = 5 THEN 5
                    WHEN tipo_cita = 6 THEN 4
                    WHEN tipo_cita = 7 THEN 4
                    WHEN tipo_cita = 8 THEN 4
                    WHEN tipo_cita = 9 THEN 4
                    WHEN tipo_cita = 10 THEN 4
                    WHEN tipo_cita = 11 THEN 6
                    WHEN tipo_cita = 12 THEN 4
                    WHEN tipo_cita = 13 THEN 5
                ELSE servicio_id END AS servicio_id,
                c.paciente_id, 
                CASE
                    WHEN tipo_cita = 0 THEN 2
                    WHEN tipo_cita = 3 THEN 2
                    WHEN tipo_cita = 4 THEN 2
                    WHEN tipo_cita = 5 THEN 2
                    WHEN tipo_cita = 6 THEN 2
                    WHEN tipo_cita = 7 THEN 2
                    WHEN tipo_cita = 8 THEN 2
                    WHEN tipo_cita = 9 THEN 2
                    WHEN tipo_cita = 10 THEN 2
                    WHEN tipo_cita = 11 THEN 2
                    WHEN tipo_cita = 12 THEN 2
                    WHEN tipo_cita = 13 THEN 2
                ELSE tipo_cita END AS tipo_cita,
                c.fecha_solicitud, c.fecha, c.hora, c.autorizacion, c.estado, c.plan_id, c.copago_id, c.pago, c.valor_consulta, c.observacion, c.historia_id, c.fecha_registro, c.sede_id, c.regimen, 
                ( SELECT MAX(CASE 
                                WHEN especialidad_id = 19 THEN 1
                                WHEN especialidad_id = 7 THEN 2
                                WHEN especialidad_id = 8 THEN 3
                                WHEN especialidad_id = 5 THEN 6
                                WHEN especialidad_id = 13 THEN 7
                                WHEN especialidad_id = 24 THEN 8
                                WHEN especialidad_id = 28 THEN 9
                                WHEN especialidad_id = 29 THEN 12
                                WHEN especialidad_id = 26 THEN 13
                                WHEN especialidad_id = 27 THEN 14
                                WHEN especialidad_id = 4 THEN 15
                                WHEN especialidad_id = 10 THEN 16
                                WHEN especialidad_id = 11 THEN 17
                                WHEN especialidad_id = 15 THEN 18
                                WHEN especialidad_id = 16 THEN 19
                                WHEN especialidad_id = 17 THEN 20
                                WHEN especialidad_id = 18 THEN 21
                                WHEN especialidad_id = 20 THEN 22
                                WHEN especialidad_id = 21 THEN 23
                                WHEN especialidad_id = 25 THEN 24
                                ELSE especialidad_id
                            END) 
                FROM personal_especialidad p WHERE p.personal_user_id = c.personal_user_id ) AS especialidad_id FROM consulta c",
                "queryDes" => "admision (id, prestador_id, entidad_id, profesional_salud_id, consultorio, servicio_id, paciente_id, tipo_cita_id, fecha_deseada, fecha, hora_atencion, autorizacion, admision_estado_id , plan_id, copago_id, pago, valor_consulta, observacion, historia_id, fecha_registro, sede_id, cobertura_id, especialidad_id)",
                "tableName" => "admision"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "covid":
            $datosArreglo = array(
                "queryOri" => "SELECT id, covid19_pregunta_1, covid19_pregunta_2, covid19_pregunta_3, covid19_pregunta_4, covid19_sintoma_1, covid19_sintoma_2, covid19_sintoma_3, covid19_sintoma_4, covid19_sintoma_5, covid19_sintoma_6 FROM historia WHERE (covid19_pregunta_1 IS NOT NULL OR covid19_pregunta_2 IS NOT NULL OR covid19_pregunta_3 IS NOT NULL OR covid19_pregunta_4 IS NOT NULL OR covid19_sintoma_1 IS NOT NULL OR covid19_sintoma_2 IS NOT NULL OR covid19_sintoma_3 IS NOT NULL OR covid19_sintoma_4 IS NOT NULL OR covid19_sintoma_5 IS NOT NULL OR covid19_sintoma_6 IS NOT NULL) AND (covid19_pregunta_1 != 0 OR covid19_pregunta_2 != 0 OR covid19_pregunta_3 != 0 OR covid19_pregunta_4 != 0 OR covid19_sintoma_1 != 0 OR covid19_sintoma_2 != 0 OR covid19_sintoma_3 != 0 OR covid19_sintoma_4 != 0 OR covid19_sintoma_5 != 0 OR covid19_sintoma_6 != 0);",
                "queryDes"=> "covid (historia_id, fuera_pais, cerca_persona_covid, trabajador_salud, paciente_hospitalizado, fiebre, tos, dolor_garganta, fatiga, dificultad_respiratoria, ninguna_anterior)",
                "tableName"=>"covid"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_diagnostico":
            $datosArreglo2 = array(
                "tableName" => "historia_diagnostico"
            );
            $mensaje = processBucle($datosArreglo2);
            break;

        case "historia_examen_fisico":
            $datosArreglo2 = array (
                "tableName" => "historia_examen_fisico"
            );
            $mensaje = processBucle($datosArreglo2);
            break;

        case "factor_de_riesgo":
            $datosArreglo = array(
                "queryOri" => "SELECT tabaquismo, actividad_fisica, diabetes_familiar, come_frutas_verduras, receta_medicamentos_hipertension, glucosa_alta_anteriormente, glucometria_ayunas, id FROM historia WHERE tabaquismo IS NOT NULL OR actividad_fisica IS NOT NULL OR diabetes_familiar IS NOT NULL OR come_frutas_verduras IS NOT NULL OR receta_medicamentos_hipertension IS NOT NULL OR glucosa_alta_anteriormente IS NOT NULL OR glucometria_ayunas IS NOT NULL;",
                "queryDes" => "factor_de_riesgo(tabaquismo, actividad_fisica, diabetes_familiar, come_frutas_verduras, receta_medicamentos_hipertension, glucosa_alta_anteriormente, glucometria_ayunas, historia_id)",
                "tableName" => "factor_de_riesgo" 
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "factura":
            $datosArreglo = array(
                "queryOri" => "SELECT id, numero_factura, prestador_id, resolucion_id, concepto, valor, fecha_inicio, fecha_fin, personal_user_id, fecha_registro FROM factura",
                "queryDes" => "factura (id, numero_factura, prestador_id, resolucion_id, concepto, valor, fecha_inicio, fecha_fin, usuario_id, created_at)",
                "tableName" => "factura"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_antecedente":echo $action;
            $datosArreglo = array(
                "queryOri" => "SELECT id, historia_id, NULLIF(tipo, 0) AS tipo, fecha, CASE WHEN texto = ' ' THEN 'negativo' ELSE texto END AS texto, CASE WHEN activa = 0 THEN 2 ELSE activa END AS activa, ( SELECT paciente_id FROM consulta c WHERE c.historia_id = historia_antecedentes.historia_id LIMIT 1 ) AS paciente_id FROM historia_antecedentes",
                "queryDes" => "historia_antecedente (id, historia_id, antecedente_id, fecha, texto_explicativo, estado, paciente_id)",
                "tableName" => "historia_antecedente"
            );
            $mensaje = processMigration($datosArreglo);
            break;//Marlon puso esta linea de codigo sin esta linea estaria pensando aun

        case "historia_antecedente_especial":
            $datosArreglo = array(
                "queryOri" => "SELECT id, historia_id, NULLIF(antecedente_id, 0) AS antecedente_id, confirma, conoce_fecha, fecha,
                (
                    SELECT paciente_id
                    FROM consulta c
                    WHERE c.historia_id = historia_antecedente.historia_id
                    LIMIT 1
                ) AS paciente_id
            FROM historia_antecedente WHERE historia_id NOT IN (71252, 94550, 103782, 103979, 104913, 106359, 106632, 111431, 114477, 116560, 125209) ORDER BY id;",
                "queryDes" => "historia_antecedente_especial(id, historia_id, antecedente_especial_id, confirma, conoce_fecha, fecha, paciente_id)",
                "tableName" => "historia_antecedente_especial"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_cups":
            $datosArreglo = array(
                "queryOri" => "SELECT id, historia_id, cups_id, CASE WHEN fecha = '0000-00-00 00:00:00' THEN '0000-00-00' ELSE DATE(fecha) END AS fecha, cantidad, texto_explicativo, 
                CASE 
                    WHEN especialidad_id = 19 THEN 1
                    WHEN especialidad_id = 7 THEN 2
                    WHEN especialidad_id = 8 THEN 3
                    WHEN especialidad_id = 5 THEN 6
                    WHEN especialidad_id = 13 THEN 7
                    WHEN especialidad_id = 24 THEN 8
                    WHEN especialidad_id = 28 THEN 9
                    WHEN especialidad_id = 29 THEN 12
                    WHEN especialidad_id = 26 THEN 13
                    WHEN especialidad_id = 27 THEN 14
                    WHEN especialidad_id = 4 THEN 15
                    WHEN especialidad_id = 10 THEN 16
                    WHEN especialidad_id = 11 THEN 17
                    WHEN especialidad_id = 15 THEN 18
                    WHEN especialidad_id = 16 THEN 19
                    WHEN especialidad_id = 17 THEN 20
                    WHEN especialidad_id = 18 THEN 21
                    WHEN especialidad_id = 20 THEN 22
                    WHEN especialidad_id = 21 THEN 23
                    WHEN especialidad_id = 25 THEN 24
                    ELSE especialidad_id
                END AS especialidad_id, 
                CASE 
                    WHEN anular = 0 OR anular IS NULL THEN 2 
                    ELSE anular 
                END AS anular, 
                paquete, ( SELECT paciente_id FROM consulta c WHERE c.historia_id = historia_cups.historia_id LIMIT 1 ) AS paciente_id FROM historia_cups",
                "queryDes" => "historia_cups(id, historia_id, cups_id, fecha, cantidad, texto_explicativo, especialidad_id, estado, paquete, paciente_id)",
                "tableName" => "historia_cups"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case 'historia_dialisis':
            $datosArreglo = array(
                "queryOri" => "SELECT id, fecha_diagnostico_erc, fecha_trr, tasa_filtracion_glomerular, etiologia_erc, modo_inicio_trr, modalidad_actual_trr, fecha_modalidad_actual, sesiones_semanales, horas_dialisis, dp_concentracion_1, dp_concentracion_2, dp_concentracion_3, peritonitis_infecciosa, fecha_peritonitis_actual, fecha_peritonitis_anteriores, episodio_peritonitis_mes, episodio_peritonitis_acumuladas, infeccion_hepatitis_b, fecha_infeccion_hepatitis_b, infeccion_hepatitis_c, fecha_infeccion_hepatitis_c, vacuna_hepatitis_b, fecha_vacuna_hepatitisb_1, fecha_vacuna_hepatitisb_2, fecha_vacuna_hepatitisb_3, vih, fecha_vih, ultimo_titulo_anticuerpo, fecha_anticuerpo, transplante_renal, fecha_transplante_renal, tipo_donante, 
                CASE WHEN confirma_rechazo_trr IS NULL THEN 3 ELSE confirma_rechazo_trr END AS confirma_rechazo_trr, rechazo_trasplante_renal, confirma_retorno_trr, retorno_terapia_reemplazo_renal, apto_transplante_renal, causas_contraindicaciones, fecha_contraindicacion, paciente_transplantado,  contraindicacion_transplantado, lista_espera, fecha_lista_espera, confirma_diuresis, diuresis, ultrafiltracion, horas_por_sesiones, peso_seco, enfermedad_neoplasica, menor_cinco_anos_evolucion,  menor_dos_anos_evolucion,  tumores_localizados, fecha_ingreso_unidad_renal, tipo_hemodialisis, dp_recambios, dp_volumen, cantidad_tr, contraindicacion_na, resultado, fecha_resultado, resultado_2, fecha_resultado_2, resultado_3, fecha_resultado_3, resultado_4, fecha_resultado_4 FROM historia
            WHERE
                fecha_diagnostico_erc IS NOT NULL OR fecha_trr IS NOT NULL OR tasa_filtracion_glomerular IS NOT NULL OR etiologia_erc IS NOT NULL OR modo_inicio_trr IS NOT NULL OR modalidad_actual_trr IS NOT NULL OR fecha_modalidad_actual IS NOT NULL OR sesiones_semanales IS NOT NULL OR  horas_dialisis  IS NOT NULL OR dp_concentracion_1 IS NOT NULL OR dp_concentracion_2 IS NOT NULL OR dp_concentracion_3 IS NOT NULL OR  peritonitis_infecciosa IS NOT NULL OR  fecha_peritonitis_actual IS NOT NULL OR fecha_peritonitis_anteriores IS NOT NULL OR episodio_peritonitis_mes IS NOT NULL OR episodio_peritonitis_acumuladas IS NOT NULL OR infeccion_hepatitis_b IS NOT NULL OR fecha_infeccion_hepatitis_b IS NOT NULL OR infeccion_hepatitis_c IS NOT NULL OR fecha_infeccion_hepatitis_c IS NOT NULL OR vacuna_hepatitis_b IS NOT NULL OR fecha_vacuna_hepatitisb_1 IS NOT NULL OR fecha_vacuna_hepatitisb_2 IS NOT NULL OR fecha_vacuna_hepatitisb_3 IS NOT NULL OR vih IS NOT NULL OR fecha_vih IS NOT NULL OR ultimo_titulo_anticuerpo IS NOT NULL OR  fecha_anticuerpo IS NOT NULL OR transplante_renal IS NOT NULL OR fecha_transplante_renal IS NOT NULL OR tipo_donante IS NOT NULL OR
                confirma_rechazo_trr IS NOT NULL OR rechazo_trasplante_renal IS NOT NULL OR confirma_retorno_trr IS NOT NULL OR  retorno_terapia_reemplazo_renal IS NOT NULL OR  apto_transplante_renal IS NOT NULL OR causas_contraindicaciones IS NOT NULL OR fecha_contraindicacion IS NOT NULL OR paciente_transplantado IS NOT NULL OR contraindicacion_transplantado IS NOT NULL OR lista_espera IS NOT NULL OR fecha_lista_espera IS NOT NULL OR confirma_diuresis IS NOT NULL OR diuresis IS NOT NULL OR  ultrafiltracion IS NOT NULL OR horas_por_sesiones IS NOT NULL OR peso_seco IS NOT NULL OR enfermedad_neoplasica IS NOT NULL OR menor_cinco_anos_evolucion IS NOT NULL OR  menor_dos_anos_evolucion IS NOT NULL OR  tumores_localizados IS NOT NULL OR fecha_ingreso_unidad_renal IS NOT NULL OR tipo_hemodialisis IS NOT NULL OR dp_recambios IS NOT NULL OR  dp_volumen IS NOT NULL OR cantidad_tr IS NOT NULL OR contraindicacion_na IS NOT NULL OR  resultado IS NOT NULL OR  fecha_resultado IS NOT NULL OR  resultado_2 IS NOT NULL OR fecha_resultado_2 IS NOT NULL OR resultado_3 IS NOT NULL OR fecha_resultado_3 IS NOT NULL OR resultado_4 IS NOT NULL OR fecha_resultado_4 IS NOT NULL",
                "queryDes" => "historia_dialisis (historia_id, fecha_diagnostico_erc, fecha_ingreso_trr, tasa_filtracion_glomerular, etiologia_erc, modo_trr, modalidad_actual_trr, fecha_modalidad_actual, numero_sesiones_semanales, horas_dialisis_semanales, concentracion1, concentracion2, concentracion3, peritonitis_infecciosa, fecha_peritonitis_actual, fecha_peritonitis_anterior, episodio_peritonitis_mes, episodio_peritonitis_acumuladas, infeccion_hepatitis_b, fecha_infeccion_hepatitis_b, infeccion_hepatitis_c, fecha_infeccion_hepatitis_c, vacuna_hepatitis_b, fecha_vacuna_hepatitis_b1,  fecha_vacuna_hepatitis_b2, fecha_vacuna_hepatitis_b3,
                vih, fecha_vih, ultimo_titulo_anticuerpo_hepatitis_b, fecha_ultimo_titulo_anticuerpo_hepatitis_b, trasplante_renal, fecha_trasplante_renal, tipo_donante, rechazo_trasplante_renal, fecha_rechazo_trasplante_renal, retorno_trr, fecha_retorno_trr, apto_trasplante_renal, causas_contraindicacion, fecha_contraindicacion, paciente_trasplantado, contraindicacion_trasplantado, lista_espera, fecha_ingreso_lista_espera, confirma_diuresis, diuresis, ultrafiltracion, horas_sesion, peso_seco, enfermedad_neoplasica, menor_cinco_anios_evolucion, menor_dos_anios_evolucion, tumores_localizados, fecha_ingreso_unidad_renal,
                tipo_modalidad_hemodialisis_actual, cantidad_recambios, volumen_recambio, cantidad_trasplante_renal, causas_n_a, anemia, fecha_resultado_anem, hiperparatiroidismo_secundario, fecha_resultado_hipesecu, anormalidad_calcio, fecha_resultado_anorcalc, fosforo, fecha_resultado_fosf)",
                "tableName" => "historia_dialisis"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_enfermeria":
            $datosArreglo = array(
                "queryOri" => "SELECT id, nota_enfermeria FROM historia WHERE nota_enfermeria IS NOT NULL AND nota_enfermeria != ''",
                "queryDes" => "historia_enfermeria(historia_id, nota_enfermeria)",
                "tableName" => "historia_enfermeria"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_insumo":
            $datosArreglo = array(
                "queryOri" => "SELECT id, historia_id, insumo_id, cantidad, texto_explicativo, anular,  ( SELECT paciente_id FROM consulta c WHERE c.historia_id = historia_insumo.historia_id LIMIT 1 ) AS paciente_id FROM historia_insumo WHERE insumo_id IS NOT NULL AND historia_id NOT IN (63426, 68462, 77158, 79092, 83931, 86014, 86092, 89115, 90298, 96247, 97635, 98605, 98671, 99020, 99380, 99442, 99488, 99701, 100263, 100528, 104218, 107644, 107861, 108472, 109634, 113173, 113541, 117515, 120401, 126433, 136515, 139327, 139752, 140222, 140464, 140838, 142870, 150954)",
                "queryDes" => "historia_insumo (id, historia_id, insumo_id, cantidad, texto_explicativo, anular, paciente_id)",
                "tableName" => "historia_insumo"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_laboratorio":
            $datosArreglo = array(
                "queryOri" => "SELECT rl.id, rl.cod_entidad, rl.resultado, rl.fecha, rl.hora, ( SELECT p.id FROM paciente p WHERE p.numero_documento = rl.num_documento LIMIT 1 ) AS paciente_id FROM resultados_laboratorios rl",
                "queryDes" => "historia_laboratorio (id, laboratorio_id, resultado, fecha, hora, paciente_id)",
                "tableName" => "historia_laboratorio"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_medicamento":
            $datosArreglo = array(
                "queryOri" => "SELECT id, historia_id, medicamento_id, fecha, via_id, ciclo_id, dosis, tiempo, cantidad, texto_explicativo, CASE WHEN anular = 0 THEN 2 ELSE anular END AS anular, paquete, (SELECT paciente_id FROM consulta c WHERE c.historia_id = historia_medicamento.historia_id LIMIT 1) AS paciente_id FROM historia_medicamento",
                "queryDes" => "historia_medicamento (id, historia_id, medicamento_id, created_at, via, ciclo, dosis, tiempo, cantidad, texto_explicativo, estado, entrega, paciente_id)",
                "tableName" => "historia_medicamento"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_nutricion":
            $datosArreglo = array(
                "queryOri" => "SELECT id, historia_id, apetito, intolerancias, habito_intestinal, masticacion, deglucion, sintomas_gastrointestinales, complemento_suplemento_nutricional, alimentos_favoritos, alimentos_rechazados, actividad_fisica, alcohol, cigarrillos, desayuno, nueves, almuerzo, onces, cena, refrigerio, diagnostico_nutricional FROM nutricion",
                "queryDes" => "historia_nutricion (id, historia_id, apetito, intolerancia, habito_intestinal, masticacion, deglucion, sintoma_gastrointestinal, complemento_suplemento_nutricional, alimento_favorito, alimento_rechazado, actividad_fisica, alcohol, cigarrillo, desayuno, nueve, almuerzo, once, cena, refrigerio, diagnostico_nutricional)",
                "tableName" => "historia_nutricion"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_procedimiento":
            $datosArreglo = array(
                "queryPrepara" => "DROP TABLE IF EXISTS tmp_historia_procedimiento;
                    CREATE TABLE tmp_historia_procedimiento AS 
                    SELECT id, tipos_procedimiento, opciones_cateter, posicion, tipo_anestesia, 
                        CASE WHEN descripcion_procedimiento = '' THEN NULL ELSE descripcion_procedimiento END AS descripcion_procedimiento, 
                        CASE WHEN complicaciones = '' THEN NULL ELSE complicaciones END AS complicaciones, 
                        sangrado, diligencio_consentimiento_informado, 
                        CASE WHEN lista_chequeo_seguridad IS NULL THEN 2 WHEN lista_chequeo_seguridad = 0 THEN 2 ELSE lista_chequeo_seguridad END AS lista_chequeo_seguridad 
                    FROM historia; 
                    DELETE FROM tmp_historia_procedimiento 
                    WHERE 
                        tipos_procedimiento IS NULL 
                        AND posicion IS NULL 
                        AND tipo_anestesia IS NULL 
                        AND descripcion_procedimiento IS NULL
                        AND complicaciones IS NULL 
                        AND sangrado IS NULL
                        AND diligencio_consentimiento_informado IS NULL 
                        AND lista_chequeo_seguridad = 2; 
                    DELETE FROM tmp_historia_procedimiento 
                    WHERE 
                        tipos_procedimiento IS NULL 
                        AND posicion IS NULL
                        AND tipo_anestesia IS NULL
                        AND descripcion_procedimiento IS NULL
                        AND complicaciones IS NULL 
                        AND sangrado = 0 
                        AND diligencio_consentimiento_informado IS NULL 
                        AND lista_chequeo_seguridad = 2;
                    DELETE FROM tmp_historia_procedimiento 
                    WHERE 
                        tipos_procedimiento = 0
                        AND posicion = 0
                        AND tipo_anestesia = 0
                        AND descripcion_procedimiento IS NULL
                        AND complicaciones IS NULL 
                        AND sangrado = 0 
                        AND diligencio_consentimiento_informado = 0 OR diligencio_consentimiento_informado IS NULL
                        AND lista_chequeo_seguridad = 2;
                        DELETE FROM tmp_historia_procedimiento 
                    WHERE 
                        tipos_procedimiento IS NULL 
                        AND posicion IS NULL
                        AND tipo_anestesia IS NULL
                        AND descripcion_procedimiento IS NULL
                        AND complicaciones IS NULL 
                        AND sangrado = 0 
                        AND diligencio_consentimiento_informado = 0 
                        AND lista_chequeo_seguridad = 2;",
                "queryOri" => "SELECT id, tipos_procedimiento, opciones_cateter, posicion, tipo_anestesia, descripcion_procedimiento, complicaciones, sangrado, diligencio_consentimiento_informado, lista_chequeo_seguridad FROM tmp_historia_procedimiento; DROP TABLE tmp_historia_procedimiento",
                "queryDes" => "historia_procedimiento(historia_id, tipo_procedimiento, opciones_cateter, posicion, tipo_anestesia, descripcion, complicaciones, sangrado, consentimiento_informado, lista_chequeo_seguridad)",
                "tableName" => "historia_procedimiento"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_usuario":
            $datosArreglo = array(
                "queryOri" => "SELECT id, CASE WHEN fecha_inicio_atencion IS NOT NULL THEN fecha_inicio_atencion WHEN fecha_fin_atencion IS NOT NULL THEN DATE_ADD(fecha_fin_atencion, INTERVAL -20 MINUTE) ELSE NULL END AS fecha_inicio_atencion_ajustada, CASE WHEN fecha_fin_atencion IS NOT NULL THEN fecha_fin_atencion WHEN fecha_inicio_atencion IS NOT NULL THEN DATE_ADD(fecha_inicio_atencion, INTERVAL 20 MINUTE) ELSE NULL END AS fecha_fin_atencion_ajustada, medico_especialista_id FROM historia WHERE (medico_especialista_id IS NOT NULL AND (fecha_inicio_atencion IS NOT NULL OR fecha_fin_atencion IS NOT NULL))",
                "queryDes" => "historia_usuario (historia_id, fecha_inicio_atencion, fecha_fin_atencion, usuario_id)",
                "tableName" => "historia_usuario"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "kru_dialisis":
            $datosArreglo = array(
                "queryOri" => "SELECT id, historia_id, nitrogeno_urinario, volumen_urinario, bun_pre, bun_post, bun, kru FROM  consulta_kru",
                "queryDes" => "kru_dialisis (id, historia_id, nitrogeno_urinario, volumen_urinario, bun_pre, bun_post, bun_kru, kru)",
                "tableName" => "kru_dialisis"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "ktv_dialisis":
            $datosArreglo = array(
                "queryOri" => "SELECT id, historia_id, peso_predialisis, peso_predialisis AS peso, peso_postdialisis, nitrogeno_ureico_pre_dialisis, nitrogeno_ureico_pre_dialisis AS bun_nitrogeno_dializado, nitrogeno_ureico_post_dialisis, nitrogeno_ureico_post_dialisis AS bun_ktv, horas, ktv, volumen_liquido_dializado, fecha_registro FROM consulta_ktv",
                "queryDes" => "ktv_dialisis (id, historia_id, peso_predialisis, peso, peso_postdialisis, nitrogeno_ureico_predialisis, bun_nitrogeno_dializado, nitrogeno_ureico_postdialisis, bun_ktv, horas, ktv, volumen_liquido_dializado, fecha)",
                "tableName" => "ktv_dialisis"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "remision":
            $datosArreglo = array(
                "queryOri" => "SELECT id, historia_id, servicio_remision_id, justificacion, 
                CASE 
                    WHEN responsable_tipo_documento = 'CC' THEN 1
                    WHEN responsable_tipo_documento = 'TI' THEN 2
                    WHEN responsable_tipo_documento = 'RC' THEN 3
                    WHEN responsable_tipo_documento = 'CE' THEN 4
                    WHEN responsable_tipo_documento = 'PA' THEN 5
                    WHEN responsable_tipo_documento = 'AS' THEN 6
                    WHEN responsable_tipo_documento = 'MS' THEN 7
                    WHEN responsable_tipo_documento = 'NV' THEN 8
                    WHEN responsable_tipo_documento = 'SC' THEN 9
                    WHEN responsable_tipo_documento = 'CD' THEN 10
                    WHEN responsable_tipo_documento = 'PE' THEN 11
                    WHEN responsable_tipo_documento = 'NIT' THEN 12
                END AS responsable_tipo_documento, 
                responsable_numero_documento, responsable_nombre, responsable_apellido, responsable_fecha_nacimiento, responsable_direccion, responsable_telefono, responsable_municipio_id FROM remision",
                "queryDes" => "remision (id, historia_id, servicio_remision_id, justificacion, tipo_documento_id, responsable_numero_documento, responsable_nombres, responsable_apellidos, responsable_fecha_nacimiento, responsable_direccion, responsable_telefono, municipio_id)",
                "tableName" => "remision"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "revision_por_sistema":
            $datosArreglo = array(
                "queryOri" => "SELECT id, 
                CASE WHEN sintomas_generales IS NULL THEN 'Niega' WHEN sintomas_generales = '' THEN 'Niega' ELSE sintomas_generales END AS sintomas_generales, 
                CASE WHEN piel_y_faneras IS NULL THEN 'Niega' WHEN piel_y_faneras = '' THEN 'Niega' ELSE piel_y_faneras END AS piel_y_faneras, 
                CASE WHEN organos_de_los_sentidos IS NULL THEN 'Niega' WHEN organos_de_los_sentidos = '' THEN 'Niega' ELSE organos_de_los_sentidos END AS organos_de_los_sentidos, 
                CASE WHEN musculoesqueletico IS NULL THEN 'Niega' WHEN musculoesqueletico = '' THEN 'Niega' ELSE musculoesqueletico END AS musculoesqueletico, 
                CASE WHEN hematologico_y_linforreticular IS NULL THEN 'Niega' WHEN hematologico_y_linforreticular = '' THEN 'Niega' ELSE hematologico_y_linforreticular END AS hematologico_y_linforreticular, 
                CASE WHEN cardiovascular IS NULL THEN 'Niega' WHEN cardiovascular = '' THEN 'Niega' ELSE cardiovascular END AS cardiovascular, 
                CASE WHEN respiratorio IS NULL THEN 'Niega' WHEN respiratorio = '' THEN 'Niega' ELSE respiratorio END AS respiratorio, 
                CASE WHEN digestivo IS NULL THEN 'Niega' WHEN digestivo= '' THEN 'Niega' ELSE digestivo END AS digestivo, 
                CASE WHEN genitourinario_rs IS NULL THEN 'Niega' WHEN genitourinario_rs = '' THEN 'Niega' ELSE genitourinario_rs END AS genitourinario_rs, 
                CASE WHEN psiquiatrico  IS NULL THEN 'Niega' WHEN psiquiatrico  = '' THEN 'Niega' ELSE psiquiatrico  END AS psiquiatrico,
                1 AS estado 
                FROM `historia`;
                ",
                "queryDes" => "revision_por_sistema (historia_id, sintomas_generales, piel_y_faneras, organos_de_los_sentidos, musculoesqueletico, hematologico_y_linforreticular, cardiovascular, respiratorio, digestivo, genitourinario_rs, psiquiatrico, estado)",
                "tableName" => "revision_por_sistema"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "signo_vital_dialisis":
            $datosArreglo2 = array (
                "tableName" => "signo_vital_dialisis"
            );
            $mensaje = processBucle($datosArreglo2);
            break;

        case "test_escala":
            $datosArreglo = array(
                "queryOri" =>"SELECT H.id AS historia_id_historia, H.morinsky_green_uno AS morinsky_green_uno_charlson, H.morinsky_green_dos AS morinsky_green_dos_charlson, H.morinsky_green_tres AS morinsky_green_tres_charlson, H.morinsky_green_cuatro AS morinsky_green_cuatro_charlson,
                                    B.puntaje_comer AS puntaje_comer_barthel, B.puntaje_trasladarse_entre_la_silla_y_la_cama AS puntaje_trasladarse_barthel, B.puntaje_aseo_personal AS puntaje_aseo_personal_barthel, B.puntaje_uso_del_retrete AS puntaje_uso_del_retrete_barthel, B.puntaje_banarse_o_ducharse AS puntaje_banarse_barthel, B.puntaje_desplazarse AS puntaje_desplazarse_barthel, B.puntaje_subir_y_bajar_escaleras AS puntaje_escaleras_barthel, B.puntaje_vestirse_y_desvestirse AS puntaje_vestirse_barthel, B.puntaje_control_de_heces AS puntaje_heces_barthel, B.puntaje_control_de_orina AS puntaje_orina_barthel, B.sumatoria_total AS sumatoria_total_barthel, B.clasificacion AS clasificacion_barthel,
                                    Y.puntaje_uno AS puntaje_uno_yesavage, Y.puntaje_dos AS puntaje_dos_yesavage, Y.puntaje_tres AS puntaje_tres_yesavage, Y.puntaje_cuatro AS puntaje_cuatro_yesavage, Y.puntaje_cinco AS puntaje_cinco_yesavage, Y.puntaje_seis AS puntaje_seis_yesavage, Y.puntaje_siete AS puntaje_siete_yesavage, Y.puntaje_ocho AS puntaje_ocho_yesavage, Y.puntaje_nueve AS puntaje_nueve_yesavage, Y.puntaje_diez AS puntaje_diez_yesavage, Y.puntaje_once AS puntaje_once_yesavage, Y.puntaje_doce AS puntaje_doce_yesavage, Y.puntaje_trece AS puntaje_trece_yesavage, Y.puntaje_catorce AS puntaje_catorce_yesavage, Y.puntaje_quince AS puntaje_quince_yesavage, Y.sumatoria_total AS sumatoria_total_yesavage, Y.clasificacion AS clasificacion_yesavage,
                                    T.en_que_ano_estamos AS en_que_ano_estamos_folstein, T.en_que_estacion AS en_que_estacion_folstein, T.en_que_dia_fecha AS en_que_dia_fecha_folstein, T.en_que_mes AS en_que_mes_folstein, T.en_que_dia_de_la_semana AS en_que_dia_de_la_semana_folstein, T.en_que_hospital_o_lugar_estamos AS en_que_hospital_folstein, T.en_que_piso_o_planta_sala_servicio AS en_que_piso_folstein, T.en_que_pueblo_ciudad AS en_que_pueblo_folstein, T.en_que_provincia_estamos AS en_que_provincia_folstein, T.en_que_pais_o_nacion_autonomia AS en_que_pais_folstein, T.recuerdo_diferido AS recuerdo_diferido_folstein, T.atencion_calculo AS atencion_calculo_folstein, T.recuerdo_inmediato AS recuerdo_inmediato_folstein, T.sumatoria_total AS sumatoria_total_folstein, T.clasificacion AS clasificacion_folstein,
                                    C.infarto_miocardio AS infarto_miocardio_charlson, C.insuficiencia_cardiaca_congestiva AS insuficiencia_cardiaca_charlson, C.enfermedad_vascular_periferica AS enfermedad_vascular_charlson, C.enfermedad_cerebrovascular AS enfermedad_cerebrovascular_charlson, C.demencia AS demencia_charlson, C.enfermedad_pulmonar_cronica AS enfermedad_pulmonar_charlson, C.patologia_tejido_conectivo AS patologia_tejido_charlson, C.enfermedad_ulcerosa AS enfermedad_ulcerosa_charlson, C.patologia_hepatica AS patologia_hepatica_charlson, C.diabetes_mellitus AS diabetes_mellitus_charlson, C.hemiplejia AS hemiplejia_charlson, C.patologia_renal_moderada_grave AS patologia_renal_charlson, C.tumor_solido AS tumor_solido_charlson, C.leucemias AS leucemias_charlson, C.linfomas_malignos AS linfomas_charlson, C.sida AS sida_charlson, C.puntuacion_charlson AS puntuacion_charlson_charlson, C.supervivencia_estimada AS supervivencia_estimada_charlson
                            FROM historia H
                            LEFT JOIN indice_barthel B ON B.historia_id = H.id
                            LEFT JOIN escala_yesavage Y ON Y.historia_id = H.id
                            LEFT JOIN folstein T ON T.historia_id = H.id
                            LEFT JOIN Indice_charlson C ON C.historia_id = H.id
                            WHERE
                                ( H.morinsky_green_uno IS NOT NULL AND H.morinsky_green_dos IS NOT NULL AND H.morinsky_green_tres IS NOT NULL AND H.morinsky_green_cuatro IS NOT NULL )
                                OR 
                                ( B.puntaje_comer IS NOT NULL AND B.puntaje_trasladarse_entre_la_silla_y_la_cama IS NOT NULL AND B.puntaje_aseo_personal IS NOT NULL AND B.puntaje_uso_del_retrete IS NOT NULL AND B.puntaje_banarse_o_ducharse IS NOT NULL AND B.puntaje_desplazarse IS NOT NULL AND B.puntaje_subir_y_bajar_escaleras IS NOT NULL AND B.puntaje_vestirse_y_desvestirse IS NOT NULL AND B.puntaje_control_de_heces IS NOT NULL AND B.puntaje_control_de_orina IS NOT NULL AND B.sumatoria_total IS NOT NULL AND B.clasificacion IS NOT NULL)
                                OR 
                                ( Y.puntaje_uno IS NOT NULL AND Y.puntaje_dos IS NOT NULL AND Y.puntaje_tres IS NOT NULL AND Y.puntaje_cuatro IS NOT NULL AND Y.puntaje_cinco IS NOT NULL AND Y.puntaje_seis IS NOT NULL AND Y.puntaje_siete IS NOT NULL AND Y.puntaje_ocho IS NOT NULL AND Y.puntaje_nueve IS NOT NULL AND Y.puntaje_diez IS NOT NULL AND Y.puntaje_once IS NOT NULL AND Y.puntaje_doce IS NOT NULL AND Y.puntaje_trece IS NOT NULL AND Y.puntaje_catorce IS NOT NULL AND Y.puntaje_quince IS NOT NULL AND Y.sumatoria_total IS NOT NULL AND Y.clasificacion IS NOT NULL)
                                OR 
                                ( T.en_que_ano_estamos IS NOT NULL AND T.en_que_estacion IS NOT NULL AND T.en_que_dia_fecha IS NOT NULL AND T.en_que_mes IS NOT NULL AND T.en_que_dia_de_la_semana IS NOT NULL AND T.en_que_hospital_o_lugar_estamos IS NOT NULL AND T.en_que_piso_o_planta_sala_servicio IS NOT NULL AND T.en_que_pueblo_ciudad IS NOT NULL AND T.en_que_provincia_estamos IS NOT NULL AND T.en_que_pais_o_nacion_autonomia IS NOT NULL AND T.recuerdo_diferido IS NOT NULL AND T.atencion_calculo IS NOT NULL AND T.recuerdo_inmediato IS NOT NULL AND T.sumatoria_total IS NOT NULL AND T.clasificacion IS NOT NULL )
                                OR 
                                ( C.infarto_miocardio IS NOT NULL AND C.insuficiencia_cardiaca_congestiva IS NOT NULL AND C.enfermedad_vascular_periferica IS NOT NULL AND C.enfermedad_cerebrovascular IS NOT NULL AND C.demencia IS NOT NULL AND C.enfermedad_pulmonar_cronica IS NOT NULL AND C.patologia_tejido_conectivo IS NOT NULL AND C.enfermedad_ulcerosa IS NOT NULL AND C.patologia_hepatica IS NOT NULL AND C.diabetes_mellitus IS NOT NULL AND C.hemiplejia IS NOT NULL AND C.patologia_renal_moderada_grave IS NOT NULL AND C.tumor_solido IS NOT NULL AND C.leucemias IS NOT NULL AND C.linfomas_malignos IS NOT NULL AND C.sida IS NOT NULL AND C.puntuacion_charlson IS NOT NULL AND C.supervivencia_estimada IS NOT NULL )",
                "queryDes" =>  "test_escala (historia_id, olvida_tomar_medicacion, toma_horas_indicadas, deja_tomar_bien, deja_tomar_mal,
                                comer_barthel, trasladarse_entre_silla_cama_barthel, aseo_personal_barthel, uso_retrete_barthel, bañarse_ducharse_barthel, desplazarse_barthel, subir_bajar_escaleras_barthel, vestirse_desvestirse_barthel, control_heces_barthel, control_orina_barthel, sumatorio_total_barthel, clasificacion_barthel,
                                satisfecho_yesavage, intereses_actividades_yesavage, vida_vacia_yesavage, aburrido_yesavage, buen_animo_yesavage, preocupado_teme_yesavage, feliz_yesavage, desamparado_yesavage, quedarse_casa_yesavage, problemas_memoria_yesavage, maravilloso_estar_vivo_yesavage, inutil_despreciable_yesavage, lleno_energia_yesavage, sin_esperanza_yesavage, otras_personas_estan_mejor_yesavage, sumatorio_total_yesavage, clasificacion_yesavage,
                                anio_actual_folstein, estacion_actual_folstein, dia_mes_actual_folstein, mes_actual_folstein, dia_semana_actual_folstein, lugar_hospital_actual_folstein, planta_piso_actual_folstein, pueblo_ciudad_actual_folstein, provincia_municipio_actual_folstein, pais_actual_folstein, memoria_folstein, atencion_calculo_folstein, fijacion_folstein, sumatorio_total_folstein, clasificacion_folstein,
                                infarto_miocardio_charlson, insuficiencia_cardiaca_congestiva_charlson, enfermedad_vascular_periferica_charlson, enfermedad_cerebrovascular_charlson, demencia_charlson, enfermedad_pulmonar_cronica_charlson, patologia_tejido_conectivo_charlson, enfermedad_ulcerosa_charlson, patologia_hepatica_charlson, diabetes_mellitus_charlson, hemiplejia_charlson, patologia_renal_charlson, tumor_solido_charlson, leucemia_charlson, linfoma_charlson, sida_charlson, puntuacion_charlson, supervivencia_estimada_charlson )",
                "tableName" => "test_escala"
            );
            $mensaje = processMigration($datosArreglo);

            break;

        case "usuario_especialidad":
            $datosArreglo = array(
                "queryOri" => "SELECT id, personal_user_id, 
                CASE 
                WHEN especialidad_id = 19 THEN 1
                    WHEN especialidad_id = 7 THEN 2
                    WHEN especialidad_id = 8 THEN 3
                    WHEN especialidad_id = 5 THEN 6
                    WHEN especialidad_id = 13 THEN 7
                    WHEN especialidad_id = 24 THEN 8
                    WHEN especialidad_id = 28 THEN 9
                    WHEN especialidad_id = 29 THEN 12
                    WHEN especialidad_id = 26 THEN 13
                    WHEN especialidad_id = 27 THEN 14
                    WHEN especialidad_id = 4 THEN 15
                    WHEN especialidad_id = 10 THEN 16
                    WHEN especialidad_id = 11 THEN 17
                    WHEN especialidad_id = 15 THEN 18
                    WHEN especialidad_id = 16 THEN 19
                    WHEN especialidad_id = 17 THEN 20
                    WHEN especialidad_id = 18 THEN 21
                    WHEN especialidad_id = 20 THEN 22
                    WHEN especialidad_id = 21 THEN 23
                    WHEN especialidad_id = 25 THEN 24
                    ELSE especialidad_id
                END AS especialidad_id FROM personal_especialidad",
                "queryDes" => "usuario_especialidad (id, usuario_id, especialidad_id)",
                "tableName" => "usuario_especialidad"
            );
            $mensaje = processMigration($datosArreglo);
            break;
            
        case "usuario_prestador":
            $datosArreglo = array(
                "queryOri" => "SELECT id, personal_user_id , prestador_id FROM personal_prestador",
                "queryDes" => "usuario_prestador (id, usuario_id, prestador_id)",
                "tableName" => "usuario_prestador"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_psicologia":
            $datosArreglo = array (
                "queryOri" => "SELECT id, historia_id, comunicacion_abierta_dinamica, comunicacion_respetuosa, comunicacion_falta_respeto, comunicacion_decisiones_consenso, comunicacion_no_hay, animo_depresion, animo_alegria, animo_tristeza, animo_melancolia, animo_euforia, animo_neutro, animo_estres, animo_insomnio, animo_preocupado, animo_letargo, proyecto_vida, hobbies, tiempo_libre, valores, imagen_paciente, pregunta_proyecta_superar, pregunta_impacto_personal, pregunta_impacto_familiar, ducharse, hacer_compras, vestirse, comer, otros_diarios,trabajo_habitual, caminar_solo, medicarse, quehaceres_domesticos, actividades_livianas, actividades_recreativas, otros_instrumentales FROM psicologia
                WHERE (comunicacion_abierta_dinamica != 0 OR comunicacion_respetuosa != 0 OR comunicacion_falta_respeto != 0 OR comunicacion_decisiones_consenso != 0 OR comunicacion_no_hay != 0 OR animo_depresion != 0 OR animo_alegria != 0 OR animo_tristeza != 0 OR animo_melancolia != 0 OR animo_euforia != 0 OR animo_neutro != 0 OR animo_estres != 0 OR animo_insomnio != 0 OR animo_preocupado != 0 OR animo_letargo != 0 OR proyecto_vida IS NOT NULL OR hobbies IS NOT NULL OR tiempo_libre IS NOT NULL OR valores IS NOT NULL OR imagen_paciente IS NOT NULL OR pregunta_proyecta_superar IS NOT NULL OR pregunta_impacto_personal IS NOT NULL OR pregunta_impacto_familiar IS NOT NULL OR ducharse != 0 OR hacer_compras != 0 OR vestirse != 0 OR comer != 0 OR otros_diarios != 0 OR trabajo_habitual != 0 OR caminar_solo != 0 OR medicarse != 0 OR quehaceres_domesticos != 0 OR actividades_livianas != 0 OR actividades_recreativas != 0 OR otros_instrumentales != 0)
                AND (comunicacion_abierta_dinamica != 0 OR comunicacion_respetuosa != 0 OR comunicacion_falta_respeto != 0 OR comunicacion_decisiones_consenso != 0 OR comunicacion_no_hay != 0 OR animo_depresion != 0 OR animo_alegria != 0 OR animo_tristeza != 0 OR animo_melancolia != 0 OR animo_euforia != 0 OR animo_neutro != 0 OR animo_estres != 0 OR animo_insomnio != 0 OR animo_preocupado != 0 OR animo_letargo != 0 OR proyecto_vida != '' OR hobbies != '' OR tiempo_libre != '' OR valores != '' OR imagen_paciente != '' OR pregunta_proyecta_superar != '' OR pregunta_impacto_personal != '' OR pregunta_impacto_familiar != '' OR ducharse != 0 OR hacer_compras != 0 OR vestirse != 0 OR comer != 0 OR otros_diarios != 0 OR trabajo_habitual != 0 OR caminar_solo != 0 OR medicarse != 0 OR quehaceres_domesticos != 0 OR actividades_livianas != 0 OR actividades_recreativas != 0 OR otros_instrumentales != 0)",
                "queryDes" => "historia_psicologia (id, historia_id, comunicacion_abierta_dinamica, comunicacion_respetuosa, comunicacion_falta_respeto, comunicacion_decisiones_consenso, comunicacion_no_hay, depresion, alegria, tristeza, melancolia, euforia, miedo, estres, insomnio, preocupado, letargo, proyecto_vida, hobbies, uso_tiempo_libre, valores, imagen_paciente, pregunta_proyecta_superar, pregunta_impacto_personal, pregunta_impacto_familiar, ducharse, hacer_compras, vestirse, comer, otros_diarios, trabajo_habitual, caminar_solo, medicarse, quehaceres_domesticos, actividades_livianas, actividades_recreativas, otros_instrumentales )",
                "tableName" => "historia_psicologia"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "historia_nucleo_familiar":
            $datosArreglo2 = array (
                "tableName" => "historia_nucleo_familiar"
            );
            $mensaje = processBucle($datosArreglo2);
            break;

            case "historia_trabajo_social":
                $datosArreglo2 = array(
                    "tableName" => "historia_trabajo_social"
                );
                $mensaje = processBucle($datosArreglo2);
                break;

/* -------------------- TABLAS 6to NIVEL ---------------------------------- */

        case "agenda":
            $datosArreglo = array(
                "queryOri" => "SELECT id, medio_cita, fecha, hora, medico_id, consulta_id, personal_user_id, consultorio_id, fecha_registro, (SELECT CASE WHEN prestador_id IS NULL THEN 1 ELSE prestador_id END AS prestador_id FROM consulta WHERE consulta.id = agenda.consulta_id LIMIT 1) AS prestador_id, 15 AS tiempo_cita FROM agenda WHERE consulta_id IS NOT NULL",
                "queryDes" => "agenda (id, medio_cita, fecha, hora_inicial, usuario_id, admision_id, personal_id, consultorio, fecha_registro, prestador_id, tiempo_cita)",
                "tableName" => "agenda"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "admision_cancelacion":
            $datosArreglo = array(
                "queryOri" => "SELECT consulta_id, cancelacion_id, observacion, reporta_id, fecha_registro  FROM consulta_cancelacion",
                "queryDes" => "admision_cancelacion(admision_id, motivo_cancelacion_id, observacion, usuario_id, fecha_registro)",
                "tableName" => "admision_cancelacion"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "admision_factura":
            $datosArreglo = array(
                "queryOri" => "SELECT id, factura_id, consulta_id, consecutivo_entidad, CASE WHEN anulado = 0 THEN 2 ELSE anulado END AS anulado FROM factura_consulta",
                "queryDes" => "admision_factura (id, factura_id, admision_id, consecutivo_entidad, estado)",
                "tableName" => "admision_factura"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "admision_inatencion":
            $datosArreglo = array(
                "queryOri" => "SELECT consulta_id, inatencion_id, observacion, reporta_id, fecha_registro FROM consulta_inatencion",
                "queryDes" => "admision_inatencion (admision_id, inatencion_id, observacion, usuario_id, fecha_registro)",
                "tableName" => "admision_inatencion"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"indices":
            $mensaje = processIndices();
            break;
/* -------------------- CASE por default ---------------------------------- */

        //se puede segir parametrizando más acciones por medio de los case.
        default:
        $mensaje =  ' Error Acción no valida o no se ha codificado';
    }
    echo $mensaje;//este es el mensaje que le responde a la solicitud de ajax.
}
/**************************************** -- FIN DEL  CASE -- ********************************************************/

function confirm(){
    $conexion = conectarbd();
    $token = $_POST['token'];
    if(isset($token)){
        $query = "SELECT token FROM usuarios WHERE token = '$token'";
        $statement = $conexion->query($query);
        $result = $statement->fetch(PDO::FETCH_ASSOC);
        if ($result){
            $mensaje = 1;
            return $mensaje;
        }else{
            $mensaje = 0;
            return $mensaje;
        };
    }
}

function guardatos() {
    $conexion = conectarbd();
    
    // Obtener los valores de la base de datos de origen.
    $nombreMig = $_POST['nombreMig'];
    $hostOri = $_POST['hostOri'];
    $puertoOri = $_POST['puertoOri'];
    $bdNameOri = $_POST['bdNameOri'];
    $usuarioOri = $_POST['usuarioOri'];
    $contrasenaOri = $_POST['contrasenaOri'];
    
    // Obtener los valores de la base de datos de destino.
    $hostDes = $_POST['hostDes'];
    $puertoDes = $_POST['puertoDes'];
    $bdNameDes = $_POST['bdNameDes'];
    $usuarioDes = $_POST['usuarioDes'];
    $contrasenaDes = $_POST['contrasenaDes'];
    
    // Consulta SQL con marcadores de posición para evitar problemas de seguridad
    $queryDes = "INSERT INTO tbldatosdestino (Nombre_Migracion, host, puerto, nombre_Db, nombre_Usuario, contraseña) VALUES (?, ?, ?, ?, ?, ?)";
    $queryOri = "INSERT INTO tbldatosorigen (Nombre_Migracion, host, puerto, nombre_Db, nombre_Usuario, contraseña) VALUES (?, ?, ?, ?, ?, ?)";
                
    if (!$nombreMig || !$hostOri || !$puertoOri || !$bdNameOri || !$usuarioOri || /*!$contrasenaOri ||*/ !$hostDes || !$puertoDes || !$bdNameDes || !$usuarioDes /*|| !$contrasenaDes*/) {
    $mensaje = 'Error php linea 79: las variables llegaron vacias';
    return $mensaje;
    }
    else{
        try {

            // Preparar la consulta para la base de datos de destino
            $statement = $conexion->prepare($queryDes);
            $statement->bindParam(1, $nombreMig);
            $statement->bindParam(2, $hostDes);
            $statement->bindParam(3, $puertoDes);
            $statement->bindParam(4, $bdNameDes);
            $statement->bindParam(5, $usuarioDes);
            $statement->bindParam(6, $contrasenaDes);
            $resultado = $statement->execute();
            
            // Verificar si la consulta se ejecutó exitosamente
            if ($resultado) {
                $msn1 = 'La inserción de datos a la tabla de destino se ejecutó exitosamente. ';
                //echo "La consulta para la base de datos de destino se ejecutó exitosamente.";
            } else {
                $msn1 = 'Ocurrió un error en la inserción de datos a la tabla de destino: ' . $statement->errorInfo()[2];
                //echo "Ocurrió un error al ejecutar la consulta para la base de datos de destino: " . $statement->errorInfo()[2];
            }
            // Preparar la consulta para la base de datos de origen
            $statement = $conexion->prepare($queryOri);
            $statement->bindParam(1, $nombreMig);
            $statement->bindParam(2, $hostOri);
            $statement->bindParam(3, $puertoOri);
            $statement->bindParam(4, $bdNameOri);
            $statement->bindParam(5, $usuarioOri);
            $statement->bindParam(6, $contrasenaOri);
            $resultado = $statement->execute();
            // Verificar si la consulta se ejecutó exitosamente
            if ($resultado) {
                $msn2 = "La inserción de datos a la tabla de origen se ejecutó exitosamente. ";
                //echo "La consulta para la base de datos de origen se ejecutó exitosamente.";
            } else {
                $msn2 = 'Ocurrió un error en la inserción de datos a la tabla de origen: ' . $statement->errorInfo()[2];
                //echo "Ocurrió un error al ejecutar la consulta para la base de datos de origen: " . $statement->errorInfo()[2];
            }
            $mensaje = $msn1 . $msn2;
            
            // Cerrar la conexión y liberar los recursos
            $statement = null;
            $conexion = null;
            return $mensaje;
        } catch (PDOException $e) {
            $mensaje = "Error en la consulta: ". $e->getMessage();
            //echo "Error en la consulta: " . $e->getMessage();
            return $mensaje;
        };
    };    
}

function selected(){
    try {
        $conexion = conectarbd();
        $query = "SELECT Nombre_Migracion FROM tbldatosdestino";
        $statement = $conexion->query($query);
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);
        $mensaje = json_encode($result);
        return $mensaje;
    }catch (Exception $e) {
        $mensaje = "Error en la consulta: " . $e->getMessage();
        return $mensaje;
    }   
}

/* ****************************** DIFERENTES FUNCIONES PARA REALIZAR LA MIGRACIÓN ******************************* */

function validarValor($valor) 
{
    // Si el valor es numérico, elimina las comillas y devuelve el valor
    if (is_numeric($valor)) {
        return $valor;
    }

    if ($valor==null) {
        return $valor = 'NULL';
    }
    // Si el valor es de texto, agregar comillas simples y escapar caracteres especiales
    $valor = addslashes($valor);
    
    // Escapar asteriscos (*)
    $valor = str_replace('*', ' * ', $valor);
    return "'" . $valor . "'";
    
}

function procesador($result) 
{
    
    $numRegistros = count($result);// cuento los arrays para despues pasarlos al for
    $cadena = ''; // Cadena de texto para concatenar los resultados
    $elementosProcesados = 0; // Contador de elementos procesados

    for ($i = 0; $i < $numRegistros; $i++) {
        $valores = array_values($result[$i]);// transformo el array de arrays en un array simple
        $valoresValidados = array_map('validarValor', $valores);// se llama a la funcion validarValor para que busque y separe los valores númericos de los characteres
        $jsonResult = '(' . implode(',', $valoresValidados) . '),'; // Vuelvo el array en un string
        $cadena .= $jsonResult . ' ';//agrego cada elemento como parte de la cadena de string
        $elementosProcesados++;// Incrementar el contador de elementos procesados
        if ($elementosProcesados % 250 == 0) {//aqui //si la división de los 250 registros me devuelve cero es decir si no hay un residuo.
            $cadena = substr($cadena, 0, -2);// se borrarn los ultimos dos elementos de cada cadena
            $cadena .= ';*-'; // se agrega ; para separar cada 250 registros y se agrega *- para despues contarlos con el explode que los quite y cada vez que encuentre esto lo vuelva un indice.
        }
    }
    // Verifica si quedan registros sin procesar
    if ($numRegistros % 250 != 0) {//aqui
        $cadena = substr($cadena, 0, -2);
        $cadena .= ';'; // Agrega el punto y coma final
    }
    
    $regIndex = explode("*-", $cadena); // Divide la cadena de texto en registros indexados
    return $regIndex; // Retorna los registros indexados obtenidos
}

function contador($registros)
{
    $registrosComp = $registros;
    $numRegistrosLotes = count($registros); // numero de lotes.
    $menosUnregistro = $numRegistrosLotes - 1;
    $explodeUltIndex = explode('),', $registrosComp[$menosUnregistro]);
    $numRegistros = $numRegistrosLotes * 250;//aqui
    $contRegistros = count($explodeUltIndex);
    $contRegistros = $numRegistros - 250 + $contRegistros; // numero de registros. //aqui
    $mensaje = " La tabla de origen contiene: $contRegistros registros, la insercción se realizará en: $numRegistrosLotes Lotes, cada lote de 250 registros. ";
    return array('mensaje' => $mensaje, 'numRegistroLotes' => $numRegistrosLotes, 'contRegist' => $contRegistros);
}

function processBucle($datosArreglo2)
{
    $tableName = $datosArreglo2['tableName'];
    $conexAplication = conectarbd();
    if($tableName === 'historia_diagnostico'){
        $diangosti_his=array(
            "SELECT id, diagnostico_id, if(tipo_diagnostico IS NULL, 6, tipo_diagnostico) AS tipo_diagnostico FROM historia WHERE diagnostico_id IS NOT NULL ORDER BY id",
            "SELECT id, diagnostico_dos_id, if(tipo_diagnostico_dos IS NULL, 6, tipo_diagnostico_dos) AS tipo_diagnostico_dos FROM historia WHERE diagnostico_dos_id IS NOT NULL ORDER BY id",
            "SELECT id, diagnostico_tres_id, if(tipo_diagnostico_tres IS NULL, 6, tipo_diagnostico_tres) AS tipo_diagnostico_tres FROM historia WHERE diagnostico_tres_id IS NOT NULL ORDER BY id",
            "SELECT id, diagnostico_cuatro_id, if(tipo_diagnostico_cuatro IS NULL, 6, tipo_diagnostico_cuatro) AS tipo_diagnostico_cuatro FROM historia WHERE diagnostico_cuatro_id IS NOT NULL ORDER BY id",
            "SELECT id, diagnostico_cinco_id, if(tipo_diagnostico_cinco IS NULL, 6, tipo_diagnostico_cinco) AS tipo_diagnostico_cinco FROM historia WHERE diagnostico_cinco_id IS NOT NULL ORDER BY id",
            "SELECT id, diagnostico_seis_id, if(tipo_diagnostico_seis IS NULL, 6, tipo_diagnostico_seis) AS tipo_diagnostico_seis FROM historia WHERE diagnostico_seis_id IS NOT NULL ORDER BY id",
            "SELECT id, diagnostico_siete_id, if(tipo_diagnostico_siete IS NULL, 6, tipo_diagnostico_siete) AS tipo_diagnostico_siete FROM historia WHERE diagnostico_siete_id IS NOT NULL ORDER BY id"
        );
        $queryOri=$diangosti_his;
        $queryDes = "historia_diagnostico(historia_id, diagnostico_id, tipo_diagnostico_id)";
    }

    if($tableName === 'historia_examen_fisico'){
        $examen_fis_his = array(
            "SELECT id, 1 AS examen_fisico_id, cabeza, cabeza_texto_explicativo FROM historia WHERE cabeza IS NOT NULL",
            "SELECT id, 2 AS examen_fisico_id, ojos, ojos_texto_explicativo FROM historia WHERE ojos IS NOT NULL",
            "SELECT id, 3 AS examen_fisico_id, oidos, oidos_texto_explicativo FROM historia WHERE oidos IS NOT NULL",
            "SELECT id, 4 AS examen_fisico_id, nariz, nariz_texto_explicativo FROM historia WHERE nariz IS NOT NULL",
            "SELECT id, 5 AS examen_fisico_id, boca, boca_texto_explicativo FROM historia WHERE boca IS NOT NULL",
            "SELECT id, 6 AS examen_fisico_id, garganta, garganta_texto_explicativo FROM historia WHERE garganta IS NOT NULL",
            "SELECT id, 7 AS examen_fisico_id, cuello, cuello_texto_explicativo FROM historia WHERE cuello IS NOT NULL",
            "SELECT id, 8 AS examen_fisico_id, torax, torax_texto_explicativo FROM historia WHERE torax IS NOT NULL",
            "SELECT id, 9 AS examen_fisico_id, corazon, corazon_texto_explicativo FROM historia WHERE corazon IS NOT NULL",
            "SELECT id, 10 AS examen_fisico_id, pulmon, pulmon_texto_explicativo FROM historia WHERE pulmon IS NOT NULL",
            "SELECT id, 11 AS examen_fisico_id, abdomen, abdomen_texto_explicativo FROM historia WHERE abdomen IS NOT NULL",
            "SELECT id, 12 AS examen_fisico_id, pelvis, pelvis_texto_explicativo FROM historia WHERE pelvis IS NOT NULL",
            "SELECT id, 13 AS examen_fisico_id, tacto_rectal, tacto_rectal_texto_explicativo FROM historia WHERE tacto_rectal IS NOT NULL",
            "SELECT id, 14 AS examen_fisico_id, genitourinario, genitourinario_texto_explicativo FROM historia WHERE genitourinario IS NOT NULL",
            "SELECT id, 15 AS examen_fisico_id, extremidades_superiores, extremidades_superiores_texto_explicativo FROM historia WHERE extremidades_superiores IS NOT NULL",
            "SELECT id, 16 AS examen_fisico_id, extremidades_inferiores, extremidades_inferiores_texto_explicativo FROM historia WHERE extremidades_inferiores IS NOT NULL",
            "SELECT id, 17 AS examen_fisico_id, espalda, espalda_texto_explicativo FROM historia WHERE espalda IS NOT NULL",
            "SELECT id, 18 AS examen_fisico_id, piel, piel_texto_explicativo FROM historia WHERE piel IS NOT NULL",
            "SELECT id, 19 AS examen_fisico_id, endocrino, endocrino_texto_explicativo FROM historia WHERE endocrino IS NOT NULL",
            "SELECT id, 20 AS examen_fisico_id, sistema_nervioso, sistema_nervioso_texto_explicativo FROM historia WHERE sistema_nervioso IS NOT NULL",
        );
        $queryOri = $examen_fis_his;
        $queryDes = "historia_examen_fisico(historia_id, examen_fisico_id, estado, observacion)";
    }

    if ($tableName === 'signo_vital_dialisis'){
        $signoVitalDial = array(
            "SELECT historia_id, tension_arterial_ingreso, frecuencia_cardiaca_ingreso, frecuencia_respiratoria_ingreso, temperatura_ingreso, fecha_registro, SUBSTRING_INDEX(tension_arterial_durante_dos, '/', 1) AS diastolica, SUBSTRING_INDEX(tension_arterial_durante_dos, '/', -1) AS sistolica, hora_tension_dos, 1 AS estado FROM signos_vitales_dialisis WHERE historia_id IS NOT NULL",
            "SELECT historia_id, tension_arterial_ingreso, frecuencia_cardiaca_ingreso, frecuencia_respiratoria_ingreso, temperatura_ingreso, fecha_registro, SUBSTRING_INDEX(tension_arterial_durante_tres, '/', 1) AS diastolica, SUBSTRING_INDEX(tension_arterial_durante_tres, '/', -1) AS sistolica, hora_tension_tres, 1 AS estado FROM signos_vitales_dialisis WHERE historia_id IS NOT NULL",
            "SELECT historia_id, tension_arterial_ingreso, frecuencia_cardiaca_ingreso, frecuencia_respiratoria_ingreso, temperatura_ingreso, fecha_registro, SUBSTRING_INDEX(tension_arterial_durante_cuatro, '/', 1) AS diastolica, SUBSTRING_INDEX(tension_arterial_durante_cuatro, '/', -1) AS sistolica, hora_tension_cuatro, 1 AS estado FROM signos_vitales_dialisis WHERE historia_id IS NOT NULL",
            "SELECT historia_id, tension_arterial_ingreso, frecuencia_cardiaca_ingreso, frecuencia_respiratoria_ingreso, temperatura_ingreso, fecha_registro, SUBSTRING_INDEX(tension_arterial_durante_cinco, '/', 1) AS diastolica, SUBSTRING_INDEX(tension_arterial_durante_cinco, '/', -1) AS sistolica, hora_tension_cinco, 1 AS estado FROM signos_vitales_dialisis WHERE historia_id IS NOT NULL",
            "SELECT historia_id, tension_arterial_ingreso, frecuencia_cardiaca_ingreso, frecuencia_respiratoria_ingreso, temperatura_ingreso, fecha_registro, SUBSTRING_INDEX(tension_arterial_durante_seis, '/', 1) AS diastolica, SUBSTRING_INDEX(tension_arterial_durante_seis, '/', -1) AS sistolica, hora_tension_seis, 1 AS estado FROM signos_vitales_dialisis WHERE historia_id IS NOT NULL",
            "SELECT historia_id, tension_arterial_ingreso, frecuencia_cardiaca_ingreso, frecuencia_respiratoria_ingreso, temperatura_ingreso, fecha_registro, SUBSTRING_INDEX(tension_arterial_durante_siete, '/', 1) AS diastolica, SUBSTRING_INDEX(tension_arterial_durante_siete, '/', -1) AS sistolica, hora_tension_siete, 1 AS estado FROM signos_vitales_dialisis WHERE historia_id IS NOT NULL",
            "SELECT historia_id, tension_arterial_ingreso, frecuencia_cardiaca_ingreso, frecuencia_respiratoria_ingreso, temperatura_ingreso, fecha_registro, SUBSTRING_INDEX(tension_arterial_durante_ocho, '/', 1) AS diastolica, SUBSTRING_INDEX(tension_arterial_durante_ocho, '/', -1) AS sistolica, hora_tension_ocho, 1 AS estado FROM signos_vitales_dialisis WHERE historia_id IS NOT NULL"
        );
        $queryOri = $signoVitalDial;
        $queryDes = "signo_vital_dialisis (historia_id, tension_arterial, frecuencia_cardiaca, frecuencia_respiratoria, temperatura, created_at, sistolica, diastolica, hora, estado)";
    }

    if($tableName === 'historia_nucleo_familiar'){
        $his_nu_fa = array(
            "SELECT historia_id, familiar_nombre, familiar_parentesco, familiar_edad, familiar_estado_civil, familiar_convive, familiar_estudio, familiar_ocupacion, familiar_empresa, familiar_ingreso FROM psicologia
            WHERE (familiar_nombre IS NOT NULL OR familiar_parentesco IS NOT NULL OR familiar_edad IS NOT NULL OR familiar_estado_civil IS NOT NULL OR familiar_convive != 0 OR familiar_estudio IS NOT NULL OR familiar_ocupacion IS NOT NULL OR familiar_empresa IS NOT NULL OR familiar_ingreso IS NOT NULL) AND (familiar_nombre !='' OR familiar_parentesco != '' OR familiar_edad IS NOT NULL OR familiar_estado_civil IS NOT NULL OR familiar_estudio IS NOT NULL OR familiar_ocupacion != '' OR familiar_empresa != '' OR familiar_ingreso IS NOT NULL)",
            "SELECT historia_id, familiar_nombre_uno, familiar_parentesco_uno, familiar_edad_uno, familiar_estado_civil_uno, familiar_convive_uno, familiar_estudio_uno, familiar_ocupacion_uno, familiar_empresa_uno, familiar_ingreso_uno FROM psicologia 
            WHERE (familiar_nombre_uno IS NOT NULL OR familiar_parentesco_uno IS NOT NULL OR familiar_edad_uno IS NOT NULL OR familiar_estado_civil_uno IS NOT NULL OR familiar_convive_uno != 0 OR familiar_estudio_uno IS NOT NULL OR familiar_ocupacion_uno IS NOT NULL OR familiar_empresa_uno IS NOT NULL OR familiar_ingreso_uno IS NOT NULL) AND (familiar_nombre_uno !='' OR familiar_parentesco_uno != '' OR familiar_edad_uno IS NOT NULL OR familiar_estado_civil_uno IS NOT NULL OR familiar_estudio_uno IS NOT NULL OR familiar_ocupacion_uno != '' OR familiar_empresa_uno != '' OR familiar_ingreso_uno IS NOT NULL)"
        );
        $queryOri = $his_nu_fa;
        $queryDes = "historia_nucleo_familiar(historia_id, nombre, parentesco, edad, estado_civil, convive, estudio, ocupacion, empresa, ingresos)";
    }

    if($tableName === 'historia_trabajo_social'){
        $SoccialWorkOri = array(
            "SELECT historia_id, dependencia_padre, dependencia_madre, dependencia_hermanos, dependencia_hijos, dependencia_nietos, dependencia_otros, cual_dependencia, figura_autoridad, cual_figura_autoridad, intrafamiliares_padre, intrafamiliares_madre, intrafamiliares_conyuge, intrafamiliares_hijos, intrafamiliares_nietos, intrafamiliares_otros, familiar_padre, familiar_madre, familiar_conyuge, familiar_hijos, familiar_nietos, familiar_otros, relacion_unidad, relacion_apoyo, relacion_independencia, relacion_conflicto, relacion_estabilidad, relacion_colaboracion, relacion_lejana, cuantos_integrantes, cuantos_trabajan, cuantos_desempleados, cuantos_escolar, cuantos_ancianos, cuantos_pensionados, mascota, conviviente_compania, conviviente_conyugue, conviviente_hijos, conviviente_padres, conviviente_nietos, conviviente_otros_familiares, comparte_habitacion, barrio_emergencia, cocina_lena, agua, alcantarillado, gas, luz, otros, vivienda FROM psicologia WHERE figura_autoridad = 1",
            "SELECT historia_id, dependencia_padre, dependencia_madre, dependencia_hermanos, dependencia_hijos, dependencia_nietos, dependencia_otros, cual_dependencia, figura_autoridad, cual_figura_autoridad, intrafamiliares_padre, intrafamiliares_madre, intrafamiliares_conyuge, intrafamiliares_hijos, intrafamiliares_nietos, intrafamiliares_otros, familiar_padre, familiar_madre, familiar_conyuge, familiar_hijos, familiar_nietos, familiar_otros, relacion_unidad, relacion_apoyo, relacion_independencia, relacion_conflicto, relacion_estabilidad, relacion_colaboracion, relacion_lejana, cuantos_integrantes, cuantos_trabajan, cuantos_desempleados, cuantos_escolar, cuantos_ancianos, cuantos_pensionados, mascota, conviviente_compania, conviviente_conyugue, conviviente_hijos, conviviente_padres, conviviente_nietos, conviviente_otros_familiares, comparte_habitacion, barrio_emergencia, cocina_lena, agua, alcantarillado, gas, luz, otros, vivienda FROM psicologia WHERE figura_autoridad = 2",
            "SELECT historia_id, dependencia_padre, dependencia_madre, dependencia_hermanos, dependencia_hijos, dependencia_nietos, dependencia_otros, cual_dependencia, figura_autoridad, cual_figura_autoridad, intrafamiliares_padre, intrafamiliares_madre, intrafamiliares_conyuge, intrafamiliares_hijos, intrafamiliares_nietos, intrafamiliares_otros, familiar_padre, familiar_madre, familiar_conyuge, familiar_hijos, familiar_nietos, familiar_otros, relacion_unidad, relacion_apoyo, relacion_independencia, relacion_conflicto, relacion_estabilidad, relacion_colaboracion, relacion_lejana, cuantos_integrantes, cuantos_trabajan, cuantos_desempleados, cuantos_escolar, cuantos_ancianos, cuantos_pensionados, mascota, conviviente_compania, conviviente_conyugue, conviviente_hijos, conviviente_padres, conviviente_nietos, conviviente_otros_familiares, comparte_habitacion, barrio_emergencia, cocina_lena, agua, alcantarillado, gas, luz, otros, vivienda FROM psicologia WHERE figura_autoridad = 3",
            "SELECT historia_id, dependencia_padre, dependencia_madre, dependencia_hermanos, dependencia_hijos, dependencia_nietos, dependencia_otros, cual_dependencia, figura_autoridad, cual_figura_autoridad, intrafamiliares_padre, intrafamiliares_madre, intrafamiliares_conyuge, intrafamiliares_hijos, intrafamiliares_nietos, intrafamiliares_otros, familiar_padre, familiar_madre, familiar_conyuge, familiar_hijos, familiar_nietos, familiar_otros, relacion_unidad, relacion_apoyo, relacion_independencia, relacion_conflicto, relacion_estabilidad, relacion_colaboracion, relacion_lejana, cuantos_integrantes, cuantos_trabajan, cuantos_desempleados, cuantos_escolar, cuantos_ancianos, cuantos_pensionados, mascota, conviviente_compania, conviviente_conyugue, conviviente_hijos, conviviente_padres, conviviente_nietos, conviviente_otros_familiares, comparte_habitacion, barrio_emergencia, cocina_lena, agua, alcantarillado, gas, luz, otros, vivienda FROM psicologia WHERE figura_autoridad = 4",
            "SELECT historia_id, dependencia_padre, dependencia_madre, dependencia_hermanos, dependencia_hijos, dependencia_nietos, dependencia_otros, cual_dependencia, figura_autoridad, cual_figura_autoridad, intrafamiliares_padre, intrafamiliares_madre, intrafamiliares_conyuge, intrafamiliares_hijos, intrafamiliares_nietos, intrafamiliares_otros, familiar_padre, familiar_madre, familiar_conyuge, familiar_hijos, familiar_nietos, familiar_otros, relacion_unidad, relacion_apoyo, relacion_independencia, relacion_conflicto, relacion_estabilidad, relacion_colaboracion, relacion_lejana, cuantos_integrantes, cuantos_trabajan, cuantos_desempleados, cuantos_escolar, cuantos_ancianos, cuantos_pensionados, mascota, conviviente_compania, conviviente_conyugue, conviviente_hijos, conviviente_padres, conviviente_nietos, conviviente_otros_familiares, comparte_habitacion, barrio_emergencia, cocina_lena, agua, alcantarillado, gas, luz, otros, vivienda FROM psicologia WHERE figura_autoridad = 5",
            "SELECT historia_id, dependencia_padre, dependencia_madre, dependencia_hermanos, dependencia_hijos, dependencia_nietos, dependencia_otros, cual_dependencia, figura_autoridad, cual_figura_autoridad, intrafamiliares_padre, intrafamiliares_madre, intrafamiliares_conyuge, intrafamiliares_hijos, intrafamiliares_nietos, intrafamiliares_otros, familiar_padre, familiar_madre, familiar_conyuge, familiar_hijos, familiar_nietos, familiar_otros, relacion_unidad, relacion_apoyo, relacion_independencia, relacion_conflicto, relacion_estabilidad, relacion_colaboracion, relacion_lejana, cuantos_integrantes, cuantos_trabajan, cuantos_desempleados, cuantos_escolar, cuantos_ancianos, cuantos_pensionados, mascota, conviviente_compania, conviviente_conyugue, conviviente_hijos, conviviente_padres, conviviente_nietos, conviviente_otros_familiares, comparte_habitacion, barrio_emergencia, cocina_lena, agua, alcantarillado, gas, luz, otros, vivienda FROM psicologia WHERE figura_autoridad = 6",
            "SELECT historia_id, dependencia_padre, dependencia_madre, dependencia_hermanos, dependencia_hijos, dependencia_nietos, dependencia_otros, cual_dependencia, cual_figura_autoridad, intrafamiliares_padre, intrafamiliares_madre, intrafamiliares_conyuge, intrafamiliares_hijos, intrafamiliares_nietos, intrafamiliares_otros, familiar_padre, familiar_madre, familiar_conyuge, familiar_hijos, familiar_nietos, familiar_otros, relacion_unidad, relacion_apoyo, relacion_independencia, relacion_conflicto, relacion_estabilidad, relacion_colaboracion, relacion_lejana, cuantos_integrantes, cuantos_trabajan, cuantos_desempleados, cuantos_escolar, cuantos_ancianos, cuantos_pensionados, mascota, conviviente_compania, conviviente_conyugue, conviviente_hijos, conviviente_padres, conviviente_nietos, conviviente_otros_familiares, comparte_habitacion, barrio_emergencia, cocina_lena, agua, alcantarillado, gas, luz, otros, vivienda FROM psicologia WHERE figura_autoridad IS NULL"

        );
        $SoccialWorkDes = array(
            "historia_trabajo_social (historia_id, dependencia_economica_padre, dependencia_economica_madre, dependencia_economica_hermano, dependencia_economica_hijo, dependencia_economica_nieto, dependencia_economica_otro, dependencia_economica_otro_descripcion, figura_autoridad_padre, figura_autoridad_otro_descripcion, relacion_intrafamiliar_padre, relacion_intrafamiliar_madre, relacion_intrafamiliar_pareja, relacion_intrafamiliar_hijo, relacion_intrafamiliar_nieto, relacion_intrafamiliar_otro, comunicacion_familiar_padre, comunicacion_familiar_madre, comunicacion_familiar_pareja, comunicacion_familiar_hijo, comunicacion_familiar_nieto, comunicacion_familiar_otro, unidad, apoyo, independecia, conflicto, estabilidad, colaboracion, lejana, cuantos_integrantes, cuantos_empleados, cuantos_desempleados, cuantos_edad_escolar, cuantos_tercera_edad, cuantos_pensionados, mascota, convive, convive_pareja, convive_hijo, convive_padre, convive_nieto, convive_otro, comparte_habitacion, barrio_emergencia, cocina_madera, agua, alcantarillado, gas, energia, otros, donde_vive)",
            "historia_trabajo_social (historia_id, dependencia_economica_padre, dependencia_economica_madre, dependencia_economica_hermano, dependencia_economica_hijo, dependencia_economica_nieto, dependencia_economica_otro, dependencia_economica_otro_descripcion, figura_autoridad_madre, figura_autoridad_otro_descripcion, relacion_intrafamiliar_padre, relacion_intrafamiliar_madre, relacion_intrafamiliar_pareja, relacion_intrafamiliar_hijo, relacion_intrafamiliar_nieto, relacion_intrafamiliar_otro, comunicacion_familiar_padre, comunicacion_familiar_madre, comunicacion_familiar_pareja, comunicacion_familiar_hijo, comunicacion_familiar_nieto, comunicacion_familiar_otro, unidad, apoyo, independecia, conflicto, estabilidad, colaboracion, lejana, cuantos_integrantes, cuantos_empleados, cuantos_desempleados, cuantos_edad_escolar, cuantos_tercera_edad, cuantos_pensionados, mascota, convive, convive_pareja, convive_hijo, convive_padre, convive_nieto, convive_otro, comparte_habitacion, barrio_emergencia, cocina_madera, agua, alcantarillado, gas, energia, otros, donde_vive)",
            "historia_trabajo_social (historia_id, dependencia_economica_padre, dependencia_economica_madre, dependencia_economica_hermano, dependencia_economica_hijo, dependencia_economica_nieto, dependencia_economica_otro, dependencia_economica_otro_descripcion, figura_autoridad_hermano, figura_autoridad_otro_descripcion, relacion_intrafamiliar_padre, relacion_intrafamiliar_madre, relacion_intrafamiliar_pareja, relacion_intrafamiliar_hijo, relacion_intrafamiliar_nieto, relacion_intrafamiliar_otro, comunicacion_familiar_padre, comunicacion_familiar_madre, comunicacion_familiar_pareja, comunicacion_familiar_hijo, comunicacion_familiar_nieto, comunicacion_familiar_otro, unidad, apoyo, independecia, conflicto, estabilidad, colaboracion, lejana, cuantos_integrantes, cuantos_empleados, cuantos_desempleados, cuantos_edad_escolar, cuantos_tercera_edad, cuantos_pensionados, mascota, convive, convive_pareja, convive_hijo, convive_padre, convive_nieto, convive_otro, comparte_habitacion, barrio_emergencia, cocina_madera, agua, alcantarillado, gas, energia, otros, donde_vive)",
            "historia_trabajo_social (historia_id, dependencia_economica_padre, dependencia_economica_madre, dependencia_economica_hermano, dependencia_economica_hijo, dependencia_economica_nieto, dependencia_economica_otro, dependencia_economica_otro_descripcion, figura_autoridad_hijo, figura_autoridad_otro_descripcion, relacion_intrafamiliar_padre, relacion_intrafamiliar_madre, relacion_intrafamiliar_pareja, relacion_intrafamiliar_hijo, relacion_intrafamiliar_nieto, relacion_intrafamiliar_otro, comunicacion_familiar_padre, comunicacion_familiar_madre, comunicacion_familiar_pareja, comunicacion_familiar_hijo, comunicacion_familiar_nieto, comunicacion_familiar_otro, unidad, apoyo, independecia, conflicto, estabilidad, colaboracion, lejana, cuantos_integrantes, cuantos_empleados, cuantos_desempleados, cuantos_edad_escolar, cuantos_tercera_edad, cuantos_pensionados, mascota, convive, convive_pareja, convive_hijo, convive_padre, convive_nieto, convive_otro, comparte_habitacion, barrio_emergencia, cocina_madera, agua, alcantarillado, gas, energia, otros, donde_vive)",
            "historia_trabajo_social (historia_id, dependencia_economica_padre, dependencia_economica_madre, dependencia_economica_hermano, dependencia_economica_hijo, dependencia_economica_nieto, dependencia_economica_otro, dependencia_economica_otro_descripcion, figura_autoridad_nieto, figura_autoridad_otro_descripcion, relacion_intrafamiliar_padre, relacion_intrafamiliar_madre, relacion_intrafamiliar_pareja, relacion_intrafamiliar_hijo, relacion_intrafamiliar_nieto, relacion_intrafamiliar_otro, comunicacion_familiar_padre, comunicacion_familiar_madre, comunicacion_familiar_pareja, comunicacion_familiar_hijo, comunicacion_familiar_nieto, comunicacion_familiar_otro, unidad, apoyo, independecia, conflicto, estabilidad, colaboracion, lejana, cuantos_integrantes, cuantos_empleados, cuantos_desempleados, cuantos_edad_escolar, cuantos_tercera_edad, cuantos_pensionados, mascota, convive, convive_pareja, convive_hijo, convive_padre, convive_nieto, convive_otro, comparte_habitacion, barrio_emergencia, cocina_madera, agua, alcantarillado, gas, energia, otros, donde_vive)",
            "historia_trabajo_social (historia_id, dependencia_economica_padre, dependencia_economica_madre, dependencia_economica_hermano, dependencia_economica_hijo, dependencia_economica_nieto, dependencia_economica_otro, dependencia_economica_otro_descripcion, figura_autoridad_otro, figura_autoridad_otro_descripcion, relacion_intrafamiliar_padre, relacion_intrafamiliar_madre, relacion_intrafamiliar_pareja, relacion_intrafamiliar_hijo, relacion_intrafamiliar_nieto, relacion_intrafamiliar_otro, comunicacion_familiar_padre, comunicacion_familiar_madre, comunicacion_familiar_pareja, comunicacion_familiar_hijo, comunicacion_familiar_nieto, comunicacion_familiar_otro, unidad, apoyo, independecia, conflicto, estabilidad, colaboracion, lejana, cuantos_integrantes, cuantos_empleados, cuantos_desempleados, cuantos_edad_escolar, cuantos_tercera_edad, cuantos_pensionados, mascota, convive, convive_pareja, convive_hijo, convive_padre, convive_nieto, convive_otro, comparte_habitacion, barrio_emergencia, cocina_madera, agua, alcantarillado, gas, energia, otros, donde_vive)",
            "historia_trabajo_social (historia_id, dependencia_economica_padre, dependencia_economica_madre, dependencia_economica_hermano, dependencia_economica_hijo, dependencia_economica_nieto, dependencia_economica_otro, dependencia_economica_otro_descripcion, figura_autoridad_otro_descripcion, relacion_intrafamiliar_padre, relacion_intrafamiliar_madre, relacion_intrafamiliar_pareja, relacion_intrafamiliar_hijo, relacion_intrafamiliar_nieto, relacion_intrafamiliar_otro, comunicacion_familiar_padre, comunicacion_familiar_madre, comunicacion_familiar_pareja, comunicacion_familiar_hijo, comunicacion_familiar_nieto, comunicacion_familiar_otro, unidad, apoyo, independecia, conflicto, estabilidad, colaboracion, lejana, cuantos_integrantes, cuantos_empleados, cuantos_desempleados, cuantos_edad_escolar, cuantos_tercera_edad, cuantos_pensionados, mascota, convive, convive_pareja, convive_hijo, convive_padre, convive_nieto, convive_otro, comparte_habitacion, barrio_emergencia, cocina_madera, agua, alcantarillado, gas, energia, otros, donde_vive)"
        );
        $queryOri = $SoccialWorkOri;
        $queryDes = $SoccialWorkDes;
    }
        
    $count = COUNT($queryOri) - 1;
    $mensajeArray = array();
    $sqlcheckpoint = "SELECT indexHis FROM checkpoint WHERE tableName = '$tableName'";
    $statementCheck = $conexAplication->query($sqlcheckpoint);
    $resultCheckpoint = $statementCheck->fetchAll(PDO::FETCH_ASSOC);
    $indexAntEspecial = intval($resultCheckpoint[0]['indexHis']);
    
    if($indexAntEspecial == $count){
        $mensaje = "ERROR: No se puede realizar la migración de esta tabla debido a que ya se habia realizado antes";
        return $mensaje;
    }else{
            
        for( $i = $indexAntEspecial; $i <= $count; $i++ ){

            if($tableName === 'historia_trabajo_social'){
                $datosArreglo = array(  "queryOri" => $queryOri[$i],
                                        "queryDes" => $queryDes[$i],
                                        "tableName" => $tableName
                );
                
                $sql = "UPDATE checkpoint SET indexHis = $i, lastIndex = 0 WHERE tableName = '".$tableName."'";
                $conexAplication->exec($sql);
                $mensajeResp = processMigration($datosArreglo);
                array_push($mensajeArray, $mensajeResp);
                echo $i." Ciclo terminado. ";

            }else{

                $datosArreglo = array(  "queryOri" => $queryOri[$i],
                                        "queryDes" => $queryDes,
                                        "tableName" => $tableName
                );
                
                $sql = "UPDATE checkpoint SET indexHis = $i, lastIndex = 0 WHERE tableName = '".$tableName."'";
                $conexAplication->exec($sql);
                $mensajeResp = processMigration($datosArreglo);
                array_push($mensajeArray, $mensajeResp);
                echo $i." Ciclo terminado. ";
            }
        };
        $mensaje = " MIGRACIÓN POR CICLOS TERMINADA CON EXITO. ";
        return $mensaje;
    }
}

function processIndices() {
    $migracion = $_POST['migracion'];
    $conexDestino = conectarBdDestino($migracion);

    $queryBarthel = "SELECT historia_id FROM test_escala WHERE (comer_barthel IS NOT NULL OR trasladarse_entre_silla_cama_barthel IS NOT NULL OR aseo_personal_barthel IS NOT NULL OR uso_retrete_barthel IS NOT NULL OR bañarse_ducharse_barthel IS NOT NULL OR desplazarse_barthel IS NOT NULL OR subir_bajar_escaleras_barthel IS NOT NULL OR vestirse_desvestirse_barthel IS NOT NULL OR control_heces_barthel IS NOT NULL OR control_orina_barthel IS NOT NULL OR sumatorio_total_barthel IS NOT NULL OR clasificacion_barthel IS NOT NULL) AND (comer_barthel != 0 OR trasladarse_entre_silla_cama_barthel != 0 OR aseo_personal_barthel != 0 OR uso_retrete_barthel != 0 OR bañarse_ducharse_barthel != 0 OR desplazarse_barthel != 0 OR subir_bajar_escaleras_barthel != 0 OR vestirse_desvestirse_barthel != 0 OR control_heces_barthel != 0 OR control_orina_barthel != 0 OR sumatorio_total_barthel != 0 OR clasificacion_barthel != 0)";
    $statement = $conexDestino->query($queryBarthel);
    $resultBarthel = $statement->fetchAll(PDO::FETCH_ASSOC);

    $mensajeBarthel = "";
    $errorBarthel = $statement->errorInfo(); // Obtener información de error

    if (!empty($errorBarthel[2])) {
        $mensajeBarthel = "Error de base de datos: " . $errorBarthel[2];
    } elseif (empty($resultBarthel)) {
        $mensajeBarthel = "En los campos de Barthel no se encontró ningún resultado";
    } else {
        foreach ($resultBarthel as $row) {
            $historia_id = $row['historia_id'];

            // Debes ejecutar una declaración SQL de actualización para cada historia_id
            $updateQuery = "UPDATE historia SET indice_barthel = 1 WHERE id = :historia_id";
            $updateStatement = $conexDestino->prepare($updateQuery);
            $updateStatement->bindParam(':historia_id', $historia_id, PDO::PARAM_INT);

            // Ejecutar la declaración de actualización
            $updateStatement->execute();
        }

        // Mensaje de éxito o información adicional si es necesario
        $mensajeBarthel = "Se actualizó el campo indice_barthel a 1 para las historias encontradas.";
    }

    $queryEscala_Yesavage = "SELECT historia_id FROM test_escala WHERE satisfecho_yesavage =1 OR intereses_actividades_yesavage =1 OR vida_vacia_yesavage =1 OR aburrido_yesavage =1 OR buen_animo_yesavage =1 OR preocupado_teme_yesavage =1 OR feliz_yesavage =1 OR desamparado_yesavage =1 OR quedarse_casa_yesavage =1 OR problemas_memoria_yesavage =1 OR maravilloso_estar_vivo_yesavage =1 OR inutil_despreciable_yesavage =1 OR lleno_energia_yesavage =1 OR sin_esperanza_yesavage =1 OR otras_personas_estan_mejor_yesavage =1 OR sumatorio_total_yesavage =1 OR clasificacion_yesavage =1";
    $statement = $conexDestino->query($queryEscala_Yesavage);
    $resultEscala_Yesavage = $statement->fetchAll(PDO::FETCH_ASSOC);
    $mensajeEscala_Yesavage = "";
    $errorEscala_Yesavage = $statement->errorInfo(); // Obtener información de error

    if (!empty($errorEscala_Yesavage[2])) {
        $mensajeEscala_Yesavage = "Error de base de datos: " . $errorEscala_Yesavage[2];
    } elseif (empty($resultEscala_Yesavage)) {
        $mensajeEscala_Yesavage = "En los campos de Escala Yesavage no se encontró ningún resultado";
    } else {
        foreach ($resultEscala_Yesavage as $row) {
            $historia_id = $row['historia_id'];

            // Debes ejecutar una declaración SQL de actualización para cada historia_id
            $updateQuery = "UPDATE historia SET escala_yesavage = 1 WHERE id = :historia_id";
            $updateStatement = $conexDestino->prepare($updateQuery);
            $updateStatement->bindParam(':historia_id', $historia_id, PDO::PARAM_INT);

            // Ejecutar la declaración de actualización
            $updateStatement->execute();
        }

        // Mensaje de éxito o información adicional si es necesario
        $mensajeEscala_Yesavage = "Se actualizó el campo escala_yesavage a 1 para las historias encontradas.";
    }

    // Repite el mismo proceso para las otras consultas

    $queryFolstein ="SELECT historia_id FROM test_escala WHERE anio_actual_folstein = 1 OR estacion_actual_folstein = 1 OR dia_mes_actual_folstein = 1 OR mes_actual_folstein = 1 OR dia_semana_actual_folstein = 1 OR lugar_hospital_actual_folstein = 1 OR planta_piso_actual_folstein = 1 OR pueblo_ciudad_actual_folstein = 1 OR provincia_municipio_actual_folstein = 1 OR pais_actual_folstein = 1 OR memoria_folstein = 1 OR atencion_calculo_folstein = 1 OR fijacion_folstein = 1 OR sumatorio_total_folstein = 1 OR clasificacion_folstein = 1";
    $statement = $conexDestino->query($queryFolstein);
    $resultFolstein = $statement->fetchAll(PDO::FETCH_ASSOC);
    $mensajeFolstein = "";
    $errorFolstein = $statement->errorInfo(); // Obtener información de error

    if (!empty($errorFolstein[2])) {
        $mensajeFolstein = "Error de base de datos: " . $errorFolstein[2];
    } elseif (empty($resultFolstein)){
        $mensajeFolstein = "En los campos de Folstein no se encontró ningún resultado";
    } else {
        foreach ($resultFolstein as $row) {
            $historia_id = $row["historia_id"];

            // Debes ejecutar una declaración SQL de actualización para cada historia_id
            $updateQuery = "UPDATE historia SET mmse_folstein = 1 WHERE id = :historia_id";
            $updateStatement = $conexDestino->prepare($updateQuery);
            $updateStatement->bindParam(':historia_id', $historia_id, PDO::PARAM_INT);

            // Ejecutar la declaración de actualización
            $updateStatement->execute();
        }

        // Mensaje de éxito o información adicional si es necesario
        $mensajeFolstein = "Se actualizó el campo mmse_folstein a 1 para las historias encontradas.";
    }

    $queryCharlson = "SELECT historia_id FROM test_escala WHERE supervivencia_estimada_charlson != 0 OR supervivencia_estimada_charlson IS NOT NULL";
    $statement = $conexDestino->query($queryCharlson);
    $resultCharlson = $statement->fetchAll(PDO::FETCH_ASSOC);
    $mensajeCharlson = "";
    $errorCharlson = $statement->errorInfo(); // Obtener información de error

    if (!empty($errorCharlson[2])) {
        $mensajeCharlson = "Error de base de datos: " . $errorCharlson[2];
    } elseif (empty($resultCharlson)){
        $mensajeCharlson = "En los campos de indice charlson no se encontró ningún resultado";
    } else {
        foreach ($resultCharlson as $row) {
            $historia_id = $row["historia_id"];

            // Debes ejecutar una declaración SQL de actualización para cada historia_id
            $updateQuery = "UPDATE historia SET indice_charlson = 1 WHERE id = :historia_id";
            $updateStatement = $conexDestino->prepare($updateQuery);
            $updateStatement->bindParam(':historia_id', $historia_id, PDO::PARAM_INT);

            // Ejecutar la declaración de actualización
            $updateStatement->execute();
        }

        // Mensaje de éxito o información adicional si es necesario
        $mensajeCharlson = "Se actualizó el campo indice_charlson a 1 para las historias encontradas.";
    }

    $queryKarnofsky = "SELECT historia_id FROM test_escala WHERE escala_karnofsky = 1";
    $statement = $conexDestino->query($queryKarnofsky);
    $resultKarnofsky = $statement->fetchAll(PDO::FETCH_ASSOC);
    $mensajeKarnofsky = "";
    $errorKarnofsky = $statement->errorInfo(); // Obtener información de error

    if (!empty($errorKarnofsky[2])) {
        $mensajeKarnofsky = "Error de base de datos: " . $errorKarnofsky[2];
    } elseif (empty($resultKanofsky)){
        $mensajeCharlson = "En los campos de escala karnofsky no se encontró ningún resultado";
    } else {
        foreach ($resultKarnofsky as $row) {
            $historia_id = $row["historia_id"];

            // Debes ejecutar una declaración SQL de actualización para cada historia_id
            $updateQuery = "UPDATE historia SET escala_karnofsky = 1 WHERE id = :historia_id";
            $updateStatement = $conexDestino->prepare($updateQuery);
            $updateStatement->bindParam(':historia_id', $historia_id, PDO::PARAM_INT);

            // Ejecutar la declaración de actualización
            $updateStatement->execute();
        }

        // Mensaje de éxito o información adicional si es necesario
        $mensajeKarnofsky = "Se actualizó el campo escala_karnofsky a 1 para las historias encontradas.";
    }

    $queryMorinsky = "SELECT historia_id FROM test_escala WHERE olvida_tomar_medicacion = 1  OR toma_horas_indicadas = 1 OR deja_tomar_bien = 1 OR deja_tomar_mal = 1";
    $statement = $conexDestino->query($queryMorinsky);
    $resultMorinsky = $statement->fetchAll(PDO::FETCH_ASSOC);
    $mensajeMorinsky = "";
    $errorMorinsky = $statement->errorInfo(); // Obtener información de error

    if (!empty($errorMorinsky[2])) {
        $mensajeMorinsky = "Error de base de datos: " . $errorMorinsky[2];
    } elseif (empty($resultMorinsky)){
        $mensajeMorinsky = "En los campos de Test Morinsky no se encontró ningún resultado";
    } else {
        foreach ($resultMorinsky as $row) {
            $historia_id = $row["historia_id"];

            // Debes ejecutar una declaración SQL de actualización para cada historia_id
            $updateQuery = "UPDATE historia SET test_morinsky = 1 WHERE id = :historia_id";
            $updateStatement = $conexDestino->prepare($updateQuery);
            $updateStatement->bindParam(':historia_id', $historia_id, PDO::PARAM_INT);

            // Ejecutar la declaración de actualización
            $updateStatement->execute();
        }

        // Mensaje de éxito o información adicional si es necesario
        $mensajeMorinsky = "Se actualizó el campo test_morinsky a 1 para las historias encontradas.";
    }

    $queryComorbilidad = "SELECT historia_id FROM historia_dialisis WHERE enfermedad_neoplasica = 1 OR menor_cinco_anios_evolucion = 1 OR menor_dos_anios_evolucion = 1 OR tumores_localizados = 1";
    $statement = $conexDestino->query($queryComorbilidad);
    $resultComorbilidad = $statement->fetchAll(PDO::FETCH_ASSOC);
    $mensajeComorbilidad = "";
    $errorComorbilidad = $statement->errorInfo(); // Obtener información de error

    if (!empty($errorComorbilidad[2])) {
        $mensajeComorbilidad = "Error de base de datos: " . $errorComorbilidad[2];
    } elseif (empty($resultComorbilidad)){
        $mensajeComorbilidad = "En los campos de Comorbilidad no se encontró ningún resultado";
    } else {
        foreach ($resultComorbilidad as $row) {
            $historia_id = $row["historia_id"];

            // Debes ejecutar una declaración SQL de actualización para cada historia_id
            $updateQuery = "UPDATE historia SET comorbilidad = 1 WHERE id = :historia_id";
            $updateStatement = $conexDestino->prepare($updateQuery);
            $updateStatement->bindParam(':historia_id', $historia_id, PDO::PARAM_INT);

            // Ejecutar la declaración de actualización
            $updateStatement->execute();
        }

        // Mensaje de éxito o información adicional si es necesario
        $mensajeComorbilidad = "Se actualizó el campo comorbilidad a 1 para las historias encontradas.";
    }

    $queryCovid = "SELECT historia_id FROM covid WHERE fuera_pais = 1 OR cerca_persona_covid = 1 OR trabajador_salud = 1 OR paciente_hospitalizado = 1 OR fiebre = 1 OR tos = 1 OR dolor_garganta = 1 OR fatiga = 1 OR dificultad_respiratoria = 1";
    $statement = $conexDestino->query($queryCovid);
    $resultCovid = $statement->fetchAll(PDO::FETCH_ASSOC);
    $mensajeCovid = "";
    $errorCovid = $statement->errorInfo(); // Obtener información de error

    if (!empty($errorCovid[2])) {
        $mensajeCovid = "Error de base de datos: " . $errorCovid[2];
    } elseif (empty($resultCovid)){
        $mensajeCovid = "En los campos de Covid no se encontró ningún resultado";
    } else {
        foreach ($resultCovid as $row) {
            $historia_id = $row["historia_id"];

            // Debes ejecutar una declaración SQL de actualización para cada historia_id
            $updateQuery = "UPDATE historia SET test_covid = 1 WHERE id = :historia_id";
            $updateStatement = $conexDestino->prepare($updateQuery);
            $updateStatement->bindParam(':historia_id', $historia_id, PDO::PARAM_INT);

            // Ejecutar la declaración de actualización
            $updateStatement->execute();
        }

        // Mensaje de éxito o información adicional si es necesario
        $mensajeCovid = "Se actualizó el campo test_covid a 1 para las historias encontradas.";
    }


    $mensaje = array(
        "mensajeBarthel" => $mensajeBarthel,
        "mensajeEscala_Yesavage" => $mensajeEscala_Yesavage,
        "mensajeFolstein" => $mensajeFolstein,
        "mensajeCharlson" => $mensajeCharlson,
        "mensajeKarnofsky" => $mensajeKarnofsky,
        "mensajeMorinsky" => $mensajeMorinsky,
        "mensajeComorbilidad" => $mensajeComorbilidad,
        "mensajeCovid" => $mensajeCovid,
        
    );
    
    return $mensaje['mensajeBarthel']. " ===> ". $mensaje['mensajeEscala_Yesavage']. " ===> ". $mensaje['mensajeFolstein']. " ===> ". $mensaje['mensajeCharlson']. " ===> ". $mensaje['mensajeKarnofsky']. " ===> ". $mensaje['mensajeMorinsky']. " ===> ". $mensaje['mensajeComorbilidad']. " ===> ". $mensaje['mensajeCovid'];
}


/* ************************************************************************************************************** */

/*Plantilla para realizar la migración este es el modelo básico que se utilizará para trabajar */
function processMigration($datosArreglo) 
{
    $migracion =$_POST['migracion'];
    $queryOri = $datosArreglo["queryOri"];
    $conexOrigen = conectarBdOrigen($migracion);
    $conexDestino = conectarBdDestino($migracion);
    $tableName = $datosArreglo["tableName"];
    try {
        if ($tableName === 'historia_procedimiento') {
            $queryprepara = $datosArreglo["queryPrepara"];
            $queryProc = $queryprepara;
            $conexOrigen->exec($queryProc);
        }

        $query = $queryOri;// Traemos la consulta en forma de array desde el switch para que sea dinamico
        $statement = $conexOrigen->query($query);
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);
        

        if (empty($result)) {
            $mensaje = "ERROR: no hay datos en la tabla. La migración no se puede realizar.";
            return $mensaje;
        }

        if($tableName === 'usuario'){
            $count = 0;
            foreach ($result as $key => $value) {
                $nombre = explode(' ', $value['nombre']);
                if(COUNT($nombre) == 1){
                    $nombres = $nombre[0];
                    $apellidos = '';
                    $result[$count]['nombresG']=$nombres;
                    $result[$count]['apellidosG']=$apellidos;
                }
                else if(COUNT($nombre) == 2){
                    $nombres = $nombre[0];
                    $apellidos = $nombre[1];
                    $result[$count]['nombresG']=$nombres;
                    $result[$count]['apellidosG']=$apellidos;
                }
                else if(COUNT($nombre) == 3){
                    $nombres = $nombre[0];
                    $apellidos = $nombre[1]. ' ' .$nombre[2];
                    $result[$count]['nombresG']=$nombres;
                    $result[$count]['apellidosG']=$apellidos;
                }
                else if (COUNT($nombre) == 4){
                    $nombres = $nombre[0]. ' ' .$nombre[1];
                    $apellidos = $nombre[2]. ' ' .$nombre[3];
                    $result[$count]['nombresG']=$nombres;
                    $result[$count]['apellidosG']=$apellidos;
                }else {
                    $result[$count]['nombresG']='';
                    $result[$count]['apellidosG']='';
                }
                unset($result[$count]['nombre']);
                unset($nombre);
                $count = $count+1;
            }
        }

    } catch (\Throwable $th) {
        
        throw $th;
    }
    // Paso a la funcion procesador el resultado de la recuperación 
    $registros = procesador($result);// ** Aqui estoy devolviendo el resultado del proceso de transformación de datos
    //paso por la funcion contador para realizar los diferentes mensajes al front
    $contador = contador($registros); //transformar el mensaje en un array para utilizar las variablen en el for...
    $numRegistrosLotes = $contador['numRegistroLotes'];
    $numRegistrosLotes = $numRegistrosLotes - 1;
    $queryDest = $datosArreglo["queryDes"];
    $conexAplication = conectarbd();
    echo $tableName. " ". $contador["mensaje"] . " " ; //modificar esto para que de un mensaje mas coherente ⚠️
    // Bloque de codigo para trae el indice que se guardo en el checkpoint para que realice la migración desde ese indice
    $sqlcheckpoint = "SELECT lastIndex FROM checkpoint WHERE tableName = '$tableName'";
    $statementCheck = $conexAplication->query($sqlcheckpoint);
    $resultCheckpoint = $statementCheck->fetchAll(PDO::FETCH_ASSOC);
    $indexAntEspecial = intval($resultCheckpoint[0]['lastIndex']);
    $indexAntEspecial = $indexAntEspecial - 1;
    if($indexAntEspecial === $numRegistrosLotes){
        $mensaje = "ERROR: No se puede realizar la migración de esta tabla debido a que ya se habia realizado antes";
        return $mensaje;
    }else{
        $indexAntEspecial = $indexAntEspecial + 1;
    }
    
    try {
        for ($j = $indexAntEspecial; $j <=  $numRegistrosLotes; $j++) {
            $conexDestino->beginTransaction(); 
            $sqlValues = $registros[$j];
            $sql = "INSERT INTO $queryDest VALUES $sqlValues";
            $conexDestino->exec($sql);
            $con = $j + 1;
            echo " Se insertó el lote: $con" . PHP_EOL;
            // Aquí se hace la inserción del índice...
            $aplication = "UPDATE checkpoint SET lastIndex = $con WHERE tableName = '$tableName'";
            $conexAplication->exec($aplication);
            
            $conexDestino->commit();
        }
        $mensaje = "¡Se realizó la migración con éxito...!";
        return $mensaje;
    } catch (\Throwable $th) {
        /* ***************************************************** */
        $conexDestino->rollBack();
        // Obtener el número de registro del rollback
        $rollbackRegistro = $j + 1;
        echo "Error se hará rollback al lote #$rollbackRegistro, a continuación se muestra el mensaje del servidor *** $th "; 
        $recu = "SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'nesys_anterior' AND TABLE_NAME = '$tableName'";
        $resultado = $conexDestino->query($recu);
        if ($resultado) {
            $fila = $resultado->fetch(PDO::FETCH_ASSOC);
            $autoIncrement = $fila['AUTO_INCREMENT'];
            echo "El ultimo id que se inserto fue:  " . $autoIncrement;
        } else {
            echo "Error al ejecutar la consulta.";
        }
        echo "Este fue el ultimo lote que tuvo el error " . $sql;
    } 
}

/* Se va a agregar dos registros a la tabla cobertura */
function addRecords()
{
    $migracion = $_POST['migracion'];
    $conexOrigen = conectarBdOrigen($migracion);

    // Agregar los registros en la tabla de origen
    $newRecords = array(
        array("id" => 6, "descripcion" => "EXCEPCIÓN"),
        array("id" => 7, "descripcion" => "ESPECIAL"),
    );

    foreach ($newRecords as $registro) {
        $id = $registro["id"];
        $descripcion = $registro["descripcion"];
        $query = "INSERT INTO cobertura (id, descripcion) VALUES ('$id', '$descripcion')";
        $result = $conexOrigen->exec($query);
        if (!$result) {
            return false; // Indicar fallo
        }
    }
    
    return true; // Indicar éxito
}

function deleteRecords() 
{
    $migracion = $_POST['migracion'];
    $conexOrigen = conectarBdOrigen($migracion);

    // Eliminar los registros agregados anteriormente
    $registrosNuevos = array(6, 7);

    foreach ($registrosNuevos as $id) {
        $query = "DELETE FROM cobertura WHERE id = '$id'";
        $result = $conexOrigen->exec($query);
        if (!$result) {
            return false; // Indicar fallo
        }
    }
    return true; // Indicar éxito
}