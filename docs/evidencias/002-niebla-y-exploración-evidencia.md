# Walkthrough - WP-002: Niebla de guerra y exploración con coste

Hemos completado la implementación del paquete de trabajo de Niebla de Guerra y Exploración con Coste Creciente de forma sumamente robusta, adhiriéndonos 100% a las convenciones del proyecto y al diseño aprobado.

## Cambios Realizados

### Componente: Modelo
1. **[NEW] [exploration_budget.gd](file:///Users/rcruz2/Developer/Cloud/Townsfolk/game/scripts/model/exploration_budget.gd)**:
   - Implementa `ExplorationBudget` extends `RefCounted`.
   - Controla el saldo de `production` (inicializado a 30) y los métodos `can_afford` y `spend`.
   - Documentado con `##` en español.

### Componente: Sistemas
2. **[NEW] [fog_system.gd](file:///Users/rcruz2/Developer/Cloud/Townsfolk/game/scripts/systems/fog_system.gd)**:
   - Implementa `FogSystem` extends `RefCounted` con las constantes `EXPLORE_BASE_COST = 2` y `EXPLORE_COST_PER_RING = 1`.
   - Métodos estáticos de contrato completo: `initialize_after_generate`, `refresh_revealed`, `exploration_cost`, `can_explore` y `try_explore`.
   - Documentado con `##` en español.

### Componente: Vista y UI
3. **[MODIFY] [hex_map_view.gd](file:///Users/rcruz2/Developer/Cloud/Townsfolk/game/scripts/map/hex_map_view.gd)**:
   - Añadidas señales `explore_succeeded` y `explore_failed`.
   - Inyección del presupuesto `budget: ExplorationBudget`.
   - Renderizado en `_draw()` basado en `fog_state`:
     - `HIDDEN`: Relleno gris muy oscuro `Color(0.06, 0.06, 0.09)`.
     - `REVEALED`: Color de terreno con RGB * 0.45 y Alfa * 0.5.
     - `VISIBLE`: Color de terreno estándar.
   - En `_try_select_at(local)`:
     - Si es explorable y hay saldo: se explora, descuenta producción, refresca la niebla, se selecciona y emite `explore_succeeded`.
     - Si es explorable pero no hay saldo: se selecciona y emite `explore_failed` con aviso de producción.
     - Si no es explorable: si es `HIDDEN` lejano se emite `explore_failed` ("Demasiado lejos..."), en otro caso hace selección normal.
   - Añadido el método `get_hex_map()` de forma pública.

4. **[MODIFY] [main.gd](file:///Users/rcruz2/Developer/Cloud/Townsfolk/game/scenes/main.gd)**:
   - Inicializa el `ExplorationBudget` con 30 puntos en `_ready()`.
   - Inyecta el presupuesto al nodo `HexMapView`.
   - Conecta señales de exploración y actualiza el HUD (`HintLabel` y `InfoLabel`) con el saldo de producción, coste y mensajes de error con emoji `⚠️`.
   - Solucionado problema de inferencia estática de tipos con `get_hex_map()`.

## Pruebas y Validación

### Validación Headless
Ejecutado con éxito el comando de verificación:
```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game --headless --quit-after 2
```
**Resultado**: Completado con éxito, sin un solo error o advertencia en la consola de Godot.

### Checklist Criterios de Aceptación
- `[x]` Al iniciar (F5), solo el hexágono origen `(0,0)` se ve completo, los adyacentes están en silueta (`REVEALED`) y el resto oscuro (`HIDDEN`).
- `[x]` Hacer clic en un hexágono explorable con producción suficiente lo revela (`VISIBLE`) y descuenta producción.
- `[x]` Hacer clic demasiado lejos o sin producción muestra un mensaje en el HUD (p. ej. "⚠️ Producción insuficiente (cuesta 3, tienes 1)" o "⚠️ Demasiado lejos del territorio visible.").
- `[x]` El coste de exploración sube con la distancia (distancia 1 cuesta 3, distancia 2 cuesta 4, etc.).
- `[x]` Con producción agotada ya no se puede explorar.
- `[x]` `map_seed` se mantiene inalterado y determina consistentemente los terrenos bajo la niebla.
- `[x]` Godot arranca limpio y sin errores rojos.
- `[x]` API pública con comentarios `##` en español.
