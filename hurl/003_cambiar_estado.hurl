# Característica: Cambiar el estado de un ticket
#
#   Escenario: El agente trabaja el ticket y el cliente confirma la resolución
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
  "descripcion": "Internet muy lento por la noche."
}
HTTP 201
[Captures]
id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists


#     Cuando el agente cambia el estado del ticket "id" a "en_proceso"
#     Entonces la solicitud debe ser exitosa
#     Y no deben existir errores o violaciones en la respuesta
#     Y el estado debe ser "en_proceso"
#     Y la fecha de finalización debe estar vacía

PATCH {{ host }}/tickets/{{ id }}/estado
Accept: application/json
Prefer: example=en-proceso
{ "estado": "en_proceso" }
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ id }}
jsonpath "$.estado" == "en_proceso"
jsonpath "$.fecha_finalizacion" == null


#     Cuando el agente cambia el estado del ticket "id" a "en_revision"
#     Entonces la solicitud debe ser exitosa
#     Y el estado debe ser "en_revision"
#     Y la fecha de finalización debe estar vacía

PATCH {{ host }}/tickets/{{ id }}/estado
Accept: application/json
Prefer: example=en-revision
{ "estado": "en_revision" }
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.estado" == "en_revision"
jsonpath "$.fecha_finalizacion" == null


#     Cuando el cliente cambia el estado del ticket "id" a "cerrado"
#     Entonces la solicitud debe ser exitosa
#     Y el estado debe ser "cerrado"
#     Y la fecha de finalización debe ser una fecha válida

PATCH {{ host }}/tickets/{{ id }}/estado
Accept: application/json
Prefer: example=cerrado
{ "estado": "cerrado" }
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.estado" == "cerrado"
jsonpath "$.fecha_finalizacion" isIsoDate
