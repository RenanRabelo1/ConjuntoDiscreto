extends Control

@onready var btn_verde = $ButtonVerde
@onready var btn_amarelo = $ButtonAmarelo
@onready var btn_vermelho = $ButtonVermelho
@onready var btn_roxo = $ButtonRoxo
@onready var btn_laranja = $ButtonLaranja

func _ready() -> void:
	# Conecta os botões automaticamente
	if btn_verde: btn_verde.pressed.connect(_on_button_verde_pressed)
	if btn_amarelo: btn_amarelo.pressed.connect(_on_button_amarelo_pressed)
	if btn_vermelho: btn_vermelho.pressed.connect(_on_button_vermelho_pressed)
	if btn_roxo: btn_roxo.pressed.connect(_on_button_roxo_pressed)
	if btn_laranja: btn_laranja.pressed.connect(_on_button_laranja_pressed)

# Salva o caminho exato da imagem direto na memória estática da Bolinha
func salvar_textura_na_bola(caminho_imagem: String) -> void:
	BolinhaPrincipal.textura_selecionada_caminho = caminho_imagem
	ir_para_proxima_cena()

# --- SEUS CAMINHOS EXATOS ---
func _on_button_verde_pressed() -> void:
	salvar_textura_na_bola("res://Assets/Símbolos/Círculo (Bolinha)/bolinha_verde_claro-removebg-preview.png")

func _on_button_amarelo_pressed() -> void:
	salvar_textura_na_bola("res://Assets/Símbolos/Círculo (Bolinha)/bolinha_amarela-removebg-preview.png")

func _on_button_vermelho_pressed() -> void:
	salvar_textura_na_bola("res://Assets/Símbolos/Círculo (Bolinha)/bolinha_vermelho_claro-removebg-preview.png")

func _on_button_roxo_pressed() -> void:
	salvar_textura_na_bola("res://Assets/Símbolos/Círculo (Bolinha)/bolinha_roxa-removebg-preview.png")

func _on_button_laranja_pressed() -> void:
	salvar_textura_na_bola("res://Assets/Símbolos/Círculo (Bolinha)/bolinha_laranja-removebg-preview.png")

# --- TRANSIÇÃO PARA O MAPA ---
func ir_para_proxima_cena() -> void:
	get_tree().change_scene_to_file("res://Cenas/mapa_1.tscn")
