extends Area2D

const UNIVERSO = ["estrela", "quadrado", "triangulo"]
var conteudo_do_conjunto: Array = []

var em_cooldown: bool = false  # Evita disparar colisão várias vezes seguidas

@onready var sprite_estrela   = $Formas/Estrela
@onready var sprite_quadrado  = $Formas/Quadrado
@onready var sprite_triangulo = $Formas/Triangulo

func _ready() -> void:
	gerar_conjunto_aleatorio()
	atualizar_visual()
	body_entered.connect(_on_body_entered)

func gerar_conjunto_aleatorio() -> void:
	conteudo_do_conjunto.clear()
	for elemento in UNIVERSO:
		if randf() > 0.5:
			conteudo_do_conjunto.append(elemento)
	if conteudo_do_conjunto.is_empty():
		conteudo_do_conjunto.append(UNIVERSO.pick_random())

func _on_body_entered(body: Node2D) -> void:
	if em_cooldown:
		return
	if body.has_method("interacao"):
		em_cooldown = true
		body.interacao(conteudo_do_conjunto)
		# Após 2s, permite nova interação e gera novo conjunto
		await get_tree().create_timer(2.0).timeout
		gerar_conjunto_aleatorio()
		atualizar_visual()
		em_cooldown = false

func atualizar_visual() -> void:
	sprite_estrela.visible   = conteudo_do_conjunto.has("estrela")
	sprite_quadrado.visible  = conteudo_do_conjunto.has("quadrado")
	sprite_triangulo.visible = conteudo_do_conjunto.has("triangulo")


func _on_botao_subconjunto_pressed() -> void:
	pass # Replace with function body.
