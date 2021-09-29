extends Area2D
signal hit_finished()
class_name Player
const _PLAYING: int = 1
const _HIT_ANIM: String = "hit"
const _MOVING_ANIM: String = "moving"
const _WRONG_ANS: int = 0
const _INIT_POS: Vector2 = Vector2(192, 736)
const _SPEED: float = 400.0
const _MIN_LIM: float = 32.0
const _MAX_LIM: float = 352.0
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

func _get_velocity(dir: Vector2, speed: float, delta: float) -> Vector2:
	return dir*speed*delta

func _keep_on_limits(number: float, min_lim: float, max_lim: float) -> float:
	if min_lim > number:
		return min_lim
	elif max_lim < number:
		return max_lim
	return number

func _physics_process(delta):
	self._move_dir = Vector2(
		Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"),
		0
	).clamped(1)
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

func _on_GameController_game_was_started() -> void:
	self._start()

func _on_GameController_advice_was_requested() -> void:
	self._activate(false)

func _on_GameController_advice_was_given() -> void:
	self._activate(true)

func _on_GameController_game_has_ended() -> void:
	self._activate(false)

func _on_GameController_game_was_restarted() -> void:
	self._start()

func _on_GameController_game_was_uninitialized() -> void:
	self._activate(false)
