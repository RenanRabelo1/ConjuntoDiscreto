extends CharacterBody2D

# --- VARIÁVEIS E NÓS ---
@export var speed: float = 300.0
const UNIVERSO = ["estrela", "quadrado", "triangulo"]
const SIMBOLOS  = {"estrela": "★", "quadrado": "■", "triangulo": "▲"}

var meu_conjunto: Array = []
var poder_ativo: String = "uniao"

# Controla se a bolinha pode se mover ou está pausada para pensar
var pode_mover: bool = true

@onready var sprite_estrela   = $Formas/Estrela
@onready var sprite_quadrado  = $Formas/Quadrado
@onready var sprite_triangulo = $Formas/Triangulo
@onready var ui = $Camera2D/Control

func _ready() -> void:
	resetar_conjunto()
	atualizar_visual()
	if ui:
		ui.mudou_poder.connect(_on_mudou_poder)
		ui.nova_missao.connect(resetar_conjunto)
		print("✅ Bolinha conectada à UI")
	else:
		print("❌ UI não encontrada")

# --- DETECÇÃO DO TECLADO (INPUT MAP) ---
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("uniao"):
		_on_mudou_poder("uniao")
	elif event.is_action_pressed("interseccao"):
		_on_mudou_poder("interseccao")
	elif event.is_action_pressed("diferenca"):
		_on_mudou_poder("diferenca")
	elif event.is_action_pressed("complemento"):
		_on_mudou_poder("complemento")
	elif event.is_action_pressed("subconjunto"):
		_on_mudou_poder("subconjunto")
	
	# --- BOTÃO ÚNICO DE ALTERNAR PAUSA (ESPAÇO) ---
	elif event.is_action_pressed("parar"):
		pode_mover = not pode_mover # Inverte o estado (true vira false, false vira true)
		
		if pode_mover:
			print("🟢 Movimento liberado. Seguindo o mouse...")
		else:
			print("🛑 Movimento pausado. Hora de pensar!")

func resetar_conjunto() -> void:
	meu_conjunto.clear()
	meu_conjunto.append(UNIVERSO.pick_random())
	atualizar_visual()
	print("🔄 Bolinha resetada: ", conjunto_para_texto(meu_conjunto))

# Botão clicado ou Tecla pressionada → muda a operação selecionada
func _on_mudou_poder(novo_poder: String) -> void:
	poder_ativo = novo_poder
	print("🔵 Operação selecionada: ", poder_ativo)
	# Avisa a UI para destacar o botão ativo
	if ui:
		ui.destacar_botao(poder_ativo)

func _physics_process(_delta: float) -> void:
	# Se estiver pausado, zera a velocidade e ignora o resto do movimento
	if not pode_mover:
		velocity = Vector2.ZERO
		return

	var mouse_pos = get_global_mouse_position()
	var distance  = global_position.distance_to(mouse_pos)
	if distance > 5.0:
		velocity = global_position.direction_to(mouse_pos) * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

# Chamado pelo outro_conjunto ao colidir → aplica operação selecionada
func interacao(outro_conjunto: Array) -> void:
	print("=== COLISÃO ===")
	print("A = ", conjunto_para_texto(meu_conjunto))
	print("B = ", conjunto_para_texto(outro_conjunto))
	print("Operação: ", poder_ativo)

	if ui:
		ui.feedback_operacao(poder_ativo, meu_conjunto, outro_conjunto)

	aplicar_operacao(outro_conjunto)
	atualizar_visual()

	print("Resultado: ", conjunto_para_texto(meu_conjunto))
	print("===============")

	await get_tree().create_timer(0.9).timeout
	if ui:
		ui.verificar_igualdade(meu_conjunto)

func aplicar_operacao(outro: Array) -> void:
	match poder_ativo:
		"uniao":
			for forma in outro:
				if not meu_conjunto.has(forma):
					meu_conjunto.append(forma)

		"interseccao":
			var lista = []
			for forma in meu_conjunto:
				if outro.has(forma):
					lista.append(forma)
			meu_conjunto = lista

		"diferenca":
			var novo = []
			for e in meu_conjunto:
				if not outro.has(e):
					novo.append(e)
			meu_conjunto = novo

		"complemento":
			var novo = []
			for e in UNIVERSO:
				if not meu_conjunto.has(e):
					novo.append(e)
			meu_conjunto = novo

		"subconjunto":
			var ok = true
			for e in meu_conjunto:
				if not outro.has(e):
					ok = false
					break
			if ui:
				ui.feedback_subconjunto(meu_conjunto, outro, ok)

func conjunto_para_texto(conjunto: Array) -> String:
	if conjunto.is_empty():
		return "{ ∅ }"
	var s = []
	for e in conjunto:
		s.append(SIMBOLOS.get(e, e))
	return "{ " + ", ".join(s) + " }"

func atualizar_visual() -> void:
	sprite_estrela.visible   = meu_conjunto.has("estrela")
	sprite_quadrado.visible  = meu_conjunto.has("quadrado")
	sprite_triangulo.visible = meu_conjunto.has("triangulo") 
