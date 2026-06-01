extends Control

const FONT_PATH = "res://Assets/Interface (UI-HUD)/Fontes/Cópia de Fredoka-VariableFont_wdth,wght.ttf"

const PAGINAS = [
	{
		"titulo": "LABORATORIO UNIFOR: SETOR OMEGA",
		"texto": "Bem-vindo ao ConjuntoDiscreto, o simulador avancado de biologia sintetica.\n\nNeste ambiente, pesquisamos o comportamento de organismos cujo codigo genetico e estruturado puramente em logica matematica."
	},
	{
		"titulo": "AMOEBA-SIGMA",
		"texto": "Voce esta no controle da Amoeba-Sigma.\n\nDiferente de outros organismos, sua sobrevivencia depende da estabilizacao de seus elementos geneticos atraves da Teoria dos Conjuntos."
	},
	{
		"titulo": "OBJETIVO DA PESQUISA",
		"texto": "Sua missao e manipular os elementos da Amoeba-Sigma para que seu conjunto atual seja exatamente igual ao Conjunto Alvo definido pelo sistema."
	},
	{
		"titulo": "ESTABILIZACAO",
		"texto": "A fase e concluida quando 'Seu Conjunto' possuir os mesmos elementos que o 'Objetivo'.\n\nNao importa a ordem dos elementos, apenas se o conteudo e identico."
	}
]

var pagina_atual = 0

@onready var label_titulo  = %LabelTitulo
@onready var label_texto   = %LabelTexto
@onready var label_paginas = %LabelPaginas
@onready var btn_anterior  = %BtnAnterior
@onready var btn_proximo   = %BtnProximo
@onready var btn_pular     = %BtnPular

func _ready():
	aplicar_estilo_e_fonte()
	
	btn_proximo.pressed.connect(_on_btn_proximo_pressed)
	btn_anterior.pressed.connect(_on_btn_anterior_pressed)
	btn_pular.pressed.connect(_on_btn_pular_pressed)

	mostrar_pagina(0)

func aplicar_estilo_e_fonte():
	var fonte_personalizada = load(FONT_PATH)
	
	if has_node("FundoColorido"):
		$FundoColorido.color = Color("#0d1b2a") # Fundo azul escuro laboratório
	elif has_node("ColorRect"):
		$ColorRect.color = Color("#0d1b2a")
	
	for label in [label_titulo, label_texto, label_paginas]:
		label.add_theme_font_override("font", fonte_personalizada)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	label_titulo.add_theme_font_size_override("font_size", 32)
	label_texto.add_theme_font_size_override("font_size", 20)
	label_texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func mostrar_pagina(index):
	var p = PAGINAS[index]
	label_titulo.text  = p["titulo"]
	label_texto.text   = p["texto"]
	label_paginas.text = "Pagina: %d / %d" % [index + 1, PAGINAS.size()]
	
	btn_anterior.visible = index > 0
	btn_proximo.text = "Continuar" if index < PAGINAS.size() - 1 else "Iniciar Missao"

func _on_btn_proximo_pressed():
	if pagina_atual < PAGINAS.size() - 1:
		pagina_atual += 1
		mostrar_pagina(pagina_atual)
	else:
		get_tree().change_scene_to_file("res://Cenas/mapa_1.tscn")

func _on_btn_anterior_pressed():
	if pagina_atual > 0:
		pagina_atual -= 1
		mostrar_pagina(pagina_atual)

func _on_btn_pular_pressed():
	get_tree().change_scene_to_file("res://Cenas/mapa_1.tscn")


func _on_botao_pular_tudo_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/mapa_1.tscn")
