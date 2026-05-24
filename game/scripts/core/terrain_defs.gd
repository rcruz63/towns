## Catálogo mínimo de terrenos (placeholder Fase 0).
class_name TerrainDefs
extends RefCounted

enum Type {
	OCEAN,
	FERTILE,
	DESERT,
	POOR,
	SNOW,
	MOUNTAIN,
	HILLS,
}

const NAMES: PackedStringArray = [
	"Océano",
	"Fértil",
	"Desierto",
	"Pobre",
	"Nieve",
	"Montaña",
	"Colinas",
]

const COLORS: PackedColorArray = [
	Color(0.15, 0.35, 0.72), # océano
	Color(0.28, 0.62, 0.22), # fértil
	Color(0.82, 0.71, 0.38), # desierto
	Color(0.45, 0.40, 0.32), # pobre
	Color(0.88, 0.92, 0.96), # nieve
	Color(0.42, 0.44, 0.48), # montaña
	Color(0.36, 0.52, 0.30), # colinas
]

const OUTLINE := Color(0.08, 0.08, 0.10)
const SELECTED_TINT := Color(1.15, 1.15, 1.15)
const SELECTED_OUTLINE := Color(0.95, 0.85, 0.25)


static func name_for(terrain: Type) -> String:
	return NAMES[terrain]


static func color_for(terrain: Type) -> Color:
	return COLORS[terrain]
