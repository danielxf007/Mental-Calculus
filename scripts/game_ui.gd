extends Control
class_name GameUI
const PROBLEM_FORMAT: String = "%d %s %d"
export(Array) var OPT_LS_PATHS: Array 
export(NodePath) var PROB_CONT_L_PATH: NodePath
export(NodePath) var SCORE_L_PATH: NodePath
export(NodePath) var LIVES_L_PATH: NodePath
const _OPERATORS: Array = [" + ", " - ", " * ", " quot ", " mod "]
const _EXPR_END: String = " = ?"
var _prob_content_l: Label
var _opt_ls: Array
var _advice_l: Label
var _lives_l: Label
var _score_l: Label

func _ready():
	self._prob_content_l = self.get_node(self.PROB_CONT_L_PATH)
	self._opt_ls = []
	for path in self.OPT_LS_PATHS:
		self._opt_ls.append(self.get_node(path))
	self._score_l = self.get_node(self.SCORE_L_PATH)
	self._lives_l = self.get_node(self.LIVES_L_PATH)

func _set_prob_content_l_text(op_code: int, a: int, b: int) -> void:
	self._prob_content_l.text = self.PROBLEM_FORMAT%[a, _OPERATORS[op_code],b]

func _set_opt_ls_text(problem_opts: Array) -> void:
	for i in range(self._opt_ls.size()):
		self._opt_ls[i].text = String(problem_opts[i])

func _on_GameDataHandler_lives_changed(lives: int) -> void:
	self._lives_l.text = String(lives)


func _on_GameDataHandler_score_changed(score: int) -> void:
	self._score_l.text = String(score)


func _on_ProblemGenerator_problem_generated(problem: Dictionary) -> void:
	self._set_prob_content_l_text(problem["op_code"], problem["a"], problem["b"])
	self._set_opt_ls_text(problem["opts"])


func _on_BackToOperators_button_down() -> void:
	self.hide()


func _on_GameController_game_was_started() -> void:
	$PlayAgain.hide()
	$BackToOperators.hide()
	$MarginContainer.show()
	$Joystick.show()
	self.show()


func _on_GameController_advice_was_requested() -> void:
	self.hide()


func _on_GameController_advice_was_given() -> void:
	$Joystick.show()
	self.show()

func _on_GameController_game_has_ended() -> void:
	$PlayAgain.show()
	$BackToOperators.show()
	$Joystick.hide()
	$MarginContainer.hide()


func _on_GameController_game_was_restarted() -> void:
	$PlayAgain.hide()
	$BackToOperators.hide()
	$MarginContainer.show()
	$Joystick.show()


func _on_GameController_game_was_uninitialized() -> void:
	self.hide()
