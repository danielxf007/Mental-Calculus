extends Node
signal got_answered(grade)
signal gone_inactive()
class_name Problem
enum {STOPPED, PLAYING, ADVISING, GAME_OVER}
export var _BOX_SCENE: PackedScene
export var _INIT_POS: Vector2
export var _SPEED: float
export var _N_BOXES: int
export var _BOX_DIM: Vector2
var _box_arr: Array
var _n_active_boxes: int
var _answer: int
var _answered: bool
var _collided_box: Box

func _ready():
	self._answered = false
	self._box_arr = []
	self._n_active_boxes = 0
	var box
	var init_pos: Vector2 = self._INIT_POS
	for i in range(self._N_BOXES):
		box = self._BOX_SCENE.instance()
		box.init(init_pos, self._SPEED, i)
		self._box_arr.append(box)
		self.add_child(box)
		box.connect("got_out_screen", self, "_on_Box_got_out_screen")
		box.connect("collided", self, "_on_Box_collided")
		init_pos.x +=  self._BOX_DIM.x

func _activate(value: bool) -> void:
	for box in self._box_arr:
		box.activate(value)

func set_speed(speed: float) -> void:
	for box in self._box_arr:
		box.set_speed(speed)

func start() -> void:
	self._n_active_boxes = self._N_BOXES
	self._answered = false
	for box in self._box_arr:
		box.start()

func _on_Box_collided(box: Box) -> void:
	var grade: int
	self._collided_box = box
	if not self._answered:
		box.stop_movement(true)
		grade = box._opt_value == self._answer
		if grade:
			box.play_anim()
		self.emit_signal("got_answered", grade)
		self._answered = true

func _on_Box_got_out_screen() -> void:
	self._n_active_boxes -= 1
	if not self._n_active_boxes:
		self.emit_signal("gone_inactive")

func _on_ProblemGenerator_problem_generated(problem: Dictionary) -> void:
	for i in range(self._N_BOXES):
		self._box_arr[i].set_opt_value(problem["opts"][i])
	self._answer = problem["ans"]
	self.start()

func _on_Player_hit_finished() -> void:
	self._collided_box.stop_movement(false)

func _on_GameController_state_changed(last_state: int, new_state: int):
	if last_state == self.PLAYING:
		self._activate(false)
	elif last_state == self.STOPPED or last_state == self.GAME_OVER:
		self.emit_signal("gone_inactive")
		if new_state == self.PLAYING:
			self.start()
	elif last_state == self.ADVISING:
		self._activate(new_state == self.PLAYING)


func _on_GameDataHandler_speed_calculated(speed: int) -> void:
	self.set_speed(speed)
