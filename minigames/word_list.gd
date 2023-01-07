class_name WordList extends Resource

var word_list: Array

const word_list_path = "res://utils/wordlist.json"

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
