extends Node

var word_utils = preload("res://utils/word_utils.tres")

func assign_address(network_node_object) -> void:
    network_node_object._address = word_utils.get_random_website()