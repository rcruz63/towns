extends Node2D

signal hex_selected(coords: Vector2i, terrain: TerrainDefs.Type, terrain_name: String)

@export var map_radius: int = 10
@export var hex_size: float = 14.0
@export var map_seed: int = 4242

var _cells: Dictionary = {} # Vector2i -> TerrainDefs.Type
var _selected: Vector2i = Vector2i(9999, 9999)
var _has_selection := false


func _ready() -> void:
	_generate_map()
	queue_redraw()


func _generate_map() -> void:
	_cells.clear()
	var rng := RandomNumberGenerator.new()
	rng.seed = map_seed
	var origin := Vector2i.ZERO

	for coords in HexMath.disk(origin, map_radius):
		var dist := HexMath.axial_distance(coords, origin)
		var terrain := _pick_terrain(dist, map_radius, rng)
		_cells[coords] = terrain


func _pick_terrain(dist: int, radius: int, rng: RandomNumberGenerator) -> TerrainDefs.Type:
	if dist >= radius:
		return TerrainDefs.Type.OCEAN
	if dist >= radius - 1:
		return TerrainDefs.Type.OCEAN if rng.randf() < 0.7 else TerrainDefs.Type.POOR
	if dist >= radius - 2:
		var roll := rng.randi_range(0, 99)
		if roll < 40:
			return TerrainDefs.Type.OCEAN
		if roll < 65:
			return TerrainDefs.Type.POOR
		if roll < 85:
			return TerrainDefs.Type.DESERT
		return TerrainDefs.Type.HILLS

	var roll := rng.randi_range(0, 99)
	if roll < 22:
		return TerrainDefs.Type.FERTILE
	if roll < 38:
		return TerrainDefs.Type.HILLS
	if roll < 52:
		return TerrainDefs.Type.POOR
	if roll < 64:
		return TerrainDefs.Type.DESERT
	if roll < 76:
		return TerrainDefs.Type.MOUNTAIN
	if roll < 86:
		return TerrainDefs.Type.SNOW
	if roll < 94:
		return TerrainDefs.Type.FERTILE
	return TerrainDefs.Type.HILLS


func _draw() -> void:
	var sorted: Array[Vector2i] = []
	for coords in _cells.keys():
		sorted.append(coords)
	sorted.sort_custom(_sort_draw_order)

	for coords in sorted:
		var center := HexMath.axial_to_pixel(coords.x, coords.y, hex_size)
		var terrain: TerrainDefs.Type = _cells[coords]
		var fill := TerrainDefs.color_for(terrain)
		var outline := TerrainDefs.OUTLINE
		var line_width := 1.0

		if _has_selection and coords == _selected:
			fill = fill * TerrainDefs.SELECTED_TINT
			outline = TerrainDefs.SELECTED_OUTLINE
			line_width = 2.0

		var corners := HexMath.hex_corners(center, hex_size * 0.96)
		draw_colored_polygon(corners, fill)
		draw_polyline(corners, outline, line_width, true)


func _sort_draw_order(a: Vector2i, b: Vector2i) -> bool:
	# Dibujar filas más al norte primero para solapado coherente.
	if a.y == b.y:
		return a.x < b.x
	return a.y < b.y


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var click := event as InputEventMouseButton
		if click.pressed and click.button_index == MOUSE_BUTTON_LEFT:
			_try_select_at(get_local_mouse_position())


func _try_select_at(local: Vector2) -> void:
	var coords := HexMath.pixel_to_axial(local, hex_size)
	if not _cells.has(coords):
		return

	_selected = coords
	_has_selection = true
	queue_redraw()

	var terrain: TerrainDefs.Type = _cells[coords]
	hex_selected.emit(coords, terrain, TerrainDefs.name_for(terrain))


func get_cell_count() -> int:
	return _cells.size()
