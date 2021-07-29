extends Area2D
signal hit_finished()
class_name Player
enum {STOPPED, PLAYING, ADVISING, GAME_OVER}
const _PLAYING: int = 1
const _HIT_ANIM: String = "hit"
const _MOVING_ANIM: String = "moving"
const _WRONG_ANS: int = 0
const _INIT_POS: Vector2 = Vector2(352, 672)
const _SPEED: float = 150.0
const _MIN_LIM: float = 288.0
const _MAX_LIM: float = 416.0
var _move_dir: Vector2

func _ready():
	self._activate(false)

func _start() -> void:
	self._move_dir = Vector2()
	self.global_position = self._INIT_POS
	self._activate(true)

func _activate(value: bool) -> void:
	self.set_physics_process(value)
	self.visible = value
	$AnimatedSprite.playing = value

func _get_move_dir() -> int:
	return (int(Input.is_action_pressed("ui_right"))-
	int(Input.is_action_pressed("ui_left")))

func _get_velocity(dir: Vector2, speed: float, delta: float) -> Vector2:
	return dir*speed*delta

func _keep_on_limits(number: float, min_lim: float, max_lim: float) -> float:
	if min_lim > number:
		return min_lim
	elif max_lim < number:
		return max_lim
	return number

func _physics_process(delta):
	self._move_dir.x = self._get_move_dir()
	self.global_position+=self._get_velocity(self._move_dir, self._SPEED, delta)
	self.global_position.x = self._keep_on_limits(self.global_position.x,
	self._MIN_LIM, self._MAX_LIM)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == self._HIT_ANIM:
		$AnimatedSprite.animation = self._MOVING_ANIM
		self.emit_signal("hit_finished")

func _on_Player_area_entered(_area) -> void:
	self.set_physics_process(false)


func _on_Problem_got_answered(grade: int) -> void:
	if grade == self._WRONG_ANS:
		$AnimatedSprite.animation = self._HIT_ANIM
		$AudioStreamPlayer.play()

func _on_Problem_gone_inactive() -> void:
	self.set_physics_process(true)

func _on_GameController_state_changed(last_state: int, new_state: int) -> void:
	if last_state == self.PLAYING:
		self._activate(false)
	elif new_state==STOPPED:
		self._activate(false)
	elif last_state == self.STOPPED or last_state == self.GAME_OVER:
		self._start()
	elif last_state == self.ADVISING:
		self._activate(new_state == self.PLAYING)

