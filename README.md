# Repton Returns

A 3D isometric remake of the classic **Repton** puzzle game, built in **Godot 4.6** with GDScript.

## How to Play

### Objective

Navigate grid-based levels, collecting **all diamonds, crowns, and eggs**, killing **all monsters**, then reaching the **bomb** to defuse it and complete the level.

### Controls

| Key | Action |
|-----|--------|
| W / Up Arrow | Move forward |
| S / Down Arrow | Move back |
| A / Left Arrow | Move left |
| D / Right Arrow | Move right |

Movement is grid-based (one cell at a time) with smooth interpolation.

### Core Mechanics

- **Dig through earth** — walk into earth tiles to clear them.
- **Push rocks/eggs** — shove them horizontally if the space behind is empty.
- **Collect diamonds** — the primary collectible; all must be gathered to complete a level.
- **Collect keys** — a key converts all **safes** into diamonds; colored keys open matching colored doors.
- **Time capsules** — extend the level's countdown timer by 30 seconds.
- **Transporters** — teleport you to a paired transporter elsewhere in the level.

### Hazards

You have **3 lives**. The following cost a life:

- **Falling rocks/eggs** — rocks and eggs obey gravity; they fall if unsupported and slide off rounded surfaces. Getting crushed kills you.
- **Monsters** — hatch from cracked eggs (eggs that free-fall 2+ cells) or start in the level. They chase you with simple pathfinding.
- **Spirits** — follow walls using a left-hand rule. Kill on contact, but entering a **cage** converts them into a diamond.
- **Skulls & Fungus** — instant death on contact.
- **Time bomb** — some levels have a countdown; run out and it's game over.

### Win / Lose Conditions

| Win | Lose |
|-----|------|
| Collect all diamonds, crowns, eggs | Crushed by falling object |
| Kill all monsters | Touched by monster, spirit, skull, or fungus |
| Reach and defuse the bomb | Timer runs out |
| | Lose all 3 lives |

## Project Structure

```
scripts/
  game.gd            # Game orchestrator and state management
  level.gd            # Level loading and map management
  piece_factory.gd    # Object creation factory
  pieces/
    piece.gd          # Base class for all grid objects
    movable.gd        # Adds interpolated movement and direction tracking
    repton.gd         # Player controller
    fallable.gd       # Gravity and falling/sliding logic (rocks, eggs)
    rock.gd           # Rock piece
    egg.gd            # Egg piece (cracks into a monster after free fall)
    monster.gd        # Monster AI (seeks player)
    spirit.gd         # Spirit AI (wall-following, left-hand rule)
    diamond.gd        # Diamond collectible
    earth.gd          # Diggable terrain
    wall.gd           # Wall variants
levels/
  Level 1.rrl         # Level data (30x30 grid)
models/
  ReptonReturnsFbx.fbx  # 3D models
```

## Level Format (.rrl)

Levels are stored as text files with the following structure:

```
ReptonReturnsLevelV1.1
[Level Name]
[Time limit in seconds, or -1 for unlimited]
[Map width],[Map height]
[Map data — one character per grid cell, one row per line]
[Transporter coordinates]
[Messages data]
[Navigation map]
[Colored key-to-door mapping]
```

### Map Characters

| Char | Piece | Char | Piece |
|------|-------|------|-------|
| `i` | Player start | `d` | Diamond |
| `e` | Earth | `r` | Rock |
| `g` | Egg | `m` | Monster |
| `p` | Spirit | `c` | Cage |
| `s` | Safe | `k` | Key |
| `b` | Bomb (goal) | `u` | Skull |
| `f` | Fungus | `t` | Crown |
| `n` | Transporter | `z` | Time Capsule |
| `a` | Barrier | `x` | Message |
| `C` | Colored Key | `D` | Colored Door |
| `1`–`9`, `%`, `&`, `(`, `!` | Wall variants | `.` | Empty |

## Requirements

- Godot 4.6+
- Jolt Physics (configured in project settings)
