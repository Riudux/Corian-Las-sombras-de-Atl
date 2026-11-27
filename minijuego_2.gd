extends Node2D

const LANE_X = [406.0, 512.0, 618.0]
const PLAYER_Y = 525.0
const RACCOON_Y = 205.0
const GOLPES_NECESARIOS = 10
const PERDISTE_SCENE = preload("res://perdiste.tscn")
const RAMA_TEXTURE = preload("res://assets/rama.png")
const PIEDRA_TEXTURE = preload("res://assets/piedra.png")
const VIDA_TEXTURE = preload("res://assets/vida.png")
const VIDA_PERDIDA_TEXTURE = preload("res://assets/vida_perdida.png")

var jugador
var mapache
var carril_actual = 1
var vidas = 5
var tiempo = 0.0
var tiempo_spawn = 0.0
var tiempo_cambio_mapache = 1.5
var tiempo_rama = 0.0
var carril_mapache = 1
var golpes_mapache = 0
var tiempo_mapache_golpeado = 0.0
var estado = "ataque"
var proyectiles = []
var etiqueta_vidas
var etiqueta_estado
var etiqueta_controles
var contenedor_vidas
var pantalla_perdiste
var sprite_mapache_normal
var sprite_mapache_golpeado
var aleatorio = RandomNumberGenerator.new()

func _ready():
	aleatorio.randomize()
	jugador = get_node("player_atl")
	jugador.puedo_moverme = false
	jugador.position = Vector2(LANE_X[carril_actual], PLAYER_Y)
	mapache = get_node("Mapache")
	# mapache.tscn fue creado como escena independiente; se centra aquí para
	# que sus offsets de edición no desplacen el personaje fuera del carril.
	sprite_mapache_normal = mapache.get_node("Mapache")
	sprite_mapache_normal.position = Vector2.ZERO
	mapache.get_node("CollisionShape2D").position = Vector2.ZERO
	mapache.scale = Vector2(0.45, 0.45)
	mapache.position = Vector2(LANE_X[carril_mapache], RACCOON_Y)
	mapache.get_node("Mapache/AnimationPlayer").play("mapache_abajo")
	sprite_mapache_golpeado = Sprite.new()
	sprite_mapache_golpeado.name = "MapacheGolpeado"
	sprite_mapache_golpeado.texture = load("res://assets/mapache_golpeado.png")
	sprite_mapache_golpeado.visible = false
	mapache.add_child(sprite_mapache_golpeado)

	etiqueta_vidas = Label.new()
	etiqueta_vidas.rect_position = Vector2(28, 22)
	etiqueta_vidas.add_color_override("font_color", Color(1, 1, 1))
	add_child(etiqueta_vidas)
	contenedor_vidas = HBoxContainer.new()
	contenedor_vidas.rect_position = Vector2(28, 48)
	contenedor_vidas.add_constant_override("separation", 6)
	add_child(contenedor_vidas)

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
	if tiempo_mapache_golpeado > 0.0:
		tiempo_mapache_golpeado -= delta
		if tiempo_mapache_golpeado <= 0.0 and estado == "ataque":
			_restaurar_mapache_atacando()
	if estado == "ataque":
		tiempo_cambio_mapache -= delta
		if tiempo_cambio_mapache <= 0.0:
			var nuevo_carril = aleatorio.randi_range(0, 2)
			if nuevo_carril == carril_mapache:
				nuevo_carril = (carril_mapache + aleatorio.randi_range(1, 2)) % 3
			carril_mapache = nuevo_carril
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(mapache, "position:x", LANE_X[carril_mapache], 0.35)
			tiempo_cambio_mapache = aleatorio.randf_range(0.75, 1.45)
	if estado == "ataque":
		tiempo += delta
		tiempo_spawn -= delta
		if tiempo_spawn <= 0.0:
			_crear_proyectil()
			tiempo_spawn = aleatorio.randf_range(0.65, 1.15)
	if estado == "ataque" and Input.is_key_pressed(KEY_SPACE) and tiempo_rama <= 0.0:
		_lanzar_rama()
	_actualizar_proyectiles(delta)

func _unhandled_input(event):
	if estado == "perdido" and event is InputEventKey and event.pressed and event.scancode == KEY_R:
		get_tree().reload_current_scene()
		return
	if estado != "ataque":
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
	var sprite = Sprite.new()
	sprite.texture = PIEDRA_TEXTURE if proyectil.get_meta("tipo") == 0 else RAMA_TEXTURE
	sprite.scale = Vector2(1.44, 1.44)
	proyectil.add_child(sprite)
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
		elif proyectil.get_meta("direccion") < 0 and estado == "ataque" and proyectil.position.y <= RACCOON_Y + 45:
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
		etiqueta_estado.text = "Atl se perdió..."
		_mostrar_pantalla_perdiste()

func _lanzar_rama():
	tiempo_rama = 0.45
	var rama = Node2D.new()
	rama.position = Vector2(jugador.position.x, PLAYER_Y - 42)
	rama.set_meta("velocidad", 260.0)
	rama.set_meta("direccion", -1)
	var sprite = Sprite.new()
	sprite.texture = RAMA_TEXTURE
	sprite.scale = Vector2(1.44, 1.44)
	rama.add_child(sprite)
	add_child(rama)
	proyectiles.append(rama)

func _recibir_golpe_mapache(proyectil):
	proyectil.queue_free()
	proyectiles.erase(proyectil)
	golpes_mapache += 1
	sprite_mapache_normal.visible = false
	sprite_mapache_golpeado.visible = true
	tiempo_mapache_golpeado = 0.35
	etiqueta_estado.text = "Golpes al mapache: %d / %d" % [golpes_mapache, GOLPES_NECESARIOS]
	if golpes_mapache >= GOLPES_NECESARIOS:
		_completar_minijuego()

func _restaurar_mapache_atacando():
	if estado != "ataque":
		return
	sprite_mapache_golpeado.visible = false
	sprite_mapache_normal.visible = true

func _completar_minijuego():
	estado = "completado"
	sprite_mapache_normal.visible = false
	sprite_mapache_golpeado.visible = true
	mapache.get_node("Mapache/AnimationPlayer").stop()
	etiqueta_estado.text = "¡El mapache soltó el fragmento!"
	etiqueta_controles.text = "Minijuego completado"
	variables.fragmentos_obtenidos = max(1, variables.fragmentos_obtenidos)
	set_process(false)
	variables.minijuego_2_ganado = true
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://pueblo.tscn")

func _actualizar_interfaz():
	etiqueta_vidas.text = "Vidas: " + str(vidas)
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
	if estado == "ataque":
		etiqueta_estado.text = "Esquiva las piedras y ramas"

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
