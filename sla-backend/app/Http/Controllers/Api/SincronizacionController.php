<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\SincronizacionRequest;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\CatalogoDilema;
use App\Models\CatalogoMinijuego;
use App\Models\JugadorSesion;
use App\Models\ProgresoJuego;
use App\Models\DecisionMoral;
use App\Models\ResultadoMinijuego;
use App\Models\MetricaSesion;

class SincronizacionController extends Controller
{
    // 1. FLUJO DE DESCARGA (PULL)
    public function descargarCatalogos()
    {
        return response()->json([
            'dilemas' => CatalogoDilema::all(),
            'minijuegos' => CatalogoMinijuego::all(),
        ], 200);
    }

    // 2. FLUJO DE SUBIDA (PUSH MASIVO OFFLINE-FIRST)
    public function sincronizarDatos(SincronizacionRequest $request)
    {
        $jugadores = $request->input('jugadores', []);

        // Bloqueo de seguridad ACID: Todo o nada.
        DB::beginTransaction();

        try {
            $ahora = now(); // Marcamos el tiempo exacto de sincronización

            foreach ($jugadores as $data) {
                
                // A. Sesión del Jugador (updateOrCreate evita errores si el UUID ya se había registrado)
                $jugador = JugadorSesion::updateOrCreate(
                    ['id' => $data['id']],
                    [
                        'token_acceso' => $data['token_acceso'],
                        'codigo_recuperacion' => $data['codigo_recuperacion'] ?? bin2hex(random_bytes(4)),
                        'dispositivo' => $data['dispositivo'] ?? 'Desconocido',
                        'ultimo_acceso' => $data['ultimo_acceso'] ?? null,
                        'sincronizado_en' => $ahora
                    ]
                );

                // B. Progreso
                if (isset($data['progreso'])) {
                    ProgresoJuego::updateOrCreate(
                        ['jugador_id' => $jugador->id],
                        [
                            'nivel_actual' => $data['progreso']['nivel_actual'],
                            'puntaje_total' => $data['progreso']['puntaje_total'],
                            'estado_json' => is_string($data['progreso']['estado_json']) 
                                ? $data['progreso']['estado_json'] 
                                : json_encode($data['progreso']['estado_json']),
                            'sincronizado_en' => $ahora
                        ]
                    );
                }

                // C. Decisiones Morales
                if (isset($data['decisiones'])) {
                    foreach ($data['decisiones'] as $decision) {
                        DecisionMoral::create([
                            'jugador_id' => $jugador->id,
                            'dilema_id' => $decision['dilema_id'],
                            'opcion_elegida' => $decision['opcion_elegida'],
                            'es_decision_etica' => $decision['es_decision_etica'],
                            'tiempo_respuesta_seg' => $decision['tiempo_respuesta_seg'],
                            'fecha_registro' => $decision['fecha_registro'],
                            'sincronizado_en' => $ahora
                        ]);
                    }
                }

                // D. Resultados Minijuegos
                if (isset($data['minijuegos'])) {
                    foreach ($data['minijuegos'] as $mini) {
                        ResultadoMinijuego::create([
                            'jugador_id' => $jugador->id,
                            'minijuego_id' => $mini['minijuego_id'],
                            'aciertos' => $mini['aciertos'],
                            'errores' => $mini['errores'],
                            'puntaje' => $mini['puntaje'],
                            'fecha_completado' => $mini['fecha_completado'],
                            'sincronizado_en' => $ahora
                        ]);
                    }
                }

                // E. Métricas Sesión
                if (isset($data['metricas'])) {
                    MetricaSesion::create([
                        'jugador_id' => $jugador->id,
                        'duracion_segundos' => $data['metricas']['duracion_segundos'],
                        'niveles_completados' => $data['metricas']['niveles_completados'],
                        'sincronizado_en' => $ahora
                    ]);
                }
            }

            // Si llegamos hasta aquí sin errores, confirmamos los cambios en PostgreSQL
            DB::commit();
            return response()->json(['mensaje' => 'Sincronización exitosa', 'timestamp' => $ahora], 200);

        } catch (\Exception $e) {
            // Si algo explota, deshacemos todo y regresamos el error
            DB::rollBack();
            return response()->json(['mensaje' => 'Error crítico en la sincronización', 'error' => $e->getMessage()], 500);
        }
    }
}