extends Control

class_name MainUI



func _on_PlayButton_button_down() -> void:
	self.hide()


func _on_ExitButton_button_down() -> void:
	self.get_tree().quit(0)


func _on_BackMain_button_down() -> void:
	self.show()


func _on_ScoresButton_button_down() -> void:
	self.hide()


func _on_Back_button_down() -> void:
	self.show()
