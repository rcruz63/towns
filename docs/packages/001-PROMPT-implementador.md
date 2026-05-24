# Prompt para agente implementador — WP-001

Copia **todo el bloque de abajo** en un chat nuevo de Cursor (u otro agente), con workspace abierto en:

`/Users/rcruz2/Developer/Cloud/Townsfolk`

---

## Bloque para copiar

```
Eres el agente IMPLEMENTADOR del proyecto Townsfolk. No eres arquitecto: no rediseñes el motor ni amplias el alcance.

## Tu única tarea
Implementar el cuaderno de carga WP-001 leyendo el archivo:
docs/packages/001-hex-cell-y-generacion.md

Léelo entero antes de escribir código. Si algo no está en el cuaderno, no lo implementes.

## Documentación obligatoria del repo
1. docs/CONVENTIONS.md — comentarios ## en GDScript (equivalente a docstrings), estructura de carpetas, inglés en código / español en UI.
2. docs/PLAN.md — contexto Fase 1 (solo lectura).
3. AGENTS.md — workspace y Godot 4.6+.

## Stack
- Godot 4.6+ Universal, carpeta game/ (GDScript).
- No uses Godot 3. No toques pyproject.toml salvo que el cuaderno lo pida (no lo pide).

## Estado actual (Fase 0 hecha)
- game/scripts/core/hex_math.gd — coordenadas axiales, documentado.
- game/scripts/core/terrain_defs.gd — enum + colores (MIGRAR a TerrainCatalog y eliminar este archivo al final).
- game/scripts/map/hex_map_view.gd — dibuja mapa y tiene _pick_terrain (MOVER generación a MapGenerator).
- game/scenes/main.tscn + main.gd — HUD con clic en hex.

## Entregables (archivos del cuaderno)
CREAR:
- game/scripts/model/hex_cell.gd (FogState + HexCell)
- game/scripts/model/hex_map.gd
- game/scripts/core/terrain_def.gd
- game/scripts/core/terrain_catalog.gd (7 terrenos, tabla build_tags del cuaderno)
- game/scripts/systems/map_generator.gd

MODIFICAR:
- game/scripts/map/hex_map_view.gd (solo vista + input, usa HexMap)
- game/scenes/main.gd (nueva firma de señal hex_selected; HUD con fog legible)

ELIMINAR cuando no haya referencias:
- game/scripts/core/terrain_defs.gd

## Reglas de implementación
- Misma map_seed + map_radius => mismo mapa (RandomNumberGenerator con seed fija).
- Al generar: entities = [], building_id = "", fog_state = VISIBLE.
- Sin lógica de niebla jugable, sin entidades, sin edificios, sin economía.
- Separación estricta: MapGenerator/HexMap = modelo; hex_map_view = vista.
- Toda función/clase pública nueva: comentarios ## en español con [param] y [returns] donde aplique.
- Respóndeme en español. Al terminar, lista archivos tocados y cómo verificar los criterios de aceptación del cuaderno (checklist marcada).

## Verificación
Tras implementar, ejecuta si tienes Godot en PATH o /Applications/Godot.app:
  Godot --path game --headless --quit-after 2
Debe salir sin errores.

## Si te bloqueas
No inventes diseño alternativo. Indica qué punto del cuaderno es ambiguo y detente.
```

---

## Notas para quien lanza el agente

- Usa un chat **nuevo** para no mezclar contexto de arquitecto.
- Opcional: adjunta `@docs/packages/001-hex-cell-y-generacion.md` y `@docs/CONVENTIONS.md` en Cursor.
- Tras la entrega, vuelve al chat arquitecto para **revisión** contra los criterios de aceptación del cuaderno.
