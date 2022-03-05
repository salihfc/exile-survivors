extends Sprite

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const SPEED = 2000.0

### EXPORT ###
export(float) var projectile_damage := 10.0

### PUBLIC VAR ###
var velocity := Vector2.ZERO

### PRIVATE VAR ###


### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###
func _physics_process(delta: float) -> void:
	global_position += velocity * delta


### PUBLIC FUNCTIONS ###
func set_dir(dir : Vector2) -> void:
	velocity = dir.normalized() * SPEED

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Enemy:
		var enemy := body as Enemy
		enemy.take_damage(projectile_damage)
