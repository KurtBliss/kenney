class_name StateHelper #Devzze: 1-13-22
extends Node 

"""
usage example:

onready var state_helper = $StateHelper

func _process(delta): 
	state_helper.process(self, delta) 
func _physics_process(delta): 
	state_helper.phy_process(self, delta) #(delta, physics)

func process_init():
	state_helper.reset("idle")

func process_idle():
	pass

func physics_idle():
	pass
"""

# Default state will just had the process_init function
@export var states = ["init"]

# This will be added to the state's prefix when set
@export var prefix = "process_"
@export var phy_prefix = "physics_"

#	Functions to call all processes for the state
#
# Call processes of state
func process(helpfor = self, delta = 0):
	for state in states:
		var call = prefix + state
		if helpfor.has_method(call):
			helpfor.call(call, delta)

# Call physic processes of state
func phy_process(helpfor, delta = 0):
	for state in states:
		var call = phy_prefix + state
		if helpfor.has_method(call):
			helpfor.call(call, delta)

#	Use these functions to change the state!
#
# Remove all processes from state
func reset(state = []):
	if state is Array:
		states = state
	else:
		states = [state]

# Add new process to state
func add(process):
	if process is Array:
		for process_i in process:
			add(process_i)
	else:
		if states.has(process):
			return
		states.append(process)

# Remove process from state
func remove(process):
	if process is Array:
		for process_i in process:
			remove(process_i)
	else:
		var f = states.find(process)
		if f == -1: return
		states.remove(f)
