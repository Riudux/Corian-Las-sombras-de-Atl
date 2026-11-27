extends Node
var posicion_entrada = "a"

# Progreso narrativo local del MVP. No depende del backend.
var conchas_disponibles: int = 5
var conchas_comidas: int = 0
var comio_concha: bool = false
var madre_llamo: bool = false
var escape_desbloqueado: bool = false
var dialogo_cocina_visto: bool = false
var dialogo_reclamo_visto: bool = false
var tentacion_concha_vista: bool = false
var tiene_fragmento_templo: bool = false
var fragmento_incrustado: bool = false

# Contadores de fragmentos (los recuperados vs. los ya puestos en el altar)
var fragmentos_obtenidos: int = 0
var fragmentos_colocados: int = 0

# Progreso de la Aldea (Corian) y Minijuegos
var hablo_con_tepache: bool = false
var minijuego_1_ganado: bool = false
var minijuego_2_ganado: bool = false
var minijuego_3_ganado: bool = false

# Para que perdiste.tscn sepa exactamente qué minijuego recargar
var ultimo_minijuego: String = ""

# Nodos del HUD global
var hud_layer: CanvasLayer
var fondo_contador: ColorRect
var label_fragmentos: Label


func _ready():
	# Capa superior para que se vea encima de cualquier escena o minijuego
	hud_layer = CanvasLayer.new()
	hud_layer.layer = 100
	add_child(hud_layer)

	# Fondo semitransparente en la esquina superior derecha (pantalla 1024x600)
	fondo_contador = ColorRect.new()
	fondo_contador.rect_position = Vector2(760, 18)
	fondo_contador.rect_size = Vector2(240, 36)
	fondo_contador.color = Color(0, 0, 0, 0.45)
	hud_layer.add_child(fondo_contador)

	label_fragmentos = Label.new()
	label_fragmentos.rect_position = Vector2(760, 18)
	label_fragmentos.rect_size = Vector2(240, 36)
	label_fragmentos.align = Label.ALIGN_CENTER
	label_fragmentos.valign = Label.VALIGN_CENTER
	label_fragmentos.add_color_override("font_color", Color(1, 1, 1))
	hud_layer.add_child(label_fragmentos)


func _process(_delta):
	# Mantiene sincronizado el conteo en cuanto ganas cualquier minijuego
	var ganados = int(minijuego_1_ganado) + int(minijuego_2_ganado) + int(minijuego_3_ganado)
	if ganados > fragmentos_obtenidos:
		fragmentos_obtenidos = ganados

	# Oculta el contador únicamente en el menú de inicio
	var ocultar = false
	if get_tree().current_scene:
		var nombre_escena = get_tree().current_scene.name.to_lower()
		if "menu" in nombre_escena:
			ocultar = true

	fondo_contador.visible = not ocultar
	label_fragmentos.visible = not ocultar
	label_fragmentos.text = "Fragmentos: %d / 3" % fragmentos_obtenidos


func reiniciar_partida():
	posicion_entrada = "a"
	conchas_disponibles = 5
	conchas_comidas = 0
	comio_concha = false
	madre_llamo = false
	escape_desbloqueado = false
	dialogo_cocina_visto = false
	dialogo_reclamo_visto = false
	tentacion_concha_vista = false
	tiene_fragmento_templo = false
	fragmento_incrustado = false
	fragmentos_obtenidos = 0
	fragmentos_colocados = 0
	hablo_con_tepache = false
	minijuego_1_ganado = false
	minijuego_2_ganado = false
	minijuego_3_ganado = false
	ultimo_minijuego = ""
