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
    Schema::create('decisiones_morales', function (Blueprint $table) {
        $table->id(); // BigInt autoincremental
        $table->foreignUuid('jugador_id')->constrained('jugadores_sesion')->cascadeOnDelete();
        
        $table->unsignedSmallInteger('dilema_id');
        $table->foreign('dilema_id')->references('id')->on('catalogo_dilemas');
        
        $table->string('opcion_elegida');
        $table->boolean('es_decision_etica');
        $table->integer('tiempo_respuesta_seg');
        $table->timestamp('fecha_registro');
        $table->timestamp('sincronizado_en')->nullable(); // Control offline
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('decisiones_morales');
    }
};
