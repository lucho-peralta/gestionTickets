# Característica: Dar de alta un agente
#
#   Escenario: Se da de alta un agente nuevo
#
#     Dado que el agente "40111222" no está cargado
#     (si quedó de una corrida anterior se da de baja; si no existe, da 404 y se sigue)

DELETE {{ host }}/agentes/40111222
HTTP *


#     Cuando se da de alta el agente con DNI "40111222" y nombre "Juan Pérez"
#     Entonces la creación debe ser exitosa
#     Y no deben existir errores o violaciones en la respuesta
#     Y el DNI del agente debe ser "40111222"
#     Y el nombre del agente debe ser "Juan Pérez"

POST {{ host }}/agentes
Accept: application/json
{
  "dni": "40111222",
  "nombre": "Juan Pérez"
}
HTTP 201
[Asserts]
header "sl-violations" not exists
jsonpath "$.dni" == "40111222"
jsonpath "$.nombre" == "Juan Pérez"


#     Cuando se vuelve a dar de alta el agente con DNI "40111222"
#     Entonces la respuesta debe indicar un conflicto
#     Y el mensaje debe ser "El agente ya existe"

POST {{ host }}/agentes
Accept: application/json
Prefer: code=409
{
  "dni": "40111222",
  "nombre": "Juan Pérez"
}
HTTP 409
[Asserts]
jsonpath "$.message" == "El agente ya existe"


#     Cuando se da de baja el agente "40111222"
#     Entonces la eliminación debe ser exitosa

DELETE {{ host }}/agentes/40111222
HTTP 204
