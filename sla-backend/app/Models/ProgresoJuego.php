<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProgresoJuego extends Model
{
    protected $table = 'progreso_juego';
    protected $primaryKey = 'jugador_id';
    public $incrementing = false;
    protected $keyType = 'string';
    
    protected $fillable = [
        'nivel_actual', 'puntaje_total', 'estado_json', 'sincronizado_en'
    ];
    
    public function jugador()
    {
        return $this->belongsTo(JugadorSesion::class, 'jugador_id');
    }
}