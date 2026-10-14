<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CatalogoDilema extends Model
{
    protected $table = 'catalogo_dilemas';
    public $timestamps = false;
    
    protected $fillable = [
        'codigo', 'descripcion', 'capitulo_juego', 'opcion_correcta'
    ];
}