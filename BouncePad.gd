tool
extends Node2D

export(int) var unit_width = 1
export(float) var launch_height = 600

var unit_width_extent = 25
var collision_margin = 10
var height = 5
var area
var collisionShape
var launch_guard_enabled

# Called when the node enters the scene tree for the first time.
func _ready():
	area = get_node("Area2D")
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.set_extents(Vector2(unit_width * unit_width_extent - collision_margin, height))
	shape.set_shape(rect)
	area.add_child(shape)

func _draw():
	var extents = Vector2(unit_width_extent * unit_width, height)
	draw_rect(Rect2(area.get_position() - extents, extents * 2), Color.red, true)

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player" && !launch_guard_enabled:
		launch_guard_enabled = true
		body.add_on_floor_callback(self)
		
func _on_Area2D_body_exited(body):
	launch_guard_enabled = false
	body.remove_on_floor_callback(self)
		
func on_floor_callback(body):
	# Adding the half the player height so the jump height is 
	# calculated from the players feet
	var launch_speed = sqrt(2 * (launch_height + Globals.player_extents.y) * Globals.gravity)
	body.velocity = Vector2(0, -launch_speed)
