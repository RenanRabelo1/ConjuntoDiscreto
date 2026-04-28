extends Area2D

const UNIVERSO = ["estrela", "quadrado", "coracao"]
var conteudo_do_conjunto: Array = []

@onready var sprite_estrela = $Formas/Estrela
@onready var sprite_quadrado = $Formas/Quadrado
@onready var sprite_coracao = $Formas/Coracao


func _ready() -> void:
	gerar_conjunto_aleatorio()
	atualizar_visual()
	
	# MÁGICA DA COLISÃO: Liga o sensor da Area2D via código
	body_entered.connect(_on_body_entered)

func gerar_conjunto_aleatorio() -> void:
	conteudo_do_conjunto.clear()
	
	for elemento in UNIVERSO:
		if randf() > 0.5:
			conteudo_do_conjunto.append(elemento)
			
	if conteudo_do_conjunto.is_empty():
		conteudo_do_conjunto.append(UNIVERSO.pick_random())

# --- FUNÇÃO DO SENSOR DE COLISÃO ---
func _on_body_entered(body: Node2D) -> void:
	# Verifica se quem encostou tem a função de interagir (ou seja, é o Jogador)
	if body.has_method("interacao"):
		body.interacao(conteudo_do_conjunto)

# --- NOVO VISUAL COM SHOW/HIDE ---
func atualizar_visual() -> void:
	if conteudo_do_conjunto.has("estrela"):
		sprite_estrela.show()
	else:
		sprite_estrela.hide()
		
	if conteudo_do_conjunto.has("quadrado"):
		sprite_quadrado.show()
	else:
		sprite_quadrado.hide()
		
	if conteudo_do_conjunto.has("coracao"):
		sprite_coracao.show()
	else:
		sprite_coracao.hide()
