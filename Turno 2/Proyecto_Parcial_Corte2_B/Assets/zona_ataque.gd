extends Area3D

@export var dano: float = 25.0
@export var duracion_activa: float = 0.15
@onready var forma: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	forma.set_deferred("disabled", true)
	body_entered.connect(_al_entrar)

func _unhandled_input(evento: InputEvent) -> void:
	if evento.is_action_pressed("atacar"):
		activar()

func activar() -> void:
	forma.set_deferred("disabled", false)
	await get_tree().create_timer(duracion_activa).timeout
	forma.set_deferred("disabled", true)

func _al_entrar(cuerpo_enemigo: Node3D) -> void:
	if cuerpo_enemigo.has_method("recibir_dano"):
		cuerpo_enemigo.recibir_dano(dano)
		var jugador := get_tree().get_first_node_in_group("player")
		var camara := jugador.get_node_or_null("SpringArm3D")
		if camara != null and camara.has_method("sacudir"):
			camara.sacudir(0.15, 0.2)
