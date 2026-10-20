<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class SincronizacionRequest extends FormRequest
{
    /**
     * Determina si el usuario está autorizado a hacer esta petición.
     * Por ahora lo dejamos en true (más adelante podríamos validar tokens reales aquí).
     */
    public function authorize(): bool
    {
        return true; 
    }

    /**
     * Reglas de validación estrictas para el JSON de Godot.
     */
    public function rules(): array
    {
        return [
            'jugadores' => 'required|array|min:1',
            
            // Reglas de sesión
            'jugadores.*.id' => 'required|uuid',
            'jugadores.*.token_acceso' => 'required|string',
            'jugadores.*.dispositivo' => 'nullable|string|max:255',
            'jugadores.*.ultimo_acceso' => 'nullable|date',

            // Reglas de Decisiones Morales (si vienen, deben cumplir esto)
            'jugadores.*.decisiones' => 'nullable|array',
            'jugadores.*.decisiones.*.dilema_id' => 'required_with:jugadores.*.decisiones|integer|exists:catalogo_dilemas,id',
            'jugadores.*.decisiones.*.opcion_elegida' => 'required_with:jugadores.*.decisiones|string',
            'jugadores.*.decisiones.*.es_decision_etica' => 'required_with:jugadores.*.decisiones|boolean',
            'jugadores.*.decisiones.*.tiempo_respuesta_seg' => 'required_with:jugadores.*.decisiones|integer|min:0',
            'jugadores.*.decisiones.*.fecha_registro' => 'required_with:jugadores.*.decisiones|date',

            // Reglas de Minijuegos
            'jugadores.*.minijuegos' => 'nullable|array',
            'jugadores.*.minijuegos.*.minijuego_id' => 'required_with:jugadores.*.minijuegos|integer|exists:catalogo_minijuegos,id',
            'jugadores.*.minijuegos.*.aciertos' => 'required_with:jugadores.*.minijuegos|integer|min:0',
            'jugadores.*.minijuegos.*.errores' => 'required_with:jugadores.*.minijuegos|integer|min:0',
            'jugadores.*.minijuegos.*.puntaje' => 'required_with:jugadores.*.minijuegos|integer|min:0',
            'jugadores.*.minijuegos.*.fecha_completado' => 'required_with:jugadores.*.minijuegos|date',

            // Reglas de Progreso
            'jugadores.*.progreso' => 'nullable|array',
            'jugadores.*.progreso.nivel_actual' => 'required_with:jugadores.*.progreso|integer|min:0',
            'jugadores.*.progreso.puntaje_total' => 'required_with:jugadores.*.progreso|integer|min:0',

            // Reglas de Métricas
            'jugadores.*.metricas' => 'nullable|array',
            'jugadores.*.metricas.duracion_segundos' => 'required_with:jugadores.*.metricas|integer|min:0',
            'jugadores.*.metricas.niveles_completados' => 'required_with:jugadores.*.metricas|integer|min:0',
        ];
    }

    /**
     * Mensajes de error en español para que el cliente entienda qué falló.
     */
    public function messages(): array
    {
        return [
            'jugadores.*.id.uuid' => 'El ID del jugador debe ser un UUID válido.',
            'jugadores.*.decisiones.*.dilema_id.exists' => 'El dilema reportado no existe en el catálogo central.',
            'jugadores.*.minijuegos.*.minijuego_id.exists' => 'El minijuego reportado no existe en el catálogo central.',
            // Laravel generará los demás en automático o podemos agregar más específicos
        ];
    }
}