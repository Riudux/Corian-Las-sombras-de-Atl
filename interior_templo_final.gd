extends Node2D

const ESCENA_EXTERIOR = "res://templo_en_ruinas_soleado.tscn"
const ESCENA_MENU = "res://MenuInicio.tscn"

var jugador = null
var altar = null
var salida = null
var etiqueta_mensaje = null
var salida_lista = false
var cambiando_escena = false
var final_activado = false
var gemas_dibujadas = 0

func _ready():
	jugador = find_node("player_atl", true, false)
	altar = find_node("AltarFragmentos", true, false)
	salida = find_node("SalidaExterior", true, false)

	etiqueta_mensaje = Label.new()
	etiqueta_mensaje.rect_position = Vector2(212, 35)
	etiqueta_mensaje.rect_size = Vector2(600, 70)
	etiqueta_mensaje.align = Label.ALIGN_CENTER
	etiqueta_mensaje.autowrap = true
	add_child(etiqueta_mensaje)

	if altar:
		if altar is Area2D:
			altar.monitoring = true
			if not altar.is_connected("body_entered", self, "_on_altar_body_entered"):
				altar.connect("body_entered", self, "_on_altar_body_entered")
		# Dibuja los fragmentos que YA habían sido puestos en visitas anteriores
		_actualizar_visual_altar()

	if salida and salida is Area2D:
		salida.monitoring = true
		if not salida.is_connected("body_entered", self, "_on_salida_body_entered"):
			salida.connect("body_entered", self, "_on_salida_body_entered")


func _process(_delta):
	if final_activado or cambiando_escena or not jugador:
		return

	# 1. Al acercarse al altar del centro, coloca los fragmentos que traiga Atl
	if altar and jugador.global_position.distance_to(altar.global_position) < 65.0:
		_colocar_fragmentos_en_altar()

	# 2. Control de la escalera de salida
	if salida:
		var dist_escalera = jugador.global_position.distance_to(salida.global_position)
		if not salida_lista and dist_escalera > 75.0:
			salida_lista = true
		elif salida_lista and dist_escalera < 55.0:
			_salir_por_escalera()


func _on_altar_body_entered(body):
	if body == jugador or body.name == "player_atl":
		_colocar_fragmentos_en_altar()


func _on_salida_body_entered(body):
	if not salida_lista or final_activado or cambiando_escena:
		return
	if body == jugador or body.name == "player_atl":
		_salir_por_escalera()


func _salir_por_escalera():
	cambiando_escena = true
	get_tree().change_scene(ESCENA_EXTERIOR)


func _colocar_fragmentos_en_altar():
	# Si Atl trae fragmentos nuevos sin colocar, los pone en el centro del altar
	if variables.fragmentos_obtenidos > variables.fragmentos_colocados:
		variables.fragmentos_colocados = min(3, variables.fragmentos_obtenidos)
		_actualizar_visual_altar()
		if variables.fragmentos_colocados < 3:
			etiqueta_mensaje.text = "¡Colocaste un fragmento en el centro! (%d / 3)\nVe al pueblo por los que faltan." % variables.fragmentos_colocados

	if variables.fragmentos_colocados >= 3:
		_activar_final()
	elif variables.fragmentos_obtenidos == 0:
		etiqueta_mensaje.text = "El altar está vacío (0 / 3).\nVe al pueblo a recuperar los fragmentos."


func _actualizar_visual_altar():
	if not altar:
		return
	var posiciones = [Vector2(-28, 6), Vector2(0, -18), Vector2(28, 6)]

	# Dibuja solo los fragmentos colocados que aún no aparecen en el centro
	while gemas_dibujadas < variables.fragmentos_colocados and gemas_dibujadas < 3:
		var gema = Polygon2D.new()
		gema.polygon = PoolVector2Array([
			Vector2(0, -16), Vector2(13, 0), Vector2(0, 16), Vector2(-13, 0)
		])
		gema.color = Color(0.2, 0.95, 1.0)
		gema.position = posiciones[gemas_dibujadas]
		altar.add_child(gema)
		gemas_dibujadas += 1


func _activar_final():
	if final_activado:
		return
	final_activado = true

	if jugador and "puedo_moverme" in jugador:
		jugador.puedo_moverme = false

	etiqueta_mensaje.text = "¡Has colocado los 3 fragmentos y restaurado el Templo de Corian!\n¡Gracias por jugar!"

	yield(get_tree().create_timer(4.5), "timeout")
	get_tree().change_scene(ESCENA_MENU)
