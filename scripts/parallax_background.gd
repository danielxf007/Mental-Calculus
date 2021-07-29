extends ParallaxBackground
const PLAYING: int = 1
export var _N_ROWS: int
export var _M_COLS: int
export var _INIT_POS: Vector2
export var _CELL_DIM: Vector2
export var _TEXTURE: Texture
export var _CAMERA_VEL: Vector2 = Vector2(0, 150)
var _parallax_layer: ParallaxLayer

func _ready():
	self._parallax_layer = $ParallaxLayer
	self._game_started(false)
	var sprite: Sprite
	var curr_pos: Vector2 = self._INIT_POS
	for _i in range(self._N_ROWS):
		curr_pos.x = self._INIT_POS.x
		for _j in range(self._M_COLS):
			sprite = Sprite.new()
			sprite.texture = self._TEXTURE
			self._parallax_layer.add_child(sprite)
			sprite.global_position = curr_pos
			curr_pos.x += self._CELL_DIM.x
		curr_pos.y += self._CELL_DIM.y
 
func _physics_process(delta: float) -> void:
	var new_offset: Vector2 = get_scroll_offset() + self._CAMERA_VEL*delta
	set_scroll_offset( new_offset )

func _game_started(value: bool) -> void:
	self._parallax_layer.visible = value
	self.set_physics_process(value)

func _on_GameDataHandler_speed_calculated(speed: float) -> void:
	self._CAMERA_VEL.y = speed


func _on_GameController_state_changed(_last_state: int, new_state: int) -> void:
	if new_state == self.PLAYING:
		self._game_started(true)
	else:
		self._game_started(false)
