extends Node2D

const LANE_X = [406.0, 512.0, 618.0]
const PLAYER_Y = 525.0
const RAMAS_NECESARIAS = 10
const PERDISTE_SCENE = preload("res://perdiste.tscn")
const RAMA_TEXTURE = preload("res://assets/rama.png")
const PIEDRA_TEXTURE = preload("res://assets/piedra.png")
const VIDA_TEXTURE = preload("res://assets/vida.png")
const VIDA_PERDIDA_TEXTURE = preload("res://assets/vida_perdida.png")

var jugador
var carril_actual = 1
var vidas = 5
var puntos = 0
var tiempo_spawn = 0.6
var estado = "jugando" # jugando, perdido, completado
var objetos_cayendo = []

var etiqueta_vidas
var etiqueta_estado
var etiqueta_controles
var contenedor_vidas
var pantalla_perdiste
var aleatorio = RandomNumberGenerator.new()

func _ready():
	aleatorio.randomize()
	
	# Si duplicaste minijuego_1, ocultamos al mapache para que no estorbe
	var mapache_extra = get_node_or_null("Mapache")
	if mapache_extra:
		mapache_extra.visible = false

	jugador = get_node("player_atl")
	jugador.puedo_moverme = false
	jugador.position = Vector2(LANE_X[carril_actual], PLAYER_Y)

	etiqueta_vidas = Label.new()
	etiqueta_vidas.rect_position = Vector2(28, 22)
	etiqueta_vidas.add_color_override("font_color", Color(1, 1, 1))
	add_child(etiqueta_vidas)

	contenedor_vidas = HBoxContainer.new()
	contenedor_vidas.rect_position = Vector2(28, 48)
	contenedor_vidas.add_constant_override("separation", 6)
	add_child(contenedor_vidas)

	etiqueta_estado = Label.new()
	etiqueta_estado.rect_position = Vector2(260, 24)
	etiqueta_estado.rect_size = Vector2(500, 40)
	etiqueta_estado.align = Label.ALIGN_CENTER
	etiqueta_estado.add_color_override("font_color", Color(1, 1, 1))
	add_child(etiqueta_estado)

	etiqueta_controles = Label.new()
	etiqueta_controles.rect_position = Vector2(28, 555)
	etiqueta_controles.text = "Flechas Izq/Der (o Clic en el carril): atrapa las ramas y esquiva las piedras"
	etiqueta_controles.add_color_override("font_color", Color(1, 1, 1))
	add_child(etiqueta_controles)

	_actualizar_interfaz()
	update()

func _process(delta):
	if estado != "jugando":
		return

	tiempo_spawn -= delta
	if tiempo_spawn <= 0.0:
		_crear_objeto()
		tiempo_spawn = aleatorio.randf_range(0.55, 0.95)

	_actualizar_objetos(delta)

func _unhandled_input(event):
	if estado == "perdido" and event is InputEventKey and event.pressed and event.scancode == KEY_R:
		get_tree().reload_current_scene()
		return

	if estado != "jugando":
		return

	if event.is_action_pressed("ui_left"):
		_mover_carril(-1)
	elif event.is_action_pressed("ui_right"):
		_mover_carril(1)
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		# Soporte Point & Click para niños: mueve a Atl directo al carril donde hicieron clic
		var mejor_carril = 0
		var menor_dist = abs(event.position.x - LANE_X[0])
		for i in range(1, LANE_X.size()):
			var dist = abs(event.position.x - LANE_X[i])
			if dist < menor_dist:
				menor_dist = dist
				mejor_carril = i
		carril_actual = mejor_carril
		jugador.position.x = LANE_X[carril_actual]

func _mover_carril(direccion):
	carril_actual = clamp(carril_actual + direccion, 0, LANE_X.size() - 1)
	jugador.position.x = LANE_X[carril_actual]

func _crear_objeto():
	var obj = Node2D.new()
	var carril = aleatorio.randi_range(0, 2)
	obj.position = Vector2(LANE_X[carril], 120.0)
	obj.set_meta("velocidad", aleatorio.randf_range(210.0, 290.0))
	
	# 60% probabilidad de rama buena (tipo 1), 40% de piedra mala (tipo 0)
	var es_rama = aleatorio.randf() < 0.6
	obj.set_meta("es_rama", es_rama)

	var sprite = Sprite.new()
	sprite.texture = RAMA_TEXTURE if es_rama else PIEDRA_TEXTURE
	sprite.scale = Vector2(1.5, 1.5)
	obj.add_child(sprite)

	add_child(obj)
	objetos_cayendo.append(obj)

func _actualizar_objetos(delta):
	for obj in objetos_cayendo.duplicate():
		if not is_instance_valid(obj):
			objetos_cayendo.erase(obj)
			continue

		obj.position.y += float(obj.get_meta("velocidad")) * delta

		# Revisar si Atl lo atrapa o choca con él
		if abs(obj.position.y - PLAYER_Y) < 35 and abs(obj.position.x - jugador.position.x) < 40:
			var es_rama = bool(obj.get_meta("es_rama"))
			obj.queue_free()
			objetos_cayendo.erase(obj)
			if es_rama:
				_atrapar_rama()
			else:
				_chocar_piedra()
		elif obj.position.y > 620:
			obj.queue_free()
			objetos_cayendo.erase(obj)

func _atrapar_rama():
	puntos += 1
	etiqueta_estado.text = "¡Bien! Ramas de paz juntadas: %d / %d" % [puntos, RAMAS_NECESARIAS]
	if puntos >= RAMAS_NECESARIAS:
		_completar_minijuego()

func _chocar_piedra():
	vidas -= 1
	_actualizar_interfaz()
	if vidas <= 0:
		estado = "perdido"
		etiqueta_estado.text = "¡Demasiado alboroto en el mercado!"
		_mostrar_pantalla_perdiste()
	else:
		etiqueta_estado.text = "¡Cuidado con las piedras! Ramas: %d / %d" % [puntos, RAMAS_NECESARIAS]

func _completar_minijuego():
	estado = "completado"
	# Limpiamos los objetos que quedaron en pantalla
	for obj in objetos_cayendo:
		if is_instance_valid(obj):
			obj.queue_free()
	objetos_cayendo.clear()

	etiqueta_estado.text = "¡Los animales se calmaron y entregaron el 3.er fragmento!"
	etiqueta_controles.text = "Regresando a la aldea..."

	variables.minijuego_3_ganado = true
	variables.fragmentos_obtenidos = max(3, variables.fragmentos_obtenidos)
	set_process(false)

	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://pueblo.tscn")

func _actualizar_interfaz():
	etiqueta_vidas.text = "Paciencia: " + str(vidas)
	if contenedor_vidas:
		for hijo in contenedor_vidas.get_children():
			hijo.queue_free()
		for i in range(5):
			var corazon = TextureRect.new()
			corazon.texture = VIDA_TEXTURE if i < vidas else VIDA_PERDIDA_TEXTURE
			corazon.rect_min_size = Vector2(28, 28)
			corazon.expand = true
			corazon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			contenedor_vidas.add_child(corazon)
	if estado == "jugando":
		etiqueta_estado.text = "Ramas de paz juntadas: %d / %d" % [puntos, RAMAS_NECESARIAS]

func _mostrar_pantalla_perdiste():
	if pantalla_perdiste:
		return
	pantalla_perdiste = PERDISTE_SCENE.instance()
	add_child(pantalla_perdiste)
	var boton = pantalla_perdiste.get_node_or_null("ColorRect/VBoxContainer/btn_retry")
	if boton:
		boton.connect("pressed", self, "_reintentar_desde_pantalla")

func _reintentar_desde_pantalla():
	get_tree().reload_current_scene()

func _draw():
	for x in LANE_X:
		draw_line(Vector2(x, 145), Vector2(x, 565), Color(1, 1, 1, 0.18), 2.0)
