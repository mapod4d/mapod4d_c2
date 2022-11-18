# tool

# class_name

# extends
extends Mapod4dBaseUi

## A brief description of your script.
##
## A more detailed description of the script.
##
## @tutorial:			http://the/tutorial1/url.com
## @tutorial(Tutorial2): http://the/tutorial2/url.com


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables
@onready var start_button = $AspectRatioContainer/PanelContainer/CenterContainer/Start

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_on_start_button_pressed)


# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # Replace with function body.


# ----- public methods

# ----- private methods

func _on_start_button_pressed():
	print("pressed")
#	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
#	DisplayServer.window_set_size(Vector2i(1920, 1080))
#	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
#	Mapod4dAutoload.im_alive()
	emit_signal("scene_requested", 
			"res://mapod4d_core/mapod4d_main_menu/mapod4d_main_menu.tscn", true)

