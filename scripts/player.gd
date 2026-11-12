extends CharacterBody3D

@export var move_speed: float = 7.0
@export var jump_velocity: float = 4.5

var gravity: float = 18.0
var camera_pivot: Node3D


func _ready() -> void:

    # PLAYER BODY
    var body_mesh = MeshInstance3D.new()
    var capsule = CapsuleMesh.new()

    capsule.radius = 0.42
    capsule.height = 1.8

    body_mesh.mesh = capsule

    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.08, 0.12, 0.22)

    body_mesh.material_override = material
    body_mesh.position.y = 0.9

    add_child(body_mesh)

    # PLAYER COLLISION
    var collider = CollisionShape3D.new()
    var shape = CapsuleShape3D.new()

    shape.radius = 0.42
    shape.height = 1.8

    collider.shape = shape
    collider.position.y = 0.9

    add_child(collider)

    # CAMERA PIVOT
    camera_pivot = Node3D.new()
    camera_pivot.position.y = 2.2

    add_child(camera_pivot)

    # THIRD PERSON CAMERA
    var camera = Camera3D.new()

    camera.position = Vector3(0, 3, 7)
    camera.rotation_degrees.x = -15
    camera.current = true

    camera_pivot.add_child(camera)


func _unhandled_input(event: InputEvent) -> void:

    if event is InputEventMouseButton and event.pressed:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

    if event is InputEventMouseMotion:
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

            rotate_y(-event.relative.x * 0.003)

            camera_pivot.rotate_x(
                -event.relative.y * 0.003
            )

            camera_pivot.rotation.x = clamp(
                camera_pivot.rotation.x,
                -0.8,
                0.35
            )

    if event.is_action_pressed("ui_cancel"):
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(delta: float) -> void:

    if not is_on_floor():
        velocity.y -= gravity * delta

    elif Input.is_action_just_pressed("ui_accept"):
        velocity.y = jump_velocity

    var input_dir = Input.get_vector(
        "ui_left",
        "ui_right",
        "ui_up",
        "ui_down"
    )

    var direction = (
        transform.basis *
        Vector3(input_dir.x, 0, input_dir.y)
    ).normalized()

    if direction:

        velocity.x = direction.x * move_speed
        velocity.z = direction.z * move_speed

    else:

        velocity.x = move_toward(
            velocity.x,
            0,
            move_speed * delta * 5
        )

        velocity.z = move_toward(
            velocity.z,
            0,
            move_speed * delta * 5
        )

    move_and_slide()
