extends Node2D

const DIALOGO_TEMPLO = preload("res://dialogues/atl_templo_ruinas.tres")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	DialogueManager.show_example_dialogue_balloon("start", DIALOGO_TEMPLO)
	yield(DialogueManager, "dialogue_finished")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_entrada_templo_body_entered(body):
	# Esta escena es el destino de la secuencia; no tiene retorno.
	pass
