# Característica: Dar de baja un agente
#
#   Escenario: Se da de baja un agente sin tickets
#
#     Dado que el agente "40111222" no está cargado
#     (si quedó de una corrida anterior se da de baja; si no existe, da 404 y se sigue)

DELETE {{ host }}/agentes/40111222
HTTP *


#     Cuando se da de alta el agente con DNI "40111222" y nombre "Juan Pérez"
#     Entonces la creación debe ser exitosa

POST {{ host }}/agentes
Accept: application/json
{
  "dni": "40111222",
  "nombre": "Juan Pérez"
}
HTTP 201
[Asserts]
header "sl-violations" not exists


#     Cuando se da de baja el agente "40111222"
#     Entonces la eliminación debe ser exitosa
#     Y no deben existir errores o violaciones en la respuesta

DELETE {{ host }}/agentes/40111222
HTTP 204
[Asserts]
header "sl-violations" not exists


#     Cuando se vuelve a dar de baja el agente "40111222"
#     Entonces la respuesta debe indicar que el agente no existe
#     Y el mensaje debe ser "Agente no encontrado"

DELETE {{ host }}/agentes/40111222
Accept: application/json
Prefer: code=404
HTTP 404
[Asserts]
jsonpath "$.message" == "Agente no encontrado"


#   Escenario: No se puede dar de baja un agente con tickets
#
#     Dado que hay agentes cargados en el sistema
#
#     Cuando el cliente crea un ticket con DNI "30123456" y categoría "consulta_general"
#     Entonces la creación debe ser exitosa
#     Y el DNI del agente asignado se guarda como "dni_agente"

POST {{ host }}/tickets
Accept: application/json
{
  "dni_cliente": "30123456",
  "categoria": "consulta_general",
  "descripcion": "Quiero saber los horarios de atención."
}
HTTP 201
[Captures]
dni_agente: jsonpath "$.agente.dni"
[Asserts]
header "sl-violations" not exists


#     Cuando se da de baja el agente "dni_agente"
#     Entonces la respuesta debe indicar un conflicto
#     Y el mensaje debe ser "El agente tiene tickets asignados"

DELETE {{ host }}/agentes/{{ dni_agente }}
Accept: application/json
Prefer: code=409
HTTP 409
[Asserts]
jsonpath "$.message" == "El agente tiene tickets asignados"
