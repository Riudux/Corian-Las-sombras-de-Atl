extends Area2D

export(Resource) var dialogo_resource
export(String) var titulo_seccion = "start"
export(String) var nombre_jugador = "player_atl"

var procesando_evento: bool = false

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == nombre_jugador and not procesando_evento:
		if dialogo_resource == null:
			print("Advertencia: No se asignó ningún diálogo en el Inspector para ", name)
			return
			
		procesando_evento = true
		
		# 1. Bloquea el movimiento del jugador
		if "puedo_moverme" in body:
			body.puedo_moverme = false

		# 2. Inicia el diálogo
		DialogueManager.show_example_dialogue_balloon(titulo_seccion, dialogo_resource)
		
		# 3. Espera a que termine TODA la conversación (Señal oficial: dialogue_finished)
		yield(DialogueManager, "dialogue_finished")

		# 4. Devuelve el control al jugador al finalizar el diálogo
		if "puedo_moverme" in body:
			body.puedo_moverme = true

func _on_body_exited(body):
	if body.name == nombre_jugador:
		procesando_evento = false
