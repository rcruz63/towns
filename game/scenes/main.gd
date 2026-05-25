extends Node2D

@onready var _hex_map: Node2D = $HexMapView
@onready var _info_label: Label = $UI/HUD/Margin/VBox/InfoLabel
@onready var _hint_label: Label = $UI/HUD/Margin/VBox/HintLabel

const FOG_NAMES = {
	HexCell.FogState.HIDDEN: "oculto",
	HexCell.FogState.REVEALED: "revelado",
	HexCell.FogState.VISIBLE: "visible"
}

## Presupuesto de producción para exploración de la sesión de juego.
var _budget: ExplorationBudget


func _ready() -> void:
	_budget = ExplorationBudget.new(ExplorationBudget.STARTING_PRODUCTION)
	_hex_map.budget = _budget
	
	_hex_map.hex_selected.connect(_on_hex_selected)
	_hex_map.explore_succeeded.connect(_on_explore_succeeded)
	_hex_map.explore_failed.connect(_on_explore_failed)
	
	_update_hud()
	_info_label.text = "Sin selección"


## Actualiza el HUD con la producción restante y datos del mapa.
func _update_hud() -> void:
	_hint_label.text = "Fase 2 — Producción: %d | Total hexágonos: %d · clic para explorar/seleccionar" % [
		_budget.production, 
		_hex_map.get_cell_count()
	]


func _on_hex_selected(coords: Vector2i, _terrain_id: String, terrain_name: String, fog_state: int) -> void:
	var fog_text = FOG_NAMES.get(fog_state, "desconocido")
	var map_data: HexMap = _hex_map.get_hex_map()
	
	var cost_text := ""
	if FogSystem.can_explore(map_data, coords):
		var cost := FogSystem.exploration_cost(map_data, coords)
		cost_text = " · Coste: %d" % cost
		
	_info_label.text = "Hex (%d, %d) — %s · %s%s" % [coords.x, coords.y, terrain_name, fog_text, cost_text]


func _on_explore_succeeded(_coords: Vector2i, _cost: int, _production_remaining: int) -> void:
	_update_hud()


func _on_explore_failed(reason: String) -> void:
	_info_label.text = "⚠️ %s" % reason
