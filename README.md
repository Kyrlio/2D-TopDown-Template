# 2D Top-Down Template

A 2D top-down action game created with Godot, featuring a melee combat system with different weapons and enemies.

![Godot Version](https://img.shields.io/badge/Godot-4.4-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📋 Description

This project is a 2D top-down action game template with a rich combat system including multiple weapon types, combos, a dash system, and visual effects. The player can fight enemies with different weapons like a sword, double axe, or magic wand.

## ✨ Features

### Combat System
- **Multiple weapons**: Sword, double axe, magic wand
- **Combo system**: Attack chaining for each weapon
- **Slash effects**: Visual animations during attacks
- **Magic projectiles**: Projectile shooting with the magic wand

### Game Mechanics
- **Fluid movement**: WASD/Arrow controls with acceleration and friction
- **Dash system**: Quick movement with spacebar and cooldown
- **Health system**: Health points for player and enemies
- **Knockback**: Recoil effects on impact
- **Death particles**: Visual effects when enemies are destroyed

### Enemy System
- **Basic AI**: Enemies follow the player
- **Damage system**: Enemies can hurt the player
- **Animations**: Walking and attack animations

### Visual Effects
- **Damage flash shader**: Visual effect when taking damage
- **Run particles**: Effects during fast movement
- **Dynamic camera**: Smooth player following

## 🎮 Controls

| Action | Key |
|--------|-----|
| Movement | `WASD` or `Arrow keys` |
| Attack | `Left Click` |
| Dash | `Space` |

## 📁 Project Structure

```
├── assets/                 # Graphic resources
│   ├── entities/          # Character sprites
│   ├── weapons/           # Weapon sprites
│   └── world/             # Environment elements
├── scenes/                # Godot scenes (.tscn)
│   ├── player.tscn        # Player scene
│   ├── enemy.tscn         # Enemy scene
│   ├── sword.tscn         # Sword weapon
│   ├── double_axe.tscn    # Double axe weapon
│   ├── magic_wand.tscn    # Magic wand weapon
│   └── test_level.tscn    # Test level
└── scripts/               # GDScript files (.gd)
    ├── player.gd          # Player logic
    ├── enemy.gd           # Enemy logic
    ├── weapon.gd          # Weapon base class
    ├── sword.gd           # Sword logic
    ├── double_axe.gd      # Double axe logic
    └── magic_wand.gd      # Magic wand logic
```

## 🛠️ Installation and Usage

### Prerequisites
- [Godot 4.4](https://godotengine.org/download) or later

### Installation
1. Clone the repository:
```bash
git clone https://github.com/Kyrlio/2D-TopDown-Template.git
```

2. Open Godot and import the project by selecting the `project.godot` file

3. Run the game by pressing `F5` or clicking the "Play" button

## 🎯 Main Classes

### Player (player.gd)
- Movement management with acceleration/friction
- Dash system with speed curve
- Health and damage management
- Integration with weapon system

### Weapon (weapon.gd)
- Base class for all weapons
- Configurable combo system
- Attack cooldown management
- Signals for player communication

### Enemy (enemy.gd)
- Player following AI
- Collision and damage system
- Knockback effects
- Contextual animations

## 🔧 Customization

### Adding a New Weapon
1. Create a new scene inheriting from `Weapon`
2. Implement the `perform_attack()` method
3. Configure animations and effects
4. Add specific logic in a dedicated script

### Modifying Parameters
Exported variables allow easy modification of:
- Player movement speed
- Weapon damage
- Combo duration
- Dash distance and speed

## 📝 License

This project is under MIT license. See the [LICENSE](LICENSE) file for more details.
