class_name Level
extends Node2D

@onready var fragment_scene: PackedScene = preload("res://scenes/fragments/fragment_scene.tscn")
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var destructible_layer: TileMapLayer = $DestructibleLayer
@onready var goal: Goal = $Goal
@onready var respawn_point: Respawn = $Respawn

var player_initial_position: Vector2
var player_respawn: Callable = Callable(self, "_respawn_player")
var player_exploded: Callable = Callable(self, "_handle_explosion")
var respawn_finished: Callable = Callable(self, "_on_respawn_finished")

func _ready() -> void:
	player_initial_position = respawn_point.global_position + Vector2(15, 0)
	player.global_position = player_initial_position
	player.exploded.connect(player_exploded)
	player.ready_to_respawn.connect(player_respawn)
	respawn_point.respawn_animation_finished.connect(respawn_finished)

func _handle_explosion(explosion_area: Area2D, radius: float) -> void:
	_destroy_goal_on_explosion(explosion_area)
	_remove_tiles_in_radius(explosion_area.global_position, radius)

func _is_goal_within_explosion_range(explosion_area: Area2D) -> bool:
	var areas_inside_explosion_radius = explosion_area.get_overlapping_areas()
	for area in areas_inside_explosion_radius:
		if area.get_collision_layer_value(5):
			return true
	return false

func _destroy_goal_on_explosion(explosion_area: Area2D) -> void:
	if(_is_goal_within_explosion_range(explosion_area)):
		goal._on_explosion_hit_goal()

func _remove_tiles_in_radius(explosion_center: Vector2, radius: float) -> void:
	var used_cells: Array[Vector2i] = destructible_layer.get_used_cells()
	var tile_size = destructible_layer.tile_set.tile_size
	var start_cell = destructible_layer.local_to_map(explosion_center - Vector2(radius, radius))
	var end_cell = destructible_layer.local_to_map(explosion_center + Vector2(radius, radius)) 
	for x in range(start_cell.x, end_cell.x + 1):
		for y in range(start_cell.y, end_cell.y + 1):
			var cell_pos: Vector2i = Vector2i(x, y)
			if (!used_cells.has(cell_pos)):		# show fragments only if we destroy something
				continue
			var world_pos = destructible_layer.map_to_local(cell_pos) + Vector2(tile_size / 2)
			_spawn_fragments(world_pos)
			destructible_layer.erase_cell(Vector2i(x, y))
			
func _spawn_fragments(spawn_position: Vector2):
	var fragment: Fragment = fragment_scene.instantiate()
	fragment.global_position = spawn_position
	get_tree().root.add_child(fragment)
	
func _respawn_player() -> void:
	player.global_position = player_initial_position
	respawn_point.play_respawn_animation()
	
func _on_respawn_finished() -> void:
	player.on_repsawn()
