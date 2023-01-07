class_name WordUtils extends Resource

const word_list_path = "res://utils/wordlist.json"

var word_list: Array
var valid_scancodes: Array
var alphabet: Array

func generate_word_list() -> void:
	var f = File.new()
	assert(f.file_exists(word_list_path), "Cannot find word list!")

	f.open(word_list_path, File.READ)
	var json = f.get_as_text()
	word_list = parse_json(json)

	var word_list_upper = []
	for word in word_list:
		word_list_upper.append(word.to_upper())

	word_list = word_list_upper


func generate_alphabet() -> void:
	valid_scancodes = range(KEY_A, KEY_Z + 1)
	for each_scancode in valid_scancodes:
		alphabet.append(OS.get_scancode_string(each_scancode))