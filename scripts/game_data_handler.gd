extends Node
signal level_changed(lvl)
signal lives_changed(lives)
signal score_changed(score)
signal speed_calculated(speed)
signal got_input(input)
signal got_end_score(score)
class_name GameDataHandler
enum {STOPPED, PLAYING, GAME_OVER=3}
enum {CORRECT_ANS=1, SCORE_INCREMENT=5, ZERO_LIVES=3, MAX_LVL=7}
export var _MAX_N_OK_ANS: int
export var _N_LIVES: int
export var _LVL: int
export var _SCORE: int
var _n_ok_ans: int

func set_lives(new_lives: int) -> void:
	self._N_LIVES = new_lives
	self.emit_signal("lives_changed", new_lives)

func set_score(new_score: int) -> void:
	self._SCORE = new_score
	self.emit_signal("score_changed", new_score)

func set_lvl(new_lvl: int) -> void:
	if self._LVL != new_lvl and new_lvl<=self.MAX_LVL:
		self._LVL = new_lvl
		self.emit_signal("level_changed", new_lvl)

func _increase_max_n_ok_ans() -> void:
	self._MAX_N_OK_ANS += 1

func _calculate_speed(num: int) -> float:
	return num*50.0 + 100.0

func start() -> void:
	self.set_lvl(1)
	self.set_lives(2)
	self.set_score(0)
	self._n_ok_ans = 0
	self._MAX_N_OK_ANS = 5
	self.emit_signal("speed_calculated", self._calculate_speed(self._LVL))

func _on_Problem_got_answered(grade: int) -> void:
	if grade == self.CORRECT_ANS:
		self.set_score(self._SCORE+self.SCORE_INCREMENT)
		self._n_ok_ans += 1
		if self._n_ok_ans == self._MAX_N_OK_ANS:
			self.set_lives(self._N_LIVES+1)
			self.set_lvl(self._LVL+1)
			self._increase_max_n_ok_ans()
			self._n_ok_ans = 0
			self.emit_signal("speed_calculated", self._calculate_speed(self._LVL))
	else:
		self.set_lives(self._N_LIVES-1)
		if not self._N_LIVES:
			self.emit_signal("got_input", self.ZERO_LIVES)

func _on_GameController_state_changed(last_state: int, new_state: int) -> void:
	if new_state==self.GAME_OVER:
		self.emit_signal("got_end_score", self._SCORE)
	elif last_state == self.STOPPED or last_state == self.GAME_OVER:
		if new_state == self.PLAYING:
			self.start()
