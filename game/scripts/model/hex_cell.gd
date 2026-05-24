## Representa los datos de una única celda en el mapa.
## Clase de datos pura sin lógica de vista.
class_name HexCell
extends RefCounted

## Estado de visibilidad de una celda (niebla de guerra).
enum FogState {
	HIDDEN,   # No explorado, negro total.
	REVEALED, # Explorado antes pero fuera de visión actual (grisáceo).
	VISIBLE   # En rango de visión actual.
}

## Identificador único del tipo de terreno (debe existir en TerrainCatalog).
var terrain_id: String

## Lista de entidades presentes en la celda (p. ej. unidades, recursos).
## Reservado para Fase 2+.
var entities: Array = []

## Identificador del edificio construido en esta celda. Cadena vacía si no hay ninguno.
var building_id: String = ""

## Estado actual de la niebla de guerra para el jugador.
var fog_state: int = FogState.VISIBLE

## Coordenadas axiales de la celda. Útil para depuración y referencia inversa.
var coords: Vector2i


## Constructor de la celda.
## [param p_coords] Coordenadas (q, r).
## [param p_terrain_id] ID del terreno inicial.
func _init(p_coords: Vector2i, p_terrain_id: String) -> void:
	coords = p_coords
	terrain_id = p_terrain_id
