extends Area2D
signal collided(box)
signal got_out_screen()
class_name Box
const _BOXES_ANIM: Array = ["box_0", "box_1", "box_2"]
const _BOUNDS: Vector2 = Vector2(0, 768)
var _init_pos: Vector2
var _speed: float
var _move_dir: Vector2
var _opt_value: int

func activate(value: bool) -> void:
	self.set_physics_process(value)
	$CollisionShape2D.set_deferred("disabled", not value)
	self.visible = value

func stop_movement(value: bool) -> void:
	self.set_physics_process(not value)

func set_opt_value(value: int) -> void:
	self._opt_value = value
 
func set_speed(new_speed: float) -> void:
	self._speed = new_speed

func init(init_pos: Vector2, speed: float, anim_addr: int) -> void:
	self._init_pos = init_pos
	self._speed = speed
	$AnimatedSprite.animation = self._BOXES_ANIM[anim_addr]
	self._move_dir = Vector2()
	self._opt_value = 0
	self.activate(false)


func start() -> void:
	self._move_dir.y = 1.0
	self.global_position = self._init_pos
	$AnimatedSprite.frame = 0
	self.activate(true)

func _get_velocity(dir: Vector2, speed: float, delta: float) -> Vector2:
	return dir*speed*delta

func _is_out_of_bounds(pos: Vector2, bounds: Vector2) -> bool:
	return pos.y >= bounds.y

func _physics_process(delta):
	self.global_position+=self._get_velocity(self._move_dir, self._speed, delta)
	if self._is_out_of_bounds(self.global_position, self._BOUNDS):
		self.stop_movement(true)
		self.emit_signal("got_out_screen")


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.frame = 2
	$AnimatedSprite.playing = false
	self.stop_movement(false)


func _on_Box_area_entered(_area) -> void:
	self.emit_signal("collided", self)

func play_anim() -> void:
	$AnimatedSprite.play()
