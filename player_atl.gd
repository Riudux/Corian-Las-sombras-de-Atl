extends KinematicBody2D

var puedo_moverme: bool = true
var velocidad = 200
var movimiento = Vector2()

# Variables nuevas para el movimiento por clic
var objetivo = Vector2()
var moviendo_por_clic: bool = false
var margen_llegada = 10 # Distancia mínima para detenerse y no temblar

onready var animacion = $Sprite/AnimationPlayer


func _unhandled_input(event):
	# Usamos _unhandled_input para que NO camine si haces clic en un botón de pausa o diálogo
	if not puedo_moverme or DialogueManager.is_dialogue_running:
		return

	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		objetivo = get_global_mouse_position()
		moviendo_por_clic = true


func _physics_process(delta):
	# Si está en un diálogo o evento, detiene todo y cancela el clic pendiente
	if not puedo_moverme or DialogueManager.is_dialogue_running:
		moviendo_por_clic = false
		animacion.stop()
		return

	movimiento = Vector2()

	# 1. Revisar movimiento con Teclado (Flechas o WASD)
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		movimiento.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		movimiento.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		movimiento.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		movimiento.y -= 1

	# Si el jugador usa el teclado, cancelamos el destino del clic
	if movimiento != Vector2.ZERO:
		moviendo_por_clic = false
		movimiento = movimiento.normalized() * velocidad
	
	# 2. Si no usa teclado, revisamos si está caminando hacia un clic
	elif moviendo_por_clic:
		if global_position.distance_to(objetivo) > margen_llegada:
			movimiento = (objetivo - global_position).normalized() * velocidad
		else:
			moviendo_por_clic = false

	# 3. Animaciones (mejoradas para diagonales al usar clic)
	if movimiento != Vector2.ZERO:
		if abs(movimiento.x) > abs(movimiento.y):
			if movimiento.x > 0:
				reproducir_animacion("derecha")
			else:
				reproducir_animacion("izquierda")
		else:
			if movimiento.y > 0:
				reproducir_animacion("abajo")
			else:
				reproducir_animacion("arriba")
	else:
		animacion.stop()

	# 4. Aplicar movimiento
	movimiento = move_and_slide(movimiento)

	# Si iba caminando por clic y choca con una pared/objeto, se detiene
	if moviendo_por_clic and get_slide_count() > 0:
		moviendo_por_clic = false


func reproducir_animacion(nombre):
	if animacion.current_animation != nombre:
		animacion.play(nombre)
