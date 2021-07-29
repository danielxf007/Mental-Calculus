extends Control
signal got_input(input)
class_name GameUI
enum {PLAY_AGAIN=4, BACK=5}
enum {STOPPED, PLAYING, ADVISING, GAME_OVER}
const _OPERATORS: Array = [" + ", " - ", " * ", " quot ", " mod "]
const _EXPR_END: String = " = ?"
var _prob_content_l: Label
var _opt_ls: Array
var _advice_l: Label
var _lives_l: Label
var _score_l: Label

func _ready():
	self._prob_content_l = $ProblemContentL
	self._opt_ls = [$OptAL, $OptBL, $OptCL]
	self._lives_l = $LivesL
	self._score_l = $ScoreL

func _set_prob_content_l_text(op_code: int, a: int, b: int) -> void:
	self._prob_content_l.text = String(a)+self._OPERATORS[op_code]+String(b)

func _set_opt_ls_text(problem_opts: Array) -> void:
	for i in range(self._opt_ls.size()):
		self._opt_ls[i].text = String(problem_opts[i])

func _game_started() -> void:
	$PlayAgain.visible = false
	$Back.visible = false
	self.show()

func _on_PlayAgain_button_down() -> void:
	$PlayAgain.visible = false
	$Back.visible = false
	self.emit_signal("got_input", self.PLAY_AGAIN)

func _on_Back_button_down() -> void:
	self.hide()
	self.emit_signal("got_input", self.BACK)

func _on_OperatorsUI_start_pressed() -> void:
	self.show()

func _on_GameController_state_changed(last_state: int, new_state: int) -> void:
	if new_state == self.STOPPED:
		self.hide()
	elif new_state == self.PLAYING:
		self._game_started()
	elif new_state == self.ADVISING and last_state == self.PLAYING:
		self.hide()
	elif new_state == self.GAME_OVER and last_state == self.PLAYING:
		self._game_over()

func _game_over() -> void:
	$PlayAgain.visible = true
	$Back.visible = true


func _on_GameDataHandler_lives_changed(lives: int) -> void:
	self._lives_l.text = String(lives)


func _on_GameDataHandler_score_changed(score: int) -> void:
	self._score_l.text = String(score)


func _on_ProblemGenerator_problem_generated(problem: Dictionary) -> void:
	self._set_prob_content_l_text(problem["op_code"], problem["a"], problem["b"])
	self._set_opt_ls_text(problem["opts"])
