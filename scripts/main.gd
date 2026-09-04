extends Control

const CELL_SIZE := 64
const GRID_COLS := 8
const GRID_ROWS := 6

@onready var target_label: Label = $TargetLabel
@onready var playfield: Control = $Playfield
@onready var draggable: ColorRect = $Playfield/Draggable
@onready var ghost: ColorRect = $Playfield/Ghost
@onready var check_button: Button = $CheckButton
@onready var new_target_button: Button = $NewTargetButton
@onready var result_label: Label = $ResultLabel

var target_cell: Vector2i = Vector2i.ZERO
var is_dragging := false
var drag_center_offset := Vector2.ZERO

func _ready() -> void:
	randomize()
	check_button.pressed.connect(_check_position)
	new_target_button.pressed.connect(_set_new_target)
	draggable.gui_input.connect(_on_draggable_gui_input)
	_snap_to_cell(draggable, Vector2i(0, 0))
	_set_new_target()

func _process(_delta: float) -> void:
	if not is_dragging:
		return

	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_dragging = false
		return

	var desired_center := playfield.get_local_mouse_position() - drag_center_offset
	var snapped_cell := _position_to_cell(desired_center)
	_snap_to_cell(draggable, snapped_cell)

func _on_draggable_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_center_offset = playfield.get_local_mouse_position() - _node_center(draggable)
			ghost.visible = false
		else:
			is_dragging = false

func _set_new_target() -> void:
	target_cell = Vector2i(randi_range(0, GRID_COLS - 1), randi_range(0, GRID_ROWS - 1))
	_snap_to_cell(ghost, target_cell)
	ghost.visible = false
	target_label.text = "Target coordinate: (%d, %d)" % [target_cell.x, target_cell.y]
	result_label.text = ""

func _check_position() -> void:
	var current_cell := _position_to_cell(_node_center(draggable))
	ghost.visible = true
	if current_cell == target_cell:
		result_label.text = "Correct! You placed it at (%d, %d). Notice how y increases as you move down the screen." % [current_cell.x, current_cell.y]
		return

	result_label.text = "Not yet. You are at (%d, %d), but the target is (%d, %d)." % [current_cell.x, current_cell.y, target_cell.x, target_cell.y]

func _position_to_cell(pos: Vector2) -> Vector2i:
	var x := clampi(int(floor(pos.x / CELL_SIZE)), 0, GRID_COLS - 1)
	var y := clampi(int(floor(pos.y / CELL_SIZE)), 0, GRID_ROWS - 1)
	return Vector2i(x, y)

func _snap_to_cell(node: Control, cell: Vector2i) -> void:
	node.position = _cell_center(cell) - (node.size * 0.5)

func _cell_center(cell: Vector2i) -> Vector2:
	return Vector2((cell.x + 0.5) * CELL_SIZE, (cell.y + 0.5) * CELL_SIZE)

func _node_center(node: Control) -> Vector2:
	return node.position + (node.size * 0.5)
