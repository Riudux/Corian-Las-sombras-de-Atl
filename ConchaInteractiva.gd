extends Area2D

signal solicitada(concha)

export(String) var texto_burbuja = "Comer conchita"
export(Vector2) var posicion_burbuja = Vector2(-40, -40)

var consumida: bool = false
var burbuja_visual = null

func _ready():
	input_pickable = true
	connect("input_event", self, "_on_input_event")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
	configurar_burbuja()
	
	# Las escenas se recargan al cambiar de habitación; conserva las conchas ya comidas.
	var numero = name.substr(6).to_int()
	if numero > 0 and numero <= variables.conchas_comidas:
		consumida = true
		visible = false
		monitoring = false
		input_pickable = false


func configurar_burbuja():
	if has_node("Burbuja"):
		burbuja_visual = get_node("Burbuja")
		burbuja_visual.visible = false
	else:
		var contenedor = Node2D.new()
		contenedor.z_index = 100 # Lo manda por encima de todos los sprites
		contenedor.position = posicion_burbuja
		contenedor.visible = false
		
		var fondo = ColorRect.new()
		fondo.color = Color(0, 0, 0, 0.75) # Fondo negro semitransparente
		fondo.rect_size = Vector2(120, 22)
		fondo.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		var label = Label.new()
		label.text = texto_burbuja
		label.rect_position = Vector2(5, 3)
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		contenedor.add_child(fondo)
		contenedor.add_child(label)
		add_child(contenedor)
		burbuja_visual = contenedor


func _on_mouse_entered():
	if consumida or DialogueManager.is_dialogue_running:
		return
	if burbuja_visual != null:
		burbuja_visual.visible = true


func _on_mouse_exited():
	if burbuja_visual != null:
		burbuja_visual.visible = false


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
	input_pickable = false # Evita que la burbuja aparezca después de comerla
	if burbuja_visual != null:
		burbuja_visual.visible = false
