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
    Schema::create('metricas_sesion', function (Blueprint $table) {
        $table->id();
        $table->foreignUuid('jugador_id')->constrained('jugadores_sesion')->cascadeOnDelete();
        $table->integer('duracion_segundos');
        $table->integer('niveles_completados')->default(0);
        $table->timestamp('sincronizado_en')->nullable(); // Control offline
        $table->timestamps();
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('metricas_sesion');
    }
};
