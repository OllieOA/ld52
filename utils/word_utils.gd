class_name WordUtils extends Resource

const word_list_path = "res://utils/wordlist.json"

var word_list: Array
var valid_scancodes: Array
var special_scancodes := [KEY_PERIOD]
var alpha_scancodes: Array
var alphabet: Array

const MIN_URL_LENGTH = 6
const MAX_URL_LENGTH = 12
var url_suffixes := []
var generated_websites = []  # Track to make sure unique

const SPECIAL_LOOKUP = {
	KEY_PERIOD: ".",
}

var rng = RandomNumberGenerator.new()


func generate_all() -> void:
	rng.randomize()
	_generate_word_list()
	_generate_alphabet()
	_generate_url_suffixes()


func _generate_word_list() -> void:
	var f = File.new()
	assert(f.file_exists(word_list_path), "Cannot find word list!")

	f.open(word_list_path, File.READ)
	var json = f.get_as_text()
	word_list = parse_json(json)

	var word_list_upper = []
	for word in word_list:
		word_list_upper.append(word.to_upper())

	word_list = word_list_upper


func _generate_alphabet() -> void:
	alpha_scancodes = range(KEY_A, KEY_Z + 1)
	for each_scancode in alpha_scancodes:
		alphabet.append(OS.get_scancode_string(each_scancode))

	# Set other scancodes
	valid_scancodes = alpha_scancodes
	valid_scancodes += special_scancodes

func _generate_url_suffixes() -> void:
	if len(alphabet) == 0:
		generate_all()

	var chance_of_double := 0.3
	while len(url_suffixes) < 20:
		var new_url_suffix = "."
		var n_chars = rng.randi_range(2, 3)
		for _idx in range(n_chars):
			new_url_suffix += alphabet[rng.randi() % alphabet.size()].to_lower()

		if rng.randf() > chance_of_double:
			new_url_suffix += "."
			for _idx in range(2):
				new_url_suffix += alphabet[rng.randi() % alphabet.size()].to_lower()

		url_suffixes.append(new_url_suffix)


func get_random_words(target_num_words: int, min_word_length: int, max_word_length: int) -> Array:
	if len(word_list) == 0:
		generate_all()

	var strings = []

	while len(strings) < target_num_words:
		var rand_choice = word_list[rng.randi() % word_list.size()]
		if not rand_choice in strings and len(rand_choice) <= max_word_length and len(rand_choice) >= min_word_length:
			strings.append(rand_choice)
	
	return strings


func get_random_website() -> String:
	if len(url_suffixes) == 0:
		generate_all()

	var random_pool = get_random_words(3, 4, 8)
	var website_address = ""

	while len(website_address) < MIN_URL_LENGTH:
		website_address += random_pool.pop_back().to_lower()

	while len(website_address) > MAX_URL_LENGTH:
		website_address = website_address.substr(0, len(website_address) - 1)

	website_address += url_suffixes[rng.randi() % url_suffixes.size()]

	if website_address in generated_websites:
		website_address = get_random_website()

	generated_websites.append(website_address)

	return website_address
