extends CharacterBody2D
class_name BolinhaPrincipal

# Memória estática que vai receber o caminho lá da tela de opções
static var textura_selecionada_caminho: String = ""

# --- VARIÁVEIS E NÓS ---
@export var speed: float = 300.0
const UNIVERSO = ["estrela", "quadrado", "triangulo"]
const SIMBOLOS = {"estrela": "★", "quadrado": "■", "triangulo": "▲"}

var meu_conjunto: Array = []
var poder_ativo: String = "uniao"
var pode_mover: bool = true

# --- VARIÁVEIS DO CRONÔMETRO ---
static var tempo_final: String = "00:00" 
var tempo_decorrido: float = 0.0
var cronometro_ativo: bool = true

@onready var sprite_circulo = $Circulo
@onready var sprite_estrela = $Formas/Estrela
@onready var sprite_quadrado = $Formas/Quadrado
@onready var sprite_triangulo = $Formas/Triangulo
@onready var ui = $Camera2D/Control

func _ready() -> void:
	resetar_conjunto()
	atualizar_visual()
	if ui:
		ui.mudou_poder.connect(_on_mudou_poder)
		ui.nova_missao.connect(resetar_conjunto)
		print("✅ Bolinha conectada à UI")
	
	# --- APLICAÇÃO DA IMAGEM ---
	# Assim que a bola nasce, verifica se o jogador escolheu uma imagem
	if sprite_circulo and textura_selecionada_caminho != "":
		var nova_textura = load(textura_selecionada_caminho)
		if nova_textura:
			sprite_circulo.texture = nova_textura
			print("✅ Textura aplicada com sucesso!")

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
	elif event.is_action_pressed("parar"):
		pode_mover = not pode_mover

func resetar_conjunto() -> void:
	meu_conjunto.clear()
	meu_conjunto.append(UNIVERSO.pick_random())
	
	# 🐛 ANTI-BUG: Evita que a bolinha nasça com o mesmo conjunto da missão!
	# Ele olha para a UI e verifica se o que foi sorteado para a bolinha é igual ao alvo.
	if ui and "conjunto_alvo" in ui:
		var alvo = ui.conjunto_alvo
		
		# Enquanto a bolinha for exatamente igual à missão, sorteamos outra forma
		while meu_conjunto.size() == alvo.size() and alvo.has(meu_conjunto[0]):
			meu_conjunto.clear()
			meu_conjunto.append(UNIVERSO.pick_random())
			
	atualizar_visual()

func _on_mudou_poder(novo_poder: String) -> void:
	if poder_ativo == novo_poder:
		poder_ativo = ""
	else:
		poder_ativo = novo_poder
		
	if ui:
		ui.destacar_botao(poder_ativo)

func _physics_process(_delta: float) -> void:
	if cronometro_ativo:
		tempo_decorrido += _delta
		Global.tempo_final = obter_tempo_formatado()
		
		if has_node("Camera2D/LabelTempo"):
			$Camera2D/LabelTempo.text = Global.tempo_final

	if not pode_mover:
		velocity = Vector2.ZERO
		return

	var mouse_pos = get_global_mouse_position()
	var distance = global_position.distance_to(mouse_pos)
	if distance > 5.0:
		velocity = global_position.direction_to(mouse_pos) * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func obter_tempo_formatado() -> String:
	var minutos: int = int(tempo_decorrido) / 60
	var segundos: int = int(tempo_decorrido) % 60
	return "%02d:%02d" % [minutos, segundos]

func interacao(outro_conjunto: Array) -> void:
	if poder_ativo == "":
		return
		
	if ui:
		ui.feedback_operacao(poder_ativo, meu_conjunto, outro_conjunto)
	aplicar_operacao(outro_conjunto)
	atualizar_visual()
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
	if conjunto.is_empty(): return "{ ∅ }"
	var s = []
	for e in conjunto:
		s.append(SIMBOLOS.get(e, e))
	return "{ " + ", ".join(s) + " }"

func atualizar_visual() -> void:
	# Apenas esconde/mostra as formas, não mexe mais em cores
	sprite_estrela.visible = meu_conjunto.has("estrela")
	sprite_quadrado.visible = meu_conjunto.has("quadrado")
	sprite_triangulo.visible = meu_conjunto.has("triangulo")
