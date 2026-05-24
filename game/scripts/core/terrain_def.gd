## Definición de un tipo de terreno y sus propiedades base.
class_name TerrainDef
extends RefCounted

## ID técnico en snake_case (ej: "fertile").
var terrain_id: String

## Nombre legible para el jugador en la interfaz.
var display_name: String

## Clave para buscar el sprite correspondiente (en Fase 1 es igual al ID).
var sprite_key: String

## Etiquetas que definen qué se puede construir o qué reglas aplican (ej: ["mining", "elevated"]).
var build_tags: PackedStringArray

## Color representativo usado como placeholder visual.
var color: Color


## [param p_id] ID técnico.
## [param p_name] Nombre en español.
## [param p_tags] Etiquetas de construcción.
## [param p_color] Color base.
func _init(p_id: String, p_name: String, p_tags: PackedStringArray, p_color: Color) -> void:
	terrain_id = p_id
	display_name = p_name
	sprite_key = p_id
	build_tags = p_tags
	color = p_color
