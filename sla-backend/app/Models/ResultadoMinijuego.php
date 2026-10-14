<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ResultadoMinijuego extends Model
{
    protected $table = 'resultados_minijuegos';
    public $timestamps = false;
    
    protected $fillable = [
        'jugador_id', 'minijuego_id', 'aciertos', 'errores', 
        'puntaje', 'fecha_completado', 'sincronizado_en'
    ];
}
