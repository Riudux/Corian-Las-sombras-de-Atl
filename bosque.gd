extends Node2D

const DIALOGO_MAMA_REGRESA = preload("res://dialogues/mama_regresa.tres")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	DialogueManager.show_example_dialogue_balloon("start", DIALOGO_MAMA_REGRESA)
	yield(DialogueManager, "dialogue_finished")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_entrada_templo_en_ruinas_body_entered(body):
	if body.name == "player_atl":
		get_tree().change_scene("res://templo_en_ruinas.tscn")
