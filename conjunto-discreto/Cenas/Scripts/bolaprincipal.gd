extends CharacterBody2D
# Damos um nome para a classe para que outros scripts consigam ler a memória dela
class_name BolinhaPrincipal

# --- VARIÁVEIS E NÓS ---
@export var speed: float = 300.0
const UNIVERSO = ["estrela", "quadrado", "triangulo"]
const SIMBOLOS  = {"estrela": "★", "quadrado": "■", "triangulo": "▲"}

var meu_conjunto: Array = []
var poder_ativo: String = "uniao"
var pode_mover: bool = true

# --- VARIÁVEIS DO CRONÔMETRO ---
static var tempo_final: String = "00:00" # Memória global que a tela final vai ler
var tempo_decorrido: float = 0.0
var cronometro_ativo: bool = true

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
	atualizar_visual()

func _on_mudou_poder(novo_poder: String) -> void:
	# Se apertou o botão que já está ativo, desativa tudo
	if poder_ativo == novo_poder:
		poder_ativo = ""
	# Se for um botão diferente, ativa o novo poder
	else:
		poder_ativo = novo_poder
		
	if ui:
		ui.destacar_botao(poder_ativo)

func _physics_process(_delta: float) -> void:
	# --- CONTADOR DO CRONÔMETRO ---
	if cronometro_ativo:
		tempo_decorrido += _delta
		# Salva o tempo atual diretamente no Global
		Global.tempo_final = obter_tempo_formatado()
		
		if has_node("Camera2D/LabelTempo"):
			$Camera2D/LabelTempo.text = Global.tempo_final

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
# Transforma segundos puros em texto no formato "00:00"
func obter_tempo_formatado() -> String:
	var minutos: int = int(tempo_decorrido) / 60
	var segundos: int = int(tempo_decorrido) % 60
	return "%02d:%02d" % [minutos, segundos]

func interacao(outro_conjunto: Array) -> void:
	# Trava de segurança: se não tem poder ativo, bate e não faz nada
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
	sprite_estrela.visible   = meu_conjunto.has("estrela")
	sprite_quadrado.visible  = meu_conjunto.has("quadrado")
	sprite_triangulo.visible = meu_conjunto.has("triangulo")
