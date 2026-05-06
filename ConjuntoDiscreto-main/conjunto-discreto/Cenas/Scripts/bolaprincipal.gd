extends CharacterBody2D

@export var speed: float = 300.0

const UNIVERSO = ["estrela", "quadrado", "triangulo"]

var meu_conjunto: Array = ["estrela", "quadrado"]  # Começa com alguns elementos
var poder_ativo: String = "uniao"

@onready var sprite_estrela   = $Formas/Estrela
@onready var sprite_quadrado  = $Formas/Quadrado
@onready var sprite_triangulo = $Formas/Triangulo

# Referência para a UI (pega pelo caminho no mapa)
@onready var ui = $"../Control"

func _ready() -> void:
	atualizar_visual()
	# Conecta o sinal da UI para trocar o poder
	if ui:
		ui.mudou_poder.connect(_on_mudou_poder)

func _on_mudou_poder(novo_poder: String) -> void:
	poder_ativo = novo_poder
	print("Poder ativo: ", poder_ativo)

func _physics_process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var distance = global_position.distance_to(mouse_pos)

	if distance > 5.0:
		var direction = global_position.direction_to(mouse_pos)
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

# --- CHAMADO PELO outro_conjunto QUANDO HÁ COLISÃO ---
func interacao(outro_conjunto: Array) -> void:
	# Primeiro verifica com a UI se o poder escolhido é o da missão
	var acertou = false
	if ui:
		acertou = await ui.verificar_resposta(poder_ativo)

	# Só aplica a operação se acertou (ou se não tiver UI)
	if acertou or not ui:
		aplicar_operacao(outro_conjunto)

func aplicar_operacao(outro_conjunto: Array) -> void:
	match poder_ativo:
		"uniao":
			for forma in outro_conjunto:
				if not meu_conjunto.has(forma):
					meu_conjunto.append(forma)

		"interseccao":
			var lista = []
			for forma in meu_conjunto:
				if outro_conjunto.has(forma):
					lista.append(forma)
			meu_conjunto = lista

		"diferenca":
			var novo = []
			for elemento in meu_conjunto:
				if not outro_conjunto.has(elemento):
					novo.append(elemento)
			meu_conjunto = novo

		"complemento":
			var novo = []
			for elemento in UNIVERSO:
				if not meu_conjunto.has(elemento):
					novo.append(elemento)
			meu_conjunto = novo

		"subconjunto":
			# Verifica se meu_conjunto é subconjunto de outro_conjunto
			# (não muda o conjunto, só mostra o resultado visual)
			var e_subconjunto = true
			for elemento in meu_conjunto:
				if not outro_conjunto.has(elemento):
					e_subconjunto = false
					break
			print("É subconjunto? ", e_subconjunto)

	print("Meu conjunto atual: ", meu_conjunto)
	atualizar_visual()

func atualizar_visual() -> void:
	sprite_estrela.visible   = meu_conjunto.has("estrela")
	sprite_quadrado.visible  = meu_conjunto.has("quadrado")
	sprite_triangulo.visible = meu_conjunto.has("triangulo")
