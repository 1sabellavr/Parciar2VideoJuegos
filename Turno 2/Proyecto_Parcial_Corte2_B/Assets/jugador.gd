extends CharacterBody3D

## Velocidad máxima de desplazamiento, en metros por segundo.
@export var speed: float = 4.0
## Cámara que define qué es "adelante". Si se deja vacía se usa la activa.
@export var camara: Camera3D

@export var turn_speed: float = 12.0
@export var fuerzaSalto: float = 4.5
@export var friccion: float = 20.0
@export var aceleracion: float = 12.0


func _ready() -> void:
	if camara == null:
		camara = get_viewport().get_camera_3d()


func _physics_process(delta: float) -> void:
	# Gravedad y salto
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	elif Input.is_action_just_pressed("jump"):
		velocity.y = fuerzaSalto
	
	# --- Horizontal: hacia dónde quiere ir ------------------------------
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var entrada := Vector3(input_dir.x, 0.0, input_dir.y)

	# Movimiento relativo a la cámara (mismo patrón de la Sesión 8/9).
	var direction := camara.global_basis * entrada
	direction.y = 0.0
	direction = direction.normalized()
	
	var objetivo := direction * speed
	var ritmo := aceleracion if direction.length() > 0.1 else friccion

	# TODO (Tarea 3): esto asigna la velocidad DE GOLPE. Reemplazar por
	# move_toward con aceleración y fricción, como en la Sesión 9.
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# TODO (Tarea 2): falta la función de salto completa. Todavía no hay
	# gravedad ni velocity.y en absoluto — por eso caminar funciona bien
	# aunque no exista ningún piso en la escena.

	move_and_slide()
