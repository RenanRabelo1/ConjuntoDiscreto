extends Control

const FONT_PATH = "res://Assets/Interface (UI-HUD)/Fontes/Cópia de Fredoka-VariableFont_wdth,wght.ttf"

const PAGINAS_HELP = [
	{
		"titulo": "INTERFACE DE ANALISE",
		"texto": "No canto inferior, voce encontrara o monitor de conjuntos.\n\n'Seu Conjunto' exibe seus elementos atuais.\n'Objetivo' exibe a combinacao que voce deve alcancar."
	},
	{
		"titulo": "DEFINIÇÃO CONJUNTO",
		"texto": "Um conjunto é uma coleção bem definida de objetos, chamados de elementos ou membros, que compartilham uma característica comum ou são agrupados."
	},
	{
		"titulo": "UNIAO ( A U B )",
		"texto": "A Uniao adiciona todos os elementos do outro organismo ao seu.\n\nE o equivalente a soma de todos os elementos, mas sem repeticoes."
	},
	{
		"titulo": "INTERSECAO ( A n B )",
		"texto": "A Intersecao filtra seu conjunto.\n\nSomente os elementos que voce e o outro organismo possuem em comum permanecerao em seu DNA."
	},
	{
		"titulo": "DIFERENCA ( A - B )",
		"texto": "A Diferenca remove elementos.\n\nTodos os elementos presentes no outro organismo serao subtraidos do seu conjunto atual."
	},
	{
		"titulo": "COMPLEMENTO E SUBCONJUNTO",
		"texto": "COMPLEMENTO (Aᶜ): Inverte seu conjunto, adicionando o que falta do Universo e tirando o que voce tem.\n\nSUBCONJUNTO (A ⊆ B): Verifica se seus elementos estao contidos dentro do outro. Retorna Verdadeiro ou Falso."
	}
]

var pagina_atual = 0

@onready var label_titulo  = %LabelTitulo
@onready var label_texto   = %LabelTexto
@onready var label_paginas = %LabelPaginas
@onready var btn_anterior  = %BtnAnterior
@onready var btn_proximo   = %BtnProximo

func _ready():
	aplicar_estilo_e_fonte()
	
	btn_proximo.pressed.connect(_on_btn_proximo_pressed)
	btn_anterior.pressed.connect(_on_btn_anterior_pressed)

	mostrar_pagina(0)

func aplicar_estilo_e_fonte():
	var fonte_personalizada = load(FONT_PATH)
	
	if has_node("FundoColorido"):
		$FundoColorido.color = Color("192b19ff") # Fundo cinza escuro
	elif has_node("ColorRect"):
		$ColorRect.color = Color("#1b1b1b")
	
	for label in [label_titulo, label_texto, label_paginas]:
		label.add_theme_font_override("font", fonte_personalizada)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	label_titulo.add_theme_font_size_override("font_size", 32)
	label_texto.add_theme_font_size_override("font_size", 20)
	label_texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func mostrar_pagina(index):
	var p = PAGINAS_HELP[index]
	label_titulo.text  = p["titulo"]
	label_texto.text   = p["texto"]
	label_paginas.text = "Instrucao: %d / %d" % [index + 1, PAGINAS_HELP.size()]
	
	btn_anterior.visible = index > 0
	btn_proximo.text = "Entendido" if index < PAGINAS_HELP.size() - 1 else "Voltar ao Menu"

func _on_btn_proximo_pressed():
	if pagina_atual < PAGINAS_HELP.size() - 1:
		pagina_atual += 1
		mostrar_pagina(pagina_atual)
	else:
		# Muda para o nome exato da sua cena inicial
		get_tree().change_scene_to_file("res://Cenas/tela_inicial.tscn")

func _on_btn_anterior_pressed():
	if pagina_atual > 0:
		pagina_atual -= 1
		mostrar_pagina(pagina_atual)
