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
    Schema::create('catalogo_minijuegos', function (Blueprint $table) {
        // En tu DBML es "id smallint primary key"
        $table->smallIncrements('id'); 
        
        $table->string('codigo', 50)->unique();
        $table->string('nombre', 100);
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('catalogo_minijuegos');
    }
};
