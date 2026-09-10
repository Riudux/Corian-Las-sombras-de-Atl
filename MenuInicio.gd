extends Control

# Rutas a las escenas principales (se pueden asignar desde el Inspector)
export(String, FILE, "*.tscn") var escena_juego = "res://escenas/IntroduccionHistoria.tscn"
export(String, FILE, "*.tscn") var escena_creditos = "res://escenas/Creditos.tscn"

# Referencias a nodos mediante onready
onready var btn_jugar = $CanvasLayer/ContenedorPrincipal/ContenidoCenter/BotonesContenedor/BtnJugar
onready var btn_instrucciones = $CanvasLayer/ContenedorPrincipal/ContenidoCenter/BotonesContenedor/BtnInstrucciones
onready var btn_creditos = $CanvasLayer/ContenedorPrincipal/ContenidoCenter/BotonesContenedor/BtnCreditos
onready var btn_salir = $CanvasLayer/ContenedorPrincipal/ContenidoCenter/BotonesContenedor/BtnSalir

onready var musica_fondo = $MusicaFondo
onready var panel_instrucciones = $CanvasLayer/PanelInstrucciones # Si agregas un panel flotante

func _ready():
	# 1. Configuración responsive de pantalla completa
	anchor_right = 1.0
	anchor_bottom = 1.0
	
	# 2. Detectar si estamos en navegador Web (HTML5/WebGL)
	# Ocultamos el botón "Salir" porque en Web no existe cerrar la app
	if OS.get_name() == "HTML5" or OS.has_feature("JavaScript"):
		btn_salir.visible = false
	
	# 3. Conectar señales de los botones por código
	btn_jugar.connect("pressed", self, "_on_BtnJugar_pressed")
	btn_instrucciones.connect("pressed", self, "_on_BtnInstrucciones_pressed")
	btn_creditos.connect("pressed", self, "_on_BtnCreditos_pressed")
	btn_salir.connect("pressed", self, "_on_BtnSalir_pressed")
	
	# 4. Intentar reproducir música
	reproducir_musica()

func _input(event):
	# Si el jugador da un clic en cualquier parte, activamos el audio si el navegador lo bloqueó
	if event is InputEventMouseButton and event.pressed:
		reproducir_musica()

func reproducir_musica():
	if musica_fondo and not musica_fondo.playing:
		musica_fondo.play()

# --- FUNCIONES DE LOS BOTONES ---

func _on_BtnJugar_pressed():
	# Transición a la primera escena del juego (o la intro de Atl)
	if escena_juego != "":
		get_tree().change_scene(escena_juego)
	else:
		print("ADVERTENCIA: Asigna la escena del juego en el Inspector")

func _on_BtnInstrucciones_pressed():
	# Aquí abriremos una ventana emergente o cambiaremos de escena
	print("Mostrar panel de instrucciones")

func _on_BtnCreditos_pressed():
	if escena_creditos != "":
		get_tree().change_scene(escena_creditos)

func _on_BtnSalir_pressed():
	# Solo funcionará si lo ejecutan en PC/Escritorio
	get_tree().quit()
