class_name empty extends CharacterBody2D


enum State {
	jalan,
	diam,
}

const jalan_SPEED = 100.0

var _state := State.jalan

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var platform_detector := $PlatformDetector as RayCast2D
@onready var floor_detector_left := $FloorDetectorLeft as RayCast2D
@onready var floor_detector_right := $FloorDetectorRight as RayCast2D
@onready var sprite := $Sprite2D as Sprite2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer

func _physics_process(delta: float) -> void:
	if _state == State.jalan and velocity.is_zero_approx():
		velocity.x = jalan_SPEED
	velocity.y += gravity * delta
	if not floor_detector_left.is_colliding():
		velocity.x = jalan_SPEED
	elif not floor_detector_right.is_colliding():
		velocity.x = -jalan_SPEED

	if is_on_wall():
		velocity.x = -velocity.x

	move_and_slide()

	if velocity.x > 0.0:
		sprite.scale.x = 1.0
	elif velocity.x < 0.0:
		sprite.scale.x = -1.0

	var animation := get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)


func get_new_animation() -> StringName:
	var animation_new: StringName
	if _state == State.jalan:
		if velocity.x == 0:
			animation_new = &"diam"
		else:
			animation_new = &"jalan"
	else:
		animation_new = &"destroy"
	return animation_new
