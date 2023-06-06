<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!--Importamos el cdn de bootstrap-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <!--Hoja de estilos propia-->
    <link rel="stylesheet" href="homeIwo.css" type="text/css"><!--Aun no se ha relacionado hoja de estilos-->
    <title>IWO MIGRATIONS</title>
    
</head>
<body>
  <header>
    <nav class="navbar  bg-dark">
      <div class="container">
        <a class="navbar-brand" href="#">
          <h1>IWO MIGRATIONS</h1>
        </a>
        <button class="btn btn-primary" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRight" aria-controls="offcanvasRight">menu</menu></button>
      </div>
    </nav>
    <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasRight" aria-labelledby="offcanvasRightLabel">
      <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="offcanvasRightLabel">IWO MIGRATIONS MENU</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
      </div>
      <div>
      <!--Aqui deberiamos poner los datos de la persona que se coneto-->
      </div>
      <div class="offcanvas-body">
        <ul>
          <li><a class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="" aria-expanded="false" aria-controls="" onclick="mostrarCollapse(1)">CONFIGURACIÓN</a></li>
          <li><a class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="" aria-expanded="false" aria-controls="" onclick="mostrarCollapse(2)">CONEXIÓN</a></li>
          <li><a href="#">MIGRACIÓN</a></li>
          <li><a href="#">LOGS</a></li>
        </ul>
      </div>
    </div>
  </header>
  <main>
    <div class="row" style="display: flex; width: max-content;">
      <div class="contenedorutilidades col-8">
        <div class="collapse collapse-horizontal" id="collapse1">
          <!--Módulo de configuración para guardar las credenciales-->
          <div class="card card-body" style="width: 700px;" id="cardConfiguration">
            <h5>CONFIGURACIÓN DE MIGRACIÓN</h5>
            <label>Por favor introduzca las credenciales de la base de datos de origen</label>
            <div class="row">
              <div class="col">
                <label>Nombre de la migración*</label>
                <input type="text" class="form-control" placeholder="" aria-label="" required name="nombreMig" id="nombreMig">
              </div>
              <div class="col">
                <label>Host de origen*</label>
                <input type="text" class="form-control" placeholder="" aria-label="" required name="hostOri" id="hostOri">
              </div>
            </div>
            <div class="row">            
              <div class="col">
                <label>Puerto de origen*</label>
                <input type="number" class="form-control" placeholder="" aria-label="" required name="puertoOri" id="puertoOri">
              </div>
              <div class="col">
                <label>Nombre de la base de datos de origen*</label>
                <input type="text" class="form-control" placeholder="" aria-label="" required name="bdNameOri" id="bdNameOri">
              </div>
            </div>
            <div class="row">            
              <div class="col">
                <label>Usuario de origen*</label>
                <input type="text" class="form-control" placeholder="" aria-label="" required name="usuarioOri" id="usuarioOri">
              </div>
              <div class="col">
                <label>Contraseña de origen*</label>
                 <input type="text" class="form-control" placeholder="" aria-label="" required name="contrasenaOri" id="contrasenaOri">
              </div>
            </div>
            <div class="row">            
              <div class="col">
                <label>Host de destino*</label>
                <input type="text" class="form-control" placeholder="" aria-label="" required name="hostDes" id="hostDes">
              </div>
              <div class="col">
                <label>Puerto de destino*</label>
                <input type="number" class="form-control" placeholder="" aria-label="" required name="puertoDes" id="puertoDes">
              </div>
            </div>
            <div class="row">            
              <div class="col">
                <label>Nombre de la base de datos de destino*</label>
                <input type="text" class="form-control" placeholder="" aria-label="" required name="bdNameDes" id="bdNameDes"> 
              </div>
              <div class="col">
                <label>Usuario de destino*</label>
                <input type="text" class="form-control" placeholder="" aria-label="" required name="usuarioDes" id="usuarioDes">
              </div>
            </div>
            <div class="row">            
              <div class="col">
                 <label>Contraseña*</label>
                <input type="text" class="form-control" placeholder="" aria-label="" required name="contrasenaDes" id="contrasenaDes">
              </div>
              <div class="col" style="padding: 23px 0 0 0;">
                <button type="buton" class="btn btn-primary" id="guardar">GUARDAR</button>
              </div>
            </div>
          </div>
        </div>
        <!--Módulo para establecer la conexión a las bases de datos.-->
        <div class="collapse collapse-horizontal" id="collapse2">
          <div class="card card-body" style="width: 700px;" id="cardConexion">
            <div class="container">
              <div class="headercollapse2">
                <h5>CONEXIÓN</h5>
              </div>
              <div class="maincollapsed">
                <select class="form-select" aria-label="Default select example" id="selected" onclick="fillSelect()">
                  <option value="" selected>Seleccionar opción</option>
                </select>
                <div class="conexOri" style="display: inline-grid;">
                  <img src="imgServerOri.png" alt="Imagen de servidor de origen" style="width: 20vw;">
                  <button>CONECTARSE A BD ORIGEN</button>
                </div>
                <div class="conexDes" style="display: inline-grid;">
                  <img src="imgServerDes.png" alt="Imagen de servidor de destino" style="width: 22.5vw">
                  <button>CONECTARSE A BD DESTINO</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="log col-4" id="log">
        <h5>LOGS DEL SISTEMA</h5>
      </div>
    </div>
  </main>
  <footer>
      
  </footer>
  <script src="https://code.jquery.com/jquery-3.7.0.min.js"
          integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g="
          crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" 
          integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" 
          crossorigin="anonymous"></script>
  <script src="homeIwo.js"></script>
</body>
</html>