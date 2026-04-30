extends Control

signal mudou_poder(novo_poder: String)

func _on_botao_uniao_pressed():
	mudou_poder.emit("uniao")
	
func _on_botao_intersecao_pressed():
	mudou_poder.emit("interseccao")
	
func _on_botao_diferenca_pressed():
	mudou_poder.emit("diferenca")

func _on_botao_complemento_pressed():
	mudou_poder.emit("complemento")
# Repita para os outros...


func _on_button_uniao_pressed() -> void:
	mudou_poder.emit("uniao")




func _on_button_interseccao_pressed() -> void:
	mudou_poder.emit("interseccao")


func _on_button_diferenca_pressed() -> void:
	mudou_poder.emit("diferenca")
