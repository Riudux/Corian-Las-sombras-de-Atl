<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class JugadorSesion extends Model
{
    use HasUuids; // Inyecta la generación automática de UUIDs

    // Forzamos el nombre exacto de tu tabla en la base de datos
    protected $table = 'jugadores_sesion';

    // Desactivamos el comportamiento auto-incrementable por defecto
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';

    // Permitimos la asignación masiva de estas columnas
    protected $fillable = [
        'token_acceso',
        'codigo_recuperacion',
        'dispositivo',
        'ultimo_acceso',
        'sincronizado_en'
    ];
}