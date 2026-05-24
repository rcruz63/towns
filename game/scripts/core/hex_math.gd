## Utilidades puras para coordenadas hexagonales axiales (q, r).
##
## Sin dependencias de escena ni de dibujo. Orientación: punta arriba (pointy-top).
## Referencia: https://www.redblobgames.com/grids/hexagons/
class_name HexMath
extends RefCounted

const SQRT3 := 1.7320508075688772

## Los seis vecinos en coordenadas axiales, en orden horario.
const AXIAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i(1, 0),
	Vector2i(1, -1),
	Vector2i(0, -1),
	Vector2i(-1, 0),
	Vector2i(-1, 1),
	Vector2i(0, 1),
]


## Convierte (q, r) a posición local en píxeles (centro del hexágono).
## [param q] Columna axial.
## [param r] Fila axial.
## [param hex_size] Radio exterior del hexágono en píxeles.
## [returns] Posición en el espacio local del nodo que dibuja el mapa.
static func axial_to_pixel(q: int, r: int, hex_size: float) -> Vector2:
	var x := hex_size * (SQRT3 * float(q) + SQRT3 * 0.5 * float(r))
	var y := hex_size * 1.5 * float(r)
	return Vector2(x, y)


## Convierte un punto local (píxeles) a la celda axial más cercana.
## [param local] Posición en espacio local del mapa (p. ej. ratón).
## [param hex_size] Mismo radio que en [method axial_to_pixel].
## [returns] Coordenadas (q, r) redondeadas al hexágono bajo el punto.
static func pixel_to_axial(local: Vector2, hex_size: float) -> Vector2i:
	var q := (SQRT3 / 3.0 * local.x - 1.0 / 3.0 * local.y) / hex_size
	var r := (2.0 / 3.0 * local.y) / hex_size
	return axial_round(q, r)


## Redondea coordenadas axiales fraccionarias al hexágono más cercano (redondeo cúbico).
## [param q] Componente q en float.
## [param r] Componente r en float.
## [returns] Celda axial entera.
static func axial_round(q: float, r: float) -> Vector2i:
	var s := -q - r
	var rq := roundi(q)
	var rr := roundi(r)
	var rs := roundi(s)
	var q_diff := absf(rq - q)
	var r_diff := absf(rr - r)
	var s_diff := absf(rs - s)
	if q_diff > r_diff and q_diff > s_diff:
		rq = -rr - rs
	elif r_diff > s_diff:
		rr = -rq - rs
	return Vector2i(rq, rr)


## Distancia en pasos de hexágono entre dos celdas.
## [param a] Celda origen (q, r) como Vector2i.
## [param b] Celda destino.
## [returns] Número entero >= 0.
static func axial_distance(a: Vector2i, b: Vector2i) -> int:
	var dq := a.x - b.x
	var dr := a.y - b.y
	var ds := -dq - dr
	return maxi(maxi(absi(dq), absi(dr)), absi(ds))


## Devuelve las seis celdas vecinas de [param coords].
## [returns] Array de hasta 6 Vector2i (siempre 6 en mapa infinito).
static func axial_neighbors(coords: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for direction in AXIAL_DIRECTIONS:
		result.append(coords + direction)
	return result


## Vértices de un hexágono para dibujar con [method CanvasItem.draw_colored_polygon].
## [param center] Centro en píxeles.
## [param hex_size] Radio exterior.
## [returns] Seis puntos en orden horario.
static func hex_corners(center: Vector2, hex_size: float) -> PackedVector2Array:
	var corners := PackedVector2Array()
	corners.resize(6)
	for i in range(6):
		var angle := deg_to_rad(60.0 * float(i) - 30.0)
		corners[i] = center + Vector2(cos(angle), sin(angle)) * hex_size
	return corners


## Todas las celdas dentro de un disco axial (incluye el centro).
## [param center] Centro del disco en coordenadas axiales.
## [param radius] Radio en número de hexágonos (0 = solo el centro).
## [returns] Lista de celdas (q, r).
static func disk(center: Vector2i, radius: int) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for q in range(-radius, radius + 1):
		var r1 := maxi(-radius, -q - radius)
		var r2 := mini(radius, -q + radius)
		for r in range(r1, r2 + 1):
			cells.append(center + Vector2i(q, r))
	return cells
