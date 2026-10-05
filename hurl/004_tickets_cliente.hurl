# Característica: Consultar los tickets de un cliente
#
#   Escenario: El cliente consulta sus tickets por DNI
#
#     Dado que hay agentes cargados en el sistema
#
#     Cuando el cliente crea un ticket con DNI "30123456" y categoría "conexion"
#     Entonces la creación debe ser exitosa
#     Y el ID del ticket se guarda como "id"

POST {{ host }}/tickets
Accept: application/json
{
  "dni_cliente": "30123456",
  "categoria": "conexion",
  "descripcion": "Se corta la conexión cada media hora."
}
HTTP 201
[Captures]
id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists


#     Cuando se solicitan los tickets del cliente con DNI "30123456"
#     Entonces la solicitud debe ser exitosa
#     Y no deben existir errores o violaciones en la respuesta
#     Y la respuesta debe contener una lista con al menos un ticket
#     Y el primer ticket de la lista debe ser el más reciente, con ID "id"
#     Y el DNI del cliente del primer ticket debe ser "30123456"

GET {{ host }}/clientes/30123456/tickets
Accept: application/json
Prefer: example=uno-en-revision
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" isCollection
jsonpath "$" count >= 1
jsonpath "$[0].id" == {{ id }}
jsonpath "$[0].dni_cliente" == "30123456"
