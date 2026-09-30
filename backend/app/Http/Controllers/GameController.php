<?php

namespace App\Http\Controllers;

use App\Models\JugadorSesion;
use App\Models\ProgresoJuego;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class GameController extends Controller
{
    /**
     * Endpoint de salud y conectividad para el videojuego Godot
     */
    public function status(): JsonResponse
    {
        try {
            DB::connection()->getPdo();
            $dbStatus = 'connected';
        } catch (\Exception $e) {
            $dbStatus = 'error: ' . $e->getMessage();
        }

        return response()->json([
            'juego' => 'Corian: Las sombras de Atl',
            'api_version' => '1.0.0',
            'servidor' => 'Nginx Reverse Proxy + Laravel Sail',
            'base_datos' => $dbStatus,
            'timestamp' => now()->toISOString(),
        ]);
    }

    /**
     * Inicia o registra una nueva sesión de juego para un jugador.
     */
    public function iniciarSesion(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'alias' => 'required|string|max:50',
            'dispositivo_uuid' => 'nullable|string|max:100',
        ]);

        return DB::transaction(function () use ($request, $validated) {
            $jugador = JugadorSesion::create([
                'alias' => $validated['alias'],
                'dispositivo_uuid' => $validated['dispositivo_uuid'] ?? null,
                'ip_origen' => $request->ip(),
                'activo' => true,
            ]);

            $progreso = ProgresoJuego::create([
                'jugador_id' => $jugador->id,
                'nivel_actual' => 1,
                'puntuacion_acumulada' => 0,
                'tiempo_jugado_segundos' => 0,
                'estado_json' => [
                    'vida' => 100,
                    'energia' => 100,
                    'inventario' => [
                        'pocion_vida' => 2,
                        'mapa_antiguo' => true,
                    ],
                    'habilidades' => ['salto_doble'],
                    'capitulo_actual' => 'Capítulo 1: El Despertar de Corian',
                    'checkpoints' => ['puerta_la_casa'],
                ],
            ]);

            return response()->json([
                'mensaje' => 'Sesión de juego iniciada con éxito en Corian: Las sombras de Atl',
                'jugador' => $jugador,
                'progreso' => $progreso,
            ], 201);
        });
    }

    /**
     * Obtiene el progreso actual y estado JSONB del jugador.
     */
    public function obtenerProgreso(string $jugadorId): JsonResponse
    {
        $jugador = JugadorSesion::with('progreso')->find($jugadorId);

        if (!$jugador) {
            return response()->json(['error' => 'Jugador no encontrado'], 404);
        }

        return response()->json([
            'jugador' => $jugador->alias,
            'jugador_id' => $jugador->id,
            'activo' => $jugador->activo,
            'progreso' => $jugador->progreso,
        ]);
    }

    /**
     * Actualiza el progreso y almacena el estado dinámico (JSONB).
     */
    public function actualizarProgreso(Request $request, string $jugadorId): JsonResponse
    {
        $progreso = ProgresoJuego::find($jugadorId);

        if (!$progreso) {
            return response()->json(['error' => 'Progreso no encontrado para este jugador'], 404);
        }

        $validated = $request->validate([
            'nivel_actual' => 'nullable|integer|min:1',
            'puntuacion_acumulada' => 'nullable|integer|min:0',
            'tiempo_jugado_segundos' => 'nullable|integer|min:0',
            'estado_json' => 'nullable|array',
        ]);

        if (isset($validated['nivel_actual'])) {
            $progreso->nivel_actual = $validated['nivel_actual'];
        }

        if (isset($validated['puntuacion_acumulada'])) {
            $progreso->puntuacion_acumulada = $validated['puntuacion_acumulada'];
        }

        if (isset($validated['tiempo_jugado_segundos'])) {
            $progreso->tiempo_jugado_segundos = $validated['tiempo_jugado_segundos'];
        }

        if (isset($validated['estado_json'])) {
            $progreso->estado_json = $validated['estado_json'];
        }

        $progreso->save();

        return response()->json([
            'mensaje' => 'Progreso y estado guardados correctamente',
            'progreso' => $progreso,
        ]);
    }

    /**
     * Lista todos los registros guardados en PostgreSQL (Jugadores y Progreso JSONB)
     */
    public function listarTodo(): JsonResponse
    {
        $jugadores = JugadorSesion::with('progreso')
            ->orderBy('ultimo_acceso', 'desc')
            ->get();

        return response()->json([
            'total' => $jugadores->count(),
            'jugadores' => $jugadores,
        ]);
    }

    /**
     * Elimina un registro de jugador y su progreso en cascada
     */
    public function eliminarJugador(string $jugadorId): JsonResponse
    {
        $jugador = JugadorSesion::find($jugadorId);
        if (!$jugador) {
            return response()->json(['error' => 'Jugador no encontrado'], 404);
        }

        $jugador->delete();

        return response()->json(['mensaje' => 'Registro eliminado con éxito']);
    }
}
