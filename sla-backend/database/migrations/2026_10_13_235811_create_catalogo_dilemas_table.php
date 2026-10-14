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
    Schema::create('catalogo_dilemas', function (Blueprint $table) {
        // En tu DBML es "id smallint primary key"
        $table->smallIncrements('id'); 
        
        $table->string('codigo', 50)->unique();
        $table->text('descripcion');
        $table->integer('capitulo_juego');
        $table->string('opcion_correcta');
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('catalogo_dilemas');
    }
};
