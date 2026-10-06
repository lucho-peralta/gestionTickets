# Característica: Reporte de tiempo promedio de resolución
#
#   Escenario: Obtener el tiempo promedio de los tickets cerrados
#
#     Dado que hay agentes cargados en el sistema
#
#     Cuando el cliente crea un ticket con categoría "conexion"
#     Entonces la creación debe ser exitosa
#     Y el ID del ticket se guarda como "id"

POST {{ host }}/tickets
Accept: application/json
{
  "dni_cliente": "30123456",
  "categoria": "conexion",
  "descripcion": "Sin señal de wifi."
}
HTTP 201
[Captures]
id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists


#     Cuando el cliente cambia el estado del ticket "id" a "cerrado"
#     Entonces la solicitud debe ser exitosa
#     Y el estado debe ser "cerrado"

PATCH {{ host }}/tickets/{{ id }}/estado
Accept: application/json
Prefer: example=cerrado
{ "estado": "cerrado" }
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.estado" == "cerrado"


#     Cuando se solicita el reporte de tiempo promedio de resolución
#     Entonces la solicitud debe ser exitosa
#     Y no deben existir errores o violaciones en la respuesta
#     Y la categoría del reporte debe estar vacía
#     Y la cantidad de tickets cerrados debe ser mayor o igual a 1
#     Y el promedio en horas debe ser un número mayor o igual a 0

GET {{ host }}/reportes/tiempo-promedio-resolucion
Accept: application/json
Prefer: example=general
HTTP 200
[Asserts]
header "sl-violations" not exists

jsonpath "$.categoria" == null
jsonpath "$.tickets_cerrados" >= 1
jsonpath "$.promedio_horas" isFloat
jsonpath "$.promedio_horas" >= 0




#     Cuando se solicita el reporte de tiempo promedio para la categoría "conexion"
#     Entonces la solicitud debe ser exitosa
#     Y la cantidad de tickets cerrados debe ser un entero

GET {{ host }}/reportes/tiempo-promedio-resolucion?categoria=conexion
Accept: application/json
Prefer: example=general
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.tickets_cerrados" isInteger
