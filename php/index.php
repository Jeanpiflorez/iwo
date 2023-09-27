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

try {

    $conexion = conectarbd();
    $usuario = $_POST['usuario'];
    $contraseña = $_POST['contraseña'];
    $token = substr(bin2hex(random_bytes(15)), 0, 30);
    if (isset($conexion) && isset($usuario) && isset($contraseña)) {
        // Escapar y limpiar los valores
        $usuario = $conexion->quote($usuario);
        $contraseña = $conexion->quote($contraseña);
        // Construir la consulta SQL y ejecutarla
        $query = "SELECT * FROM usuarios WHERE usuario = $usuario AND contraseña = $contraseña";
        $statement = $conexion->query($query);
        $result = $statement->fetch(PDO::FETCH_ASSOC);
        if ($result) {// si el resultado es positivo
            $updateQuery = "UPDATE usuarios SET token ='$token' WHERE usuario = $usuario";
            $updateStatement = $conexion->prepare($updateQuery);
            $updateStatement->execute();
            $firstName = $result['firstName'];
            $response = array('accesso' => 1, 'usuario' => $firstName, 'token' => $token);
            echo json_encode($response);
        } else {
            $response = array('accesso' => 0,);
            echo json_encode($response);
        }
    }
} catch (\Throwable $th) {
    $falla = $th;
    $response = array('falla' => "$falla");
    echo json_encode($response);
}