# Cuadernos de carga (work packages)

Antigua “orden de trabajo” para implementadores: alcance cerrado, criterios verificables, sin ambigüedad de arquitectura.

El **arquitecto** (este repo / este chat) redacta el cuaderno. El **implementador** (otro agente, o tú en modo ejecución) solo codifica lo descrito.

---

## Cuándo crear un cuaderno

- Cualquier tarea que tarde **> 2 h** o toque **> 3 archivos**.
- Cualquier fase del [PLAN.md](PLAN.md) (Fase 1, 2, …).
- Cuando delegues a alguien con menos contexto del juego.

No hace falta cuaderno para: typos, un comentario, ajuste de un color.

---

## Ubicación y nombre

```
docs/packages/NNN-slug-corto.md
```

- `NNN`: número de tres dígitos (`001`, `002`, …).
- `slug`: kebab-case en español o inglés (`001-hex-cell-model.md`).

Índice opcional en `docs/packages/README.md`.

---

## Plantilla (copiar para cada paquete)

```markdown
# WP-NNN: Título breve

| Campo | Valor |
|-------|--------|
| Fase PLAN | Fase X — nombre |
| Estado | borrador / listo / en curso / hecho |
| Autor arquitecto | nombre o agente |
| Fecha | YYYY-MM-DD |

## Objetivo

Un párrafo: qué debe poder hacer el jugador o el sistema al terminar.

## Alcance

### Incluido

- …
- …

### Excluido (no hacer en este paquete)

- …

## Diseño (solo lectura para implementador)

- Archivos nuevos y existentes a tocar (lista exacta).
- Tipos / señales / contratos entre nodos.
- Enlace a sección de PLAN.md o GDD si aplica.

## Tareas de implementación

1. [ ] Tarea ordenada y pequeña
2. [ ] …
3. [ ] Documentar API pública con `##` (ver CONVENTIONS.md)

## Criterios de aceptación

- [ ] Criterio observable 1 (ej. “misma seed → mismo mapa”)
- [ ] Criterio observable 2
- [ ] Proyecto abre en Godot 4.6+ sin errores en consola al F5
- [ ] Funciones públicas nuevas tienen comentarios `##`

## Pruebas manuales

1. Paso a paso para el revisor.
2. …

## Notas

Riesgos, decisiones ya tomadas, enlaces externos.
```

---

## Paquetes activos

| WP | Cuaderno | Prompt |
|----|----------|--------|
| 001 (hecho) | [001-hex-cell-y-generacion.md](packages/001-hex-cell-y-generacion.md) | [001-PROMPT](packages/001-PROMPT-implementador.md) |
| 002 (listo) | [002-niebla-y-exploracion.md](packages/002-niebla-y-exploracion.md) | [002-PROMPT](packages/002-PROMPT-implementador.md) |

## Revisión sin gastar tokens en vano

El implementador entrega **checklist + lista de archivos + `git diff --stat`**, no el diff completo. El arquitecto confía en la **prueba manual** y lee solo 1–2 archivos núcleo si hace falta.

---

## Revisión

El arquitecto marca el paquete **hecho** solo si todos los criterios de aceptación pasan. Si el implementador necesita cambiar diseño, debe volver al arquitecto y actualizar el cuaderno primero.
