# Característica: Obtener un ticket
#
#   Escenario: Ver un ticket recién creado
#
#     Dado que hay agentes cargados en el sistema
#
#     Cuando el cliente crea un ticket con DNI "30123456" y categoría "facturacion"
#     Entonces la creación debe ser exitosa
#     Y el ID del ticket se guarda como "id"

POST {{ host }}/tickets
Accept: application/json
{
  "dni_cliente": "30123456",
  "categoria": "facturacion",
  "descripcion": "Me cobraron dos veces la factura de septiembre."
}
HTTP 201
[Captures]
id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists


#     Cuando se solicita el ticket "id"
#     Entonces la solicitud debe ser exitosa
#     Y no deben existir errores o violaciones en la respuesta
#     Y el ID del ticket debe ser "id"
#     Y el estado debe ser "asignado"
#     Y el ticket debe tener un agente asignado

GET {{ host }}/tickets/{{ id }}
Accept: application/json
Prefer: example=asignado
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ id }}
jsonpath "$.estado" == "asignado"
jsonpath "$.agente.dni" matches /^\d{7,8}$/
