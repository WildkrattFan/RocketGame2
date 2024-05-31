extends Control

var game_scene = preload("res://scenees/capture_the_hill/capture_the_hill_space.tscn")
@export var player_scene = preload("res://scenees/player and weapons/Player.tscn")
var peer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signals for successful or failed connection
	multiplayer.connected_to_server.connect(_on_connection_succeeded)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.peer_connected.connect(_on_peer_connected)

func _on_controls_button_button_down():
	$controlsPopup.visible = true

func _on_host_pressed():
	print("Starting server...")
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	# Load the game scene for the host
	_load_game_scene()

func _on_play_pressed():
	print("Attempting to create client...")
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer

func _add_player(id):
	print("Adding player with ID:", id)
	var player = player_scene.instantiate()
	player.position = Vector2(0, 0)
	player.name = str(id)
	call_deferred("add_child", player)

func _load_game_scene():
	# Change to the game scene
	print("Loading game scene...")
	get_tree().change_scene_to_packed(game_scene)
	# Ensure we wait for the scene to load completely before adding players
	call_deferred("_check_and_add_player")

func _check_and_add_player():
	if multiplayer and multiplayer.get_multiplayer_peer() and multiplayer.get_multiplayer_peer().is_server():
		_add_player(1)  # Host player ID
	else:
		call_deferred("_add_player_for_client")

func _add_player_for_client():
	print("Adding player for client")
	if multiplayer and multiplayer.get_multiplayer_peer():
		_add_player(multiplayer.get_unique_id())

func _on_peer_connected(id):
	print("Peer connected with ID:", id)
	if multiplayer and multiplayer.get_multiplayer_peer() and multiplayer.get_multiplayer_peer().is_server():
		_add_player(id)

func _on_connection_succeeded():
	print("Successfully connected to the server.")
	# Load the game scene for the client
	_load_game_scene()

func _on_connection_failed():
	print("Failed to connect to the server.")
	show_error_message("Failed to connect to the server. Please try again.")

func _on_server_disconnected():
	print("Disconnected from the server.")
	show_error_message("Disconnected from the server.")

func show_error_message(message: String):
	# Show an error message to the player
	print("Error:", message)
	# Assuming you have a Label node for showing error messages
	$ErrorMessage.text = message
	$ErrorMessage.visible = true
