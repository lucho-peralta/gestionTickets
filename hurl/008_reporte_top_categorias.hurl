# Característica: Reporte de top de categorías
#
#   Escenario: Obtener las categorías con más tickets
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
  "descripcion": "La velocidad no es la contratada."
}
HTTP 201
[Asserts]
header "sl-violations" not exists


#     Cuando se solicita el top de categorías sin indicar cantidad
#     Entonces la solicitud debe ser exitosa
#     Y no deben existir errores o violaciones en la respuesta
#     Y el reporte debe contener 3 categorías
#     Y cada categoría debe tener nombre y cantidad

GET {{ host }}/reportes/top-categorias
Accept: application/json
Prefer: example=top-3
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count == 3
jsonpath "$[0].categoria" isString
jsonpath "$[0].cantidad" isInteger


#     Cuando se solicita el top de 2 categorías
#     Entonces la solicitud debe ser exitosa
#     Y el reporte debe contener 2 categorías

GET {{ host }}/reportes/top-categorias?limite=2
Accept: application/json
Prefer: example=top-2
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count == 2
