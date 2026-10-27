extends KinematicBody2D

var puedo_moverme: bool = true
var velocidad = 200
var movimiento = Vector2()

onready var animacion = $Sprite/AnimationPlayer

func _physics_process(delta):

	# Si está en un diálogo o evento, detiene la animación y frena el movimiento
	if not puedo_moverme:
		animacion.stop()
		return

	movimiento = Vector2()

	# Movimiento con Flechas del teclado O Teclas WASD (D, A, S, W)
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		movimiento.x += 1

	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		movimiento.x -= 1

	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		movimiento.y += 1

	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		movimiento.y -= 1


	movimiento = movimiento.normalized() * velocidad


	if movimiento != Vector2.ZERO:

		if movimiento.x > 0:
			reproducir_animacion("derecha")

		elif movimiento.x < 0:
			reproducir_animacion("izquierda")

		elif movimiento.y > 0:
			reproducir_animacion("abajo")

		elif movimiento.y < 0:
			reproducir_animacion("arriba")

	else:
		animacion.stop()


	movimiento = move_and_slide(movimiento)


func reproducir_animacion(nombre):

	if animacion.current_animation != nombre:
		animacion.play(nombre)
