$("#btnIngresar").click(function(){
    var user = $("#txtUser").val();
    var password = $("#txtPassword").val();
    if (user === "" || password === "") {
        var mensajeElement = document.createElement("p");
        mensajeElement.textContent = '---> IWO MIGRATIONS: Por favor llena las casillas de usuario y/o contraseña ⚠️';
        mensajeElement.style.color = "red";
        mensajeElement.style.fontSize = "12px";
        mensajeElement.style.marginBottom = "-23px";
        var divlog = document.getElementById('consola');
        //Es para que el scroll en el log siga a los mensajes que van apareciendo.
        divlog.scrollTop = divlog.scrollHeight;
        var brElement = document.createElement("br");
        $('#consola').append(mensajeElement);
        $('#consola').append(brElement);
        $("#txtUser").val("");
        $("#txtPassword").val("");
    }else{
        $.ajax({
            url:'php/index.php',
            method:'POST',
            data:{
                usuario:user,
                contraseña:password
            },
            dataType: 'json',
            success:function(response){
                if(response.accesso === 1){
                            // Guardar los valores en el sessionStorage
                    sessionStorage.setItem('usuario', response.usuario);
                    sessionStorage.setItem('token', response.token);
                    sessionStorage.setItem('migracion', "");
                    // Redirigir a la siguiente página
                    window.location.href = 'homeiwo.html';
                }else if(response.accesso === 0){
                    var mensajeElement = document.createElement("p");
                    mensajeElement.textContent = '---> IWO MIGRATIONS: Hola ' + user + '. Tu usuario o contraseña no son los correctos 😢';
                    mensajeElement.style.color = "red";
                    mensajeElement.style.fontSize = "12px";
                    mensajeElement.style.marginBottom = "-23px";
                    var divlog = document.getElementById('consola');
                    //Es para que el scroll en el log siga a los mensajes que van apareciendo.
                    divlog.scrollTop = divlog.scrollHeight;
                    var brElement = document.createElement("br");
                    $('#consola').append(mensajeElement);
                    $('#consola').append(brElement);
                    $("#txtUser").val("");
                    $("#txtPassword").val("");
                }else{
                    var mensajeElement = document.createElement("p");
                    mensajeElement.textContent = '---> IWO MIGRATIONS: ¡ERROR! Se ha producido un error en el server' + response.falla;
                    mensajeElement.style.color = "red";
                    mensajeElement.style.fontSize = "12px";
                    mensajeElement.style.marginBottom = "-23px";
                    var divlog = document.getElementById('consola');
                    //Es para que el scroll en el log siga a los mensajes que van apareciendo.
                    divlog.scrollTop = divlog.scrollHeight;
                    var brElement = document.createElement("br");
                    $('#consola').append(mensajeElement);
                    $('#consola').append(brElement);
                    $("#txtUser").val("");
                    $("#txtPassword").val("");
                }
            }
        })
    }
})