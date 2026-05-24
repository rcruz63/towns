## Sistema encargado de la generación procedural y determinista del mapa.
class_name MapGenerator
extends RefCounted

## Genera un objeto HexMap completo basado en una semilla y radio.
## [param seed] Semilla para el generador aleatorio.
## [param radius] Radio del mapa (disco).
## [param origin] Celda central del mapa.
## [returns] Un HexMap listo para ser usado por la vista.
static func generate(p_seed: int, p_radius: int, p_origin: Vector2i = Vector2i.ZERO) -> HexMap:
	var map := HexMap.new()
	map.map_seed = p_seed
	map.radius = p_radius
	map.origin = p_origin
	
	var rng := RandomNumberGenerator.new()
	rng.seed = p_seed
	
	for coords in HexMath.disk(p_origin, p_radius):
		var dist := HexMath.axial_distance(coords, p_origin)
		var terrain_id := _pick_terrain(dist, p_radius, rng)
		
		# Mejora opcional: clusters de montañas
		if dist < p_radius - 2 and terrain_id != "mountain":
			for neighbor_coords in HexMath.axial_neighbors(coords):
				if map.has_cell(neighbor_coords):
					var neighbor := map.get_cell(neighbor_coords)
					if neighbor.terrain_id == "mountain" and rng.randf() < 0.15:
						terrain_id = "mountain"
						break

		var cell := HexCell.new(coords, terrain_id)
		map._cells[coords] = cell
		
	return map


## Lógica de selección de terreno basada en la distancia al centro y probabilidad.
## [param dist] Distancia al centro.
## [param radius] Radio total del mapa.
## [param rng] Generador de números aleatorios con semilla.
static func _pick_terrain(dist: int, radius: int, rng: RandomNumberGenerator) -> String:
	# Borde exterior: Océano puro
	if dist >= radius:
		return "ocean"
	
	# Primer anillo interior: Océano mayoritario, algo de tierra pobre
	if dist >= radius - 1:
		return "ocean" if rng.randf() < 0.7 else "poor"
	
	# Segundo anillo: Mezcla de costa
	if dist >= radius - 2:
		var roll := rng.randi_range(0, 99)
		if roll < 40: return "ocean"
		if roll < 65: return "poor"
		if roll < 85: return "desert"
		return "hills"

	# Interior: Distribución continental
	var roll := rng.randi_range(0, 99)
	if roll < 22: return "fertile"
	if roll < 38: return "hills"
	if roll < 52: return "poor"
	if roll < 64: return "desert"
	if roll < 76: return "mountain"
	if roll < 86: return "snow"
	if roll < 94: return "fertile"
	return "hills"
