
flowchart LR
INICIO((Inicio)) --> A[A: Análisis\n2 sem]
A --> B[B: Diseño\n2 sem]
B --> C[C: Backend\n4 sem]
B -.-> D[D: Frontend\n3 sem\nholgura: 1 sem]
C --> E[E: Testing\n2 sem]
D -.-> E
E --> F[F: Implementación\n1 sem]
F --> FIN((Fin))
style A fill:#f4a3a3
style B fill:#f4a3a3
style C fill:#f4a3a3
style E fill:#f4a3a3
style F fill:#f4a3a3
style D fill:#a3c9f4
