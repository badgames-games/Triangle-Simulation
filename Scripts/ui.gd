extends Control

@onready var fpsLabel: Label = $VBoxContainer/FPS
@onready var triangleLabel: Label = $VBoxContainer/Triangles
@onready var triPSLabel: Label = $VBoxContainer/TriPS
@onready var pausePlayButton: Button = $PlayPauseButton
@onready var targetTrianglesTyped: LineEdit = $TargetTriangles
@onready var recordField: LineEdit = $RecordField
@onready var recordButton: Button = $RecordButton
@onready var recordStatus: Label = $RecordStatus

var pausePlayPressed: bool = false
var recording: bool = false
var deleteMeshes: bool = false
var recordedFPS: Array = []
var targetTriangles

var triangles: int = 0
var lastFps: float = 0.0
var lastTri: int = 0
var lastTriPS: int = 0
var recordLength: int = 0
var instPerRender: int = 1

func _ready() -> void:
	while true:
		# FPS label
		var fps = Engine.get_frames_per_second()
		
		if lastFps < fps:
			fpsLabel.label_settings.font_color = Color.from_rgba8(72, 189, 0)
		elif lastFps == fps:
			fpsLabel.label_settings.font_color = Color.from_rgba8(255, 255, 255)
		else:
			fpsLabel.label_settings.font_color = Color.from_rgba8(255, 0, 0)
		
		fpsLabel.text = "FPS: " + str(int(fps))
		lastFps = fps
		
		# TriPS label
		var triPS = triangles - lastTri
		
		if lastTriPS < triPS:
			triPSLabel.label_settings.font_color = Color.from_rgba8(72, 189, 0)
		elif lastTriPS == triPS:
			triPSLabel.label_settings.font_color = Color.from_rgba8(255, 255, 255)
		else:
			triPSLabel.label_settings.font_color = Color.from_rgba8(255, 0, 0)
		
		triPSLabel.text = "TriPS: " + str(triPS)
		lastTriPS = triPS
		lastTri = triangles
		
		await get_tree().create_timer(1).timeout


func _process(_delta: float) -> void:
	triangleLabel.text = "Triangles: " + str(triangles)

func _on_play_pause_button_pressed() -> void:
	if pausePlayPressed == false:
		pausePlayPressed = true
		pausePlayButton.text = "⏸"
	else:
		pausePlayPressed = false
		pausePlayButton.text = "▶"
	targetTriangles = targetTrianglesTyped.text
	print("Target Triangles: " + str(int(targetTriangles)))

func _on_record_button_pressed() -> void:
	if recording == false:
		recording = true
		recordButton.text = "⬜"
		recordLength = int(recordField.text)
		if recordLength == 0:
			recordLength = int(INF)
		for i in int(recordLength):
			if recording == false or i == recordLength:
				if i == recordLength:
					recordedFPS.append(Engine.get_frames_per_second())
					print("Recorded: " + str(Engine.get_frames_per_second()) + " FPS")
				print("recording finished")
				var file = FileAccess.open("user://fpsData.json", FileAccess.WRITE)
				file.store_string(str(recordedFPS))
				recordedFPS = []
				print("File saved to: " + str(OS.get_user_data_dir()))
				recordStatus.text = "File saved as fpsData.json"
				return
			recordedFPS.append(int(Engine.get_frames_per_second()))
			print("Recorded: " + str(Engine.get_frames_per_second()) + " FPS")
			if recordLength == 9223372036854775807:
				recordStatus.text = str(i) + "/(2^63) - 1"
			else:
				recordStatus.text = str(i) + "/" + str(recordLength)
				
			await get_tree().create_timer(1).timeout
	else:
		recording = false
		recordButton.text = "⬤"

func _on_delete_button_pressed() -> void:
	deleteMeshes = true

func _on_x_1_pressed() -> void:
	instPerRender = 1

func _on_x_2_pressed() -> void:
	instPerRender = 2

func _on_x_3_pressed() -> void:
	instPerRender = 3

func _on_x_5_pressed() -> void:
	instPerRender = 5

func _on_x_10_pressed() -> void:
	instPerRender = 10

func _on_x_25_pressed() -> void:
	instPerRender = 25

func _on_x_100_pressed() -> void:
	instPerRender = 100

func _on_x_1000_pressed() -> void:
	instPerRender = 1000

func _on_x_10000_pressed() -> void:
	instPerRender = 10000

func _on_x_100000_pressed() -> void:
	instPerRender = 100000
