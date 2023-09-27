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
                "queryOri" => "SELECT id, descripcion, activo FROM antecedente",
                "queryDes" => "antecedente_especial (id, descripcion, estado)",
                "tableName"=> "antecedente_especial"
            );
            $mensaje =  processMigration($datosArreglo);
            break;

        case "bodegas":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, ubicacion, 'No hay descripción' AS activa FROM bodega",
                "queryDes" => "bodegas (id, nombre, direccion, descripcion)",
                "tableName"=> "bodegas",
            );
            $mensaje =  processMigration($datosArreglo);
            break;

        case "categorias":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, activo FROM categoria",
                "queryDes" => "categorias (id, descripcion, nombre)",
                "tableName"=> "categorias",
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

        case"departamentos":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, id AS codigo FROM departamento",
                "queryDes" => "departamentos (id, nombre, codigo)",
                "tableName" => "departamentos"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"especialidad":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, activo FROM especialidad",
                "queryDes" => "especialidad (id, nombre, estado)",
                "tableName" => "especialidad"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"estadio":
            $datosArreglo = array (
                "queryOri" =>"SELECT id, estadio, activa FROM estadio",
                "queryDes" => "estadio (id, nombre, estado)",
                "tableName" => "estadio"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"insumo":
            $datosArreglo = array (
                "queryOri" =>"SELECT id, codigo, descripcion, estado FROM insumo",
                "queryDes" => "insumo (id, codigo, descripcion, estado)",
                "tableName" => "insumo"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"medicamentos":
            $datosArreglo = array (
                "queryOri" =>"SELECT id, codigo, descripcion_codigo_atc, principio_activo, concentracion, forma_farmaceutica, indicaciones, efecto_esperado, efecto_secundario, efectos_adversos, pos, 'insulina', activo FROM medicamento",
                "queryDes" =>"medicamentos (id, codigo, descripcion_codigo_atc, principio_activo, concentracion, forma_farmaceutica, indicaciones, efecto_esperado, efecto_secundario, efectos_adversos, pos, insulina, estado)",
                "tableName" => "medicamentos"
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

        case"permisos":
            $datosArreglo = array (
                "queryOri" =>"SELECT id, name, description, 'web' AS guard_name, created_at, updated_at FROM sf_guard_permission",
                "queryDes" => "permisos (id, nombre, descripcion, guard_name, created_at, updated_at)",
                "tableName" => "permisos"
            );
            $mensaje = processMigration($datosArreglo);
            break;

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

        case "servicio":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, activo FROM servicio",
                "queryDes" => "servicio (id, descripcion, estado)",
                "tableName" => "servicio"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "servicio_remision":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, activo FROM servicio_remision",
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
                "queryOri" => "SELECT id, codigo, descripcion, if(genero = 0, 3, genero) AS genero, edad_inicio, edad_fin, patologia, grupo_mortalidad, capitulo, id_sugrupo, sivigila, activa FROM diagnostico",
                "queryDes" => "diagnostico (id, codigo, descripcion, genero_id, edad_inicio, edad_fin, patologia, grupo_mortalidad, capitulo, subgrupo_id, sivigila, estado)",
                "tableName"=> "diagnostico"
            ];
            $mensaje =  processMigration($datosArreglo);
            break;

        case"municipios":
            $datosArreglo = array(
                "queryOri" => "SELECT id, departamento_id, descripcion, codigo FROM municipio",
                "queryDes" => "municipios (id, departamento_id, nombre, codigo)",
                "tableName" => "municipios"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case"programa":
            $datosArreglo = array(
                "queryOri" => "SELECT id, descripcion, duracion_meses, cita_cada_cuando_en_meses, estadio_id, activa FROM programacion ",
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
/* -------------------- TABLAS 3er NIVEL ---------------------------------- */

        case"cups":
            $datosArreglo = array(
                "queryOri" => "SELECT id, codigo, descripcion, '3' AS genero, edad_inicio, edad_fin, archivo_rips, procedimiento, tipo_procedimiento, finalidad, pos, repetido, ambito, estancia, unico, activo FROM cups",
                "queryDes" => "cups (id, codigo, descripcion, genero_id, edad_inicio, edad_fin, archivo_rips, procedimiento, tipo_procedimiento_id, finalidad, pos, repetidos, ambito, estancia, unico, estado)",
                "tableName" => "cups",
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "entidad":
            $datosArreglo = array(
                "queryOri" => "SELECT id, codigo_eps, nit, nombre, tipo_contratacion, tiempo_cita, valor_consulta, requiere_autorizacion, cobertura_id, solicitud_por_referencia, activa, citas_internet_mes, 'logo.png' AS logo, codigo_ihospital, '0' AS telefono, '0' AS direccion FROM entidad",
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
                                        SUBSTRING_INDEX(nombres, ' ', -1) AS segundo_nombre,
                                        SUBSTRING_INDEX(apellidos, ' ', 1) AS primer_apellido,
                                        SUBSTRING_INDEX(apellidos, ' ', -1) AS segundo_apellido,  
                                        fecha_nacimiento, genero, raza, condicion, municipio_id, ubicacion, estado_civil, codigo_nivel_educativo, direccion, 
                                        CASE 
                                            WHEN zona = 'U' THEN 1
                                            WHEN zona = 'R' THEN 2
                                        END AS zona, estrato, telefono, celular, correo_electronico, rh, estadio_id, acompanante_nombres, acompanante_apellidos, acompanante_telefono FROM paciente",
                "queryDes" => "paciente (id, tipo_documento_id, numero_documento, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, genero_id, etnia_id, condicion_id, municipio_id, ubicacion, estado_civil, codigo_nivel_educativo, direccion, zona, estrato, telefono, celular, correo_electronico, rh, estadio_id, acompañante_nombres, acompañante_apellidos, acompañante_telefono)",
                "tableName" => "paciente"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "plan":
            $datosArreglo = array (
                "queryOri" => "SELECT id, descripcion, tipo_contratacion, programacion_id, valor_paquete, monto_maximo, activa FROM plan",
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
                                            numero_documento, codigo_habilitacion, nombre, direccion, cuenta_de_cobro, representante_legal, telefono, municipio_id, logo, activa, resolucion_id FROM prestador",
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
                "queryOri" => "SELECT id, motivo_consulta, enfermedad_actual, causa_externa, analisis_y_conducta, conducta, recomendaciones, formula_medica, dias_incapacidad, fecha_incapacidad, orden_de_cirugia, orden_de_medicamentos, ordenes_medicas, solicitud_de_insumos, tasa_de_filtracion, test_findrisk, barthel, yesavage, folstein, mala_adherencia_tratamientos, desistimiento_terapia_dialitica, tension_arterial, frecuencia_cardiaca, frecuencia_respiratoria, temperatura, peso, talla, imc, perimetro_abdominal, cintura_pelvica, estadio_id, red_apoyo_familiar_social FROM historia",
                "queryDes" => "historia (id, motivo_consulta, enfermedad_actual, causa_externa_id, analisis_y_conducta, conducta, recomendaciones, formula_medica, dias_incapacidad, fecha_incapacidad, orden_cirugia, orden_remision, ordenes_medicas, solicitud_insumos, tasa_filtracion, test_findrisk, indice_barthel, escala_yesavage, mmse_folstein, mala_adherencia, desistimiento_terapia_dialitica, tension_arterial, frecuencia_cardiaca, frecuencia_respiratoria, temperatura, peso, talla, imc, perimetro_abdominal, cintura_pelvica, estadio_id, red_apoyo)",
                "tableName" => "historia"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "laboratorio":
            $datosArreglo = array(
                "queryOri" => "SELECT id, nombre, tipo, categoria, unidad, grafico, valor_maximo, activa, valor_normal_minimo, valor_normal_maximo, valor_minimo, cups_id FROM resultado", 
                "queryDes" => "laboratorio (id, nombre, tipo_resultado, categoria, unidad, grafico, valor_maximo, estado, valor_normal_minimo, valor_normal_maximo, valor_minimo, cups_id)",
                "tableName" => "laboratorio"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "plan_cups":
            $datosArreglo = array(
                "queryOri" => "SELECT id, plan_id, cups_id, costo, precio, activa FROM plan_cups",
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

        case "usuarios":
            $datosArreglo = array(
                "queryOri" => "SELECT
                                    p.user_id,
                                    p.cargo,
                                    p.registro_medico,
                                    p.firma,
                                    '1' AS cups_primera_id, /* Recuerde que los cups deben traer resultados */
                                    /* p.cups_primera_id, */
                                    '1' AS cups_control_id, /* Recuerde que los cups deben traer resultados */
                                    /* p.cups_control_id, */ 
                                    p.nombre,
                                    /* CASE WHEN s.first_name <> '' THEN s.first_name ELSE 'sin registro' END AS first_name,
                                    CASE WHEN s.last_name <> '' THEN s.last_name ELSE 'sin registro' END AS last_name, */
                                    /* CASE
                                        WHEN LENGTH(p.nombre) - LENGTH(REPLACE(p.nombre, ' ', '')) >= 2 THEN
                                            SUBSTRING_INDEX(p.nombre, ' ', 2)  -- Considerar las dos primeras palabras como nombre y apellido
                                        ELSE
                                            SUBSTRING_INDEX(p.nombre, ' ', 1)  -- Considerar solo la primera palabra como nombre
                                        END AS nombre_usuario,
                                    CASE
                                        WHEN LENGTH(p.nombre) - LENGTH(REPLACE(p.nombre, ' ', '')) >= 2 THEN
                                            SUBSTRING_INDEX(p.nombre, ' ', -2)  -- Obtener la última palabra como apellido
                                        ELSE
                                            TRIM(BOTH ' ' FROM REPLACE(p.nombre, SUBSTRING_INDEX(p.nombre, ' ' , 1), '')) -- Obtener el resto como apellido
                                    END AS apellido_usuario, */
                                    /* Los campos de nombre y apellido deberian traer los campos con registros */
                                    s.email_address,
                                    s.username,
                                    '1' AS tipo_documento,
                                    '$2y$10\$MoC6NAZvSCoqeIvtLp2jfuR3Fxi/DwcD6aCOaNQLprfJ4yHVqetMG' AS password, 
                                    s.is_active,
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
                "queryDes" => "usuarios (id, cargo, registro_medico, firma, cups_primero_id, cups_control_id,  email,  numero_documento, tipo_documento_id, password, estado, created_at, updated_at, foto, telefono, direccion, fecha_nacimiento, genero_id, nombres, apellidos)",
                "tableName" => "usuarios"
            );
            $mensaje = processMigration($datosArreglo);
            break;
/* -------------------- TABLAS 5to NIVEL ---------------------------------- */

        case "diagnostico_historia":
            $datosArreglo2 = array(
                "tableName" => "diagnostico_historia"
            );
            $mensaje = processBucle($datosArreglo2);
            break;

        case "admision":
            //Agregar estos campos a las tablas tipo_cita =>tipo_cita_id y tipo_cita AS especialidad => especialidad_id
            $datosArreglo = array(
                "queryOri" => "SELECT c.id, c.prestador_id, c.entidad_id, c.personal_user_id, c.consultorio_id, COALESCE(c.servicio_id, 1) AS servicio_id, c.paciente_id, c.fecha_solicitud, c.fecha, c.hora, c.autorizacion, c.estado, c.plan_id, c.copago_id, c.pago, c.valor_consulta, c.observacion, c.historia_id, c.fecha_registro, c.sede_id, c.regimen, ( SELECT MAX(especialidad_id) FROM personal_especialidad p WHERE p.personal_user_id = c.personal_user_id ) AS especialidad FROM consulta c;",
                "queryDes" => "admision (id, prestador_id, entidad_id, profesional_salud_id, consultorio, servicio_id, paciente_id, fecha_deseada, fecha, hora_atencion, autorizacion, estado, plan_id, copago_id, pago, valor_consulta, observacion, historia_id, created_at, sede_id, cobertura_id, especialidad_id)",
                "tableName" => "admision"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "factura":
            $datosArreglo = array(
                "queryOri" => "SELECT id, numero_factura, prestador_id, resolucion_id, concepto, valor, fecha_inicio, fecha_fin, personal_user_id, fecha_registro FROM factura",
                "queryDes" => "factura (id, numero_factura, prestador_id, resolucion_id, concepto, valor, fecha_inicio, fecha_fin, profesional_salud_id, created_at)",
                "tableName" => "factura"
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
                "queryOri" => "SELECT id, historia_id, peso_predialisis, peso_postdialisis, nitrogeno_ureico_pre_dialisis, nitrogeno_ureico_post_dialisis, horas, ktv, volumen_liquido_dializado FROM consulta_ktv",
                "queryDes" => "ktv_dialisis (id, historia_id, peso_predialisis, peso_postdialisis, nitrogeno_ureico_predialisis, nitrogeno_ureico_postdialisis, horas, ktv, volumen_liquido_dializado)",
                "tableName" => "ktv_dialisis"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "remision":
            $datosArreglo = array(
                "queryOri" => "SELECT id, historia_id, servicio_remision_id, codigo, justificacion FROM remision",
                "queryDes" => "remision (id, historia_id, servicio_remision_id, codigo, justificacion)",
                "tableName" => "remision"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "usuario_especialidad":
            $datosArreglo = array(
                "queryOri" => "SELECT id, personal_user_id, especialidad_id FROM personal_especialidad",
                "queryDes" => "usuario_especialidad (id, usuario_id, especialidad_id)",
                "tableName" => "usuario_especialidad"
            );
            $mensaje = processMigration($datosArreglo);
            break;
            
        case "usuario_prestador";
            $datosArreglo = array(
                "queryOri" => "SELECT id, personal_user_id , prestador_id FROM personal_prestador",
                "queryDes" => "usuario_prestador (id, usuario_id, prestador_id)",
                "tableName" => "usuario_prestador"
            );
            $mensaje = processMigration($datosArreglo);
            break;
/* -------------------- TABLAS 6to NIVEL ---------------------------------- */

        case "agenda":
            $datosArreglo = array(
                "queryOri" => "SELECT id, medio_cita, fecha, hora, medico_id, consulta_id, personal_user_id FROM agenda",
                "queryDes" => "agenda (id, medio_cita, fecha, hora_inicial, usuario_id, admision_id, personal_id)",
                "tableName" => "agenda"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "admision_cancelacion":
            $datosArreglo = array(
                "queryOri" => "SELECT consulta_id, cancelacion_id, observacion  FROM consulta_cancelacion",
                "queryDes" => "cancelar_admision(admision_id, tipo_cancelacion, observacion)",
                "tableName" => "admision_cancelacion"
            );
            $mensaje = processMigration($datosArreglo);
            break;

        case "factura_admision":
            $datosArreglo = array(
                "queryOri" => "SELECT id, factura_id, consulta_id, consecutivo_entidad, anulado FROM factura_consulta",
                "queryDes" => "factura_admision (id, factura_id, admision_id, consecutivo_entidad, estado)",
                "tableName" => "factura_admision"
            );
            $mensaje = processMigration($datosArreglo);
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
        if ($elementosProcesados % 250 == 0) {//si la división de los 250 registros me devuelve cero es decir si no hay un residuo.
            $cadena = substr($cadena, 0, -2);// se borrarn los ultimos dos elementos de cada cadena
            $cadena .= ';*-'; // se agrega ; para separar cada 250 registros y se agrega *- para despues contarlos con el explode que los quite y cada vez que encuentre esto lo vuelva un indice.
        }
    }
    // Verifica si quedan registros sin procesar
    if ($numRegistros % 250 != 0) {
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
    $numRegistros = $numRegistrosLotes * 250;
    $contRegistros = count($explodeUltIndex);
    $contRegistros = $numRegistros - 250 + $contRegistros; // numero de registros.
    $mensaje = " La tabla de origen contiene: $contRegistros registros, la insercción se realizará en: $numRegistrosLotes Lotes, cada lote de 250 registros. ";
    return array('mensaje' => $mensaje, 'numRegistroLotes' => $numRegistrosLotes, 'contRegist' => $contRegistros);
}

function processBucle($datosArreglo2)
{
    $tableName = $datosArreglo2['tableName'];
    $conexAplication = conectarbd();
    $diangosti_his=array("SELECT id, diagnostico_id, if(tipo_diagnostico IS NULL, 6, tipo_diagnostico) AS tipo_diagnostico FROM historia WHERE diagnostico_id IS NOT NULL ORDER BY id",
        "SELECT id, diagnostico_dos_id, if(tipo_diagnostico_dos IS NULL, 6, tipo_diagnostico_dos) AS tipo_diagnostico_dos FROM historia WHERE diagnostico_dos_id IS NOT NULL ORDER BY id",
        "SELECT id, diagnostico_tres_id, if(tipo_diagnostico_tres IS NULL, 6, tipo_diagnostico_tres) AS tipo_diagnostico_tres FROM historia WHERE diagnostico_tres_id IS NOT NULL ORDER BY id",
        "SELECT id, diagnostico_cuatro_id, if(tipo_diagnostico_cuatro IS NULL, 6, tipo_diagnostico_cuatro) AS tipo_diagnostico_cuatro FROM historia WHERE diagnostico_cuatro_id IS NOT NULL ORDER BY id",
        "SELECT id, diagnostico_cinco_id, if(tipo_diagnostico_cinco IS NULL, 6, tipo_diagnostico_cinco) AS tipo_diagnostico_cinco FROM historia WHERE diagnostico_cinco_id IS NOT NULL ORDER BY id",
        "SELECT id, diagnostico_seis_id, if(tipo_diagnostico_seis IS NULL, 6, tipo_diagnostico_seis) AS tipo_diagnostico_seis FROM historia WHERE diagnostico_seis_id IS NOT NULL ORDER BY id",
        "SELECT id, diagnostico_siete_id, if(tipo_diagnostico_siete IS NULL, 6, tipo_diagnostico_siete) AS tipo_diagnostico_siete FROM historia WHERE diagnostico_siete_id IS NOT NULL ORDER BY id"
    );
    $count = COUNT($diangosti_his) - 1;
    $mensajeArray = array();
    $sqlcheckpoint = "SELECT indexHis FROM checkpoint WHERE tableName = '$tableName'";
    $statementCheck = $conexAplication->query($sqlcheckpoint);
    $resultCheckpoint = $statementCheck->fetchAll(PDO::FETCH_ASSOC);
    $indexAntEspecial = intval($resultCheckpoint[0]['lastIndex']);
    $indexAntEspecial = $indexAntEspecial - 1;
    if($indexAntEspecial === $count){
        $mensaje = "ERROR: No se puede realizar la migración de esta tabla debido a que ya se habia realizado antes";
        return $mensaje;
    }else{
        $indexAntEspecial = $indexAntEspecial + 1;
    }
    for( $i = $indexAntEspecial; $i <= $count; $i++ ){
        $datosArreglo = array(  "queryOri" => $diangosti_his[$i],
                                "queryDes" => "diagnostico_historia(historia_id, diagnostico_id, tipo_diagnostico_id)",
                                "tableName" => $tableName
        );
        
        $sql = "UPDATE checkpoint SET indexHis = $i WHERE tableName = '".$tableName."'";
        $conexAplication->exec($sql);
        $mensajeResp = processMigration($datosArreglo);
        array_push($mensajeArray, $mensajeResp);
        echo $i." PASADA ECHA ";
        
    };

    
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
        $query = $queryOri;// Traemos la consulta en forma de array desde el switch para que sea dinamico
        $statement = $conexOrigen->query($query);
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);
        
        if (empty($result)) {
            $mensaje = "ERROR: no hay datos en la tabla. La migración no se puede realizar.";
            return $mensaje;
        }

        if($tableName === 'usuarios'){
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
            echo " Se inserto el lote: $con " . PHP_EOL;
            //aqui se hace la insercción del indice...
            $aplication = "UPDATE checkpoint SET lastIndex = $con WHERE tableName = '$tableName'";
            $conexAplication ->exec($aplication);
            $j+1; 
            $conexDestino->commit();
        }
        $mensaje = "¡Se realizo la migración con exito...!";
        return $mensaje;
    } catch (\Throwable $th) {
        /* ***************************************************** */
        $conexDestino->rollBack();
        // Obtener el número de registro del rollback
        $rollbackRegistro = $j + 1;
        echo "Error se hara rollback al lote #$rollbackRegistro, a continuación se muestra el mensaje del servidor *** $th ";
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