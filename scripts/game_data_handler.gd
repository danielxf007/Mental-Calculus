extends Node
signal level_changed(lvl)
signal lives_changed(lives)
signal score_changed(score)
signal speed_calculated(speed)
class_name GameDataHandler
const _MAX_LVL: int = 6
const _SCORE_INCREMENT: int = 5
const _FILE_PATH: String = "res://files/game_info.cfg"
const _SECTION: String = "info"
export var _MAX_N_OK_ANS: int
export var _N_LIVES: int
export var _LVL: int
export var _SCORE: int
var _n_ok_ans: int
var start_time: Dictionary
var end_time: Dictionary
var total_ok_ans: int
var total_mistakes: int
var game_info: Dictionary
var _config_file: ConfigFile

func _ready():
	self.game_info={"score": 0, "time_played": {}, "ok_ans": 0, "mistakes": 0}
	self._config_file = ConfigFile.new()
# warning-ignore:return_value_discarded
	self._config_file.load(self._FILE_PATH)

func increment_lives() -> void:
	self._N_LIVES+=1
	self.emit_signal("lives_changed", self._N_LIVES)

func decrease_lives() -> void:
	self._N_LIVES-=1
	self.emit_signal("lives_changed", self._N_LIVES)
 
func set_lives(lives: int) -> void:
	self._N_LIVES = lives
	self.emit_signal("lives_changed", lives)

func increment_score() -> void:
	self._SCORE+=self._SCORE_INCREMENT
	self.emit_signal("score_changed", self._SCORE)

func set_score(new_score: int) -> void:
	self._SCORE = new_score
	self.emit_signal("score_changed", new_score)

func set_lvl(lvl: int) -> void:
	self._LVL = lvl
	self.emit_signal("level_changed", lvl)

func increment_lvl() -> void:
	if not self._LVL==self._MAX_LVL:
		self._LVL+=1
		self.emit_signal("level_changed", self._LVL)

func _increment_max_n_ok_ans() -> void:
	self._MAX_N_OK_ANS+=1

func _calculate_speed(num: int) -> float:
	return num*50.0 + 150.0

func start() -> void:
	self.set_lvl(1)
	self.set_lives(2)
	self.set_score(0)
	self._n_ok_ans = 0
	self._MAX_N_OK_ANS = 5
	self.total_ok_ans=0
	self.total_mistakes=0
	self.emit_signal("speed_calculated", self._calculate_speed(self._LVL))

func _on_Problem_got_answered(grade: int) -> void:
	if grade:
		self.total_ok_ans+=1
		self.increment_score()
		self._n_ok_ans+=1
		if self._n_ok_ans == self._MAX_N_OK_ANS:
			self.increment_lives()
			self.increment_lvl()
			self._increment_max_n_ok_ans()
			self._n_ok_ans = 0
			self.emit_signal("speed_calculated", self._calculate_speed(self._LVL))
	else:
		self.total_mistakes+=1
		self.decrease_lives()


func _on_GameController_game_was_started() -> void:
	self.start_time=OS.get_time()
	self.start()


func _on_GameController_game_was_restarted() -> void:
	self.start_time=OS.get_time()
	self.start()


func _on_GameController_game_has_ended() -> void:
	self.end_time=OS.get_time()
	self.calculate_time_player(self.start_time, self.end_time)
	self.game_info["score"]=self._SCORE
	self.game_info["ok_ans"]=self.total_ok_ans
	self.game_info["mistakes"]=self.total_mistakes
	self.save_game_info(self.game_info)

func calculate_time_player(t0:Dictionary, t1:Dictionary) -> void:
	var hours: int
	var minutes: int
	var seconds: int
	var carry: int=0
	if t0["second"]>t1["second"]:
		seconds=(t1["second"]+60)-t0["second"]
		carry=-1
	else:
		seconds=t1["second"]-t0["second"]
	if t0["minute"]>t1["minute"]:
		minutes=(t1["minute"]+60+carry)-t0["minute"]
		carry=-1
	else:
		minutes=(t1["minute"]+carry)-t0["minute"]
		carry=0
	if t0["hour"]>t1["hour"]:
		hours=(t1["hour"]+60+carry)-t0["hour"]
		carry=-1
	else:
		hours=(t1["hour"]+carry)-t0["hour"]
		carry=0
	self.game_info["time_played"]={"hour": hours, "minute": minutes, "second": seconds}

func better_time(t0: Dictionary, t1: Dictionary) -> bool:
	var better: bool=false
	if t0["hour"]<t1["hour"]:
		better=true
	elif t0["minute"]<t1["minute"]:
		better=true
	elif t0["second"]<t1["second"]:
		better=true
	return better

func save_game_info(info: Dictionary) -> void:
	var inform: Array = self._config_file.get_value(self._SECTION, "game_info")
	var j: int
	for i in range(inform.size()):
		if inform[i]["score"]<info["score"]:
			j=inform.size()-2
			while j>i+1:
				inform[j+1]=inform[j]
				j-=1
			inform[i]=info
			self._config_file.set_value(self._SECTION, "game_info", inform)
# warning-ignore:return_value_discarded
			self._config_file.save(self._FILE_PATH)
			break
