extends Control
const _SCORES_FILE_PATH: String = "res://files/player_score.cfg"
const _SECTION: String = "scores"
var _labels: Array
var _scores_file: ConfigFile

func _ready():
	self._scores_file = ConfigFile.new()
	self._labels = [$Label, $Label2, $Label3]
# warning-ignore:return_value_discarded
	self._scores_file.load(self._SCORES_FILE_PATH)

func _on_Back_button_down() -> void:
	self.hide()


func _on_ScoresButton_button_down() -> void:
	var scores: Array = self._scores_file.get_value(self._SECTION, "max_scores")
	for i in range(scores.size()):
		self._labels[i].text = String(scores[i]);
	self.show()


func _on_GameDataHandler_got_end_score(score: int) -> void:
	var scores: Array = self._scores_file.get_value(self._SECTION, "max_scores")
	for i in range(scores.size()):
		if scores[i]<score:
			for j in range(i+1, scores.size()):
				scores[j] = scores[j-1]
			scores[i] = score
			self._scores_file.set_value(self._SECTION, "max_scores", scores)
# warning-ignore:return_value_discarded
			self._scores_file.save(self._SCORES_FILE_PATH)
			break
