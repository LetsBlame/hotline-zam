# hotline-zam
Proyecto de juego web para la asignatura de Aplicaciones Web - 2025.
Se puede jugar desde el navegador gracias a [GithubPages](https://letsblame.github.io/hotline-zam/)

El proyecto se ha realizado con Godot 4.5.1

## Estructura de Carpetas
Las carpetas del repositorio contienen lo siguiente:
- Scenes/: Las escenas principales del juego, como menús, niveles, personaje... (.tscn).
- Scripts/: Los archivos de código GDScript (.gd).
- Sprites/: Las imágenes, atlas y shaders (.png, .gdshader, .tres).
- Sounds/: Los efectos de sonido del juego (.wav, .tres).
- Theme/: Los estilos visuales y la tipografía para los elementos de la interfaz (.ttf, .tres).
- docs/: Los archivos exportado para GitHub Pages.

## Cómo Ejecutar el Proyecto
- Opción 1. Jugar en Línea (Recomendada):
  - Abrir el navegador e ir a la Página alojada en [GithubPages](https://letsblame.github.io/hotline-zam/)
- Opción 2. Ejecutar en local:
  - Descargar la carpeta docs/
  - Lanzar la web en un servidor local. (Se ha probado con la extensión Live Server de VSCode)
  - Acceder a la página del servidor (En el ejemplo anterior: `localhost:5500`)
- Opción 3. Abrir el proyecto de Godot:
  - Clonar el repositorio:
  ```
  git clone https://github.com/LetsBlame/hotline-zam.git
  cd hotline-zam
  ```
  - Abrir con una verisión compatible de Godot e Importar, seleccionando `project.godot`.
  - Ejecutar o exportar el proyecto.
    - En caso de exportar, seguir los pasos de la Opción 2 
