extends Node

var api_url: String = "https://tu-dominio.com/api/guardar-decision"

var jugador_id: String = ""
var es_honesto: bool = false

func _ready():
	cargar_o_crear_jugador()

func cargar_o_crear_jugador():
	var config = ConfigFile.new()
	var err = config.load("user://datos_jugador.cfg")
	
	if err == OK:
		jugador_id = config.get_value("sesion", "jugador_id", "")
		es_honesto = config.get_value("partida", "es_honesto", false)
	else:
		# Generamos un UUID v4 simulado compatible con PostgreSQL
		jugador_id = _generar_uuid_v4()
		guardar_progreso_local()

func guardar_progreso_local():
	var config = ConfigFile.new()
	config.set_value("sesion", "jugador_id", jugador_id)
	config.set_value("partida", "es_honesto", es_honesto)
	config.save("user://datos_jugador.cfg")

# Función adaptada a la tabla 'decisiones_morales'
func registrar_decision_moral(dilema_id: int, opcion_elegida: String, opcion_correcta: String, es_etica: bool, tiempo_seg: int):
	es_honesto = es_etica
	guardar_progreso_local()
	
	var payload = JSON.print({
		"jugador_id": jugador_id,
		"dilema_id": dilema_id,
		"opcion_elegida": opcion_elegida,
		"opcion_correcta": opcion_correcta,
		"es_decision_etica": es_etica,
		"tiempo_respuesta_seg": tiempo_seg
	})
	
	_enviar_a_laravel(payload)

func _enviar_a_laravel(payload_json: String):
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_on_respuesta_servidor", [http])
	
	var headers = ["Content-Type: application/json"]
	http.request(api_url, headers, true, HTTPClient.METHOD_POST, payload_json)

func _on_respuesta_servidor(_result, response_code, _headers, _body, nodo_http: HTTPRequest):
	if response_code == 200 or response_code == 201:
		print("Decisión registrada exitosamente en decisiones_morales")
	else:
		print("Error en el servidor Laravel. Código: ", response_code)
	
	nodo_http.queue_free()

func _generar_uuid_v4() -> String:
	randomize()
	var template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	var hex = "0123456789abcdef"
	var uuid = ""
	for c in template:
		if c == "x":
			uuid += hex[randi() % 16]
		elif c == "y":
			uuid += hex[(randi() % 4) + 8]
		else:
			uuid += c
	return uuid
