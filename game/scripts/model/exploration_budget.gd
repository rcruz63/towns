## Gestiona el presupuesto de producción disponible para la exploración.
## Mantiene el contador de recursos de producción y permite validar y aplicar gastos.
class_name ExplorationBudget
extends RefCounted

## Producción inicial recomendada por defecto.
const STARTING_PRODUCTION := 30

## Puntos de producción actualmente acumulados.
var production: int


## Inicializa el presupuesto con una cantidad determinada de producción.
## [param starting] Cantidad inicial de producción.
func _init(starting: int = STARTING_PRODUCTION) -> void:
	production = starting


## Verifica si se puede costear un gasto específico.
## [param cost] El coste que se desea verificar.
## [returns] True si la producción actual es igual o mayor al coste, False en caso contrario.
func can_afford(cost: int) -> bool:
	return production >= cost


## Consume la cantidad de producción indicada si es asequible.
## [param cost] La cantidad de producción a restar.
## [returns] True si se realizó el gasto con éxito, False si no se tenían fondos suficientes.
func spend(cost: int) -> bool:
	if can_afford(cost):
		production -= cost
		return true
	return false
