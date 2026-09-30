-- =============================================================================
-- Inicialización de Esquema: Corian: Las sombras de Atl - Backend API (PostgreSQL 15+)
-- Base de Datos: corian_las_sombras_de_atl
-- Esquema Híbrido: Relacional con persistencia NoSQL de estado vía JSONB
-- =============================================================================

-- Habilitar extensión para soporte de UUID en caso de requerir uuid_generate_v4()
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -----------------------------------------------------------------------------
-- Tabla: jugadores_sesion
-- Almacena las sesiones y metadata de autenticación/dispositivo de los jugadores
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS jugadores_sesion (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alias VARCHAR(50) NOT NULL,
    dispositivo_uuid VARCHAR(100),
    ip_origen INET,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------------------------------
-- Tabla: progreso_juego
-- Relación estricta 1:1 con jugadores_sesion.
-- jugador_id es simultáneamente Primary Key y Foreign Key (PK/FK).
-- Incluye campo obligatorio estado_json de tipo JSONB para estado dinámico/telemetría.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS progreso_juego (
    jugador_id UUID PRIMARY KEY,
    nivel_actual INT NOT NULL DEFAULT 1,
    puntuacion_acumulada BIGINT NOT NULL DEFAULT 0,
    tiempo_jugado_segundos INT NOT NULL DEFAULT 0,
    estado_json JSONB NOT NULL DEFAULT '{}'::jsonb,
    actualizado_en TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_progreso_jugador
        FOREIGN KEY (jugador_id)
        REFERENCES jugadores_sesion (id)
        ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------
-- Índices para Optimización de Rendimiento
-- -----------------------------------------------------------------------------
-- Índice GIN sobre estado_json: permite consultas eficientes sobre atributos dinámicos
-- (ejemplo: estado_json @> '{"inventario": {"llave_dorada": true}}')
CREATE INDEX IF NOT EXISTS idx_progreso_juego_estado_json ON progreso_juego USING GIN (estado_json);

-- Índice secundario para filtrar sesiones activas
CREATE INDEX IF NOT EXISTS idx_jugadores_sesion_activo ON jugadores_sesion (activo);
