extends Area2D

export(Array, Resource) var lista_dialogos = []
export(String) var titulo_seccion = "start"
export(String) var nombre_jugador = "player_atl"
export(bool) var repetir_ultimo = true 

var procesando_evento: bool = false

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == nombre_jugador and not procesando_evento:
		if lista_dialogos.size() == 0:
			print("Advertencia: No hay diálogos asignados en la lista para ", name)
			return
			
		procesando_evento = true
		
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
		var balloon = yield(DialogueManager.show_example_dialogue_balloon(titulo_seccion, dialogo_actual), "completed")
		
		# 4. Esperar a que la ventana del diálogo se cierre y destruya por completo
		if is_instance_valid(balloon):
			yield(balloon, "tree_exited")

		# 5. Guardar el siguiente índice en el Autoload usando la ruta única
		if indice_actual < lista_dialogos.size() - 1:
			ProgresoJuego.indices_dialogos[id_unico] = indice_actual + 1

		# 6. Devuelve el control al jugador al finalizar
		if "puedo_moverme" in body:
			body.puedo_moverme = true

func _on_body_exited(body):
	if body.name == nombre_jugador:
		# Se reactiva la interacción al salir físicamente del área
		procesando_evento = false
