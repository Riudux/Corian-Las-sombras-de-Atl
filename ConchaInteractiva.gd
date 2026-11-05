extends Area2D

signal solicitada(concha)

var consumida: bool = false

func _ready():
	input_pickable = true
	connect("input_event", self, "_on_input_event")
	# Las escenas se recargan al cambiar de habitación; conserva las conchas ya comidas.
	var numero = name.substr(6).to_int()
	if numero > 0 and numero <= variables.conchas_comidas:
		consumida = true
		visible = false
		monitoring = false

func _on_input_event(_viewport, event, _shape_idx):
	if consumida:
		return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("solicitada", self)

func consumir():
	if consumida:
		return
	consumida = true
	visible = false
	monitoring = false
