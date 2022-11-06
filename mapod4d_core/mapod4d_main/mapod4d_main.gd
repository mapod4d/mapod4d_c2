# tool

# class_name
class_name Mapod4dMain

# extends
extends Control
## Main object of multiverse.
##
## This object support autoload of general scenes and metaverses.
##

# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables
@onready var utils = $Utils
@onready var progress_bar_panel = $Utils/ProgressBar
@onready var progress_bar = \
		$Utils/ProgressBar/Panel/VBoxContainer/MarginContainerPB/ProgressBar

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# ----- remaining built-in virtual methods
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # Replace with function body.


# ----- public methods

## int somes data and configuration
func init_main():
	if utils != null:
		for child in utils.get_children():
			if "visible" in child:
				child.visible = false


## start progress bar
func init_progress_bar():
	progress_bar.value = 0.0
	progress_bar_panel.visible = true


## set progress bar
func set_progress_bar(value: float):
	progress_bar.value = value


## end progress bar
func end_progress_bar():
	progress_bar.value = 0.0
	progress_bar_panel.visible = false


# ----- private methods
