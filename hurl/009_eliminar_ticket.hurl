# Característica: Eliminar un ticket
#
#   Escenario: El agente elimina un ticket
#
#     Dado que hay agentes cargados en el sistema
#
#     Cuando el cliente crea un ticket con DNI "30123456" y categoría "otro"
#     Entonces la creación debe ser exitosa
#     Y el ID del ticket se guarda como "id"

POST {{ host }}/tickets
Accept: application/json
{
  "dni_cliente": "30123456",
  "categoria": "otro",
  "descripcion": "Ticket cargado por error."
}
HTTP 201
[Captures]
id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists


#     Cuando se elimina el ticket "id"
#     Entonces la eliminación debe ser exitosa
#     Y no deben existir errores o violaciones en la respuesta

DELETE {{ host }}/tickets/{{ id }}
HTTP 204
[Asserts]
header "sl-violations" not exists


#     Cuando se solicita el ticket "id"
#     Entonces la respuesta debe indicar que el ticket no existe
#     Y el mensaje debe ser "Ticket no encontrado"

GET {{ host }}/tickets/{{ id }}
Accept: application/json
Prefer: code=404
HTTP 404
[Asserts]
jsonpath "$.message" == "Ticket no encontrado"
