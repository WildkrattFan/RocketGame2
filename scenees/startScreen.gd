extends Control

var game_scene = preload("res://scenees/capture_the_hill/capture_the_hill_space.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$ControlsButton.connect("button_down", self, "_on_controls_button_button_down")
	$PlayButton.connect("button_down", self, "_on_play_button_down")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_controls_button_button_down():
	$controlsPopup.visible = true

func _on_play_button_button_down():
	# Connect player to server and play
	if connect_to_server():
		# Load the game scene if connection is successful
		get_tree().change_scene(game_scene)
	else:
		print("Failed to connect to the server.")
		# Show an error message to the player or handle the failure accordingly
		show_error_message("Failed to connect to the server. Please try again.")

func connect_to_server() -> bool:
	# Example function to connect to the server
	# Replace with your actual server connection logic
	var network_peer = NetworkedMultiplayerENet.new()
	network_peer.create_client("127.0.0.1", 1234)  # Replace with your server IP and port
	get_tree().network_peer = network_peer

	# Connect signals for connection status checking
	network_peer.connect("connection_succeeded", self, "_on_connection_succeeded")
	network_peer.connect("connection_failed", self, "_on_connection_failed")

	# Placeholder: assume connection will succeed after some delay
	# await(get_tree().create_timer(1.0), "timeout")

	# We assume is_connected_to_host is not reliable immediately after create_client.
	# Check connection status via signals
	return false

func _on_connection_succeeded():
	print("Successfully connected to the server.")
	# Proceed with starting the game
	get_tree().change_scene(game_scene)

func _on_connection_failed():
	print("Failed to connect to the server.")
	# Show an error message to the player or handle the failure accordingly
	show_error_message("Failed to connect to the server. Please try again.")

func show_error_message(message: String):
	# Show an error message to the player
	# Assuming you have a Label node for showing error messages
	$ErrorMessage.text = message
	$ErrorMessage.visible = true
