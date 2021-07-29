extends Node
signal state_changed(last_state, new_state)
class_name GameController
enum {STOPPED, PLAYING, ADVISING, GAME_OVER}
enum {PLAYED, NEEDED_ADVICE, ADVICE_ENDED, ZERO_LIVES, PLAY_AGAIN, BACK}
var _curr_state: int

func _ready():
	self._curr_state = self.STOPPED

func _set_state(new_state: int) -> void:
	if new_state != self._curr_state:
		self.emit_signal("state_changed", self._curr_state, new_state)
		self._curr_state = new_state


func _next_state(input: int, curr_state: int) -> int:
	var state: int
	if curr_state == self.STOPPED and input == self.PLAYED:
		state = self.PLAYING
	elif curr_state == self.PLAYING:
		if input == self.NEEDED_ADVICE:
			state = self.ADVISING
		elif input == self.ZERO_LIVES:
			state = self.GAME_OVER
	elif curr_state == self.ADVISING and input == self.ADVICE_ENDED:
		state = self.PLAYING
	elif curr_state == self.GAME_OVER:
		if input == self.PLAY_AGAIN:
			state = self.PLAYING
		elif input == self.BACK:
			state = self.STOPPED
	return state

func get_input(input: int) -> void:
	self._set_state(self._next_state(input, self._curr_state))

func _on_AudioStreamPlayer_finished() -> void:
	if self._lives:
		$AudioStreamPlayer.play()
