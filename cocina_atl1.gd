extends Node2D

const DIALOGO_NO_SALIR = preload("res://dialogues/no_salir.tres")
const DIALOGO_MAMA_CONCHAS = preload("res://dialogues/mama_conchas.tres")
const DIALOGO_TENTACION_CONCHA = preload("res://dialogues/tentacion_concha.tres")
const DIALOGO_DECISION_CONCHA = preload("res://dialogues/decision_concha.tres")
var procesando_evento: bool = false
var procesando_concha: bool = false
var decision_concha_aceptada: bool = false

var conchas_comidas_en_esta_visita: int = 0


func _ready():
	for concha in get_tree().get_nodes_in_group("conchas_cocina"):
		if not concha.is_connected("solicitada", self, "_on_concha_solicitada"):
			concha.connect("solicitada", self, "_on_concha_solicitada")

	if not variables.dialogo_cocina_visto:
		yield(get_tree(), "idle_frame")
		mostrar_dialogo_inicial()

func mostrar_dialogo_inicial():
	var jugador = get_node_or_null("YSort/player_atl")
	if jugador:
		jugador.puedo_moverme = false

	DialogueManager.show_example_dialogue_balloon("start", DIALOGO_MAMA_CONCHAS)
	yield(DialogueManager, "dialogue_finished")

	variables.dialogo_cocina_visto = true
	if jugador and is_instance_valid(jugador):
		jugador.puedo_moverme = true

func _on_concha_solicitada(concha):
	if procesando_concha:
		return
	procesando_concha = true
	var jugador = get_node_or_null("YSort/player_atl")
	if jugador:
		jugador.puedo_moverme = false

	if not variables.tentacion_concha_vista:
		DialogueManager.show_example_dialogue_balloon("start", DIALOGO_TENTACION_CONCHA)
		yield(DialogueManager, "dialogue_finished")
		variables.tentacion_concha_vista = true

	decision_concha_aceptada = false
	if not DialogueManager.is_connected("response_selected", self, "_on_decision_concha_actioned"):
		DialogueManager.connect("response_selected", self, "_on_decision_concha_actioned")
	DialogueManager.show_example_dialogue_balloon("start", DIALOGO_DECISION_CONCHA)
	yield(DialogueManager, "dialogue_finished")
	if DialogueManager.is_connected("response_selected", self, "_on_decision_concha_actioned"):
		DialogueManager.disconnect("response_selected", self, "_on_decision_concha_actioned")

	if decision_concha_aceptada:
		_on_concha_comida(concha)

	if jugador and is_instance_valid(jugador):
		jugador.puedo_moverme = true
	procesando_concha = false

func _on_decision_concha_actioned(next_id):
	decision_concha_aceptada = str(next_id).begins_with("5")

func _on_concha_comida(concha):
	concha.consumir()
	conchas_comidas_en_esta_visita += 1
	variables.conchas_comidas += 1
	variables.conchas_disponibles = max(0, variables.conchas_disponibles - 1)
	variables.comio_concha = true

	# La madre debe reaccionar cuando Atl vuelva a la habitación.
	if variables.conchas_disponibles == 0:
		variables.madre_llamo = false


func _on_Area2D_body_entered(body):
	if body.name == "player_atl":
		variables.posicion_entrada = "abajo1"
		get_tree().change_scene("res://sala_atl1.tscn")


func _on_salida_body_entered(body):
	if body.name == "player_atl" and not procesando_evento:
		procesando_evento = true
		
		# 1. Bloquear el control manual del jugador
		if "puedo_moverme" in body:
			body.puedo_moverme = false

		# 2. Obtener el nodo real del globo de diálogo esperando "completed"
		DialogueManager.show_example_dialogue_balloon("start", DIALOGO_NO_SALIR)
		yield(DialogueManager, "dialogue_finished")

		# 4. Reactivar el control del jugador
		if "puedo_moverme" in body:
			body.puedo_moverme = true


func _on_salida_body_exited(body):
	if body.name == "player_atl":
		# Se reactiva la posibilidad de hablar solo al salir físicamente del área
		procesando_evento = false
