<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CatalogoMinijuego extends Model
{
    protected $table = 'catalogo_minijuegos';
    public $timestamps = false;
    
    protected $fillable = [
        'codigo', 'nombre'
    ];
}
