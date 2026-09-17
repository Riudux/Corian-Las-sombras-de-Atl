extends CanvasLayer

onready var color_rect = $ColorRect
onready var vbox = $VBoxContainer

func _ready():
	# Empezamos con el menú oculto
	color_rect.visible = false
	vbox.visible = false
	
	# Conectar botones por código
	$VBoxContainer/btn_reanudar.connect("pressed", self, "reanudar_juego")
	$VBoxContainer/btn_exit.connect("pressed", self, "_on_btn_exit_pressed")
	$VBoxContainer/btn_options.connect("pressed", self, "_on_btn_options_pressed")

func _input(event):
	if event.is_action_pressed("ui_cancel"): # Tecla Escape por defecto
		if get_tree().paused:
			reanudar_juego()
		else:
			pausar_juego()

func pausar_juego():
	color_rect.visible = true
	vbox.visible = true
	get_tree().paused = true

func reanudar_juego():
	color_rect.visible = false
	vbox.visible = false
	get_tree().paused = false

func _on_btn_exit_pressed():
	print("SALIR PRESIONADO")
	get_tree().paused = false
	get_tree().change_scene("res://MenuInicio.tscn")
	
func _on_btn_options_pressed():
	print("Botón de opciones presionado")
