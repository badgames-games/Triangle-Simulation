extends Node3D

@onready var ui: Control = $CanvasLayer/UI
@onready var meshes: Node3D = $Meshes
var cube: PackedScene = preload("uid://brx7ev2eo21mr")
var sphere: PackedScene = preload("res://Scenes/Sphere.tscn")

var doSpawning: bool = false
var instScene: PackedScene = cube
var sceneTri: int

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
		toggleSpawning()
	elif ui.pausePlayPressed == false and doSpawning == true:
		print("Spawning disabled")
		doSpawning = false
		toggleSpawning()
	
	if ui.deleteMeshes == true:
		for mesh: MeshInstance3D in meshes.get_children():
			mesh.queue_free()
		ui.deleteMeshes = false
		ui.triangles = 0

func inst(scene, pos):
	var instance = scene.instantiate()
	instance.position = pos
	meshes.add_child(instance)

func toggleSpawning():
	while doSpawning == true:
		if int(ui.targetTriangles) == 0:
			ui.targetTriangles = int(INF)
		for i in range(ui.instPerRender):
			if ui.targetTriangles != null and ui.triangles >= int(ui.targetTriangles):
				doSpawning = false
				ui.pausePlayPressed = false
				print("Target Has been reached")
				return
			inst(instScene, Vector3(randf_range(10, -10), randf_range(10, -10), randf_range(10, -10)))
			ui.triangles += sceneTri
		await get_tree().create_timer(0.0001).timeout
