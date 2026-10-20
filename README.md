# Corian: Las sombras de Atl

Corian: Las sombras de Atl es un proyecto de videojuego enfocado principalmente en la enseñanza y consciencia de la honestidad y valores para los niños, este mismo esta ambientado en un mundo misterioso y oscuro, donde el jugador explora entornos narrativos, enfrenta amenazas y avanza a través de una historia envolvente. El repositorio reúne tanto el desarrollo del juego como la parte administrativa o complementaria del proyecto, combinando tecnologías como Godot, GDScript, PHP y Blade.

## Índice

- [Descripción](#descripción)
- [Características](#características)
- [Tecnologías](#tecnologías)
- [Requisitos previos](#requisitos-previos)
- [Instalación](#instalación)
- [Configuración de entorno](#configuración-de-entorno)
- [Ejecución](#ejecución)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Uso](#uso)
- [Desarrollo](#desarrollo)
- [Contribución](#contribución)
- [Roadmap](#roadmap)
- [Licencia](#licencia)

## Descripción

Corian: Las sombras de Atl nace como un proyecto de videojuego con enfoque narrativo, exploración y atmósfera. La idea principal es crear una experiencia visualmente evocadora, con una identidad artística fuerte y una progresión que invite al jugador a descubrir secretos, resolver retos y sumergirse en un mundo lleno de misterio.

El repositorio incluye distintas capas del desarrollo:
- lógica y contenido del videojuego en GDScript
- recursos del proyecto Godot
- posible administración o panel web con PHP + Blade
- despliegue o entorno de desarrollo con Docker

## Características

- Mundo de juego con ambientación oscura y misteriosa
- Sistema de exploración y progresión
- Lógica del juego en Godot con GDScript
- Integración con contenido web para administración o soporte
- Estructura modular para facilitar ampliación
- Compatibilidad con entorno local y Docker
- Base adecuada para crecimiento del proyecto

## Tecnologías

- Godot Engine
- GDScript
- PHP
- Blade
- JavaScript
- HTML
- CSS
- Docker
- Composer (si se usa backend o dependencias PHP)
- PostgreSQL o MySQL (según configuración del proyecto)

## Requisitos previos

Antes de comenzar, asegúrate de tener instalado:

- Godot 4.x o compatible
- PHP 8.x
- Composer
- Git
- Docker y Docker Compose (opcional, si se usa contenedores)
- Base de datos configurada (si la parte web requiere persistencia)

## Instalación

1. Clona el repositorio:

```bash
git clone https://github.com/Riudux/Corian-Las-sombras-de-Atl.git
cd Corian-Las-sombras-de-Atl
```

2. Si el proyecto incluye parte web o backend PHP, instala las dependencias:

```bash
composer install
```

3. Si el proyecto usa variables de entorno, crea un archivo `.env` según el ejemplo disponible.

## Configuración de entorno

Crea un archivo `.env` en la raíz del proyecto (si aplica) usando la configuración necesaria para la base de datos y servicios de la aplicación.

Ejemplo:

```env
APP_NAME="Corian: Las sombras de Atl"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=corian
DB_USERNAME=root
DB_PASSWORD=
```

> Ajusta estos valores según la configuración real de tu proyecto.

## Ejecución

### Ejecutar el videojuego
Abre el proyecto en Godot y ejecuta la escena principal o la escena de inicio del juego.

### Ejecutar la parte web / admin
Si el repositorio incluye una aplicación PHP con Blade, puedes arrancarla con:

```bash
php artisan serve
```

o en su caso:

```bash
composer run dev
```

### Ejecutar con Docker

Si el proyecto usa contenedores:

```bash
docker-compose up --build
```

## Estructura del proyecto

```bash
Corian-Las-sombras-de-Atl/
├── .gitignore
├── README.md
├── composer.json
├── package.json
├── docker-compose.yml
├── .env.example
├── app/
├── resources/
├── routes/
├── public/
├── config/
├── database/
├── project/
│   ├── scenes/
│   ├── scripts/
│   ├── assets/
│   └── project.godot
├── docs/
└── tests/
```

> La estructura puede variar según la etapa del desarrollo, pero esta organización refleja el enfoque híbrido del proyecto: juego + componentes web.

## Uso

- Ejecuta el proyecto en Godot para probar la experiencia del videojuego.
- Usa la parte web para gestión, administración o contenido complementario si aplica.
- Explora y modifica scripts, escenas y recursos para ampliar mecánicas o narrativa.

## Desarrollo

Para contribuir al desarrollo:

1. Crea una rama nueva:

```bash
git checkout -b feature/nombre-de-la-funcionalidad
```

2. Realiza los cambios necesarios.
3. Haz commit con mensajes claros:

```bash
git commit -m "Añade nueva mecánica de gameplay"
```

4. Sube la rama:

```bash
git push origin feature/nombre-de-la-funcionalidad
```

5. Abre un pull request.

## Contribución

Las contribuciones son bienvenidas. Si quieres colaborar:

- mejora mecánicas de juego
- añade contenido visual o sonoro
- corrige errores
- optimiza rendimiento
- ayuda con la parte web o administración
- documenta funciones y flujo del proyecto

## Roadmap

- [x] Definición inicial del proyecto
- [x] Estructura base del repositorio
- [ ] Desarrollo de mecánicas principales
- [ ] Diseño de niveles y escenarios
- [ ] Integración de narrativa y diálogos
- [ ] Optimización del rendimiento
- [ ] Integración web o administración
- [ ] Pruebas y ajustes finales
- [ ] Lanzamiento público

## Licencia

Este proyecto está bajo una licencia abierta para uso, estudio y mejora del código. Si no se especifica otra licencia en el repositorio, se recomienda revisar el archivo `LICENSE` o consultar al autor antes de reutilizar el contenido.

---

Desarrollado para el proyecto Corian: Las sombras de Atl.
