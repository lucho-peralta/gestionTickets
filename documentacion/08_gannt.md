# Diagrama de Gantt


El diagrama muestra las 13 semanas del cronograma de la cátedra (`planifProfesor.md`), con una barra por tarea y su responsable. Las tareas ya entregadas figuran como completadas (`done`), la semana en curso como activa (`active`) y la entrega final como crítica (`crit`).

```mermaid
gantt
  title Sistema de Gestión de Tickets de Soporte
  dateFormat YYYY-MM-DD
  axisFormat %d/%m

  section Semana 1 - Análisis
  Enunciado (Franco)                          :done, s1a, 2026-08-24, 7d
  Alcance y procesos (Juan)                   :done, s1b, 2026-08-24, 7d
  Requerimientos (Luciano)                    :done, s1c, 2026-08-24, 7d
  Actores y user stories (Lucas)              :done, s1d, 2026-08-24, 7d
  API básica (Juan)                           :done, s1e, 2026-08-24, 7d

  section Semana 2 - Admin. de proyectos
  Plan de trabajo y Kanban (Luciano)          :done, s2a, 2026-08-31, 7d
  Diagrama de Gantt (Lucas)                   :done, s2b, 2026-08-31, 7d
  PERT/CPM (Juan)                             :done, s2c, 2026-08-31, 7d
  Control de versiones y metodología (Franco) :done, s2d, 2026-08-31, 7d

  section Semana 3 - Modelado
  DFD, diccionario y estados (Juan)           :done, s3a, 2026-09-07, 7d
  Casos de uso (Luciano)                      :done, s3b, 2026-09-07, 7d
  Secuencias y actividades (Lucas)            :done, s3c, 2026-09-07, 7d
  Proceso de negocio (Franco)                 :done, s3d, 2026-09-07, 7d

  section Semana 4 - Diseño
  Arquitectura y herramientas (Luciano)       :done, s4a, 2026-09-14, 7d
  REST API y OpenAPI (Juan)                   :done, s4b, 2026-09-14, 7d
  ERD y entregas parciales (Lucas)            :done, s4c, 2026-09-14, 7d

  section Semana 5 - Pruebas
  Tests Happy Path                            :s5, 2026-09-21, 7d

  section Semanas 6-8 - Back-end
  Inicio de implementación                    :active, s6, 2026-09-28, 7d
  Fin de desarrollo y Docker                  :s7, 2026-10-05, 7d
  Presentación preliminar                     :milestone, s8, 2026-10-12, 1d

  section Semanas 9-11 - Front-end
  Diseño de UI                                :s9, 2026-10-19, 7d
  Inicio de implementación                    :s10, 2026-10-26, 7d
  Fin de desarrollo y Docker                  :s11, 2026-11-02, 7d

  section Semana 12 - Integración
  Integración y pruebas                       :s12, 2026-11-09, 7d

  section Semana 13 - Cierre
  Entrega y presentación final                :crit, s13, 2026-11-16, 7d
```
