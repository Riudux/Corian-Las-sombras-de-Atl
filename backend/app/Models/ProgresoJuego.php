<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProgresoJuego extends Model
{
    protected $table = 'progreso_juego';
    protected $primaryKey = 'jugador_id';
    public $incrementing = false;
    protected $keyType = 'string';

    const CREATED_AT = null;
    const UPDATED_AT = 'actualizado_en';

    protected $fillable = [
        'jugador_id',
        'nivel_actual',
        'puntuacion_acumulada',
        'tiempo_jugado_segundos',
        'estado_json',
    ];

    protected $casts = [
        'nivel_actual' => 'integer',
        'puntuacion_acumulada' => 'integer',
        'tiempo_jugado_segundos' => 'integer',
        'estado_json' => 'array', // Maneja JSONB automáticamente como estructura nativa PHP
        'actualizado_en' => 'datetime',
    ];

    public function jugador(): BelongsTo
    {
        return $this->belongsTo(JugadorSesion::class, 'jugador_id', 'id');
    }
}
