<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use App\Models\JugadorSesion;

class SesionAnonimaController extends Controller
{
    /**
     * Genera una nueva identidad anónima para un dispositivo/jugador.
     */
    public function generarToken(Request $request)
    {
        $dispositivo = $request->input('dispositivo', 'Desconocido');
        
        // Generación de persistencia anónima
        $uuid = Str::uuid()->toString();
        $tokenAcceso = bin2hex(random_bytes(16)); // Token temporal de 32 caracteres
        $codigoRecuperacion = strtoupper(Str::random(6)); // Código fácil para niños (ej. A4X9PQ)

        $jugador = JugadorSesion::create([
            'id' => $uuid,
            'token_acceso' => $tokenAcceso,
            'codigo_recuperacion' => $codigoRecuperacion,
            'dispositivo' => $dispositivo,
            'sincronizado_en' => now(),
        ]);

        return response()->json([
            'mensaje' => 'Identidad anónima generada con éxito.',
            'credenciales' => [
                'id' => $jugador->id,
                'token_acceso' => $jugador->token_acceso,
                'codigo_recuperacion' => $jugador->codigo_recuperacion,
            ]
        ], 201);
    }

    /**
     * Valida un código de recuperación para retomar progreso en otro dispositivo.
     */
    public function validarRecuperacion(Request $request)
    {
        $request->validate([
            'codigo_recuperacion' => 'required|string|size:6'
        ]);

        $jugador = JugadorSesion::where('codigo_recuperacion', strtoupper($request->codigo_recuperacion))->first();

        if (!$jugador) {
            return response()->json(['mensaje' => 'Código de recuperación inválido o expirado.'], 404);
        }

        // Regeneramos el token temporal por seguridad al cambiar de sesión
        $nuevoToken = bin2hex(random_bytes(16));
        $jugador->update([
            'token_acceso' => $nuevoToken,
            'ultimo_acceso' => now()
        ]);

        return response()->json([
            'mensaje' => 'Sesión recuperada exitosamente.',
            'credenciales' => [
                'id' => $jugador->id,
                'token_acceso' => $nuevoToken,
                'codigo_recuperacion' => $jugador->codigo_recuperacion
            ]
        ], 200);
    }
}