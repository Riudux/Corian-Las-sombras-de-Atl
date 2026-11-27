extends Node2D

const LANE_X = [406.0, 512.0, 618.0]
const PLAYER_Y = 525.0
const RACCOON_Y = 205.0
const ROBOS_A_DETENER = 7
const PERDISTE_SCENE = preload("res://perdiste.tscn")
const RAMA_TEXTURE = preload("res://assets/rama.png")
const VIDA_TEXTURE = preload("res://assets/vida.png")
const VIDA_PERDIDA_TEXTURE = preload("res://assets/vida_perdida.png")

var jugador
var mapache
var carril_actual = 1
var vidas = 5
var tiempo_cambio_mapache = 1.1
var tiempo_para_intentar_robo = 1.8
var tiempo_limite_robo = 1.5
var tiempo_rama = 0.0
var carril_mapache = 1
var golpes_mapache = 0
var tiempo_mapache_golpeado = 0.0
var estado = "jugando" # jugando, perdido, completado
var esta_robando = false
var proyectiles = []

var etiqueta_vidas
var etiqueta_estado
var etiqueta_controles
var etiqueta_robo
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

	# Aviso visual sobre el mapache cuando intenta robar
	etiqueta_robo = Label.new()
	etiqueta_robo.text = "¡ESTÁ ROBANDO!"
	etiqueta_robo.rect_position = Vector2(-55, -130)
	etiqueta_robo.rect_scale = Vector2(2.0, 2.0)
	etiqueta_robo.add_color_override("font_color", Color(1, 0.9, 0.1))
	etiqueta_robo.visible = false
	mapache.add_child(etiqueta_robo)

	etiqueta_vidas = Label.new()
	etiqueta_vidas.rect_position = Vector2(28, 22)
	etiqueta_vidas.add_color_override("font_color", Color(1, 1, 1))
	add_child(etiqueta_vidas)

	contenedor_vidas = HBoxContainer.new()
	contenedor_vidas.rect_position = Vector2(28, 48)
	contenedor_vidas.add_constant_override("separation", 6)
	add_child(contenedor_vidas)

	etiqueta_estado = Label.new()
	etiqueta_estado.rect_position = Vector2(280, 24)
	etiqueta_estado.rect_size = Vector2(460, 40)
	etiqueta_estado.align = Label.ALIGN_CENTER
	etiqueta_estado.add_color_override("font_color", Color(1, 1, 1))
	add_child(etiqueta_estado)

	etiqueta_controles = Label.new()
	etiqueta_controles.rect_position = Vector2(28, 555)
	etiqueta_controles.text = "Flechas + Espacio (o Clic en el puesto): golpear cuando robe fruta"
	etiqueta_controles.add_color_override("font_color", Color(1, 1, 1))
	add_child(etiqueta_controles)

	_actualizar_interfaz()
	update()

func _process(delta):
	tiempo_rama = max(0.0, tiempo_rama - delta)

	if tiempo_mapache_golpeado > 0.0:
		tiempo_mapache_golpeado -= delta
		if tiempo_mapache_golpeado <= 0.0 and estado == "jugando":
			sprite_mapache_golpeado.visible = false
			sprite_mapache_normal.visible = true

	if estado == "jugando":
		if not esta_robando:
			# El mapache se mueve entre los 3 puestos de fruta
			tiempo_cambio_mapache -= delta
			if tiempo_cambio_mapache <= 0.0:
				_mover_mapache_otro_carril()
				tiempo_cambio_mapache = aleatorio.randf_range(0.7, 1.3)

			# Cuenta regresiva para intentar robar
			tiempo_para_intentar_robo -= delta
			if tiempo_para_intentar_robo <= 0.0:
				_iniciar_robo()
		else:
			# Si está robando, corre el tiempo límite antes de llevarse la fruta
			tiempo_limite_robo -= delta
			if tiempo_limite_robo <= 0.0:
				_robo_exitoso_mapache()

		if Input.is_key_pressed(KEY_SPACE) and tiempo_rama <= 0.0:
			_lanzar_rama()

	_actualizar_proyectiles(delta)

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
		# Soporte Point & Click para niños: mueve a Atl al puesto cliqueado y lanza rama
		var mejor_carril = 0
		var menor_dist = abs(event.position.x - LANE_X[0])
		for i in range(1, LANE_X.size()):
			var dist = abs(event.position.x - LANE_X[i])
			if dist < menor_dist:
				menor_dist = dist
				mejor_carril = i
		carril_actual = mejor_carril
		jugador.position.x = LANE_X[carril_actual]
		if tiempo_rama <= 0.0:
			_lanzar_rama()

func _mover_carril(direccion):
	carril_actual = clamp(carril_actual + direccion, 0, LANE_X.size() - 1)
	jugador.position.x = LANE_X[carril_actual]

func _mover_mapache_otro_carril():
	var nuevo_carril = aleatorio.randi_range(0, 2)
	if nuevo_carril == carril_mapache:
		nuevo_carril = (carril_mapache + aleatorio.randi_range(1, 2)) % 3
	carril_mapache = nuevo_carril
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(mapache, "position:x", LANE_X[carril_mapache], 0.3)

func _iniciar_robo():
	esta_robando = true
	etiqueta_robo.visible = true
	mapache.modulate = Color(1.0, 0.75, 0.35)
	tiempo_limite_robo = 1.6 # Tiempo que tiene el jugador para golpearlo
	etiqueta_estado.text = "¡Rápido! ¡Detén al mapache antes de que robe!"

func _robo_exitoso_mapache():
	esta_robando = false
	etiqueta_robo.visible = false
	mapache.modulate = Color(1, 1, 1)
	vidas -= 1
	_actualizar_interfaz()

	if vidas <= 0:
		estado = "perdido"
		etiqueta_estado.text = "¡El mapache se llevó toda la fruta!"
		_mostrar_pantalla_perdiste()
	else:
		etiqueta_estado.text = "¡Se robó una fruta! Robos detenidos: %d / %d" % [golpes_mapache, ROBOS_A_DETENER]
		_mover_mapache_otro_carril()
		tiempo_para_intentar_robo = aleatorio.randf_range(1.2, 2.0)

func _lanzar_rama():
	tiempo_rama = 0.4
	var rama = Node2D.new()
	rama.position = Vector2(jugador.position.x, PLAYER_Y - 42)
	rama.set_meta("velocidad", 340.0)
	var sprite = Sprite.new()
	sprite.texture = RAMA_TEXTURE
	sprite.scale = Vector2(1.44, 1.44)
	rama.add_child(sprite)
	add_child(rama)
	proyectiles.append(rama)

func _actualizar_proyectiles(delta):
	for proyectil in proyectiles.duplicate():
		if not is_instance_valid(proyectil):
			proyectiles.erase(proyectil)
			continue
		proyectil.position.y -= float(proyectil.get_meta("velocidad")) * delta

		if estado == "jugando" and proyectil.position.y <= RACCOON_Y + 45:
			if abs(proyectil.position.x - mapache.position.x) < 42:
				_impactar_mapache(proyectil)
			else:
				proyectil.queue_free()
				proyectiles.erase(proyectil)
		elif proyectil.position.y < -60:
			proyectil.queue_free()
			proyectiles.erase(proyectil)

func _impactar_mapache(proyectil):
	proyectil.queue_free()
	proyectiles.erase(proyectil)

	if not esta_robando:
		# Si le pega cuando no está robando, no pierde vida, solo avisa
		etiqueta_estado.text = "¡Espera a que intente robar fruta!"
		return

	esta_robando = false
	etiqueta_robo.visible = false
	mapache.modulate = Color(1, 1, 1)
	golpes_mapache += 1

	sprite_mapache_normal.visible = false
	sprite_mapache_golpeado.visible = true
	tiempo_mapache_golpeado = 0.35

	etiqueta_estado.text = "¡Buen golpe! Robos detenidos: %d / %d" % [golpes_mapache, ROBOS_A_DETENER]

	if golpes_mapache >= ROBOS_A_DETENER:
		_completar_minijuego()
	else:
		_mover_mapache_otro_carril()
		tiempo_para_intentar_robo = aleatorio.randf_range(1.2, 2.2)

func _completar_minijuego():
	estado = "completado"
	esta_robando = false
	etiqueta_robo.visible = false
	sprite_mapache_normal.visible = false
	sprite_mapache_golpeado.visible = true
	mapache.get_node("Mapache/AnimationPlayer").stop()
	etiqueta_estado.text = "¡El mapache huyó y dejó el primer fragmento!"
	etiqueta_controles.text = "Regresando a la aldea..."

	variables.minijuego_1_ganado = true
	variables.fragmentos_obtenidos = max(1, variables.fragmentos_obtenidos)
	set_process(false)

	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://pueblo.tscn")

func _actualizar_interfaz():
	etiqueta_vidas.text = "Frutas a salvo: " + str(vidas)
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
		etiqueta_estado.text = "Robos detenidos: %d / %d" % [golpes_mapache, ROBOS_A_DETENER]

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
