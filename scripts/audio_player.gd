extends AudioStreamPlayer
const PLAYING_SOUND: String = "res://sounds/Breezy's Mega Quest - 6 Stage 5.wav"
const ADVISING_SOUND: String = "res://sounds/The Forest.mp3"
enum {STOPPED, PLAYING, ADVISING, GAME_OVER}
var curr_state: int

func _ready():
	self.curr_state = STOPPED

func _on_GameController_state_changed(last_state: int, new_state:int):
	self.curr_state = new_state
	if ((last_state==self.STOPPED or last_state==self.ADVISING or
	last_state==self.GAME_OVER) and new_state==self.PLAYING):
		self.stream = load(self.PLAYING_SOUND)
		self.play()
	elif last_state==self.PLAYING and new_state==self.ADVISING:
		self.stream = load(self.ADVISING_SOUND)
		self.play()
	elif (last_state==self.PLAYING and
	 (new_state==self.STOPPED or new_state==self.GAME_OVER)):
		self.stop()

func _on_AudioStreamPlayer_finished() -> void:
	if self.curr_state==self.PLAYING or self.curr_state==self.ADVISING:
		self.play()
