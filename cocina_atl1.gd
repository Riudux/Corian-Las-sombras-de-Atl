extends Node2D

const DIALOGO_NO_SALIR = preload("res://dialogues/no_salir.tres")
var procesando_evento: bool = false


func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body.name == "player_atl":
		variables.posicion_entrada = "abajo1"
		get_tree().change_scene("res://sala_atl1.tscn")


func _on_salida_body_entered(body):
	if body.name == "player_atl" and not procesando_evento:
		procesando_evento = true
		
		# 1. Bloquear el control manual del jugador
		if "puedo_moverme" in body:
			body.puedo_moverme = false

		# 2. Obtener el nodo real del globo de diálogo esperando "completed"
		var balloon = yield(DialogueManager.show_example_dialogue_balloon("start", DIALOGO_NO_SALIR), "completed")
		
		# 3. Esperar a que la ventana del diálogo se cierre y destruya
		if is_instance_valid(balloon):
			yield(balloon, "tree_exited")

		# 4. Reactivar el control del jugador
		if "puedo_moverme" in body:
			body.puedo_moverme = true


func _on_salida_body_exited(body):
	if body.name == "player_atl":
		# Se reactiva la posibilidad de hablar solo al salir físicamente del área
		procesando_evento = false
