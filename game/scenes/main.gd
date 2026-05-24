extends Node2D

@onready var _hex_map: Node2D = $HexMapView
@onready var _info_label: Label = $UI/HUD/Margin/VBox/InfoLabel
@onready var _hint_label: Label = $UI/HUD/Margin/VBox/HintLabel

const FOG_NAMES = {
	HexCell.FogState.HIDDEN: "oculto",
	HexCell.FogState.REVEALED: "revelado",
	HexCell.FogState.VISIBLE: "visible"
}


func _ready() -> void:
	_hex_map.hex_selected.connect(_on_hex_selected)
	_hint_label.text = "Fase 1 — %d hexágonos · clic para seleccionar" % _hex_map.get_cell_count()
	_info_label.text = "Sin selección"


func _on_hex_selected(coords: Vector2i, _terrain_id: String, terrain_name: String, fog_state: int) -> void:
	var fog_text = FOG_NAMES.get(fog_state, "desconocido")
	_info_label.text = "Hex (%d, %d) — %s · %s" % [coords.x, coords.y, terrain_name, fog_text]
