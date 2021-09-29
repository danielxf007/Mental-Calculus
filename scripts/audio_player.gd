extends AudioStreamPlayer
const PLAYING_SOUND: String = "res://sounds/Breezys Mega Quest - 1b Boss Battle.wav"
const ADVISING_SOUND: String = "res://sounds/The Forest.mp3"
var enabled: bool
var curr_state: int

func _ready():
	self.enabled = false

func _on_AudioStreamPlayer_finished() -> void:
	if self.enabled:
		self.play()

func _on_GameController_game_was_started() -> void:
	self.enabled = true
	self.stream = load(self.PLAYING_SOUND)
	self.play()

func _on_GameController_advice_was_requested() -> void:
	self.stream = load(self.ADVISING_SOUND)
	self.play()

func _on_GameController_advice_was_given():
	self.stream = load(self.PLAYING_SOUND)
	self.play()

func _on_GameController_game_has_ended() -> void:
	self.enabled = false
	self.stop()

func _on_GameController_game_was_restarted() -> void:
	self.enabled = true
	self.play()

func _on_GameController_game_was_uninitialized():
	self.enabled = false
	self.stop()
