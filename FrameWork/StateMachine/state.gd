class_name State
extends Node

var state_machine
var state 
var state_can_go:Array

var prv_state
var next_state

func check_can_go(state_to):
	return state_to in state_can_go

# Initialize the state. E.g. change the animation.
func enter(state_name=null):
	prv_state = state
	on_entered(state_name)
	pass

func on_entered(state):
	
	pass

# Clean up the state. Reinitialize values like a timer.
func exit(state_name=null):
	next_state = state_name
	on_exited(state_name)
	pass

func on_exited(state):
	pass
