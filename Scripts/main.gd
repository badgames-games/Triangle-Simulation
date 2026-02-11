extends Node3D

@onready var ui: Control = $CanvasLayer/UI
@onready var meshes: Node3D = $Meshes
var cube = preload("uid://brx7ev2eo21mr")
var sphere = preload("res://Scenes/Sphere.tscn")

var targetTriangles
var doSpawning = false
var instScene = cube
var sceneTri

func _ready() -> void:
	var sceneMesh: Mesh = instScene.instantiate().mesh
	
	if sceneMesh is SphereMesh:
		sceneTri = 2 * sceneMesh.radial_segments * (sceneMesh.rings - 1)
	elif sceneMesh is BoxMesh:
		sceneTri = 12
	
	print("Mesh Triangles: " + str(sceneTri))

func _process(_delta: float) -> void:
	if ui.pausePlayPressed == true and doSpawning == false:
		print("Spawning enabled")
		doSpawning = true
		targetTriangles = ui.targetTriangles
		toggleSpawning()
	elif ui.pausePlayPressed == false and doSpawning == true:
		print("Spawning disabled")
		doSpawning = false
		targetTriangles = ui.targetTriangles
		toggleSpawning()

func inst(scene, pos):
	var instance = scene.instantiate()
	instance.position = pos
	meshes.add_child(instance)

func toggleSpawning():
	while doSpawning == true:
		if int(targetTriangles) == 0:
			targetTriangles = int(INF)
		for i in range(ui.instPerRender):
			if targetTriangles != null and ui.triangles >= int(targetTriangles):
				doSpawning = false
				ui.pausePlayPressed = false
				print("Target Has been reached")
				return
			inst(instScene, Vector3(randf_range(10, -10), randf_range(10, -10), randf_range(10, -10)))
			ui.triangles += sceneTri
		await get_tree().create_timer(0.0001).timeout
