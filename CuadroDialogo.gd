extends CanvasLayer

signal decision_tomada(es_honesto)

# Referencias a nodos
onready var panel_fondo = $PanelFondo
onready var nombre_label = $PanelFondo/Contenido/NombrePersonaje
onready var texto_label = $PanelFondo/Contenido/TextoDialogo
onready var contenedor_opciones = $PanelFondo/Contenido/ContenedorOpciones
onready var btn_a = $PanelFondo/Contenido/ContenedorOpciones/BtnOpcionA
onready var btn_b = $PanelFondo/Contenido/ContenedorOpciones/BtnOpcionB

onready var tween_texto = $TweenTexto
onready var audio_voz = $AudioVoz

# Configuración de ancho
export var ancho_maximo: float = 450.0
export var ancho_minimo: float = 80.0
export var padding_horizontal: float = 5.0

export var velocidad_letra: float = 0.035
export var desfase: Vector2 = Vector2(-60, -120)

# Variación de tono para la voz
export var pitch_minimo: float = 0.85
export var pitch_maximo: float = 1.15

var objetivo_seguir: Node2D = null
var mensaje_completo: String = ""
var ultima_letra_procesada: int = 0

func _ready():
	randomize()
	panel_fondo.visible = false
	panel_fondo.rect_min_size.x = ancho_minimo
	
	if contenedor_opciones:
		contenedor_opciones.visible = false
	if btn_a and not btn_a.is_connected("pressed", self, "_on_btn_a_pressed"):
		btn_a.connect("pressed", self, "_on_btn_a_pressed")
	if btn_b and not btn_b.is_connected("pressed", self, "_on_btn_b_pressed"):
		btn_b.connect("pressed", self, "_on_btn_b_pressed")
		
	if tween_texto and not tween_texto.is_connected("tween_all_completed", self, "_on_texto_completado"):
		tween_texto.connect("tween_all_completed", self, "_on_texto_completado")

func _process(_delta):
	if objetivo_seguir and is_instance_valid(objetivo_seguir):
		var pos_pantalla = objetivo_seguir.get_global_transform_with_canvas().origin
		panel_fondo.rect_position = pos_pantalla + desfase

	if tween_texto.is_active():
		_ajustar_ancho_panel()

func _ajustar_ancho_panel():
	var total_letras = mensaje_completo.length()
	if total_letras == 0:
		return

	var letras_visibles = int(texto_label.percent_visible * total_letras)
	
	# Reproduce el sonido por cada letra nueva que va apareciendo
	if letras_visibles > ultima_letra_procesada:
		for i in range(ultima_letra_procesada, letras_visibles):
			var caracter = mensaje_completo[i]
			_reproducir_sonido_letra(caracter)
		ultima_letra_procesada = letras_visibles

	var texto_parcial = mensaje_completo.substr(0, letras_visibles)
	
	# Asignamos solo el fragmento visible al Label para que no fuerce altura de texto invisible
	texto_label.text = texto_parcial
	
	var fuente = texto_label.get_font("")
	var ancho_texto = fuente.get_string_size(texto_parcial).x
	var ancho_nombre = fuente.get_string_size(nombre_label.text).x
	
	var ancho_calculado = max(ancho_texto, ancho_nombre) + padding_horizontal
	var ancho_final = clamp(ancho_calculado, ancho_minimo, ancho_maximo)
	
	panel_fondo.rect_min_size.x = ancho_final
	panel_fondo.rect_size = Vector2(ancho_final, 0)

func _reproducir_sonido_letra(caracter: String):
	# Evitar reproducir sonidos en espacios y saltos de línea
	if caracter == " " or caracter == "\n" or caracter == "\t":
		return
		
	if audio_voz and audio_voz.stream:
		audio_voz.pitch_scale = rand_range(pitch_minimo, pitch_maximo)
		audio_voz.play()

func hablar_sobre(nodo_personaje: Node2D, nombre: String, mensaje: String):
	objetivo_seguir = nodo_personaje
	mostrar_texto(nombre, mensaje)

func mostrar_texto(nombre: String, mensaje: String):
	panel_fondo.visible = true
	if contenedor_opciones:
		contenedor_opciones.visible = false
	
	nombre_label.text = nombre
	_iniciar_efecto_teletipo(mensaje)

func mostrar_dilema(nombre: String, pregunta: String, opcion_a: String, opcion_b: String):
	panel_fondo.visible = true
	nombre_label.text = nombre
	btn_a.text = opcion_a
	btn_b.text = opcion_b
	
	_iniciar_efecto_teletipo(pregunta)
	yield(tween_texto, "tween_all_completed")
	
	contenedor_opciones.visible = true

func _iniciar_efecto_teletipo(mensaje: String):
	tween_texto.stop_all()
	mensaje_completo = mensaje
	texto_label.text = ""
	texto_label.percent_visible = 0.0
	ultima_letra_procesada = 0
	
	panel_fondo.rect_min_size.x = ancho_minimo
	panel_fondo.rect_size = Vector2(ancho_minimo, 0)
	
	var duracion_total = mensaje.length() * velocidad_letra
	
	tween_texto.interpolate_property(
		texto_label, 
		"percent_visible", 
		0.0, 1.0, 
		duracion_total, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
	)
		
	tween_texto.start()

func _on_texto_completado():
	texto_label.text = mensaje_completo
	texto_label.percent_visible = 1.0
	if audio_voz:
		audio_voz.stop()

func fijar_posicion_fija(posicion: Vector2):
	objetivo_seguir = null
	panel_fondo.rect_position = posicion

func _on_btn_a_pressed():
	contenedor_opciones.visible = false
	emit_signal("decision_tomada", true)

func _on_btn_b_pressed():
	contenedor_opciones.visible = false
	emit_signal("decision_tomada", false)
