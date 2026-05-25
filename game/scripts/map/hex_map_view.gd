## Nodo encargado de la representación visual del mapa y la gestión de entrada del usuario.
## Actúa como la "Vista" en el patrón Modelo-Vista.
extends Node2D

## Emitida cuando el usuario selecciona un hexágono.
## [param coords] Coordenadas axiales.
## [param terrain_id] ID técnico del terreno.
## [param terrain_name] Nombre legible en español.
## [param fog_state] Estado de visibilidad actual.
signal hex_selected(coords: Vector2i, terrain_id: String, terrain_name: String, fog_state: int)

## Emitida cuando la exploración tiene éxito y se revela un hexágono.
## [param coords] Coordenadas axiales exploradas.
## [param cost] Coste de producción cobrado.
## [param production_remaining] Producción restante del jugador.
signal explore_succeeded(coords: Vector2i, cost: int, production_remaining: int)

## Emitida cuando la exploración de un hexágono falla.
## [param reason] Mensaje descriptivo del motivo del fallo.
signal explore_failed(reason: String)

@export var map_radius: int = 10
@export var hex_size: float = 14.0
@export var map_seed: int = 1234

## Presupuesto de producción del jugador, inyectado externamente.
var budget: ExplorationBudget

var _hex_map: HexMap
var _selected: Vector2i = Vector2i(9999, 9999)
var _has_selection := false


func _ready() -> void:
	_hex_map = HexMap.new()
	_generate_map()
	queue_redraw()


## Solicita al modelo que genere un nuevo mapa e inicializa la niebla de guerra.
func _generate_map() -> void:
	_hex_map.generate(map_seed, map_radius)
	FogSystem.initialize_after_generate(_hex_map)


func _draw() -> void:
	if not _hex_map:
		return
		
	var sorted: Array = _hex_map.get_all_coords()
	sorted.sort_custom(_sort_draw_order)

	for coords in sorted:
		var cell := _hex_map.get_cell(coords)
		var center := HexMath.axial_to_pixel(coords.x, coords.y, hex_size)
		
		var fill := Color.MAGENTA
		var outline := TerrainCatalog.OUTLINE
		var line_width := 1.0

		match cell.fog_state:
			HexCell.FogState.HIDDEN:
				fill = Color(0.06, 0.06, 0.09)
			HexCell.FogState.REVEALED:
				var base_color := TerrainCatalog.get_color(cell.terrain_id)
				fill = Color(base_color.r * 0.45, base_color.g * 0.45, base_color.b * 0.45, 0.5)
			HexCell.FogState.VISIBLE:
				fill = TerrainCatalog.get_color(cell.terrain_id)

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
## Si la celda es explorable y se dispone de producción suficiente, se explora y revela.
## En caso contrario, se selecciona el hexágono de forma normal para ver sus detalles o coste.
func _try_select_at(local: Vector2) -> void:
	var coords := HexMath.pixel_to_axial(local, hex_size)
	if not _hex_map.has_cell(coords):
		return

	var cell := _hex_map.get_cell(coords)
	var is_explorable := FogSystem.can_explore(_hex_map, coords)
	var cost := FogSystem.exploration_cost(_hex_map, coords)

	if is_explorable:
		if budget and budget.can_afford(cost):
			var success := FogSystem.try_explore(_hex_map, coords, budget)
			if success:
				_selected = coords
				_has_selection = true
				queue_redraw()
				
				var terrain_name := TerrainCatalog.get_terrain_name(cell.terrain_id)
				hex_selected.emit(coords, cell.terrain_id, terrain_name, cell.fog_state)
				explore_succeeded.emit(coords, cost, budget.production)
				return
		
		# Si es frontera explorable pero no hay fondos
		_selected = coords
		_has_selection = true
		queue_redraw()
		
		var terrain_name := TerrainCatalog.get_terrain_name(cell.terrain_id)
		var name_to_emit := terrain_name
		if cell.fog_state == HexCell.FogState.HIDDEN:
			name_to_emit = "?"
		
		hex_selected.emit(coords, cell.terrain_id, name_to_emit, cell.fog_state)
		
		var current_prod := budget.production if budget else 0
		explore_failed.emit("Producción insuficiente (cuesta %d, tienes %d)." % [cost, current_prod])
	else:
		# Si no es explorable
		_selected = coords
		_has_selection = true
		queue_redraw()
		
		if cell.fog_state == HexCell.FogState.HIDDEN:
			hex_selected.emit(coords, cell.terrain_id, "?", cell.fog_state)
			explore_failed.emit("Demasiado lejos del territorio visible.")
		else:
			var terrain_name := TerrainCatalog.get_terrain_name(cell.terrain_id)
			hex_selected.emit(coords, cell.terrain_id, terrain_name, cell.fog_state)


## Devuelve la cantidad de celdas en el mapa actual.
func get_cell_count() -> int:
	return _hex_map.get_cell_count() if _hex_map else 0


## Devuelve la referencia al mapa de celdas del modelo.
## [returns] El mapa HexMap.
func get_hex_map() -> HexMap:
	return _hex_map
