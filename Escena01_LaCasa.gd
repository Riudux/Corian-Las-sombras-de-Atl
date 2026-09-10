extends Node2D

# Variables exportadas para ajustar las posiciones (X, Y) desde el Inspector de Godot
export var pos_dialogo_mama: Vector2 = Vector2(100, 400)
export var pos_dialogo_atl: Vector2 = Vector2(100, 100)

# Referencia a la interfaz de diálogo que creamos antes
onready var cuadro_dialogo = $CuadroDialogo
onready var bandeja = $BandejaPasteles

var pasteles_tomados: int = 0
var dialogo_mama_dicho: bool = false

func _ready():
	# Comentamos o borramos esta línea para que no se duplique:
	# bandeja.connect("input_event", self, "_on_BandejaPasteles_input_event")
	
	yield(get_tree().create_timer(1.0), "timeout")
	mostrar_instruccion_mama()

func mostrar_instruccion_mama():
	# Ubica el cuadro en las coordenadas asignadas para la Mamá
	cuadro_dialogo.fijar_posicion_fija(pos_dialogo_mama)
	
	cuadro_dialogo.mostrar_texto(
		"Mamá", 
		"Atl, cuídame los pastelillos. Tengo que salir un momento. Están contados, ¿eh? No los toques."
	)
	dialogo_mama_dicho = true

func _on_BandejaPasteles_input_event(viewport, event, shape_idx):
	# Detectar si el jugador hizo clic izquierdo sobre la bandeja
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if dialogo_mama_dicho and pasteles_tomados == 0:
			lanzar_tentacion_atl()

func lanzar_tentacion_atl():
	# Mueve el cuadro a las coordenadas asignadas para Atl
	cuadro_dialogo.fijar_posicion_fija(pos_dialogo_atl)
	
	# Inicia el monólogo interno de Atl
	cuadro_dialogo.mostrar_dilema(
		"Atl",
		"Huelen tan rico a canela... Hay un montón, ni se va a notar si falta uno. ¿Qué hago?",
		"Tomar un pastelillo",
		"Dejar la bandeja intacta"
	)
	
	# Escuchar la decisión de Atl
	if not cuadro_dialogo.is_connected("decision_tomada", self, "_on_decision_pastel"):
		cuadro_dialogo.connect("decision_tomada", self, "_on_decision_pastel")

func _on_decision_pastel(tomo_pastel: bool):
	if tomo_pastel:
		pasteles_tomados += 1
		cuadro_dialogo.mostrar_texto("Atl", "El pastelillo está dulce y tibio... Total, no pasa nada.")
		
		# Esperar 2 segundos y activar la confrontación y huida
		yield(get_tree().create_timer(2.5), "timeout")
		iniciar_confrontacion_y_huida()
	else:
		cuadro_dialogo.mostrar_texto("Atl", "Mejor le hago caso a mi mamá...")

func iniciar_confrontacion_y_huida():
	# Regresa el cuadro a la posición de la Mamá para el reclamo final
	cuadro_dialogo.fijar_posicion_fija(pos_dialogo_mama)
	
	cuadro_dialogo.mostrar_texto("Mamá", "¡Atl! Faltan pastelillos... Y mira esa puerta llena de migajas. ¡Atl!")
	yield(get_tree().create_timer(3.0), "timeout")
	
	# Cambiar a la escena del bosque lluvioso
	get_tree().change_scene("res://escenas/Escena02_BosqueYTemplo.tscn")
