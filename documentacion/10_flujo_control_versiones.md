# Explacacion de trabajo
• main protegida: solo entra código ya revisado por otra persona.
• Una rama por tarea: feature/nombre-de-la-tarea.
• Commits con prefijo según el tipo de cambio: feat:, fix:, test:, refactor:.
• Pull Request obligatorio para mergear a main, con revisión de al menos otro integrante.

flowchart LR
main[main]
f1[feature/endpoint-tickets]
f2[feature/modelo-usuario]
pr1{Pull Request}
pr2{Pull Request}
main --> f1
main --> f2
f1 --> pr1
f2 --> pr2
pr1 -- revisión de otro integrante --> main
pr2 -- revisión de otro integrante --> main

