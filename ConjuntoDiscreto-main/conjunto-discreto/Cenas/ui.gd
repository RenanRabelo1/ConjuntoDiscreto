extends Control

signal mudou_poder(novo_poder: String)
signal nova_missao

@onready var label_missao = $CanvasLayer/Control/LabelMissao
@onready var label_pontos = $CanvasLayer/Control/LabelPontos

const UNIVERSO = ["estrela", "quadrado", "triangulo"]
const SIMBOLOS = {"estrela": "★", "quadrado": "■", "triangulo": "▲"}
const NOMES_BONITOS = {
	"uniao":       "União (A ∪ B)",
	"interseccao": "Interseção (A ∩ B)",
	"diferenca":   "Diferença (A − B)",
	"complemento": "Complemento (Aᶜ)",
	"subconjunto": "Subconjunto (A ⊆ B)"
}

var conjunto_alvo: Array = []
var missoes_completas: int = 0
var total_missoes:    int = 5
var pode_interagir:   bool = true

func _ready() -> void:
	# Dicionário de botões: Nome no Scene Tree -> Nome do Poder
	var botoes = {
		"ButtonUniao":       "uniao",
		"ButtonInterseccao": "interseccao",
		"ButtonDiferenca":   "diferenca",
		"ButtonComplemento": "complemento",
		"ButtonSubconjunto": "subconjunto"
	}
	
	for nome in botoes:
		var btn = find_child(nome, true, false)
		if btn:
			var poder = botoes[nome]
			# Conecta o sinal de clique usando uma função anônima (Callable)
			btn.pressed.connect(func(): 
				destacar_botao(poder)
				mudou_poder.emit(poder)
			)
			print("Botão configurado: ", nome)
		else:
			print("Botão não encontrado: ", nome)

	await get_tree().process_frame
	gerar_nova_missao()
	atualizar_label_pontos()

# --- Lógica Visual e UI ---

func destacar_botao(poder_ativo: String) -> void:
	var mapa = {
		"uniao":       "ButtonUniao",
		"interseccao": "ButtonInterseccao",
		"diferenca":   "ButtonDiferenca",
		"complemento": "ButtonComplemento",
		"subconjunto": "ButtonSubconjunto"
	}
	for p in mapa:
		var btn = find_child(mapa[p], true, false)
		if btn:
			if p == poder_ativo:
				btn.modulate = Color(1.5, 1.5, 1.5)  # Brilho para selecionado
			else:
				btn.modulate = Color(1, 1, 1)         # Normal

func conjunto_para_texto(c: Array) -> String:
	if c.is_empty(): return "{ ∅ }"
	var s = []
	for e in c:
		s.append(SIMBOLOS.get(e, e))
	return "{ " + ", ".join(s) + " }"

func atualizar_label_pontos() -> void:
	label_pontos.text = "Missões: %d / %d" % [missoes_completas, total_missoes]

# --- Lógica de Jogo ---

func gerar_nova_missao() -> void:
	conjunto_alvo.clear()
	for e in UNIVERSO:
		if randf() > 0.5:
			conjunto_alvo.append(e)
	
	if conjunto_alvo.is_empty():
		conjunto_alvo.append(UNIVERSO.pick_random())

	label_missao.text = "Objetivo: " + conjunto_para_texto(conjunto_alvo)
	label_missao.add_theme_color_override("font_color", Color.CYAN)
	pode_interagir = true
	nova_missao.emit()

# --- Feedbacks ---

func feedback_operacao(operacao: String, conj_a: Array, conj_b: Array) -> void:
	if not pode_interagir: return
	label_missao.text = "%s\nA=%s  B=%s" % [
		NOMES_BONITOS[operacao],
		conjunto_para_texto(conj_a),
		conjunto_para_texto(conj_b)
	]
	label_missao.add_theme_color_override("font_color", Color.YELLOW)

func feedback_complemento(resultado: Array) -> void:
	if not pode_interagir: return
	label_missao.text = "Complemento aplicado!\nAgora A = %s\nObjetivo: %s" % [
		conjunto_para_texto(resultado),
		conjunto_para_texto(conjunto_alvo)
	]
	label_missao.add_theme_color_override("font_color", Color.YELLOW)

func feedback_subconjunto(conj_a: Array, conj_b: Array, resultado: bool) -> void:
	if not pode_interagir: return
	var simbolo = "⊆" if resultado else "⊄"
	label_missao.text = "A=%s %s B=%s\nObjetivo: %s" % [
		conjunto_para_texto(conj_a),
		simbolo,
		conjunto_para_texto(conj_b),
		conjunto_para_texto(conjunto_alvo)
	]
	label_missao.add_theme_color_override("font_color", Color.YELLOW)
	
	await get_tree().create_timer(2.0).timeout
	if pode_interagir:
		label_missao.text = "Objetivo: " + conjunto_para_texto(conjunto_alvo)
		label_missao.add_theme_color_override("font_color", Color.CYAN)

func verificar_igualdade(meu_conjunto: Array) -> void:
	if not pode_interagir: return

	# Lógica de comparação de arrays (ignorando ordem)
	var iguais = meu_conjunto.size() == conjunto_alvo.size()
	if iguais:
		for e in meu_conjunto:
			if not conjunto_alvo.has(e):
				iguais = false
				break

	if iguais:
		missoes_completas += 1
		label_missao.text = "Missão completa! (%d/%d)" % [missoes_completas, total_missoes]
		label_missao.add_theme_color_override("font_color", Color.GREEN)
		atualizar_label_pontos()
		pode_interagir = false
		
		await get_tree().create_timer(2.0).timeout
		if missoes_completas >= total_missoes:
			# Certifique-se que este caminho de cena existe!
			get_tree().change_scene_to_file("res://Cenas/fim_de_jogo.tscn")
		else:
			gerar_nova_missao()
	else:
		label_missao.text = "Seu conjunto: %s\nObjetivo: %s" % [
			conjunto_para_texto(meu_conjunto),
			conjunto_para_texto(conjunto_alvo)
		]
		label_missao.add_theme_color_override("font_color", Color.ORANGE)
		await get_tree().create_timer(2.0).timeout
		if pode_interagir:
			label_missao.text = "Objetivo: " + conjunto_para_texto(conjunto_alvo)
			label_missao.add_theme_color_override("font_color", Color.CYAN)
