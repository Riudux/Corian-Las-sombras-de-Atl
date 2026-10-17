<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\CatalogoDilema;

class CatalogoDilemasSeeder extends Seeder
{
    public function run(): void
    {
        CatalogoDilema::insert([
            [
                'codigo' => 'DIL-001',
                'descripcion' => 'Encuentras dinero tirado en el patio de la escuela. ¿Qué haces?',
                'capitulo_juego' => 1,
                'opcion_correcta' => 'Entregarlo al maestro',
            ],
            [
                'codigo' => 'DIL-002',
                'descripcion' => 'Un compañero te pide que lo dejes copiar en el examen. ¿Qué haces?',
                'capitulo_juego' => 1,
                'opcion_correcta' => 'Negarme y explicar que no es justo',
            ],
            [
                'codigo' => 'DIL-003',
                'descripcion' => 'Ves a alguien mayor tirando basura en el río de tu comunidad. ¿Qué haces?',
                'capitulo_juego' => 2,
                'opcion_correcta' => 'Pedirle con respeto que recoja su basura',
            ]
        ]);
    }
}