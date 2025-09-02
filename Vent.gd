# Fan.gd
extends Node2D

@export var wind_dir: Vector2 = Vector2(1, 0)   # rüzgâr yönü (sağa)
@export var force: float = 900.0                # itiş kuvveti
@export var only_gas := true                    # sadece gaz fazını itsin mi?

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $WindArea           # AĞAÇTA bu isimle olmalı

var _bodies: Array[CharacterBody2D] = []

func _ready():
	anim.play("default")                        # animasyon adın farklıysa değiştir
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D:
		_bodies.append(body)

func _on_body_exited(body):
	_bodies.erase(body)

func _physics_process(delta):
	if _bodies.is_empty(): return
	var push: Vector2 = wind_dir.normalized() * (force * delta)
	for b in _bodies:
		if only_gas and b.has_method("is_gas") and not b.is_gas():
			continue
		b.velocity += push
