# tool

# class_name
class_name Mapod4dSpherePlanet
# extends
extends Node3D

## Base class for metaverse 3d
##
## Spherical metaverse.
##


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables
var _planet: Mapod4dPlanet

# ----- onready variables

# ----- exported variables

# ----- public variables

# ----- private variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method


# Called when the node enters the scene tree for the first time.
func _ready():
	_planet.planet_type = Mapod4dPlanet.SPHERE


# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.

# ----- public methods

# ----- private methods

