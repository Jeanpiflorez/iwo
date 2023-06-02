// Hoja de js para homeiwo.php By Jean Pierre Florez Digital solutions
console.log("Consola de IWO MIGRATIONS. Bienvenido developer")

var button = document.getElementById("guardar");
button.addEventListener("click", function(){
    var txtNombreMig = document.getElementById("nombreMig");
    var txthostOri = document.getElementById("hostOri");
    var txtpuertoOri = document.getElementById("puertoOri");
    var txtbdNameOri = document.getElementById("bdNameOri");
    var txtusuarioOri = document.getElementById("usuarioOri");
    var txtcontrasenaOri = document.getElementById("contrasenaOri");
    var txthostDes = document.getElementById("hostDes");
    var txtpuertoDes = document.getElementById("puertoDes");
    var txtbdNameDes = document.getElementById("bdNameDes");
    var txtusuarioDes = document.getElementById("usuarioDes");
    var txtcontrasenaDes = document.getElementById("contrasenaDes");

    var nombreMig = txtNombreMig.value;
    var hostOri = txthostOri.value;
    var puertoOri = txtpuertoOri.value;
    var bdNameOri = txtbdNameOri.value;
    var usuarioOri = txtusuarioOri.value;
    var contrasenaOri = txtcontrasenaOri.value
    var hostDes =txthostDes.value;
    var puertoDes =txtpuertoDes.value;
    var bdNameDes =txtbdNameDes.value;
    var usuarioDes =txtusuarioDes.value;
    var contrasenaDes =txtcontrasenaDes.value;    
    // Se crea un array de todas las variables para validar si tienen datos.
    var varcreden = [
        nombreMig, 
        hostOri, 
        puertoOri, 
        bdNameOri, 
        usuarioOri, 
        contrasenaOri, 
        hostDes, 
        puertoDes, 
        bdNameDes, 
        usuarioDes, 
        contrasenaDes
    ];
    //se recibe el array y se itera para que busque variable por variable cual esta vacia
    for(var i = 0; i < varcreden.length; i++){
        var valor = varcreden[i];
        if(valor===""){
            console.log("La variable: " + (i + 1) + "Está vacía.");
            alert("Por favor rellene todos los campos");
            //Decaramos una variable como falsa
            var resvarcreden = false;
            break;
        }
    }
    //console.log(nombreMig + hostOri + puertoOri + bdNameOri + usuarioOri + contrasenaOri + hostDes + puertoDes + bdNameDes + usuarioDes + contrasenaDes);
   //si la variable de resvarcreden es diferente a falso entonces realiza la insercción de los datos a el php.
    if(resvarcreden != false){
        $.ajax({
            url:'iwo.php',
            method:'POST',
            data:{
                nombreMig     : nombreMig,
                hostOri       : hostOri,
                puertoOri     : puertoOri,
                bdNameOri     : bdNameOri,
                usuarioOri    : usuarioOri,
                contrasenaOri : contrasenaOri,
                hostDes       : hostDes,
                puertoDes     : puertoDes,
                bdNameDes     : bdNameDes,
                usuarioDes    : usuarioDes,
                contrasenaDes : contrasenaDes
            },
            success: function(response){
                //Se envia la respuesta del servidor a la función mostrarMensaje.
                mostrarMensaje(response);                    
            }
        })
    }
});

//Funcion para obtener la fecha del sistema
function mostrarFechaHora() {
    var fechaActual = new Date();
    var fechaFormateada = fechaActual.toLocaleDateString();//Se formatea la fecha para mostrar en pantalla
    var horaFormateada = fechaActual.toLocaleTimeString();//se formatea la hora
    // Se crea un array para que se pueda utilizar en los logs del sistema.
    return [fechaFormateada,horaFormateada];
}

/* Función que recibe todas las respuestas del ajax y luego las muestran en pantalla en la ventana
   del log. */
function mostrarMensaje(response) {//recibimos los mensajes del servidor para mostrarlos en pantalla.
    var mensajeElement = document.createElement("p");
    mensajeElement.textContent = '---> ' + mostrarFechaHora() + ' IWO MIGRATIONS: ' + response;
    // Si el response trae la palabra error en cualquier posición se pinta de rojo en la pantalla
    if (/error/i.test(response)) {
        mensajeElement.style.color = "red";
        mensajeElement.style.fontSize = "8px";
        mensajeElement.style.marginBottom = "-23px"
      } else {
        // Si el response no contiene las palabras "error" o "Warning", se pinta de verde
        mensajeElement.style.color = "chartreuse";
        mensajeElement.style.fontSize = "8px";
        mensajeElement.style.marginBottom = "-23px"
      }
      
      var divlog = document.getElementById('log');
      //Es para que el scroll en el log siga a los mensajes que van apareciendo.
      divlog.scrollTop = divlog.scrollHeight;
    
      var brElement = document.createElement("br");
    $('#log').append(mensajeElement);
    $('#log').append(brElement);
}

//Codigo para poner y quitar los contenedores++++++++++++++++++++++++++++++++++++++++++++++++++++++

var collapse1 = document.getElementById('collapse1');
var collapse2 = document.getElementById('collapse2');
//Aqui se agregan mas variables para obtener el id de los collapseds.
function mostrarCollapse(collapseId){
    if (collapseId === 1) {
        collapse1.classList.add("show");
        collapse2.classList.remove("show");
        //Aqui se agregan mas procedimientos.
    } else if(collapseId === 2){
        collapse2.classList.add("show");
        collapse1.classList.remove("show");
        //Aqui se agregan mas procedimientos.
    }//Aqui se agregan mas condicionales.
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//funcion para escuchar los mensajes de el servidor
function listenProgressServer1(){
    setInterval(function() {//Se pasa una función de tiempo para realizar la solicitud cada cierto tiempo
        $.ajax({
            url    :'',
            method :'get',
            success: function(response){
                mostrarMensaje(response);
            }
        });
    });
}