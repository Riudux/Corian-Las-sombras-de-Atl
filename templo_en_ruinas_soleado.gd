extends Node2D

const ESCENA_INTERIOR_TEMPLO = "res://interior_templo_final.tscn"
var puede_cambiar = false
var cambiando_escena = false
var jugador = null
var entrada_templo = null

func _ready():
	jugador = find_node("player_atl", true, false)
	entrada_templo = find_node("EntradaTemplo", true, false)

	if entrada_templo and entrada_templo is Area2D:
		entrada_templo.monitoring = true
		if not entrada_templo.is_connected("body_entered", self, "_on_entrada_templo_body_entered"):
			entrada_templo.connect("body_entered", self, "_on_entrada_templo_body_entered")

	# Espera 0.5s al cargar para evitar que Atl rebote al pueblo al regresar
	yield(get_tree().create_timer(0.5), "timeout")
	puede_cambiar = true


func _process(_delta):
	if not puede_cambiar or cambiando_escena:
		return
	# Respaldo por distancia por si fallan las capas de colisión
	if jugador and entrada_templo:
		if jugador.global_position.distance_to(entrada_templo.global_position) < 60.0:
			_ir_a_interior_templo()


func _on_entrada_pueblo_body_entered(body):
	if not puede_cambiar or cambiando_escena:
		return
	if body.name == "player_atl":
		cambiando_escena = true
		get_tree().change_scene("res://pueblo.tscn")


func _on_entrada_templo_body_entered(body):
	if not puede_cambiar or cambiando_escena:
		return
	if body.name == "player_atl" or body == jugador:
		_ir_a_interior_templo()


func _ir_a_interior_templo():
	cambiando_escena = true
	if "posicion_entrada" in variables:
		variables.posicion_entrada = "exterior_templo"
	get_tree().change_scene(ESCENA_INTERIOR_TEMPLO)
