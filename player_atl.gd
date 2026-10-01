extends KinematicBody2D

var velocidad = 200
var movimiento = Vector2()

onready var animacion = $Sprite/AnimationPlayer

func _physics_process(delta):

	movimiento = Vector2()

	if Input.is_action_pressed("ui_right"):
		movimiento.x += 1

	if Input.is_action_pressed("ui_left"):
		movimiento.x -= 1

	if Input.is_action_pressed("ui_down"):
		movimiento.y += 1

	if Input.is_action_pressed("ui_up"):
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
