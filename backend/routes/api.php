<?php

use App\Http\Controllers\GameController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes - Corian: Las sombras de Atl
|--------------------------------------------------------------------------
*/

Route::get('/status', [GameController::class, 'status']);
Route::get('/juego/todos', [GameController::class, 'listarTodo']);
Route::post('/juego/sesion', [GameController::class, 'iniciarSesion']);
Route::get('/juego/progreso/{jugadorId}', [GameController::class, 'obtenerProgreso']);
Route::put('/juego/progreso/{jugadorId}', [GameController::class, 'actualizarProgreso']);
Route::delete('/juego/jugador/{jugadorId}', [GameController::class, 'eliminarJugador']);

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
