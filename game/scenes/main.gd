extends Node2D

@onready var _hex_map: Node2D = $HexMapView
@onready var _info_label: Label = $UI/HUD/Margin/VBox/InfoLabel
@onready var _hint_label: Label = $UI/HUD/Margin/VBox/HintLabel


func _ready() -> void:
	_hex_map.hex_selected.connect(_on_hex_selected)
	_hint_label.text = "Fase 0 — %d hexágonos · clic para seleccionar" % _hex_map.get_cell_count()
	_info_label.text = "Sin selección"


func _on_hex_selected(coords: Vector2i, _terrain: TerrainDefs.Type, terrain_name: String) -> void:
	_info_label.text = "Hex (%d, %d) — %s" % [coords.x, coords.y, terrain_name]
