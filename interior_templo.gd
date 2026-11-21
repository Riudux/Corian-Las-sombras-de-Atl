extends Node2D

const DIALOGO_FRAGMENTO = preload("res://dialogues/fragmento_templo.tres")
const DIALOGO_CENTRO = preload("res://dialogues/insertar_fragmento.tres")
const DIALOGO_SALIDA_BLOQUEADA = preload("res://dialogues/salida_templo_bloqueada.tres")

var fragmento_recogido: bool = false
var procesando_fragmento: bool = false
var procesando_centro: bool = false
var procesando_salida: bool = false
onready var salida_bloqueada = $SalidaBloqueada/CollisionShape2D
onready var fragmento = $FragmentoTemplo
onready var centro = $CentroTemplo
onready var fondo = $InteriorTemplo


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if variables.fragmento_incrustado:
		salida_bloqueada.disabled = true
		fragmento.visible = false
	else:
		salida_bloqueada.disabled = false

	$salida_interior_templo.connect("body_entered", self, "_on_salida_body_entered")
	$FragmentoTemplo.connect("input_event", self, "_on_fragmento_input_event")
	$CentroTemplo.connect("input_event", self, "_on_centro_input_event")

func _on_fragmento_input_event(_viewport, event, _shape_idx):
	if procesando_fragmento or variables.tiene_fragmento_templo or variables.fragmento_incrustado:
		return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		procesando_fragmento = true
		DialogueManager.show_example_dialogue_balloon("start", DIALOGO_FRAGMENTO)
		yield(DialogueManager, "dialogue_finished")
		variables.tiene_fragmento_templo = true
		fragmento_recogido = true
		fragmento.visible = false
		procesando_fragmento = false

func _on_centro_input_event(_viewport, event, _shape_idx):
	if procesando_centro or not variables.tiene_fragmento_templo or variables.fragmento_incrustado:
		return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		procesando_centro = true
		DialogueManager.show_example_dialogue_balloon("start", DIALOGO_CENTRO)
		yield(DialogueManager, "dialogue_finished")
		variables.tiene_fragmento_templo = false
		variables.fragmento_incrustado = true
		fragmento_recogido = false
		salida_bloqueada.disabled = true
		_animar_activacion()
		procesando_centro = false

func _on_salida_body_entered(body):
	if body.name != "player_atl" or procesando_salida:
		return
	if not variables.fragmento_incrustado:
		procesando_salida = true
		DialogueManager.show_example_dialogue_balloon("start", DIALOGO_SALIDA_BLOQUEADA)
		yield(DialogueManager, "dialogue_finished")
		procesando_salida = false
	elif variables.fragmento_incrustado:
		get_tree().change_scene("res://templo_en_ruinas_soleado.tscn")

func _animar_activacion():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(fondo, "modulate", Color(1, 1, 1, 1), Color(1.6, 1.6, 1.35, 1), 0.35, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(fondo, "modulate", Color(1.6, 1.6, 1.35, 1), Color(1, 1, 1, 1), 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.35)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
