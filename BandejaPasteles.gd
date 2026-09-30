extends Area2D

export(NodePath) var cuadro_dialogo_path
onready var cuadro_dialogo = get_node_or_null(cuadro_dialogo_path)

# ID correspondiente en la tabla 'catalogo_dilemas'
export var dilema_id: int = 1 

var jugador_cerca: bool = false
var ya_interactuado: bool = false
var tiempo_inicio_dilema: float = 0.0

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _unhandled_input(event):
	if jugador_cerca and not ya_interactuado and event.is_action_pressed("ui_accept"):
		iniciar_evento_dilema()

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		jugador_cerca = true

func _on_body_exited(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		jugador_cerca = false

func iniciar_evento_dilema():
	if not cuadro_dialogo:
		return
	
	ya_interactuado = true
	tiempo_inicio_dilema = OS.get_ticks_msec() / 1000.0 # Guardamos el segundo de inicio
	
	if not cuadro_dialogo.is_connected("decision_tomada", self, "_on_decision_tomada"):
		cuadro_dialogo.connect("decision_tomada", self, "_on_decision_tomada", [], CONNECT_ONESHOT)
	
	cuadro_dialogo.mostrar_dilema(
		"Mamá",
		"¿Te comiste un pastel de la bandeja sin pedir permiso?",
		"Admitir la verdad",
		"Negarlo todo"
	)

func _on_decision_tomada(es_honesto: bool):
	var tiempo_fin = OS.get_ticks_msec() / 1000.0
	var tiempo_respuesta = int(tiempo_fin - tiempo_inicio_dilema)
	
	var opcion_elegida = "Admitir la verdad" if es_honesto else "Negarlo todo"
	var opcion_correcta = "Admitir la verdad"
	
	# Envía todos los campos exactos requeridos por la base de datos
	Global.registrar_decision_moral(
		dilema_id,
		opcion_elegida,
		opcion_correcta,
		es_honesto,
		tiempo_respuesta
	)
	
	if es_honesto:
		cuadro_dialogo.mostrar_texto("Mamá", "Aprecio tu honestidad. Ve a jugar un rato afuera.")
	else:
		cuadro_dialogo.mostrar_texto("Mamá", "Está bien... confiaré en tu palabra.")
