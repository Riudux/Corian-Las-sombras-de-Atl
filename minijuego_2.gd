extends Node2D

const LANE_X = [406.0, 512.0, 618.0]
const PLAYER_Y = 525.0
const RACCOON_Y = 205.0
const ROUND_TIME = 20.0
const GOLPES_NECESARIOS = 5

var jugador
var mapache
var carril_actual = 1
var vidas = 3
var tiempo = 0.0
var tiempo_spawn = 0.0
var tiempo_cambio_mapache = 1.5
var tiempo_rama = 0.0
var carril_mapache = 1
var golpes_mapache = 0
var estado = "ataque"
var proyectiles = []
var etiqueta_vidas
var etiqueta_estado
var etiqueta_controles
var aleatorio = RandomNumberGenerator.new()

func _ready():
	aleatorio.randomize()
	jugador = get_node("player_atl")
	jugador.puedo_moverme = false
	jugador.position = Vector2(LANE_X[carril_actual], PLAYER_Y)
	mapache = get_node("Mapache")
	mapache.position = Vector2(LANE_X[carril_mapache], RACCOON_Y)

	etiqueta_vidas = Label.new()
	etiqueta_vidas.rect_position = Vector2(28, 22)
	etiqueta_vidas.add_color_override("font_color", Color(1, 1, 1))
	add_child(etiqueta_vidas)

	etiqueta_estado = Label.new()
	etiqueta_estado.rect_position = Vector2(320, 24)
	etiqueta_estado.rect_size = Vector2(390, 40)
	etiqueta_estado.align = Label.ALIGN_CENTER
	etiqueta_estado.add_color_override("font_color", Color(1, 1, 1))
	add_child(etiqueta_estado)

	etiqueta_controles = Label.new()
	etiqueta_controles.rect_position = Vector2(28, 555)
	etiqueta_controles.text = "Izquierda/Derecha: cambiar de carril   Espacio: lanzar rama"
	etiqueta_controles.add_color_override("font_color", Color(1, 1, 1))
	add_child(etiqueta_controles)
	_actualizar_interfaz()
	update()

func _process(delta):
	tiempo_rama = max(0.0, tiempo_rama - delta)
	if estado == "ataque":
		tiempo += delta
		tiempo_spawn -= delta
		tiempo_cambio_mapache -= delta
		if tiempo_cambio_mapache <= 0.0:
			carril_mapache = aleatorio.randi_range(0, 2)
			mapache.position.x = LANE_X[carril_mapache]
			tiempo_cambio_mapache = aleatorio.randf_range(1.2, 2.3)
		if tiempo_spawn <= 0.0:
			_crear_proyectil()
			tiempo_spawn = aleatorio.randf_range(0.65, 1.15)
		if tiempo >= ROUND_TIME:
			_iniciar_fase_final()
	if (estado == "ataque" or estado == "final") and Input.is_key_pressed(KEY_SPACE) and tiempo_rama <= 0.0:
		_lanzar_rama()
	_actualizar_proyectiles(delta)

func _unhandled_input(event):
	if estado == "perdido" and event is InputEventKey and event.pressed and event.scancode == KEY_R:
		get_tree().reload_current_scene()
		return
	if estado != "ataque" and estado != "final":
		return
	if event.is_action_pressed("ui_left"):
		_mover_carril(-1)
	elif event.is_action_pressed("ui_right"):
		_mover_carril(1)

func _mover_carril(direccion):
	carril_actual = clamp(carril_actual + direccion, 0, LANE_X.size() - 1)
	jugador.position.x = LANE_X[carril_actual]

func _crear_proyectil():
	var proyectil = Node2D.new()
	proyectil.position = Vector2(LANE_X[carril_mapache], RACCOON_Y + 55)
	proyectil.set_meta("velocidad", aleatorio.randf_range(170.0, 240.0))
	proyectil.set_meta("direccion", 1)
	proyectil.set_meta("tipo", aleatorio.randi_range(0, 1))
	var dibujo = Polygon2D.new()
	if proyectil.get_meta("tipo") == 0:
		dibujo.polygon = PoolVector2Array([Vector2(-15, -10), Vector2(10, -7), Vector2(16, 8), Vector2(-8, 12)])
		dibujo.color = Color("75604c")
	else:
		dibujo.polygon = PoolVector2Array([Vector2(-25, -4), Vector2(21, -8), Vector2(25, 2), Vector2(-18, 8)])
		dibujo.color = Color("8b5a3c")
	proyectil.add_child(dibujo)
	add_child(proyectil)
	proyectiles.append(proyectil)

func _actualizar_proyectiles(delta):
	for proyectil in proyectiles.duplicate():
		if not is_instance_valid(proyectil):
			proyectiles.erase(proyectil)
			continue
		proyectil.position.y += float(proyectil.get_meta("velocidad")) * delta * float(proyectil.get_meta("direccion"))
		if proyectil.get_meta("direccion") > 0 and estado == "ataque" and proyectil.position.y >= PLAYER_Y - 28:
			if abs(proyectil.position.x - jugador.position.x) < 38:
				_recibir_impacto(proyectil)
			else:
				proyectil.queue_free()
				proyectiles.erase(proyectil)
		elif proyectil.get_meta("direccion") < 0 and proyectil.position.y <= RACCOON_Y + 45:
			if abs(proyectil.position.x - mapache.position.x) < 42:
				_recibir_golpe_mapache(proyectil)
			else:
				proyectil.queue_free()
				proyectiles.erase(proyectil)
		elif proyectil.position.y > 650 or proyectil.position.y < -60:
			proyectil.queue_free()
			proyectiles.erase(proyectil)

func _recibir_impacto(proyectil):
	proyectil.queue_free()
	proyectiles.erase(proyectil)
	vidas -= 1
	_actualizar_interfaz()
	if vidas <= 0:
		estado = "perdido"
		etiqueta_estado.text = "Atl se perdió... presiona R para reintentar"

func _iniciar_fase_final():
	estado = "final"
	for proyectil in proyectiles:
		if is_instance_valid(proyectil):
			proyectil.queue_free()
	proyectiles.clear()
	mapache.texture = load("res://assets/mapache_arrojando.png")
	mapache.hframes = 1
	mapache.vframes = 1
	etiqueta_estado.text = "Golpea al mapache varias veces: ESPACIO"
	etiqueta_controles.text = "Izquierda/Derecha: carril   ESPACIO: lanzar rama"

func _lanzar_rama():
	tiempo_rama = 0.45
	var rama = Node2D.new()
	rama.position = Vector2(jugador.position.x, PLAYER_Y - 42)
	rama.set_meta("velocidad", 260.0)
	rama.set_meta("direccion", -1)
	var dibujo = Polygon2D.new()
	dibujo.polygon = PoolVector2Array([Vector2(-24, -4), Vector2(24, -8), Vector2(25, 2), Vector2(-18, 8)])
	dibujo.color = Color("8b5a3c")
	rama.add_child(dibujo)
	add_child(rama)
	proyectiles.append(rama)

func _recibir_golpe_mapache(proyectil):
	proyectil.queue_free()
	proyectiles.erase(proyectil)
	golpes_mapache += 1
	etiqueta_estado.text = "Golpes al mapache: %d / %d" % [golpes_mapache, GOLPES_NECESARIOS]
	if golpes_mapache >= GOLPES_NECESARIOS:
		_completar_minijuego()

func _completar_minijuego():
	estado = "completado"
	mapache.texture = load("res://assets/mapache_golpeado.png")
	mapache.hframes = 1
	mapache.vframes = 1
	etiqueta_estado.text = "¡El mapache soltó el fragmento!"
	etiqueta_controles.text = "Minijuego completado"
	variables.fragmentos_obtenidos = max(1, variables.fragmentos_obtenidos)
	set_process(false)

func _actualizar_interfaz():
	etiqueta_vidas.text = "Vidas: " + str(vidas)
	if estado == "ataque":
		etiqueta_estado.text = "Esquiva las piedras y ramas"

func _draw():
	for x in LANE_X:
		draw_line(Vector2(x, 145), Vector2(x, 565), Color(1, 1, 1, 0.18), 2.0)
