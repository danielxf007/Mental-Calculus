extends Node
signal game_was_uninitialized()
signal game_was_started()
signal game_has_ended()
signal game_was_restarted()
signal advice_was_requested()
signal advice_was_given()

class_name GameController

var start_time:Dictionary
var end_time:Dictionary

func _on_PlayAgain_button_down() -> void:
	self.emit_signal("game_was_restarted")

func _on_BackToOperators_button_down() -> void:
	self.emit_signal("game_was_uninitialized")

func _on_AdviceButton_button_down() -> void:
	self.emit_signal("advice_was_requested")

func _on_BackToGame_button_down() -> void:
	self.emit_signal("advice_was_given")

func _on_GameDataHandler_lives_changed(lives: int) -> void:
	if not lives:
		self.end_time=OS.get_time()
		self.emit_signal("game_has_ended")

func _on_OperatorsUI_start_pressed() -> void:
	self.start_time=OS.get_time()
	self.emit_signal("game_was_started")
