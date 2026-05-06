extends Control

signal mudou_poder(novo_poder: String)

# --- NÓS DA UI ---
# O Label já existe na sua cena (filho do CanvasLayer > Control > Label)
# Renomeie ele para "LabelMissao" ou ajuste o caminho abaixo
@onready var label_missao = $CanvasLayer/Control/LabelMissao
@onready var label_pontos = $CanvasLayer/Control/LabelPontos

# --- SISTEMA DE MISSÕES ---
const OPERACOES = ["uniao", "interseccao", "diferenca", "complemento", "subconjunto"]
const NOMES_BONITOS = {
	"uniao":       "A ∪ B  (União)",
	"interseccao": "A ∩ B  (Interseção)",
	"diferenca":   "A − B  (Diferença)",
	"complemento": "Aᶜ    (Complemento de A)",
	"subconjunto": "A ⊆ B  (Subconjunto)"
}

var missao_atual: String = ""
var missoes_completas: int = 0
var total_missoes: int = 5
var pode_interagir: bool = true

func _ready() -> void:
	gerar_nova_missao()

func gerar_nova_missao() -> void:
	missao_atual = OPERACOES.pick_random()
	label_missao.text = "Missão: Faça " + NOMES_BONITOS[missao_atual]
	pode_interagir = true

# Chamado pelo bolaprincipal quando encosta no outro conjunto
func verificar_resposta(poder_escolhido: String) -> bool:
	if not pode_interagir:
		return false

	if poder_escolhido == missao_atual:
		missoes_completas += 1
		label_missao.text = "✅ Correto! (%d/%d)" % [missoes_completas, total_missoes]
		pode_interagir = false
		await get_tree().create_timer(1.5).timeout
		if missoes_completas >= total_missoes:
			get_tree().change_scene_to_file("res://Cenas/fim_de_jogo.tscn")
		else:
			gerar_nova_missao()
		return true
	else:
		label_missao.text = "❌ Errado! Tente: " + NOMES_BONITOS[missao_atual]
		await get_tree().create_timer(1.5).timeout
		label_missao.text = "Missão: Faça " + NOMES_BONITOS[missao_atual]
		return false

# --- BOTÕES EXISTENTES (nomes das funções devem bater com o sinal no Godot) ---
func _on_button_uniao_pressed() -> void:
	mudou_poder.emit("uniao")

func _on_button_interseccao_pressed() -> void:
	mudou_poder.emit("interseccao")

func _on_button_diferenca_pressed() -> void:
	mudou_poder.emit("diferenca")

# --- BOTÕES NOVOS (crie na cena e conecte os sinais) ---
func _on_button_complemento_pressed() -> void:
	mudou_poder.emit("complemento")

func _on_button_subconjunto_pressed() -> void:
	mudou_poder.emit("subconjunto")
