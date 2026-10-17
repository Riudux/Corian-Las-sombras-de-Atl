<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\SincronizacionController;

// Agrupamos las rutas bajo un prefijo profesional y versionado
Route::prefix('v1/sincronizacion')->group(function () {
    
    // Flujo de Descarga (Pull) - Para que la tablet obtenga los catálogos al conectarse
    Route::get('/catalogos', [SincronizacionController::class, 'descargarCatalogos']);
    
    // Flujo de Subida (Push) - El endpoint masivo para recibir todo el progreso offline
    Route::post('/push', [SincronizacionController::class, 'sincronizarDatos']);

});