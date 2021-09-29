extends Control
const _FILE_PATH: String = "res://files/game_info.cfg"
const _SECTION: String = "info"
const TIME_FORMAT: String = "%d: %d: %d"
var _labels: Array
var _config_file: ConfigFile
var game_info_table: GridContainer

func _ready():
	self._config_file = ConfigFile.new()
	self.game_info_table = $MarginContainer/GameInfoTable

func _on_ScoresButton_button_down() -> void:
# warning-ignore:return_value_discarded
	self._config_file.load(self._FILE_PATH)
	self.show_game_info()
	self.show()

func show_game_info() -> void:
	var game_info: Array = self._config_file.get_value(self._SECTION, "game_info")
	for i in range(game_info.size()):
		for column in self.game_info_table.get_children():
			var element: Label = column.get_children()[i+1]
			match(column.name):
				"Scores":
					element.text=String(game_info[i]["score"])
				"Times":
					element.text=self.TIME_FORMAT%[
					game_info[i]["time_played"]["hour"],
					game_info[i]["time_played"]["minute"],
					game_info[i]["time_played"]["second"]]
				"Correct":
					element.text=String(game_info[i]["ok_ans"])
				"Errors":
					element.text=String(game_info[i]["mistakes"])

func _on_ScoreUIBack_button_down() -> void:
	self.hide()
