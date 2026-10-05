# language: es
Característica: Consultar los tickets de un cliente

  Escenario: El cliente consulta sus tickets por DNI

    Dado que hay agentes cargados en el sistema

    Cuando el cliente crea un ticket con DNI "30123456" y categoría "conexion"
    Entonces la creación debe ser exitosa
    Y el ID del ticket se guarda como "id"

    Cuando se solicitan los tickets del cliente con DNI "30123456"
    Entonces la solicitud debe ser exitosa
    Y no deben existir errores o violaciones en la respuesta
    Y la respuesta debe contener una lista con al menos un ticket
    Y el primer ticket de la lista debe ser el más reciente, con ID "id"
    Y el DNI del cliente del primer ticket debe ser "30123456"
