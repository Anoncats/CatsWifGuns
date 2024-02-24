extends Node3D

@export var player: Node3D

@onready var raycast = $RayCast


var health := 100
var time := 0.0
var target_position: Vector3
var destroyed := false

# When ready, save the initial position


func _ready():
	target_position = position
	$AnimationPlayer.play("1_normal")

func _process(delta):
	self.look_at(player.position + Vector3(0, 0.5, 0), Vector3.UP, true)  # Look at player

	time += delta

	position = target_position
	
	if destroyed:
		$AnimationPlayer.play("3_sad")
	



# Take damage from player


func damage(amount):
	print("anoncat damage: ", amount)
	Audio.play("sounds/enemy_hurt.ogg")

	$AnimationPlayer.play("4_angry")

	health -= amount

	if health <= 0 and !destroyed:
		print("destroy anoncat")
		destroy()


# Destroy the enemy when out of health


func destroy():
	Audio.play("sounds/enemy_destroy.ogg")

	destroyed = true
	print("sad")
	$AnimationPlayer.play("3_sad")



# Shoot when timer hits 0


func _on_timer_timeout():
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var collider = raycast.get_collider()

		if collider.has_method("damage"):  # Raycast collides with player
			# Play muzzle flash animation(s)

			Audio.play("sounds/enemy_attack.ogg")

			collider.damage(5)  # Apply damage to player
