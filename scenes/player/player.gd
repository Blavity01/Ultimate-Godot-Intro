extends CharacterBody2D

signal laser_detected(pos, direction)
signal grenade_detected(pos, player_direction)

var can_laser: bool = true
var can_grenade: bool = true

func _process(_delta):
	
	# input
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * 500
	move_and_slide()
	
	# rotate player
	look_at(get_global_mouse_position())
	
	# laser shooting input
	var player_direction = (get_global_mouse_position() - position).normalized()
	if Input.is_action_pressed("primary action") and can_laser:
		var laser_markers = $LaserStartPosition.get_children()
		var selected_marker = laser_markers[randi() % laser_markers.size()]
		can_laser = false
		$LaserTimer.start()
		laser_detected.emit(selected_marker.global_position, player_direction)
		$GPUParticles2D.emitting = true

	# grenade shooting input
	if Input.is_action_pressed("secondary action") and can_grenade:
		var pos = $LaserStartPosition.get_children()[0].global_position
		can_grenade = false
		$GrenadeTimer.start()
		grenade_detected.emit(pos, player_direction)
		


func _on_laser_timer_timeout():
	can_laser = true


func _on_grenade_timer_timeout():
	can_grenade = true
