<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
{
    Schema::create('resultados_minijuegos', function (Blueprint $table) {
        $table->id();
        $table->foreignUuid('jugador_id')->constrained('jugadores_sesion')->cascadeOnDelete();
        
        $table->unsignedSmallInteger('minijuego_id');
        $table->foreign('minijuego_id')->references('id')->on('catalogo_minijuegos');
        
        $table->integer('aciertos');
        $table->integer('errores');
        $table->integer('puntaje');
        $table->timestamp('fecha_completado');
        $table->timestamp('sincronizado_en')->nullable(); // Control offline
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('resultados_minijuegos');
    }
};
