extends Button
signal got_input(input)
enum {STOPPED, PLAYING, ADVISING, GAME_OVER}
const _NEEDED_ADVICE: int = 1
var _max_n_problems: int
var _problem_counter: int

func _ready():
	self._start()

func _start() -> void:
	self._max_n_problems = 0
	self._problem_counter = 0
	self.disabled = false

func _on_GameController_state_changed(last_state: int, new_state: int) -> void:
	if (new_state == self.PLAYING and 
	(last_state == self.GAME_OVER or last_state == self.STOPPED)):
		self._start()

func _on_ProblemGenerator_problem_generated(_problem) -> void:
	if self._problem_counter < self._max_n_problems:
		self._problem_counter += 1
	else:
		self.disabled = false

func _on_AdviceButton_button_down() -> void:
	self._problem_counter = 0
	self._max_n_problems += 2
	self.disabled = true
	self.emit_signal("got_input", self._NEEDED_ADVICE)
