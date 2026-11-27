extends Node2D

const ESCENA_TEMPLO = "res://templo_en_ruinas_soleado.tscn"
var puede_salir = false

func _ready():

	var salida = find_node("SalidaTemplo", true, false)
	if salida:
		salida.monitoring = true
		if not salida.is_connected("body_entered", self, "_on_salida_templo_body_entered"):
			salida.connect("body_entered", self, "_on_salida_templo_body_entered")
		print("OK: SalidaTemplo lista.")
	else:
		print("ERROR: No existe ningún nodo llamado SalidaTemplo en pueblo.tscn")

	yield(get_tree().create_timer(0.5), "timeout")
	puede_salir = true


func _on_salida_templo_body_entered(body):
	print("Tocó la salida: ", body.name)
	if not puede_salir:
		return
	if body is KinematicBody2D or "player" in body.name.to_lower() or "atl" in body.name.to_lower():
		variables.posicion_entrada = "pueblo"
		get_tree().change_scene(ESCENA_TEMPLO)
