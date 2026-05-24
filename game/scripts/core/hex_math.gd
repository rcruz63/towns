## Utilidades puras para coordenadas hexagonales axiales (q, r).
## Orientación: punta arriba (pointy-top).
class_name HexMath
extends RefCounted

const SQRT3 := 1.7320508075688772

const AXIAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i(1, 0),
	Vector2i(1, -1),
	Vector2i(0, -1),
	Vector2i(-1, 0),
	Vector2i(-1, 1),
	Vector2i(0, 1),
]


static func axial_to_pixel(q: int, r: int, hex_size: float) -> Vector2:
	var x := hex_size * (SQRT3 * float(q) + SQRT3 * 0.5 * float(r))
	var y := hex_size * 1.5 * float(r)
	return Vector2(x, y)


static func pixel_to_axial(local: Vector2, hex_size: float) -> Vector2i:
	var q := (SQRT3 / 3.0 * local.x - 1.0 / 3.0 * local.y) / hex_size
	var r := (2.0 / 3.0 * local.y) / hex_size
	return axial_round(q, r)


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


static func axial_distance(a: Vector2i, b: Vector2i) -> int:
	var dq := a.x - b.x
	var dr := a.y - b.y
	var ds := -dq - dr
	return maxi(maxi(absi(dq), absi(dr)), absi(ds))


static func axial_neighbors(coords: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for direction in AXIAL_DIRECTIONS:
		result.append(coords + direction)
	return result


static func hex_corners(center: Vector2, hex_size: float) -> PackedVector2Array:
	var corners := PackedVector2Array()
	corners.resize(6)
	for i in range(6):
		var angle := deg_to_rad(60.0 * float(i) - 30.0)
		corners[i] = center + Vector2(cos(angle), sin(angle)) * hex_size
	return corners


static func disk(center: Vector2i, radius: int) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for q in range(-radius, radius + 1):
		var r1 := maxi(-radius, -q - radius)
		var r2 := mini(radius, -q + radius)
		for r in range(r1, r2 + 1):
			cells.append(center + Vector2i(q, r))
	return cells
