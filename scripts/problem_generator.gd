extends Node
signal problem_generated(problem)
class_name ProblemGenerator
enum {ADD, SUB, MULT, QUOT, MOD}
const _INIT_FILE_PATH: String = "res://files/init.cfg"
const _SECTION: String = "weights"
const _BASE: int = 10
const _N_OPTS: int = 3
var _difficult_lvl: int
var _d_a_w: Array
var _d_b_w_arr: Array
var _replace_i_dig_w: Array
var _replace_dig_w: Array
var _operators: Array
var _config_file: ConfigFile

func _ready():
	self._difficult_lvl = 1
	self._config_file = ConfigFile.new()
# warning-ignore:return_value_discarded
	self._config_file.load(self._INIT_FILE_PATH)
	self._d_a_w = self._config_file.get_value(self._SECTION, "_d_a_w")
	self._d_b_w_arr = self._config_file.get_value(self._SECTION, "_d_b_w_arr")
	self._replace_i_dig_w = self._config_file.get_value(self._SECTION, "_replace_i_dig_w")
	self._replace_dig_w = self._config_file.get_value(self._SECTION, "_replace_dig_w")
	randomize()

func _gen_rdm_digit(weights: Array) -> int:
	var digit: int
	var n: int = randi()%100 +1
	for i in range(weights.size()):
		if n <= weights[i]:
			digit = i
			break
	return digit

func _get_result(op_code: int, a: int, b: int) -> int:
	var result: int
	if op_code == self.ADD:
		result = a+b
	elif op_code == self.SUB:
		result = a-b
	elif op_code == self.MULT:
		result = a*b
	elif op_code == self.QUOT:
		result = a/b
	elif op_code == self.MOD:
		result = a%b
	return result

func _get_operand_a(base: int, n_digits: int, weights: Array) -> int:
	var a: int = 0
	var power: int = 1
	var digit: int
	for _i in range(n_digits):
		digit = self._gen_rdm_digit(weights)
		a += (digit*power)
		power *= base
	return a

func _get_operand_b(base: int, n_digits: int, a: int, w_arr: Array) -> int:
	var b: int = 0
	var power: int = 1
	var a_digit: int
	var b_digit: int
	for _i in range(n_digits):
		a_digit = (a%(power*base))/power
		b_digit = self._gen_rdm_digit(w_arr[a_digit])
		b += (b_digit*power)
		power *= base
	return b

func _get_n_digits(base: int, number: int) -> int:
	return int(log(number)/log(base))+1

func _get_wrong_result(base: int, result: int, d_w_arr: Array, w_arr: Array) -> int:
	var w_r: int = 0
	w_r = result if result >= 0 else ~result+1
	var n_digits: int = self._get_n_digits(base, w_r)
	var i_digit: int = self._gen_rdm_digit(d_w_arr[n_digits-1])
	var power: int = int(pow(base, i_digit))
	var r_digit: int = (w_r%(power*base))/power
	var w_digit: int = self._gen_rdm_digit(w_arr[r_digit])
	w_r -= (r_digit*power)
	w_r += (w_digit*power)
	w_r = w_r if result>=0 else ~w_r+1
	return w_r

func _get_opts(base: int, n_opts: int, ans_opt: int, d_w_arr: Array,
 w_arr: Array) -> Array:
	var opts: Array = []
	var w_opt: int 
	for _i in range(1, n_opts):
		w_opt = self._get_wrong_result(base, ans_opt, d_w_arr, w_arr)
		while w_opt in opts:
			w_opt = self._get_wrong_result(base, ans_opt, d_w_arr, w_arr)
		opts.append(w_opt)
	opts.push_front(ans_opt)
	return opts

func _generate_problem(n_opts: int, op_code: int, n_digits_a: int, n_digits_b: int) -> Dictionary:
	var problem: Dictionary = {
		"op_code": op_code, "a": 0, "b": 0, "ans": 0, "opts": []}
	problem["a"] = self._get_operand_a(self._BASE, n_digits_a, self._d_a_w)
	problem["b"] = self._get_operand_b(self._BASE, n_digits_b, problem["a"],
	self._d_b_w_arr[op_code])
	problem["ans"] = self._get_result(op_code, problem["a"], problem["b"])
	problem["opts"] = self._get_opts(self._BASE, n_opts, problem["ans"],
	self._replace_i_dig_w, self._replace_dig_w)
	problem["opts"].shuffle()
	return problem


func _get_n_dig_operator_a(op_code: int) -> int:
	return self._difficult_lvl if op_code!=2 else (self._difficult_lvl-1)/2 +1

func _get_n_dig_operator_b(op_code: int, n_dig_op_1: int) -> int:
	var n_dig_op_2: int
	if op_code==3 or op_code==4:
		n_dig_op_2 = n_dig_op_1 - 1 if n_dig_op_1 > 1 else 1
	else:
		n_dig_op_2 = n_dig_op_1 
	return n_dig_op_2

func _on_OperatorsUI_got_operators_arr(arr: Array) -> void:
	self._operators = arr

func _on_Problem_gone_inactive() -> void:
	if self._operators.size():
		var op_code: int = self._operators[randi()%self._operators.size()]
		var n_dig_a: int = self._get_n_dig_operator_a(op_code)
		var n_dig_b: int = self._get_n_dig_operator_b(op_code, n_dig_a)
		var problem: Dictionary = self._generate_problem(self._N_OPTS, op_code,
		n_dig_a, n_dig_b)
		self.emit_signal("problem_generated", problem)


func _on_GameDataHandler_level_changed(lvl: int) -> void:
	self._difficult_lvl = lvl
