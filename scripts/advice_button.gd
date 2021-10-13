extends Button
const _NEEDED_ADVICE: int = 1
var _max_n_problems: int
var _problem_counter: int

func _ready():
	self._start()

func _start() -> void:
	self._max_n_problems = 0
	self._problem_counter = 0
	self.disabled = false

func _on_ProblemGenerator_problem_generated(_problem) -> void:
	if self._problem_counter < self._max_n_problems:
		self._problem_counter += 1
	else:
		self.disabled = false

func _on_AdviceButton_button_down() -> void:
	self._problem_counter = 0
	self._max_n_problems += 2
	self.disabled = true


func _on_GameController_game_was_restarted() -> void:
	self._start()
