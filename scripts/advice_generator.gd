extends Node
signal got_advice(advice)
class_name AdviceGenerator
const _NEEDED_ADVICE: int = 1
const _ADVICE_FILE_PATH: String = "res://files/advices.cfg"
const _ADVICE_SECTIONS: Array = ["add", "sub", "mult", "quot", "mod"]
var _advice_file: ConfigFile
var _curr_problem: Dictionary

func _ready():
	self._advice_file = ConfigFile.new()
# warning-ignore:return_value_discarded
	self._advice_file.load(self._ADVICE_FILE_PATH)

func get_n_digits(number: int) -> int:
	return int(log(number)/log(10))+1

func have_at_most_three_digits(a: int, b: int) -> bool:
	return self.get_n_digits(a) == 3 or self.get_n_digits(b)==3

func equal_operands(a: int, b: int) -> bool:
	return a == b

func general_predicate(_a: int, _b: int) -> bool:
	return true

func second_operand_is_greater(a: int, b: int) -> bool:
	return b > a

func mult_by_eleven(a: int, b: int) -> bool:
	return a == 11 or b == 11

func last_digit_eight_or_nine(a: int, b: int) -> bool:
	return a%10 == 8 or a%10 == 9 or b%10 == 8 or b%10 == 9

func is_multiple_of_three(a: int, _b: int) -> bool:
	return a%3==0

func _on_ProblemGenerator_problem_generated(problem: Dictionary) -> void:
	self._curr_problem = problem

func _get_advice(advice: Dictionary) -> void:
	var advice_struct: Dictionary
	var section: String = self._ADVICE_SECTIONS[self._curr_problem["op_code"]]
	for s_key in self._advice_file.get_section_keys(section):
		advice_struct = self._advice_file.get_value(section, s_key)
		if (self.call(advice_struct["predicate"], self._curr_problem["a"],
		self._curr_problem["b"]) and not advice_struct["used"]):
			for d_key in advice.keys():
				advice[d_key] = advice_struct[d_key]
			if advice_struct["predicate"] != "general_predicate":
				advice_struct["used"] = 1
				self._advice_file.set_value(section, s_key, advice_struct)
				break
		elif advice_struct["used"]:
			advice_struct["used"] = 0
			self._advice_file.set_value(section, s_key, advice_struct)
# warning-ignore:return_value_discarded
	self._advice_file.save(self._ADVICE_FILE_PATH)

func _on_AdviceButton_got_input(input: int) -> void:
	if input == self._NEEDED_ADVICE:
		var advice: Dictionary = {"title": "", "desciption_key": "",
		"image_path": ""}
		self._get_advice(advice)
		self.emit_signal("got_advice", advice)
