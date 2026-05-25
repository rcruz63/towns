## Sistema encargado de gestionar la niebla de guerra y las reglas de exploración.
## Aplica costes, valida vecindarios y actualiza el estado de visibilidad de las celdas.
class_name FogSystem
extends RefCounted

## Coste base fijo para explorar cualquier celda válida.
const EXPLORE_BASE_COST := 2

## Coste adicional por cada anillo de distancia desde el origen del mapa.
const EXPLORE_COST_PER_RING := 1


## Inicializa el estado de la niebla tras la generación del mapa.
## Todas las celdas se ocultan (HIDDEN) excepto la celda de origen que pasa a ser visible (VISIBLE).
## Tras esto, calcula las celdas reveladas (REVEALED) adyacentes al origen.
## [param hex_map] Referencia al mapa que se va a inicializar.
static func initialize_after_generate(hex_map: HexMap) -> void:
	if not hex_map:
		return
	
	var coords_list := hex_map.get_all_coords()
	for coords in coords_list:
		var cell := hex_map.get_cell(coords)
		if cell:
			if coords == hex_map.origin:
				cell.fog_state = HexCell.FogState.VISIBLE
			else:
				cell.fog_state = HexCell.FogState.HIDDEN
				
	refresh_revealed(hex_map)


## Actualiza el estado de las celdas ocultas (HIDDEN) que son adyacentes a celdas visibles (VISIBLE).
## Estas celdas de frontera pasan a estar reveladas (REVEALED), permitiendo ver su silueta.
## [param hex_map] Referencia al mapa para refrescar.
static func refresh_revealed(hex_map: HexMap) -> void:
	if not hex_map:
		return
		
	var coords_list := hex_map.get_all_coords()
	for coords in coords_list:
		var cell := hex_map.get_cell(coords)
		if cell and cell.fog_state == HexCell.FogState.HIDDEN:
			# Si tiene algún vecino visible, pasa a REVEALED
			var neighbors := HexMath.axial_neighbors(coords)
			for n_coords in neighbors:
				var n_cell := hex_map.get_cell(n_coords)
				if n_cell and n_cell.fog_state == HexCell.FogState.VISIBLE:
					cell.fog_state = HexCell.FogState.REVEALED
					break


## Calcula el coste de producción necesario para explorar una celda.
## El coste se compone de un coste base más un coste por cada anillo de distancia al origen.
## [param hex_map] Referencia al mapa.
## [param target] Coordenadas axiales de la celda objetivo.
## [returns] El coste total calculado en puntos de producción.
static func exploration_cost(hex_map: HexMap, target: Vector2i) -> int:
	if not hex_map:
		return 0
	var distance := HexMath.axial_distance(target, hex_map.origin)
	return EXPLORE_BASE_COST + EXPLORE_COST_PER_RING * distance


## Verifica si una celda es elegible para ser explorada.
## Para poder explorar una celda, esta debe estar en estado HIDDEN o REVEALED
## y tener al menos un vecino axial que esté en estado VISIBLE.
## [param hex_map] Referencia al mapa.
## [param target] Coordenadas axiales de la celda a explorar.
## [returns] True si cumple las condiciones para ser explorada, False en caso contrario.
static func can_explore(hex_map: HexMap, target: Vector2i) -> bool:
	if not hex_map:
		return false
	var cell := hex_map.get_cell(target)
	if not cell:
		return false
	
	if cell.fog_state != HexCell.FogState.HIDDEN and cell.fog_state != HexCell.FogState.REVEALED:
		return false
		
	var neighbors := HexMath.axial_neighbors(target)
	for n_coords in neighbors:
		var n_cell := hex_map.get_cell(n_coords)
		if n_cell and n_cell.fog_state == HexCell.FogState.VISIBLE:
			return true
			
	return false


## Intenta realizar la exploración de una celda objetivo gastando del presupuesto disponible.
## Si la celda es válida para explorar y el presupuesto es suficiente, se realiza el cobro,
## se cambia su estado a VISIBLE, se refrescan las celdas reveladas y retorna True.
## [param hex_map] Referencia al mapa.
## [param target] Coordenadas axiales del objetivo.
## [param budget] Presupuesto de producción del jugador.
## [returns] True si la exploración tuvo éxito y se aplicaron los cambios; False de lo contrario.
static func try_explore(hex_map: HexMap, target: Vector2i, budget: ExplorationBudget) -> bool:
	if not hex_map or not budget:
		return false
		
	if not can_explore(hex_map, target):
		return false
		
	var cost := exploration_cost(hex_map, target)
	if budget.spend(cost):
		var cell := hex_map.get_cell(target)
		if cell:
			cell.fog_state = HexCell.FogState.VISIBLE
			refresh_revealed(hex_map)
			return true
			
	return false
