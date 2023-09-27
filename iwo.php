<?php


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

/* Aqui se da el manejo a la acción que se quiere manejar desde el ajax por medio del parametro action
por lo que es inprecindible que todos los ajax de metodo post vengan con ese parametro action */
if(isset($_POST['action'])){
    $action = $_POST['action'];
    switch($action){
        case 'guardatos':
            $mensaje = guardatos();
            break;
        case 'fillSelected':
            $mensaje = selected();
            break;
        case 'optionSelect':
            optionSelect();
            break;
        case 'conexBdDestino':
             // Llamar a la función conexBdDestino() con las variables adecuadas
             $mensaje = conexBdDestino();
             break;
        //se puede segir parametrizando más acciones por medio de los case.
        default:
        echo 'Acción no valida o no se ha codificado';
    }
    echo $mensaje;
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
    
    if (!$nombreMig || !$hostOri || !$puertoOri || !$bdNameOri || !$usuarioOri || !$contrasenaOri || !$hostDes || !$puertoDes || !$bdNameDes || !$usuarioDes || !$contrasenaDes) {
       $mensaje = 'Error las variables llegaron vacias';
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
//Variables globales para recibir los datos recuperados de la base de datos de destino de la función optionSelect.
$hostDestino = "";
$puertoDestino = "";
$nombreDbDestino = "";
$nombreUsuarioDestino = "";
$contraseñaDestino = "";
//Variables globales para recibir los datos recuperados de la base de datos de origen de la función optionSelect.
$hostOrigen = "";
$puertoOrigen = "";
$nombreDbOrigen = "";
$nombreUsuarioOrigen = "";
$contraseñaOrigen = "";

function optionSelect(){

    global $hostDestino, $puertoDestino, $nombreDbDestino, $nombreUsuarioDestino, $contraseñaDestino;
    global $hostOrigen, $puertoOrigen, $nombreDbOrigen, $nombreUsuarioOrigen, $contraseñaOrigen;

    try{
        $opcionSelect = $_POST['opcionSelect'];
        
        $conexion = conectarbd();
        $query = "SELECT host, puerto, nombre_Db, nombre_Usuario, contraseña FROM tbldatosdestino WHERE Nombre_Migracion = '$opcionSelect'";
        $statement = $conexion->query($query);
        $datosDestino = $statement->fetch(PDO::FETCH_ASSOC);
        if ($datosDestino !== false) {
        $hostDestino = $datosDestino['host'];
        $puertoDestino = $datosDestino['puerto'];
        $nombreDbDestino = $datosDestino['nombre_Db'];
        $nombreUsuarioDestino = $datosDestino['nombre_Usuario'];
        $contraseñaDestino = $datosDestino['contraseña'];
        }
        $query1 = "SELECT host, puerto, nombre_Db, nombre_Usuario, contraseña FROM tbldatosorigen WHERE Nombre_Migracion = '$opcionSelect'";
        $statement = $conexion->query($query1);
        $datosOrigen = $statement->fetch(PDO::FETCH_ASSOC);
        if ($datosDestino !== false) {
        $hostOrigen = $datosOrigen['host'];
        $puertoOrigen = $datosOrigen['puerto'];
        $nombreDbOrigen = $datosOrigen['nombre_Db'];
        $nombreUsuarioOrigen = $datosOrigen['nombre_Usuario'];
        $contraseñaOrigen = $datosOrigen['contraseña'];
        }
    }catch (Exception $e) {
        $mensaje =  "Error en la consulta de las credenciales de las bases de datos de origen y/o destino: " . $e->getMessage();
        return $mensaje;
    }
}

function conexBdDestino() {
    global $hostDestino, $puertoDestino, $nombreDbDestino, $nombreUsuarioDestino, $contraseñaDestino;

    if (!empty($hostDestino) && !empty($puertoDestino) && !empty($nombreDbDestino) && !empty($nombreUsuarioDestino) && !empty($contraseñaDestino)) {
        $mensaje = "Las variables están definidas y no están vacías.";
    } else {
        $mensaje = "Error: Las variables no están definidas o están vacías.";
    }
    echo "Estoy aqui sin hacer nada que hay pa hacer ";
    return $mensaje;
}
?>