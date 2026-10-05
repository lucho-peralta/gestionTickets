# Característica: Reporte de frecuencia por categoría
#
#   Escenario: Obtener la cantidad de tickets de cada categoría
#
#     Dado que hay agentes cargados en el sistema
#
#     Cuando el cliente crea un ticket con categoría "conexion"
#     Entonces la creación debe ser exitosa

POST {{ host }}/tickets
Accept: application/json
{
  "dni_cliente": "30123456",
  "categoria": "conexion",
  "descripcion": "El módem no enciende."
}
HTTP 201
[Asserts]
header "sl-violations" not exists


#     Cuando se solicita el reporte de frecuencia por categoría
#     Entonces la solicitud debe ser exitosa
#     Y no deben existir errores o violaciones en la respuesta
#     Y el reporte debe contener las 4 categorías: "conexion", "facturacion", "consulta_general" y "otro"
#     Y la cantidad de cada categoría debe ser un entero

GET {{ host }}/reportes/frecuencia-categorias
Accept: application/json
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count == 4
jsonpath "$[*].categoria" contains "conexion"
jsonpath "$[*].categoria" contains "facturacion"
jsonpath "$[*].categoria" contains "consulta_general"
jsonpath "$[*].categoria" contains "otro"
jsonpath "$[0].cantidad" isInteger
jsonpath "$[1].cantidad" isInteger
jsonpath "$[2].cantidad" isInteger
jsonpath "$[3].cantidad" isInteger
