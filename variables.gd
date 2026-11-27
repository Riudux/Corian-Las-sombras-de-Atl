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
var fragmentos_obtenidos: int = 0
# Progreso de la Aldea (Corian) y Minijuegos
var hablo_con_tepache: bool = false
var minijuego_1_ganado: bool = false
var minijuego_2_ganado: bool = false # Para quitar al mapache del lago y dejar entrar a Atl
var minijuego_3_ganado: bool = false

# Para que perdiste.tscn sepa exactamente qué minijuego recargar
var ultimo_minijuego: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
