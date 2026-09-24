<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;

class JugadorSesion extends Model
{
    use HasUuids;

    protected $table = 'jugadores_sesion';
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';

    const CREATED_AT = 'creado_en';
    const UPDATED_AT = 'ultimo_acceso';

    protected $fillable = [
        'id',
        'alias',
        'dispositivo_uuid',
        'ip_origen',
        'activo',
    ];

    protected $casts = [
        'activo' => 'boolean',
        'creado_en' => 'datetime',
        'ultimo_acceso' => 'datetime',
    ];

    public function progreso(): HasOne
    {
        return $this->hasOne(ProgresoJuego::class, 'jugador_id', 'id');
    }
}
