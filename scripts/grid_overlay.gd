extends Control

const CELL_SIZE := 64
const GRID_COLS := 8
const GRID_ROWS := 6

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	var background := Rect2(Vector2.ZERO, Vector2(GRID_COLS * CELL_SIZE, GRID_ROWS * CELL_SIZE))
	draw_rect(background, Color(0.08, 0.09, 0.13), true)
	for x in GRID_COLS + 1:
		var x_pos := float(x * CELL_SIZE)
		draw_line(Vector2(x_pos, 0), Vector2(x_pos, GRID_ROWS * CELL_SIZE), Color(0.35, 0.38, 0.45), 1.0)
	for y in GRID_ROWS + 1:
		var y_pos := float(y * CELL_SIZE)
		draw_line(Vector2(0, y_pos), Vector2(GRID_COLS * CELL_SIZE, y_pos), Color(0.35, 0.38, 0.45), 1.0)
