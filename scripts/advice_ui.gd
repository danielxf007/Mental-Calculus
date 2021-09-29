extends Control
class_name AdviceUI
const _SECTION: String = "descriptions"
const _DESCRIP_FILE_PATH: String = "res://files/descriptions.cfg"
const _ADVICE_ENDED: int = 2
var _description_file: ConfigFile

func _ready():
	self._description_file = ConfigFile.new()
# warning-ignore:return_value_discarded
	self._description_file.load(self._DESCRIP_FILE_PATH)

func _on_Back_button_down():
	self.hide()

func _on_AdviceGenerator_got_advice(advice: Dictionary) -> void:
	$Title.text = advice["title"]
	$Description.text = self._description_file.get_value(self._SECTION,
	advice["desciption_key"])
	$TextureRect.texture = load(advice["image_path"])
	self.show()

func _on_BackToGame_button_down() -> void:
	self.hide()

func _on_GameController_advice_was_requested() -> void:
	self.show()
