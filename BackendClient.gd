extends Node

# =============================================================================
# BackendClient.gd - Cliente de Conexión para "Corian: Las sombras de Atl"
# Compatible con Godot 3.x (HTTPRequest)
# Se conecta a: Nginx (puerto 80) -> Laravel 10 -> PostgreSQL 15 (JSONB)
# =============================================================================

const BASE_URL = "http://localhost/api"

signal sesion_creada(datos)
signal progreso_guardado(datos)
signal progreso_cargado(datos)
signal error_api(codigo, mensaje)

var jugador_id: String = ""

func iniciar_sesion(alias: String = "Corian_Heroe"):
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_on_sesion_completed", [http])
	
	var headers = ["Content-Type: application/json", "Accept: application/json"]
	var body = JSON.print({
		"alias": alias,
		"dispositivo_uuid": OS.get_unique_id()
	})
	http.request(BASE_URL + "/juego/sesion", headers, true, HTTPClient.METHOD_POST, body)

func _on_sesion_completed(result, response_code, headers, body, http_node):
	http_node.queue_free()
	if response_code == 201:
		var res = JSON.parse(body.get_string_from_utf8()).result
		jugador_id = res["jugador"]["id"]
		print("[BackendClient] Sesión creada con éxito. UUID: ", jugador_id)
		emit_signal("sesion_creada", res)
	else:
		emit_signal("error_api", response_code, body.get_string_from_utf8())

func guardar_progreso(nivel: int, puntos: int, tiempo_segundos: int, estado_json: Dictionary):
	if jugador_id == "":
		push_error("[BackendClient] Error: No hay una sesión activa de jugador.")
		return
		
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_on_guardar_completed", [http])
	
	var headers = ["Content-Type: application/json", "Accept: application/json"]
	var payload = {
		"nivel_actual": nivel,
		"puntuacion_acumulada": puntos,
		"tiempo_jugado_segundos": tiempo_segundos,
		"estado_json": estado_json
	}
	http.request(BASE_URL + "/juego/progreso/" + jugador_id, headers, true, HTTPClient.METHOD_PUT, JSON.print(payload))

func _on_guardar_completed(result, response_code, headers, body, http_node):
	http_node.queue_free()
	if response_code == 200:
		var res = JSON.parse(body.get_string_from_utf8()).result
		print("[BackendClient] Progreso y JSONB guardados en PostgreSQL exitosamente.")
		emit_signal("progreso_guardado", res)
	else:
		emit_signal("error_api", response_code, body.get_string_from_utf8())

func cargar_progreso():
	if jugador_id == "":
		push_error("[BackendClient] Error: No hay una sesión activa de jugador.")
		return
		
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_on_cargar_completed", [http])
	
	var headers = ["Accept: application/json"]
	http.request(BASE_URL + "/juego/progreso/" + jugador_id, headers, true, HTTPClient.METHOD_GET)

func _on_cargar_completed(result, response_code, headers, body, http_node):
	http_node.queue_free()
	if response_code == 200:
		var res = JSON.parse(body.get_string_from_utf8()).result
		print("[BackendClient] Progreso descargado de la BD: ", res)
		emit_signal("progreso_cargado", res)
	else:
		emit_signal("error_api", response_code, body.get_string_from_utf8())
