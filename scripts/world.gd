extends Node3D


func _ready() -> void:

    make_environment()
    make_ground()
    make_water()
    make_buildings()
    make_trees()
    make_hud()


# SKY AND LIGHTING
func make_environment() -> void:

    var env = WorldEnvironment.new()
    var environment = Environment.new()

    environment.background_mode = Environment.BG_SKY
    environment.sky = Sky.new()

    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color(0.72, 0.78, 0.86)
    environment.ambient_light_energy = 0.8

    env.environment = environment
    add_child(env)

    var sun = DirectionalLight3D.new()

    sun.rotation_degrees = Vector3(-55, -25, 0)
    sun.light_energy = 1.3

    add_child(sun)


# ISLAND GROUND
func make_ground() -> void:

    var ground = StaticBody3D.new()

    var mesh_instance = MeshInstance3D.new()
    var mesh = PlaneMesh.new()

    mesh.size = Vector2(180, 180)
    mesh_instance.mesh = mesh

    var material = StandardMaterial3D.new()

    material.albedo_color = Color(0.24, 0.43, 0.20)
    material.roughness = 1.0

    mesh_instance.material_override = material

    ground.add_child(mesh_instance)

    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()

    shape.size = Vector3(180, 0.2, 180)

    collision.shape = shape
    collision.position.y = -0.1

    ground.add_child(collision)

    add_child(ground)


# WATER AREA
func make_water() -> void:

    var water = MeshInstance3D.new()
    var mesh = PlaneMesh.new()

    mesh.size = Vector2(260, 260)
    water.mesh = mesh

    var material = StandardMaterial3D.new()

    material.albedo_color = Color(0.02, 0.30, 0.55)
    material.roughness = 0.25

    water.material_override = material
    water.position.y = -1.5

    add_child(water)


# BUILDINGS
func make_buildings() -> void:

    for i in range(18):

        var x = float((i % 6) * 22 - 55)
        var z = float((i / 6) * 28 - 28)

        var height = randf_range(5, 11)

        make_box(
            Vector3(x, 0, z),
            Vector3(9, height, 9),
            Color(0.48, 0.49, 0.52)
        )


# TREES
func make_trees() -> void:

    for i in range(45):

        var x = randf_range(-78, 78)
        var z = randf_range(-78, 78)

        if abs(x) < 12 and abs(z) < 12:
            continue

        make_tree(Vector3(x, 0, z))


func make_tree(pos: Vector3) -> void:

    # TRUNK
    var trunk = MeshInstance3D.new()
    var trunk_mesh = CylinderMesh.new()

    trunk_mesh.top_radius = 0.25
    trunk_mesh.bottom_radius = 0.4
    trunk_mesh.height = 2.8

    trunk.mesh = trunk_mesh
    trunk.position = pos + Vector3(0, 1.4, 0)

    var trunk_material = StandardMaterial3D.new()

    trunk_material.albedo_color = Color(0.28, 0.17, 0.09)

    trunk.material_override = trunk_material

    add_child(trunk)

    # LEAVES
    var crown = MeshInstance3D.new()
    var crown_mesh = SphereMesh.new()

    crown_mesh.radius = 1.6
    crown_mesh.height = 3.0

    crown.mesh = crown_mesh
    crown.position = pos + Vector3(0, 3.3, 0)

    var crown_material = StandardMaterial3D.new()

    crown_material.albedo_color = Color(0.10, 0.32, 0.12)

    crown.material_override = crown_material

    add_child(crown)


# BOX OBJECTS
func make_box(
    pos: Vector3,
    size: Vector3,
    color: Color
) -> void:

    var body = StaticBody3D.new()

    body.position = pos

    var mesh_instance = MeshInstance3D.new()
    var mesh = BoxMesh.new()

    mesh.size = size
    mesh_instance.mesh = mesh

    var material = StandardMaterial3D.new()

    material.albedo_color = color

    mesh_instance.material_override = material

    body.add_child(mesh_instance)

    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()

    shape.size = size

    collision.shape = shape
    collision.position.y = size.y / 2.0

    body.add_child(collision)

    add_child(body)


# GAME HUD
func make_hud() -> void:

    var layer = CanvasLayer.new()

    add_child(layer)

    var title = Label.new()

    title.text = "BATTLE FIRE"
    title.position = Vector2(30, 20)

    title.add_theme_font_size_override(
        "font_size",
        36
    )

    title.add_theme_color_override(
        "font_color",
        Color(1, 0.25, 0.08)
    )

    layer.add_child(title)

    var players = Label.new()

    players.text = "PLAYERS TARGET: 50"
    players.position = Vector2(30, 75)

    players.add_theme_font_size_override(
        "font_size",
        22
    )

    players.add_theme_color_override(
        "font_color",
        Color.WHITE
    )

    layer.add_child(players)

    var help = Label.new()

    help.text = "ARROW KEYS: MOVE | SPACE: JUMP | ESC: RELEASE MOUSE"
    help.position = Vector2(30, 115)

    help.add_theme_font_size_override(
        "font_size",
        17
    )

    help.add_theme_color_override(
        "font_color",
        Color.WHITE
    )

    layer.add_child(help)
