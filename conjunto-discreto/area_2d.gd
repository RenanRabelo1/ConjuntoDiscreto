extends Area2D


const UNIVERSO = ["estrela", "quadrado", "triangulo"]
var conteudo_do_conjunto: Array = []

@onready var sprite_estrela = $Formas/Estrela
@onready var sprite_quadrado = $Formas/Quadrado
@onready var sprite_triangulo = $Formas/Triangulo


func _ready() -> void:
	gerar_conjunto_aleatorio()
	atualizar_visual()

func gerar_conjunto_aleatorio() -> void:
	conteudo_do_conjunto.clear()
	
	for elemento in UNIVERSO:
		if randf() > 0.5:
			conteudo_do_conjunto.append(elemento)
			
	if conteudo_do_conjunto.is_empty():
		conteudo_do_conjunto.append(UNIVERSO.pick_random())

func atualizar_visual() -> void:
	
	sprite_estrela.visible = conteudo_do_conjunto.has("estrela")
	sprite_quadrado.visible = conteudo_do_conjunto.has("quadrado")
	sprite_triangulo.visible = conteudo_do_conjunto.has("triangulo")
