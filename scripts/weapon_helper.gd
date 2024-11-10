extends Node

enum WEAPONS {
	MERCURY,
	VENUS,
	EARTH,
	MARS,
	JUPITER,
	SATURN,
	URANUS,
	NEPTUNE,
}

class Weapon:
	var type: WEAPONS
	var level: int

const WEAPON_DATA = {
	WEAPONS.MERCURY: {
		name = "Mercury",
		cooldown = [10],
		pos = [Vector2.ZERO],
	},
	WEAPONS.VENUS: {
		name = "Venus",
		cooldown = [1],
		pos = [Vector2.ZERO],
	}
}
