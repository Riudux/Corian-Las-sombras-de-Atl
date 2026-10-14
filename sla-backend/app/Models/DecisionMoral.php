<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DecisionMoral extends Model
{
    protected $table = 'decisiones_morales';
    public $timestamps = false;
    
    protected $fillable = [
        'jugador_id', 'dilema_id', 'opcion_elegida', 'es_decision_etica', 
        'tiempo_respuesta_seg', 'fecha_registro', 'sincronizado_en'
    ];
}
