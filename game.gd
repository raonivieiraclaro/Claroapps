extends Node2D

var player := Vector2(100, 350)
var velocity := Vector2.ZERO
var on_ground := true
var rings := 0
var jump_requested := false
var left_pressed := false
var right_pressed := false

func _ready() -> void:
    queue_redraw()

func _physics_process(delta: float) -> void:
    var direction := Input.get_axis("ui_left", "ui_right")
    if left_pressed:
        direction -= 1.0
    if right_pressed:
        direction += 1.0
    velocity.x = clampf(velocity.x + direction * 1500.0 * delta, -380.0, 380.0)
    if absf(direction) < 0.1:
        velocity.x = move_toward(velocity.x, 0.0, 1100.0 * delta)
    if (Input.is_action_just_pressed("ui_accept") or jump_requested) and on_ground:
        velocity.y = -610.0
        on_ground = false
    jump_requested = false
    velocity.y += 1450.0 * delta
    player += velocity * delta
    if player.y >= 350.0:
        player.y = 350.0
        velocity.y = 0.0
        on_ground = true
    player.x = clampf(player.x, 18.0, 942.0)
    queue_redraw()

func _draw() -> void:
    draw_rect(Rect2(0, 0, 960, 540), Color("#6ac9ee"))
    draw_circle(Vector2(770, 95), 48, Color("#ffe69b"))
    draw_rect(Rect2(0, 380, 960, 160), Color("#419d49"))
    draw_rect(Rect2(0, 380, 960, 20), Color("#c58b46"))
    for i in range(12):
        var x := 145.0 + i * 67.0
        draw_arc(Vector2(x, 323), 12.0, 0, TAU, 24, Color("#f9d349"), 5.0)
    draw_circle(player, 25.0, Color("#146bd8"))
    draw_circle(player + Vector2(8, -7), 5.0, Color.WHITE)
    draw_circle(player + Vector2(9, -7), 2.0, Color.BLACK)
    draw_rect(Rect2(player.x - 22, player.y + 19, 22, 9), Color("#d82d33"))
    draw_rect(Rect2(player.x + 1, player.y + 19, 22, 9), Color("#d82d33"))
    draw_string(ThemeDB.fallback_font, Vector2(20, 42), "SONIC MS REMAKE - PROTOTIPO", HORIZONTAL_ALIGNMENT_LEFT, -1, 27, Color.WHITE)
    draw_string(ThemeDB.fallback_font, Vector2(20, 76), "Criador desta versao: Raoni Claro", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color.WHITE)
    draw_string(ThemeDB.fallback_font, Vector2(20, 110), "Setas: mover  |  Enter/Espaco: pular", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color.WHITE)
    draw_rect(Rect2(40, 445, 100, 75), Color(0, 0, 0, 0.25))
    draw_rect(Rect2(155, 445, 100, 75), Color(0, 0, 0, 0.25))
    draw_rect(Rect2(830, 445, 100, 75), Color(0, 0, 0, 0.25))
    draw_string(ThemeDB.fallback_font, Vector2(72, 495), "<", HORIZONTAL_ALIGNMENT_LEFT, -1, 40, Color.WHITE)
    draw_string(ThemeDB.fallback_font, Vector2(188, 495), ">", HORIZONTAL_ALIGNMENT_LEFT, -1, 40, Color.WHITE)
    draw_string(ThemeDB.fallback_font, Vector2(850, 495), "JUMP", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color.WHITE)

func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        var pos: Vector2 = (event as InputEventScreenTouch).position
        if event.pressed:
            if pos.x < 140.0 and pos.y > 420.0:
                left_pressed = true
            elif pos.x < 265.0 and pos.y > 420.0:
                right_pressed = true
            elif pos.x > 800.0 and pos.y > 420.0:
                jump_requested = true
        else:
            left_pressed = false
            right_pressed = false
