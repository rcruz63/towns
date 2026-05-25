# Prompt para agente implementador — WP-002

Copia el bloque en un **chat nuevo**, workspace:

`/Users/rcruz2/Developer/Cloud/Townsfolk`

Adjunta: `@docs/packages/002-niebla-y-exploracion.md` y `@docs/CONVENTIONS.md`

---

## Bloque para copiar

```
Eres el agente IMPLEMENTADOR de Townsfolk. No amplíes alcance ni rediseñes arquitectura.

## Tarea única
Implementar: docs/packages/002-niebla-y-exploracion.md
Léelo entero antes de codificar.

## Contexto obligatorio
- docs/CONVENTIONS.md (## en GDScript, carpetas, español UI / inglés código)
- AGENTS.md — Godot 4.6+, carpeta game/
- WP-001 ya integrado: HexCell.fog_state, HexMap, MapGenerator, TerrainCatalog, hex_map_view

## Estado actual relevante
- game/scripts/model/hex_cell.gd — enum FogState HIDDEN/REVEALED/VISIBLE
- game/scripts/model/hex_map.gd — generate(), get_cell(), origin, radius, map_seed
- game/scripts/map/hex_map_view.gd — dibuja todo VISIBLE hoy; hay que dibujar por fog_state
- game/scenes/main.gd — HUD con terreno y fog; FOG_NAMES
- Tras generate todas las celdas quedan VISIBLE: FogSystem debe resetear a HIDDEN salvo origin

## Crear
- game/scripts/systems/fog_system.gd
- game/scripts/model/exploration_budget.gd

## Modificar
- game/scripts/map/hex_map_view.gd (dibujo niebla, clic explorar, señales explore_*)
- game/scenes/main.gd + main.tscn (producción, mensajes, coste)

## No hacer
- Economía completa, día/turno, otros recursos, entidades, edificios, guardado
- Pegar diff completo al finalizar (ver sección Entrega del cuaderno)

## Reglas
- explore cost = explore_base_cost + explore_cost_per_ring * axial_distance(target, origin)
- starting_production = 30, explore_base_cost = 2, explore_cost_per_ring = 1 (o @export documentados)
- HIDDEN adyacente a VISIBLE → REVEALED (refresh tras cada exploración)
- Explorar: clic en HIDDEN/REVEALED con vecino VISIBLE y producción suficiente
- HUD: "?" si terreno oculto; mostrar producción restante
- ## en español en toda API pública nueva

## Verificación
/Applications/Godot.app/Contents/MacOS/Godot --path game --headless --quit-after 2

## Entrega (respuesta final)
1. Archivos tocados (lista)
2. Checklist criterios de aceptación del cuaderno [x/ ]
3. Constantes usadas (producción inicial, base, per_ring)
4. git diff --stat solamente (no diff completo)

Responde en español. Si el cuaderno es ambiguo, detente y pregunta.
```

---

## Revisión ligera (arquitecto / usuario)

| Paso | Quién | Coste tokens |
|------|--------|----------------|
| Prueba manual según cuaderno | Usuario | 0 |
| Checklist + diff --stat del implementador | Arquitecto | Bajo |
| Leer solo `fog_system.gd` + diff de `hex_map_view.gd` | Arquitecto | Bajo |
| Diff completo 273+ líneas | Evitar salvo bug esquivo | Alto |
