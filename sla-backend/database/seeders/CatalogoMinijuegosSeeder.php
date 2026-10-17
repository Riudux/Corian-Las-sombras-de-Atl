<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\CatalogoMinijuego;

class CatalogoMinijuegosSeeder extends Seeder
{
    public function run(): void
    {
        CatalogoMinijuego::insert([
            ['codigo' => 'MINI-001', 'nombre' => 'Laberinto de la Honestidad'],
            ['codigo' => 'MINI-002', 'nombre' => 'Rompecabezas de la Verdad'],
            ['codigo' => 'MINI-003', 'nombre' => 'Carrera de la Responsabilidad']
        ]);
    }
}