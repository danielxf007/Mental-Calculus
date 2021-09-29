extends Control
signal got_operators_arr(arr)
signal start_pressed()
class_name OperatorsUI
const _PLAYED: int = 0
const _CHOOSE_COLOR: String = "#00ff59"
const _OG_COLOR: String = "#ffffff"
var _operators: Array
var _operator_buttons: Array

func _ready():
	self._operators = []
	self._operator_buttons = [$Add, $Sub, $Mult, $Quot, $Mod]
	randomize()

func _on_Add_button_down() -> void:
	if not 0 in self._operators:
		self._operators.append(0)
		$Add.modulate = self._CHOOSE_COLOR
	else:
		self._operators.erase(0)
		$Add.modulate =  self._OG_COLOR

func _on_Sub_button_down() -> void:
	if not 1 in self._operators:
		self._operators.append(1)
		$Sub.modulate = self._CHOOSE_COLOR
	else:
		self._operators.erase(1)
		$Sub.modulate = self._OG_COLOR

func _on_Mult_button_down() -> void:
	if not 2 in self._operators:
		self._operators.append(2)
		$Mult.modulate = self._CHOOSE_COLOR
	else:
		self._operators.erase(2)
		$Mult.modulate = self._OG_COLOR

func _on_Quot_button_down() -> void:
	if not 3 in self._operators:
		self._operators.append(3)
		$Quot.modulate = self._CHOOSE_COLOR
	else:
		self._operators.erase(3)
		$Quot.modulate = self._OG_COLOR

func _on_Mod_button_down() -> void:
	if not 4 in self._operators:
		self._operators.append(4)
		$Mod.modulate = self._CHOOSE_COLOR
	else:
		self._operators.erase(4)
		$Mod.modulate = self._OG_COLOR

func _gen_rdm_operators() -> void:
	var n: int = randi()%self._operator_buttons.size()+1
	var op_code: int
	for _i in range(n):
		op_code = randi()%self._operator_buttons.size()
		while op_code in self._operators:
			op_code = randi()%self._operators.size()
		self._operators.append(op_code)

func _on_Back_button_down() -> void:
	for button in self._operator_buttons:
		button.modulate = self._OG_COLOR
	self.visible = true
	self._operators.clear()

func _on_OperatorsUI_start_pressed() -> void:
	self.hide()

func _on_PlayButton_button_down() -> void:
	self.show()

func _on_BackMain_button_down() -> void:
	self.hide()
	self._operators.clear()


func _on_StartGame_button_down() -> void:
	if not self._operators:
		self._gen_rdm_operators()
	self.emit_signal("got_operators_arr", self._operators)
	yield(get_tree().create_timer(0.5), "timeout")
	self.hide()
	for button in self._operator_buttons:
		button.modulate = self._OG_COLOR
	self.emit_signal("start_pressed")


func _on_OpUIBackMain_button_down() -> void:
	self.hide()
	self._operators.clear()


func _on_GameController_game_was_uninitialized() -> void:
	self._operators.clear()
	self.show()
