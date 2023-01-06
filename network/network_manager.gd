extends Node2D


export var max_width = 4
export var max_depth = 10

var network = []
var rng = RandomNumberGenerator.neW()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func generate_nodes():
	print("Thing")
	
func next_layer():
	var count = rng.randi_range(0, max_width)
	var layer = []