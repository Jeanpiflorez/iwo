// Hoja de js para homeiwo.php By Jean Pierre Florez Digital solutions
console.log("Consola de IWO MIGRATIONS. Bienvenido developer")



// Agregar el evento beforeunload a la ventana actual
window.addEventListener('beforeunload', function(event) {
    // Cancelar el evento por defecto (esto es necesario para mostrar el mensaje personalizado)
    event.preventDefault();
    // Mensaje de confirmación personalizado
    const confirmationMessage = '¿Estás seguro de que deseas cerrar esta página? Se perderán los cambios no guardados.';
    // Asignar el mensaje al evento beforeunload
    event.returnValue = confirmationMessage;
    // La mayoría de los navegadores modernos ignorarán el mensaje personalizado, pero algunos navegadores más antiguos lo mostrarán.
    return confirmationMessage;
});

const nameUser = sessionStorage.getItem('usuario');
elementNameUser = document.getElementById('usuario');
elementNameUser.textContent= nameUser

//Codigo para poner y quitar los contenedores++++++++++++++++++++++++++++++++++++++++++++++++++++++

var collapse1 = document.getElementById('collapse1');
var collapse2 = document.getElementById('collapse2');
var collapse3 = document.getElementById('collapse3');
var collapse4 = document.getElementById('collapse4');
//Aqui se agregan mas variables para obtener el id de los collapseds.
function mostrarCollapse(collapseId){
    if (collapseId === 1) {
        collapse1.classList.add("show");
        collapse2.classList.remove("show");
        collapse3.classList.remove("show");
        collapse4.classList.remove("show");
        $('#btnCloseMenu').trigger('click');
        //Aqui se agregan mas procedimientos.
    } else if(collapseId === 2){
        collapse1.classList.remove("show");
        collapse2.classList.add("show");
        collapse3.classList.remove("show");
        collapse4.classList.remove("show");
        $('#btnCloseMenu').trigger('click');
        fillSelect();
    }else if(collapseId === 3){
        collapse1.classList.remove("show");
        collapse2.classList.remove("show");
        collapse3.classList.add("show");
        collapse4.classList.remove("show");
        $('#btnCloseMenu').trigger('click');
        //Aqui se agregan mas procedimientos.
    }else if(collapseId === 4){
        collapse1.classList.remove("show");
        collapse2.classList.remove("show");
        collapse3.classList.remove("show");
        collapse4.classList.add("show");
        $('#btnCloseMenu').trigger('click');
    //Aqui se agregan mas procedimientos.
    }
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Código para procesar el formulario de guardar las credenciales de la base de datos.++++++++++++++
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
        //contrasenaOri, 
        hostDes, 
        puertoDes, 
        bdNameDes, 
        usuarioDes, 
        //contrasenaDes
    ];
    //se recibe el array y se itera para que busque variable por variable cual esta vacia
    for(var i = 0; i < varcreden.length; i++){
        var valor = varcreden[i];
        if(valor===""){
            console.log("La variable: " + (i + 1) + "Está vacía.");
            alert("Por favor rellene todos los campos");
            //Declaramos una variable como falsa
            var resvarcreden = false;
            break;
        }
    }
    //console.log(nombreMig + hostOri + puertoOri + bdNameOri + usuarioOri + contrasenaOri + hostDes + puertoDes + bdNameDes + usuarioDes + contrasenaDes);
   //si la variable de resvarcreden es diferente a falso entonces realiza la insercción de los datos a el php.
    if(resvarcreden != false){
        listenProgressServer1()
        /* console.log('Se esta llamando al listener'); */
        $.ajax({
            url:'iwo.php',
            method:'POST',
            data:{
                action        :'guardatos',
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
                stopListenerServer();
                /* console.log('Se esta cerrando la escucha. '); */
            }
        })
    }
});
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Código para mostrar datos en la consola de logs que tenemos en iwoMigrations+++++++++++++++++++++

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
    if (/error/i.test(response) || /Warning/i.test(response)) {
        mensajeElement.style.color = "red";
        mensajeElement.style.fontSize = "10px";
        mensajeElement.style.marginBottom = "-23px"
    } else {
        // Si el response no contiene las palabras "error" o "Warning", se pinta de verde
        mensajeElement.style.color = "chartreuse";
        mensajeElement.style.fontSize = "10px";
        mensajeElement.style.marginBottom = "-23px"
    }

    var divlog = document.getElementById('log');
    //Es para que el scroll en el log siga a los mensajes que van apareciendo.
    divlog.scrollTop = divlog.scrollHeight;
    
    var brElement = document.createElement("br");
    $('#log').append(mensajeElement);
    $('#log').append(brElement);
}

<<<<<<< Updated upstream:js/homeIwo.js
=======
//Codigo para poner y quitar los contenedores++++++++++++++++++++++++++++++++++++++++++++++++++++++

var collapse1 = document.getElementById('collapse1');
var collapse2 = document.getElementById('collapse2');
//Aqui se agregan mas variables para obtener el id de los collapseds.
function mostrarCollapse(collapseId){
    if (collapseId === 1) {
        collapse1.classList.add("show");
        collapse2.classList.remove("show");
        $('#cerrarMenu').trigger('click');
        //Aqui se agregan mas procedimientos.
    } else if(collapseId === 2){
        collapse2.classList.add("show");
        collapse1.classList.remove("show");
        fillSelect();
        $('#cerrarMenu').trigger('click');
        //Aqui se agregan mas procedimientos.
    }//Aqui se agregan mas condicionales.
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

>>>>>>> Stashed changes:homeIwo.js
//funcion para escuchar los mensajes de el servidor
function listenProgressServer1(){
    intervalId = setInterval(function() {//Se pasa una función de tiempo para realizar la solicitud cada cierto tiempo
        $.ajax({
            url    :'php/iwo.php',
            method :'get',
            success: function(response){
                var response = "Este es un mensaje del ajax de escucha: " + response;
                mostrarMensaje(response);
                /* console.log('Se esta ejecutando la escucha.'); */
            }
        });
    }, 2000);//En este caso se esta escuchando cada 2 segundos.
}

//Función para detener la escucha.
function stopListenerServer(){
    clearInterval(intervalId);
    /* console.log('Se esta ejecutando la detencion del escuchador. '); */
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Código para establecer las conexiones entre los servers de origen y destino.++++++++++++++++++++++

//función para llenar el select de las bases de datos.
function fillSelect() {
    $.ajax({
<<<<<<< Updated upstream:js/homeIwo.js
        url: 'php/iwo.php',
        method: 'POST',
        data: {
        action: 'fillSelected'
        },
        dataType: 'json',
        success: function(data) {
        var selected = $('#selected');
        selected.empty();
        var defaultOption = $('<option>').val('Escoja una migración').text('Escoja una migración');
        selected.append(defaultOption);
        $.each(data, function(index, dato) {
            var option = $('<option>').val(dato.Nombre_Migracion).text(dato.Nombre_Migracion);
            selected.append(option);
        });
        defaultOption.prop('disabled', true);
    },
    error: function(xhr, status, error) {
        console.log('Error en la solicitud Ajax:', error);
    }
    });
}

//Función para seleccionar el nombre de la migración que se quiere realizar.
function selectedConex() {
    var selectedValue = document.getElementById('selected').value;
    sessionStorage.setItem('migracion', selectedValue);
    alert("Se va a trabajar con los datos de: " + selectedValue);
    return selectedValue;
};

$(document).ready(function() {
    // Evento de clic en el botón
    $(document).on('click', '.btnMigration', function() {
    let table = $(this).attr("data-id");
    conexionselected = sessionStorage.getItem('migracion')
        if(conexionselected === ""){
            alert("¡NO SE HA SELECCIONADO UNA MIGRACIÓN VUELVA AL MODULO DE CONEXIÓN Y ESCOJALO!")
        }else{
            $.ajax({
                url:"php/iwo.php",
                method:"POST",
                data:{
                    action: table,
                    migracion: conexionselected
                },
                success:function(response){
                    mostrarMensaje(response);
                    stopListenerServer();
                }
            })
=======
        url: 'iwo.php',
        method: 'post',
        data: {
            action: 'fillSelected'
        },
        dataType: 'json',
        success: function (data) {
            var selected = $('#selected');
            selected.empty();
            selected.prepend('<option value="" selected disabled>Selecciona una opción</option>');
            $.each(data, function (index, dato) {
                var option = $('<option>').val(dato.Nombre_Migracion).text(dato.Nombre_Migracion);
                selected.append(option);
            });
        },
        error: function () {
            console.log('Error en la solicitud Ajax');
        }
    });
}

$('#selected').change(function() {
    // Código a ejecutar cuando se produce un doble clic en el select
    var selectedValue = $(this).val();
    console.log('Doble clic en el select. Valor seleccionado: ' + selectedValue);
    $.ajax({
        url:"iwo.php",
        method:"POST",
        data:{
            action       : 'optionSelect',
            opcionSelect : selectedValue
        },
        success :function(data){
            alert('Se establecieron las credenciales para ' + selectedValue + data);
        }
    });
});

function conexBdDestino(){
    console.log(selectedValue);
    $.ajax({
        
        url:"iwo.php",
        method:"POST",
        data:{
            action       : 'conexBdDestino', 
        },
        success:function(response){
            mostrarMensaje(response);
>>>>>>> Stashed changes:homeIwo.js
        }
    });
});