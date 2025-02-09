extends Node

@export var slime_scene: PackedScene  # Drag and drop Slime.tscn in the Inspector
@export var spawn_area: Vector2 = Vector2(400, 400)  # Spawn boundary
@export var slime_count: int = 5  # Number of slimes

func _ready():
	if slime_scene == null:
		print("Error: Slime scene is not assigned!")
		return  # Stop execution

	for i in range(slime_count):
		var slime = slime_scene.instantiate()  # Instantiate Slime.tscn
		if slime == null:
			print("Error: Slime failed to instantiate!")
			continue  # Skip adding it if null

		slime.position = Vector2(randi_range(0, spawn_area.x), randi_range(0, spawn_area.y))
		add_child(slime)
