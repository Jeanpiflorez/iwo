<?php

//Función para conectarse a la base de datos de iwo
// $conexion =mysqli_connect("localhost","root","","dbiwomigration");
// if (!$conexion) {
//     echo "Error al conectar a mysl";
//     # code...
// } else {
//     echo "conexion exitosa a Maria db";
//     # code...
// }

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

function guardatos() {
    $conexion = conectarbd();
    
    // Obtener los valores de la base de datos de origen.
    $nombreMig = $_POST['nombreMig'];
    $hostOri = $_POST['hostOri'];
    $puertoOri = $_POST['puertoOri'];
    $bdNameOri = $_POST['bdNameOri'];
    $usuarioOri = $_POST['usuarioOri'];
    $contraseñaOri = $_POST['contrasenaOri'];
    
    // Obtener los valores de la base de datos de destino.
    $hostDes = $_POST['hostDes'];
    $puertoDes = $_POST['puertoDes'];
    $bdNameDes = $_POST['bdNameDes'];
    $usuarioDes = $_POST['usuarioDes'];
    $contraseñaDes = $_POST['contrasenaDes'];
    
    // Consulta SQL con marcadores de posición para evitar problemas de seguridad
    $queryDes = "INSERT INTO tbldatosdestino (Nombre_Migracion, host, puerto, nombre_Db, nombre_Usuario, contraseña) VALUES (?, ?, ?, ?, ?, ?)";
    $queryOri = "INSERT INTO tbldatosorigen (Nombre_Migracion, host, puerto, nombre_Db, nombre_Usuario, contraseña) VALUES (?, ?, ?, ?, ?, ?)";
    
    

    try {

                // Preparar la consulta para la base de datos de destino
                $statement = $conexion->prepare($queryDes);
                $statement->bindParam(1, $nombreMig);
                $statement->bindParam(2, $hostDes);
                $statement->bindParam(3, $puertoDes);
                $statement->bindParam(4, $bdNameDes);
                $statement->bindParam(5, $usuarioDes);
                $statement->bindParam(6, $contraseñaDes);
                $resultado = $statement->execute();
                
                // Verificar si la consulta se ejecutó exitosamente
                if ($resultado) {
                    echo "La consulta para la base de datos de destino se ejecutó exitosamente.";
                } else {
                    echo "Ocurrió un error al ejecutar la consulta para la base de datos de destino: " . $statement->errorInfo()[2];
                }

        // Preparar la consulta para la base de datos de origen
        $statement = $conexion->prepare($queryOri);
        $statement->bindParam(1, $nombreMig);
        $statement->bindParam(2, $hostOri);
        $statement->bindParam(3, $puertoOri);
        $statement->bindParam(4, $bdNameOri);
        $statement->bindParam(5, $usuarioOri);
        $statement->bindParam(6, $contraseñaOri);
        $resultado = $statement->execute();

        // Verificar si la consulta se ejecutó exitosamente
        if ($resultado) {
            echo "La consulta para la base de datos de origen se ejecutó exitosamente.";
        } else {
            echo "Ocurrió un error al ejecutar la consulta para la base de datos de origen: " . $statement->errorInfo()[2];
        }
        
        
        // Cerrar la conexión y liberar los recursos
        $statement = null;
        $conexion = null;
    } catch (PDOException $e) {
        echo "Error en la consulta: " . $e->getMessage();
    }
}

//try catch que captura los errores o los procesos exitosos y los muestra a ajax
 try {
    echo guardatos();
    //echo "Inserción exitosa a la base de datos.";
} catch (Exception $e) {
    //echo "Error en la Inserción a la base de datos dbIwoMigrations debido a: " . $e->getMessage();
}

function conectarbd1(){

    $iniciarConexion = $_POST['parametro'];
    $paramMigration  = $_POST['paramMigrations'];
    //psdt: para no perder el hilo dejo este comentario aqui vamos a realizar la recuperación de los datos
    //de la base de datos y vamos a realizar la conexión de la base de datos de origen.

}

?>