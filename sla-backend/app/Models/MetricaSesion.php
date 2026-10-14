<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MetricaSesion extends Model
{
    protected $table = 'metricas_sesion';
    
    protected $fillable = [
        'jugador_id', 'duracion_segundos', 'niveles_completados', 'sincronizado_en'
    ];
}
