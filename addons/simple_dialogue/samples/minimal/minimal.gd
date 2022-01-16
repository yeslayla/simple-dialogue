extends Node

var timeline = STimeline.new("res://addons/simple_dialogue/samples/sample.yaml")
var event : SEvent
export var autoDecide : int = 1

func _process(_delta):
	if(Input.is_action_just_pressed("ui_accept")):
		
		# Check for a choice before reading the timeline
		# using `STimeline.is_choice()`
		if timeline.is_choice():
			
			# You can utilize `STimeline.get_choices()` to return
			# an array with all choices as strings in order
			
			# This sample uses the `autoDecide` variable for every
			# choice
			print("You: ", timeline.get_choices()[autoDecide])
			
			# Use `STimeline.make_choice(int)` to make a choice
			# and load that choice's events
			timeline.make_choice(autoDecide)
			return

		# Use `STimeline.read()` to get the next SEvent
		# in a dialogue timeline
		event = timeline.read()
		
		# The primary properties of a SEvent is
		# `name`, `message`, and `portrait`
		if event:
			print(event.name,": ", event.message)
		
		# When STimeline.read() returns null, the timeline has
		# completed and you can exit the dialogue
		if event == null:
			get_tree().quit()
