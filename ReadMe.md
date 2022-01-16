![Release Version](https://img.shields.io/github/v/release/josephbmanley/simple-dialogue)

# Simple Dialogue

Requirements: Godot 3.x and [godot-yaml](https://github.com/Beliaar/godot-yaml-asset)

Table of Contents:
- [Features](#Features)
- [Examples](#Examples)
- [Object Reference](#Objects)

Simple Dialogue is yet another dialogue plugin for Godot that is a lightweight dialogue system that can easily be used at a lower level dialogue.

Currently, this requires all dialogue to be written in `YAML`.

## Features

- Timelines
- Choices
- Localization

## Examples

See the [samples](addons/simple_dialogue/samples) for more examples.

### Dialogue File

```yaml
apiVersion: 1.0
kind: timeline
events:
- name:
    en_US: Person
  message:
    en_US: Hello, I say witty dialogue!
```

### Usage

```gdscipt
var timeline = STimeline.new("res://addons/simple_dialouge/samples/sample.yaml")
var event : SEvent

func _process(_delta):
	if(Input.is_action_just_pressed("ui_accept")):
		
		if timeline.is_choice():
            var autoDecide = 1
			print("You: ", timeline.get_choices()[autoDecide])
			timeline.make_choice(autoDecide)
			return

		event = timeline.read()
		
		if event:
			print(event.name,": ", event.message)
```

## Objects

### SChoice

Properties:

|Name|Type|Description|
|---|---|---|
|events|`Array`(`SEvent`)|Array of all events this choice leads towards.|
|choice|`String`|Text associated with choice.|

### SEvent

Properties:

|Name|Type|Description|
|---|---|---|
|name|`String`|Name of current event speaker.|
|message|`String`|Text spoken by speaker.|
|portrait|`Texture`|Texture associated with current speaker.|
|choices|`Array`(`SChoice`)|Array of all choices associated with event.|

Methods:

|Name|Return Type|Description|
|---|---|---|
|get_locale(property)|`String`|Returns the value of a localized property.|

### STimeline

Properties:

|Name|Type|Description|
|---|---|---|
|file_path|`String`|File path associated with timeline.|
|events|`Array`(`SEvent`)|Array of all events associated with timeline.|

Methods:

|Name|Return Type|Description|
|---|---|---|
|get_cursor()|`int`|Returns the current cursor position.|
|seek(new_pos)|`void`|Moves current cursor position on the timeline.|
|get_event(offset=`0`)|`SEvent`|Returns the event at the cursor position.|
|read()|`SEvent`|Returns the current event and moves the cursor foward.|
|get_choices()|`Array`(`String`)|Returns an array of current choices text value at cursor.|
|make_choice(choice_int)|void|Moves cursor to new event stream depending on choice value.|
