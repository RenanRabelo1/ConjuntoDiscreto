extends Control

signal mudou_poder(novo_poder: String)
signal nova_missao  # Avisa a bolinha para resetar

@onready var label_missao = $CanvasLayer/Control/LabelMissao
@onready var label_pontos = $CanvasLayer/Control/LabelPontos

const UNIVERSO = ["estrela", "quadrado", "triangulo"]
const SIMBOLOS  = {"estrela": "★", "quadrado": "■", "triangulo": "▲"}
const NOMES_BONITOS = {
	"uniao":       "União  (A ∪ B)",
	"interseccao": "Interseção  (A ∩ B)",
	"diferenca":   "Diferença  (A − B)",
	"complemento": "Complemento  (Aᶜ)",
	"subconjunto": "Subconjunto  (A ⊆ B)"
}

var conjunto_alvo: Array = []
var missoes_completas: int = 0
var total_missoes:    int = 5
var pode_interagir:   bool = true

func _ready() -> void:
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
			btn.pressed.connect(func(): mudou_poder.emit(poder))
			print("✅ ", nome)
		else:
			print("❌ ", nome)

	gerar_nova_missao()
	atualizar_label_pontos()

func conjunto_para_texto(c: Array) -> String:
	if c.is_empty(): return "{ ∅ }"
	var s = []
	for e in c:
		s.append(SIMBOLOS.get(e, e))
	return "{ " + ", ".join(s) + " }"

func gerar_nova_missao() -> void:
	conjunto_alvo.clear()
	for e in UNIVERSO:
		if randf() > 0.5:
			conjunto_alvo.append(e)
	if conjunto_alvo.is_empty():
		conjunto_alvo.append(UNIVERSO.pick_random())

	label_missao.text = "🎯 Objetivo: " + conjunto_para_texto(conjunto_alvo)
	label_missao.add_theme_color_override("font_color", Color.CYAN)
	pode_interagir = true

	# Avisa a bolinha para resetar o conjunto dela
	nova_missao.emit()

func atualizar_label_pontos() -> void:
	label_pontos.text = "Missões: %d / %d" % [missoes_completas, total_missoes]

func feedback_operacao(operacao: String, conj_a: Array, conj_b: Array) -> void:
	if not pode_interagir:
		return
	label_missao.text = "⚗️ %s\nA=%s  +  B=%s" % [
		NOMES_BONITOS[operacao],
		conjunto_para_texto(conj_a),
		conjunto_para_texto(conj_b)
	]
	label_missao.add_theme_color_override("font_color", Color.YELLOW)

func verificar_igualdade(meu_conjunto: Array) -> void:
	if not pode_interagir:
		return

	var iguais = meu_conjunto.size() == conjunto_alvo.size()
	if iguais:
		for e in meu_conjunto:
			if not conjunto_alvo.has(e):
				iguais = false
				break

	if iguais:
		missoes_completas += 1
		label_missao.text = "✅ Missão completa! (%d/%d)" % [missoes_completas, total_missoes]
		label_missao.add_theme_color_override("font_color", Color.GREEN)
		atualizar_label_pontos()
		pode_interagir = false
		await get_tree().create_timer(2.0).timeout
		if missoes_completas >= total_missoes:
			get_tree().change_scene_to_file("res://Cenas/fim_de_jogo.tscn")
		else:
			gerar_nova_missao()
	else:
		label_missao.text = "🔎 Seu conjunto: %s\n🎯 Objetivo: %s" % [
			conjunto_para_texto(meu_conjunto),
			conjunto_para_texto(conjunto_alvo)
		]
		label_missao.add_theme_color_override("font_color", Color.ORANGE)
		await get_tree().create_timer(2.0).timeout
		if pode_interagir:
			label_missao.text = "🎯 Objetivo: " + conjunto_para_texto(conjunto_alvo)
			label_missao.add_theme_color_override("font_color", Color.CYAN)
