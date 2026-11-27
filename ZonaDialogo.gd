extends Area2D

export(Array, Resource) var lista_dialogos = []
export(String) var titulo_seccion = "start"
export(String) var nombre_jugador = "player_atl"
export(bool) var requerir_escape = false
export(String, FILE, "*.tscn") var escena_siguiente = ""
export(bool) var repetir_ultimo = true 

# Opciones nuevas para la burbuja
export(bool) var mostrar_burbuja = true
export(String) var texto_burbuja = "Interactúa"
export(Vector2) var posicion_burbuja = Vector2(-35, -50)

var procesando_evento: bool = false
var burbuja_visual = null

func _ready():
	input_pickable = true # Necesario para detectar el mouse en Area2D
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
	configurar_burbuja()


func configurar_burbuja():
	# Si le pusiste un Sprite o nodo llamado "Burbuja" como hijo, usa ese
	if has_node("Burbuja"):
		burbuja_visual = get_node("Burbuja")
		burbuja_visual.visible = false
	elif mostrar_burbuja:
		# Si no, crea un Label automático para que funcione ya en todas tus escenas
		var label = Label.new()
		label.text = texto_burbuja
		label.rect_position = posicion_burbuja
		label.visible = false
		add_child(label)
		burbuja_visual = label


func _on_mouse_entered():
	print("¡EL MOUSE ENTRÓ A: ", name, "!")
	if not mostrar_burbuja or burbuja_visual == null:
		return
	if not mostrar_burbuja or burbuja_visual == null:
		return
	if procesando_evento or DialogueManager.is_dialogue_running:
		return
	if requerir_escape and not variables.escape_desbloqueado:
		return
		
	burbuja_visual.visible = true


func _on_mouse_exited():
	if burbuja_visual != null:
		burbuja_visual.visible = false


func _on_body_entered(body):
	if body.name == nombre_jugador and not procesando_evento:
		if requerir_escape and not variables.escape_desbloqueado:
			return
		if lista_dialogos.size() == 0:
			print("Advertencia: No hay diálogos asignados en la lista para ", name)
			return
			
		procesando_evento = true
		
		# Oculta la burbuja en cuanto empieza el diálogo
		if burbuja_visual != null:
			burbuja_visual.visible = false
		
		# 1. Usar get_path() como identificador único global para evitar conflictos entre escenas
		var id_unico = str(get_path())
		var indice_actual = 0
		if ProgresoJuego.indices_dialogos.has(id_unico):
			indice_actual = ProgresoJuego.indices_dialogos[id_unico]
		
		# Asegurar que el índice no se salga de los límites
		if indice_actual >= lista_dialogos.size():
			indice_actual = lista_dialogos.size() - 1

		var dialogo_actual = lista_dialogos[indice_actual]
		if dialogo_actual == null:
			procesando_evento = false
			return

		# 2. Bloquea el movimiento del jugador
		if "puedo_moverme" in body:
			body.puedo_moverme = false

		# 3. Inicia el diálogo y obtiene la instancia real del globo
		DialogueManager.show_example_dialogue_balloon(titulo_seccion, dialogo_actual)
		yield(DialogueManager, "dialogue_finished")

		# 5. Guardar el siguiente índice en el Autoload usando la ruta única
		if indice_actual < lista_dialogos.size() - 1:
			ProgresoJuego.indices_dialogos[id_unico] = indice_actual + 1

		# 6. Devuelve el control al jugador al finalizar
		if "puedo_moverme" in body:
			body.puedo_moverme = true

		if escena_siguiente != "":
			get_tree().change_scene(escena_siguiente)


func _on_body_exited(body):
	if body.name == nombre_jugador:
		# Se reactiva la interacción al salir físicamente del área
		procesando_evento = false
