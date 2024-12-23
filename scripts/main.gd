extends Node

@export var durian_scene : PackedScene
var score
var life

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func game_over():
	$DurianTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	score = 0
	life = 5
	$Basket.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("durians", "queue_free")
	$HUD.update_score(score)
	$HUD.update_life(life)
	$HUD.show_message("Get Ready")

func add_point():
	score += 1

func _on_start_timer_timeout() -> void:
	$DurianTimer.start()

func _on_durian_timer_timeout() -> void:
	# Instantiate new durian to the scene
	var durian = durian_scene.instantiate()
	
	# Access the spawn location on the path
	var durian_spawn_location = $DurianPath/DurianSpawnLocation
	durian_spawn_location.progress_ratio = randf()
	
	# Set the location of durian to the spawn location
	durian.position = durian_spawn_location.position
	
	# Downward velocity, Downward means only affect Y
	var velocity = Vector2(0.0, randf_range(150.0, 250.0))
	durian.position.x += randf_range(-20.0, 20.0)
	
	durian.linear_velocity = velocity
	
	durian.connect("durian_lost", Callable(self, "_on_durian_lost"))
	
	add_child(durian)

func _on_basket_durian_caught() -> void:
	add_point()
	$HUD.update_score(score)

func _on_durian_lost() -> void:
	life -= 1
	$HUD.update_life(life)
	
	if life <= 0:
		game_over()
