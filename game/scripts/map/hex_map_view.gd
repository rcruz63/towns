## Nodo encargado de la representación visual del mapa y la gestión de entrada del usuario.
## Actúa como la "Vista" en el patrón Modelo-Vista.
extends Node2D

## Emitida cuando el usuario selecciona un hexágono.
## [param coords] Coordenadas axiales.
## [param terrain_id] ID técnico del terreno.
## [param terrain_name] Nombre legible en español.
## [param fog_state] Estado de visibilidad actual.
signal hex_selected(coords: Vector2i, terrain_id: String, terrain_name: String, fog_state: int)

@export var map_radius: int = 10
@export var hex_size: float = 14.0
@export var map_seed: int = 1234

var _hex_map: HexMap
var _selected: Vector2i = Vector2i(9999, 9999)
var _has_selection := false


func _ready() -> void:
	_hex_map = HexMap.new()
	_generate_map()
	queue_redraw()


## Solicita al modelo que genere un nuevo mapa.
func _generate_map() -> void:
	_hex_map.generate(map_seed, map_radius)


func _draw() -> void:
	if not _hex_map:
		return
		
	var sorted: Array = _hex_map.get_all_coords()
	sorted.sort_custom(_sort_draw_order)

	for coords in sorted:
		var cell := _hex_map.get_cell(coords)
		var center := HexMath.axial_to_pixel(coords.x, coords.y, hex_size)
		
		var fill := TerrainCatalog.get_color(cell.terrain_id)
		var outline := TerrainCatalog.OUTLINE
		var line_width := 1.0

		if _has_selection and coords == _selected:
			fill = fill * TerrainCatalog.SELECTED_TINT
			outline = TerrainCatalog.SELECTED_OUTLINE
			line_width = 2.0

		var corners := HexMath.hex_corners(center, hex_size * 0.96)
		draw_colored_polygon(corners, fill)
		draw_polyline(corners, outline, line_width, true)


## Ordena las celdas para un dibujado coherente (de norte a sur).
func _sort_draw_order(a: Vector2i, b: Vector2i) -> bool:
	if a.y == b.y:
		return a.x < b.x
	return a.y < b.y


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var click := event as InputEventMouseButton
		if click.pressed and click.button_index == MOUSE_BUTTON_LEFT:
			_try_select_at(get_local_mouse_position())


## Intenta seleccionar la celda bajo la posición local del ratón.
func _try_select_at(local: Vector2) -> void:
	var coords := HexMath.pixel_to_axial(local, hex_size)
	if not _hex_map.has_cell(coords):
		return

	_selected = coords
	_has_selection = true
	queue_redraw()

	var cell := _hex_map.get_cell(coords)
	var terrain_name := TerrainCatalog.get_terrain_name(cell.terrain_id)
	hex_selected.emit(coords, cell.terrain_id, terrain_name, cell.fog_state)


## Devuelve la cantidad de celdas en el mapa actual.
func get_cell_count() -> int:
	return _hex_map.get_cell_count() if _hex_map else 0
