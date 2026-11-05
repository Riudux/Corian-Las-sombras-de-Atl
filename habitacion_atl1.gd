extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var barrera = get_node_or_null("PuertaBloqueada/CollisionShape2D")
	if barrera:
		# La puerta funciona normalmente al inicio. Se bloquea al volver después de comer.
		barrera.disabled = not (variables.comio_concha and variables.dialogo_reclamo_visto)

	if variables.comio_concha and not variables.dialogo_reclamo_visto:
		yield(get_tree(), "idle_frame")
		mostrar_reclamo_mama()

func mostrar_reclamo_mama():
	var jugador = get_node_or_null("player_atl")
	var barrera = get_node_or_null("PuertaBloqueada/CollisionShape2D")
	if barrera:
		barrera.disabled = false
	if jugador:
		jugador.puedo_moverme = false

	DialogueManager.show_example_dialogue_balloon(
		"start",
		preload("res://dialogues/mama_reclamo.tres")
	)
	yield(DialogueManager, "dialogue_finished")

	variables.dialogo_reclamo_visto = true
	variables.madre_llamo = true
	variables.escape_desbloqueado = true
	# La puerta sigue bloqueada: la ruta narrativa de escape es la ventana.
	if jugador and is_instance_valid(jugador):
		jugador.puedo_moverme = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_puerta_habitacion_atl_body_entered(body):
	if body.name == "player_atl":
		variables.posicion_entrada = "arriba1" #donde quiero que mi personaje aparezca en la sig escena?
		get_tree().change_scene("res://sala_atl1.tscn")
