# Convenciones del proyecto Townsfolk

Documento de referencia para humanos y agentes. Si cambias de agente o de cuota, **lee esto antes de codificar**.

Relacionado: [PLAN.md](PLAN.md) (roadmap), [WORK_PACKAGES.md](WORK_PACKAGES.md) (cuadernos de carga).

---

## 1. Documentación del código (equivalente a docstrings)

En **GDScript** no hay docstrings con triple comilla. El estándar oficial es el comentario de documentación con **`##`** (doble almohadilla) justo encima de la declaración. Aparece en el editor al pasar el ratón y en **Ayuda → Buscar en la documentación de la clase**.

### Reglas

| Elemento | Qué documentar |
|----------|----------------|
| `class_name` / `class` | Propósito, responsabilidades, qué **no** debe hacer |
| `func` pública | Qué hace, parámetros, valor de retorno, errores o precondiciones |
| `signal` | Cuándo se emite y qué lleva cada argumento |
| `@export` | Significado en juego, unidades, rango razonable |
| Constantes no obvias | Por qué existe ese valor |

- **`##`**: documentación de API (sí, obligatoria en código de dominio).
- **`#`**: solo comentarios de implementación cuando la lógica no sea evidente.
- Idioma: **español** en comentarios y docs de repo (nombres de código en inglés, ver §3).
- No documentar getters triviales ni código autogenerado.

### Ejemplo (estilo acordado)

```gdscript
## Convierte coordenadas axiales (q, r) a posición local en píxeles.
## Orientación: punta arriba (pointy-top).
## [param hex_size] Radio exterior del hexágono en píxeles.
## [returns] Centro del hexágono en el espacio local del mapa.
static func axial_to_pixel(q: int, r: int, hex_size: float) -> Vector2:
```

Godot 4 admite etiquetas tipo `[param nombre]` y `[returns]` en los comentarios `##`.

### Python (`tools/`)

Usar **docstrings PEP 257** en español, con tipos si el módulo crece:

```python
def axial_distance(a: tuple[int, int], b: tuple[int, int]) -> int:
    """Distancia en hexágonos entre dos celdas axiales (q, r)."""
```

---

## 2. Nombres e idioma del código

| Qué | Convención |
|-----|------------|
| Archivos GDScript | `snake_case.gd` |
| Escenas | `snake_case.tscn` |
| Clases `class_name` | `PascalCase` |
| Funciones / variables | `snake_case` |
| Señales | `snake_case`, verbo en pasado o sustantivo (`hex_selected`) |
| Constantes | `UPPER_SNAKE` o `const` en grupo lógico |
| Identificadores en código | **Inglés** (`fertile`, `hex_map`) |
| Texto visible al jugador | **Español** vía claves o `TerrainCatalog.get_terrain_name` |
| Commits | Inglés o español, pero prefijo claro: `feat(hex): …`, `docs: …` |

---

## 3. Estructura de directorios

### Raíz del repo

```text
Townsfolk/
├── README.md              # Cómo abrir el proyecto y enlaces a docs
├── docs/                  # Plan, convenciones, GDD, cuadernos de carga
├── tools/                 # Scripts Python (uv): validación, tests, export
├── game/                  # Proyecto Godot 4 (abrir esta carpeta en el editor)
├── pyproject.toml         # Dependencias Python de herramientas
└── .cursor/rules/         # Reglas para agentes Cursor
```

### Dentro de `game/`

```text
game/
├── project.godot
├── assets/                # Arte, audio, fuentes (cuando existan)
├── data/                  # JSON / .tres de balance (fuente para el juego)
├── scenes/
│   ├── main.tscn          # Entrada
│   ├── map/               # Vista del mapa
│   └── ui/                # HUD, modales
└── scripts/
    ├── core/              # Tipos puros, math, defs sin nodo
    ├── model/             # Estado de dominio (HexCell, GameState) — Fase 1+
    ├── systems/           # Economía, niebla, efectos — fases posteriores
    └── map/               # Nodos que dibujan o capturan input del mapa
```

### Dónde va cada cosa nueva

| Tipo | Ubicación |
| ------ | ----------- |
| Matemática / utilidades sin escena | `scripts/core/` |
| Estado de una celda o partida | `scripts/model/` |
| Reglas que avanzan el día, niebla, etc. | `scripts/systems/` |
| `Node2D` / `Control` que ve el jugador | `scenes/` + script en `scripts/…` acorde |
| Tablas de terrenos, edificios | `data/` (+ validación en `tools/`) |
| Especificación de diseño | `docs/GDD.md` |

**No** mezclar simulación y dibujo en el mismo script grande: separar modelo/vista como en [PLAN.md](PLAN.md).

---

## 4. Arquitectura (recordatorio)

1. **Datos** → recursos `.tres` o JSON en `data/`.
2. **Simulación** → `scripts/model/` + `scripts/systems/` (sin `draw`, sin sprites).
3. **Vista** → escenas + scripts en `map/` y `ui/` que leen estado y emiten señales.

Las fases del plan son secuenciales: no implementar economía antes de cerrar el modelo de celda.

---

## 5. Git y calidad

- Rama principal: `main`.
- Commits pequeños y descriptivos; un concepto por commit cuando sea posible.
- No commitear `.godot/` (ya en `game/.gitignore`).
- Antes de dar por cerrada una tarea: proyecto abre en Godot 4.6+ y la escena principal arranca (F5).
- Tests Python en `tools/` para lógica portable (p. ej. `hex_math`); tests GDScript opcionales más adelante.

---

## 6. Flujo de trabajo: arquitecto vs implementador

Roles acordados:

| Rol | Quién | Responsabilidad |
| ------ | -------- | ---------------- |
| **Arquitecto** | Tú + agente en este workspace (fases, diseño) | Plan, GDD, cuadernos de carga, revisión, decisiones de sistema |
| **Implementador** | Agente o persona con cuaderno | Ejecutar un paquete acotado sin rediseñar el motor |

Proceso:

1. Definir o actualizar tarea en [PLAN.md](PLAN.md).
2. Redactar **cuaderno de carga** en `docs/packages/NNN-nombre.md` ([plantilla](WORK_PACKAGES.md)).
3. Implementar solo lo del cuaderno; marcar criterios de aceptación.
4. Revisión: arquitecto valida contra el cuaderno, no contra intuición nueva.

Sin cuaderno de carga = no se pide implementación grande a un agente “junior”.

---

## 7. Agentes Cursor

- Reglas en `.cursor/rules/` (resumen ejecutable).
- Contexto largo: este archivo + `docs/PLAN.md` + cuaderno activo.
- Al retomar: indicar fase actual y enlace al cuaderno si existe.

---

## 8. Deuda conocida (Fase 0)

El código de la Fase 0 tiene documentación mínima (`##` de cabecera). Al tocar cada archivo en Fase 1+, ampliar docstrings `##` en todas las funciones públicas según §1.
