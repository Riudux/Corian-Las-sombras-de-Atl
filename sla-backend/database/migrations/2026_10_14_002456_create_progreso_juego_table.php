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
    Schema::create('progreso_juego', function (Blueprint $table) {
        $table->uuid('jugador_id')->primary();
        $table->foreign('jugador_id')->references('id')->on('jugadores_sesion')->cascadeOnDelete();
        $table->smallInteger('nivel_actual')->default(1);
        $table->integer('puntaje_total')->default(0);
        $table->jsonb('estado_json')->default('{}');
        $table->timestamp('sincronizado_en')->nullable(); // Control offline
        $table->timestamps();
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('progreso_juego');
    }
};
