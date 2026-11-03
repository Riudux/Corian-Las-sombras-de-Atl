<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\JugadorSesion;
use App\Models\MetricaSesion;
use App\Models\DecisionMoral;
use Illuminate\Http\JsonResponse;

class MetricasPublicasController extends Controller
{
    /**
     * Retorna un resumen estadístico global y anónimo para el dashboard del SLA.
     */
    public function obtenerResumen(): JsonResponse
    {
        // 1. Métricas generales de participación
        $totalJugadores = JugadorSesion::count();
        
        // 2. Promedios de sesión (Manejo de nulos si la base de datos está vacía)
        $promedioDuracionSegundos = MetricaSesion::avg('duracion_segundos') ?? 0;
        $promedioNivelesCompletados = MetricaSesion::avg('niveles_completados') ?? 0;

        // 3. Agregación de decisiones éticas (Top 5 dilemas con sus respuestas)
        $estadisticasDecisiones = DecisionMoral::selectRaw('dilema_id, opcion_elegida, es_decision_etica, count(*) as total_votos')
            ->groupBy('dilema_id', 'opcion_elegida', 'es_decision_etica')
            ->orderBy('dilema_id')
            ->orderByDesc('total_votos')
            ->get();

        // 4. Promedio de tiempo de respuesta general en dilemas
        $promedioTiempoRespuesta = DecisionMoral::avg('tiempo_respuesta_seg') ?? 0;

        return response()->json([
            'estado' => 'success',
            'metricas_globales' => [
                'total_jugadores_historico' => $totalJugadores,
                'tiempo_promedio_sesion_minutos' => round($promedioDuracionSegundos / 60, 2),
                'niveles_promedio_completados' => round($promedioNivelesCompletados, 2),
                'tiempo_promedio_decision_segundos' => round($promedioTiempoRespuesta, 1),
            ],
            'desglose_dilemas' => $estadisticasDecisiones
        ], 200);
    }
}