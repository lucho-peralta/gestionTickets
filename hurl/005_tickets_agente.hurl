# Característica: Consultar los tickets asignados a un agente
#
#   Escenario: El agente consulta su bandeja de trabajo por DNI
#
#     Dado que hay agentes cargados en el sistema
#
#     Cuando el cliente crea un ticket con DNI "30123456" y categoría "facturacion"
#     Entonces la creación debe ser exitosa
#     Y el ID del ticket se guarda como "id"
#     Y el DNI del agente asignado se guarda como "dni_agente"

POST {{ host }}/tickets
Accept: application/json
{
  "dni_cliente": "30123456",
  "categoria": "facturacion",
  "descripcion": "No me llegó la factura de este mes."
}
HTTP 201
[Captures]
id: jsonpath "$.id"
dni_agente: jsonpath "$.agente.dni"
[Asserts]
header "sl-violations" not exists


#     Cuando se solicitan los tickets del agente "dni_agente"
#     Entonces la solicitud debe ser exitosa
#     Y no deben existir errores o violaciones en la respuesta
#     Y la respuesta debe contener una lista con al menos un ticket
#     Y la lista debe contener el ticket "id"
#     Y los tickets deben estar asignados al agente "dni_agente"

GET {{ host }}/agentes/{{ dni_agente }}/tickets
Accept: application/json
Prefer: example=uno-asignado
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" isCollection
jsonpath "$" count >= 1
jsonpath "$[?(@.id == {{ id }})].id" == {{ id }}
jsonpath "$[0].agente.dni" == "{{ dni_agente }}"


#     Cuando se solicitan los tickets del agente "dni_agente" filtrados por estado "asignado"
#     Entonces la solicitud debe ser exitosa
#     Y todos los tickets de la lista deben estar en estado "asignado"

GET {{ host }}/agentes/{{ dni_agente }}/tickets?estado=asignado
Accept: application/json
Prefer: example=uno-asignado
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$[?(@.estado != 'asignado')]" not exists
