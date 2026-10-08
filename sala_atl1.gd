extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if variables.posicion_entrada == "arriba1":
		$YSort/player_atl.position = Vector2(0, -200)

	elif variables.posicion_entrada == "abajo1":
		$YSort/player_atl.position = Vector2(0, 170)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_puerta_sala_atl1_body_entered(body):
	if body.name == "player_atl":
		variables.posicion_entrada ="abajo1"
		get_tree().change_scene("res://Habitacion_atl1.tscn")


func _on_Area2D_body_entered(body):
		if body.name == "player_atl":
			variables.posicion_entrada = "arriba1"
			get_tree().change_scene("res://cocina_atl1.tscn")
