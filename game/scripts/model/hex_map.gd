## Contenedor principal del mapa que gestiona las celdas y su acceso.
class_name HexMap
extends RefCounted

## Semilla con la que se generó este mapa.
var map_seed: int

## Radio del mapa en hexágonos.
var radius: int

## Origen central del mapa.
var origin: Vector2i

## Almacén de celdas: Vector2i -> HexCell.
var _cells: Dictionary = {}


## Genera o regenera el mapa usando el MapGenerator.
## [param p_seed] Semilla aleatoria.
## [param p_radius] Radio del disco.
## [param p_origin] Centro del mapa.
func generate(p_seed: int, p_radius: int, p_origin: Vector2i = Vector2i.ZERO) -> void:
	var new_map := MapGenerator.generate(p_seed, p_radius, p_origin)
	_cells = new_map._cells
	map_seed = p_seed
	radius = p_radius
	origin = p_origin


## Devuelve la celda en las coordenadas indicadas.
## [returns] HexCell o null si la celda no existe en el mapa.
func get_cell(coords: Vector2i) -> HexCell:
	return _cells.get(coords)


## Verifica si existe una celda en las coordenadas indicadas.
func has_cell(coords: Vector2i) -> bool:
	return _cells.has(coords)


## Devuelve el número total de celdas generadas.
func get_cell_count() -> int:
	return _cells.size()


## Devuelve todas las coordenadas de las celdas presentes en el mapa.
## Útil para iterar y dibujar.
func get_all_coords() -> Array[Vector2i]:
	var keys: Array[Vector2i] = []
	for key in _cells.keys():
		keys.append(key)
	return keys
