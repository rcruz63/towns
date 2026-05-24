## Catálogo estático que centraliza todos los tipos de terreno disponibles.
class_name TerrainCatalog
extends RefCounted

## Diccionario de [id: String] -> [TerrainDef].
static var _data: Dictionary = {}

## Colores y estilos globales heredados de Fase 0 para la vista.
const OUTLINE := Color(0.08, 0.08, 0.10)
const SELECTED_TINT := Color(1.15, 1.15, 1.15)
const SELECTED_OUTLINE := Color(0.95, 0.85, 0.25)


## Inicializa el catálogo con los 7 terrenos base.
static func _static_init() -> void:
	_register("ocean", "Océano", ["water"], Color(0.15, 0.35, 0.72))
	_register("fertile", "Fértil", ["fertile"], Color(0.28, 0.62, 0.22))
	_register("desert", "Desierto", ["arid"], Color(0.82, 0.71, 0.38))
	_register("poor", "Pobre", ["poor"], Color(0.45, 0.40, 0.32))
	_register("snow", "Nieve", ["cold"], Color(0.88, 0.92, 0.96))
	_register("mountain", "Montaña", ["mining", "elevated"], Color(0.42, 0.44, 0.48))
	_register("hills", "Colinas", ["hills"], Color(0.36, 0.52, 0.30))


static func _register(id: String, display_name: String, tags: Array, color: Color) -> void:
	_data[id] = TerrainDef.new(id, display_name, PackedStringArray(tags), color)


## Devuelve la definición de un terreno por su ID.
## [returns] TerrainDef o null si no existe.
static func get_def(id: String) -> TerrainDef:
	return _data.get(id)


## Devuelve el nombre legible de un terreno.
static func get_terrain_name(id: String) -> String:
	var def := get_def(id)
	return def.display_name if def else "Desconocido"


## Devuelve el color de un terreno para el dibujo placeholder.
static func get_color(id: String) -> Color:
	var def := get_def(id)
	return def.color if def else Color.MAGENTA
