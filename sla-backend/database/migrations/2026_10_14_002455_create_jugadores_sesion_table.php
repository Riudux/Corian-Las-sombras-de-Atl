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
    Schema::create('jugadores_sesion', function (Blueprint $table) {
        $table->uuid('id')->primary(); // UUID
        $table->string('token_acceso');
        $table->string('codigo_recuperacion')->unique();
        $table->string('dispositivo')->nullable();
        $table->timestamp('ultimo_acceso')->nullable();
        $table->timestamp('sincronizado_en')->nullable(); // Control offline
        $table->timestamps();
    });
}
};
