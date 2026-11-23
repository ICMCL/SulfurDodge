"""Procedural voxel builder for Sulfur Dodge's Sakura Cloud Courtyard (`樱庭云阶浮岛`).

Writes the stratified tuff/calcite floating island, jade lotus moats, gnarled sakura trees,
flanking drum pavilions, south pergola, and north overlook pavilion directly into Minecraft 26.3
Anvil `.mca` chunks (`world/`), while recording dynamic match reset slices (`arena/floor.mcfunction`
and `arena/perimeter.mcfunction`) from a single source of truth.
"""
from __future__ import annotations

import math
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
for _cand in (ROOT.parent / "mcbeef" / "src", ROOT.parent / "mcbeef", ROOT.parent):
    if (_cand / "mcbeef" / "__init__.py").is_file() and str(_cand) not in sys.path:
        sys.path.insert(0, str(_cand))

from mcbeef.anvil import write_world_save
from mcbeef.builder import VoxelBuilder
from mcbeef.project import MapProjectConfig


def add_sakura_tree(
    b: VoxelBuilder,
    base_x: int,
    base_y: int,
    base_z: int,
    lean_x: int = 0,
    lean_z: int = 0,
    height: int = 6,
) -> None:
    """Build a gnarled blooming cherry tree with layered pink blossom clouds."""
    cx, cz = float(base_x), float(base_z)
    for step in range(height):
        t = step / max(1, height - 1)
        tx = int(round(cx + lean_x * (t ** 1.35)))
        tz = int(round(cz + lean_z * (t ** 1.35)))
        b.setblock(tx, base_y + step, tz, "cherry_log[axis=y]", record_cmd=False)
        if step == height - 2:
            b.setblock(tx + (1 if lean_x >= 0 else -1), base_y + step, tz, "cherry_wood", record_cmd=False)

    top_x = int(round(cx + lean_x))
    top_y = base_y + height
    top_z = int(round(cz + lean_z))
    leaf = "cherry_leaves[persistent=true]"

    # Layered wide sakura canopy clouds (lower skirt, main crown, upper dome)
    for dy, rx, rz in ((-1, 3.2, 3.2), (0, 3.8, 3.8), (1, 2.9, 2.9), (2, 1.7, 1.7)):
        rxi = int(math.ceil(rx))
        rzi = int(math.ceil(rz))
        for dx in range(-rxi, rxi + 1):
            for dz in range(-rzi, rzi + 1):
                dist = math.hypot(dx / rx, dz / rz)
                wobble = 0.12 * math.sin((top_x + dx) * 1.3 + (top_z + dz) * 0.9)
                if dist + wobble <= 1.0:
                    lx, ly, lz = top_x + dx, top_y + dy, top_z + dz
                    if (lx, ly, lz) not in b.voxels:
                        b.setblock(lx, ly, lz, leaf, record_cmd=False)

    # Soft hanging blossom tendrils on outer rim
    for ang_deg in (25, 115, 205, 295):
        rad = math.radians(ang_deg)
        hx = top_x + int(round(math.cos(rad) * 3.1))
        hz = top_z + int(round(math.sin(rad) * 3.1))
        if (hx, top_y - 2, hz) not in b.voxels:
            b.setblock(hx, top_y - 2, hz, leaf, record_cmd=False)


def build_island_and_gardens(b: VoxelBuilder) -> None:
    # 1. Stratified organic cloud-stone floating island (y = 55 .. 63), centered at (0, -2)
    b.tapered_island(
        center_x=0.0,
        center_z=-2.0,
        y_bottom=55,
        y_top=63,
        rx_bottom=14.5,
        rz_bottom=13.0,
        rx_top=27.0,
        rz_top=24.5,
        layer_materials=[
            "deepslate",
            "cobbled_deepslate",
            "tuff",
            "tuff_bricks",
            "polished_tuff",
            "calcite",
            "moss_block",
        ],
        wave_amp=0.065,
    )

    # Calcite & polished-tuff stepped courtyard terrace plinth around the 29x21 arena
    b.fill(-18, 63, -22, 18, 63, 15, "polished_tuff", record_cmd=False)
    b.fill(-17, 63, -13, 17, 63, 13, "calcite", record_cmd=False)

    # Hidden inventory stash vault sealed beneath arena center (0, 58, 0)
    b.fill(-1, 57, -1, 1, 59, 1, "polished_deepslate", record_cmd=False)
    b.setblock(0, 58, 0, "chest", record_cmd=False)

    # Solid sub-floor directly under the 29x21 court (y = 63)
    b.fill(-15, 63, -11, 15, 63, 11, "polished_deepslate", record_cmd=False)

    # 2. Recessed Jade Lotus & Lantern Moats on West, East & South garden wings (y = 62..63)
    for x1, z1, x2, z2 in ((-23, -8, -19, 8), (19, -8, 23, 8), (-12, 16, 12, 19)):
        b.fill(x1 - 1, 62, z1 - 1, x2 + 1, 63, z2 + 1, "tuff_bricks", record_cmd=False)
        b.fill(x1, 61, z1, x2, 61, z2, "prismarine_bricks", record_cmd=False)
        b.fill(x1, 62, z1, x2, 63, z2, "water", record_cmd=False)

    for lx, lz in ((-21, -5), (-21, 0), (-21, 5), (21, -5), (21, 0), (21, 5), (-6, 17), (0, 17), (6, 17)):
        b.setblock(lx, 61, lz, "sea_lantern", record_cmd=False)
    # Submerged calcite stepping lantern pedestals inside the jade moats
    for px, pz in ((-21, -2), (-21, 2), (21, -2), (21, 2)):
        b.setblock(px, 62, pz, "calcite", record_cmd=False)
        b.setblock(px, 63, pz, "pearlescent_froglight", record_cmd=False)

    # 3. West (Crimson) & East (Warped/Azure) Pagoda Drum Towers (x = -18..-16 & +16..+18, z = -3..3)
    for side, x0, x1, trim_plank, roof_slab, banner in (
        ("red", -18, -16, "crimson_planks", "crimson_slab[type=bottom]", "red_banner[rotation=12]"),
        ("blue", 16, 18, "warped_planks", "warped_slab[type=bottom]", "blue_banner[rotation=4]"),
    ):
        b.fill(x0, 64, -3, x1, 64, 3, "tuff_bricks", record_cmd=False)
        b.fill(x0, 65, -2, x1, 65, 2, "calcite", record_cmd=False)
        for px in (x0, x1):
            for pz in (-3, 3):
                b.fill(px, 65, pz, px, 69, pz, "stripped_dark_oak_log[axis=y]", record_cmd=False)
        b.fill(x0, 69, -3, x1, 69, 3, trim_plank, record_cmd=False)
        b.fill(x0 - 1, 70, -4, x1 + 1, 70, 4, "dark_oak_slab[type=bottom]", record_cmd=False)
        b.fill(x0, 70, -3, x1, 70, 3, "dark_oak_planks", record_cmd=False)
        b.fill(x0, 71, -2, x1, 71, 2, roof_slab, record_cmd=False)
        for cx in (x0 - 1, x1 + 1):
            for cz in (-4, 4):
                b.setblock(cx, 70, cz, "dark_oak_slab[type=top]", record_cmd=False)
        mid_x = (x0 + x1) // 2
        b.setblock(mid_x, 68, 0, "pearlescent_froglight", record_cmd=False)
        face_x = x1 if side == "red" else x0
        b.setblock(face_x, 71, 0, banner, record_cmd=False)

    # 4. South Sakura Viewing Terrace & Striped Pergola (z = 12..15, x = -11..11)
    b.fill(-12, 64, 12, 12, 64, 15, "tuff_bricks", record_cmd=False)
    b.fill(-11, 64, 12, 11, 64, 13, "pale_oak_planks", record_cmd=False)
    b.fill(-11, 65, 14, 11, 65, 15, "pale_oak_planks", record_cmd=False)
    for px in (-11, -6, 0, 6, 11):
        b.fill(px, 65, 15, px, 69, 15, "stripped_cherry_log[axis=y]", record_cmd=False)
        b.setblock(px, 64, 12, "pearlescent_froglight", record_cmd=False)
    for x in range(-12, 13):
        canopy = "cherry_planks" if (x // 2) % 2 == 0 else "calcite"
        b.fill(x, 70, 13, x, 70, 15, canopy, record_cmd=False)

    # 5. Six Blooming Gnarled Sakura Trees & Azalea Moss Planters framing the island
    sakura_specs = [
        (-21, 64, -14, -1, -1, 6),
        (21, 64, -14, 1, -1, 6),
        (-20, 64, 12, -2, 1, 6),
        (20, 64, 12, 2, 1, 6),
        (-16, 64, 17, -1, 1, 5),
        (16, 64, 17, 1, 1, 5),
    ]
    for sx, sy, sz, lx, lz, h in sakura_specs:
        b.fill(sx - 1, sy - 1, sz - 1, sx + 1, sy - 1, sz + 1, "moss_block", record_cmd=False)
        add_sakura_tree(b, sx, sy, sz, lean_x=lx, lean_z=lz, height=h)
    for ax, az in ((-19, -12), (19, -12), (-18, 11), (18, 11)):
        b.setblock(ax, 64, az, "flowering_azalea_leaves[persistent=true]", record_cmd=False)


def build_perimeter_slice(b: VoxelBuilder) -> list[str]:
    """Build low 3-block sculpted courtyard walls (y=64..66) + invisible upper barrier containment (y=67..70)."""
    b.clear_cmds()
    with b.record_commands():
        # Base & body (y = 64..65): tuff_bricks (immune to paintable_floor)
        b.walls_rect(-15, 64, -11, 15, 65, 11, "tuff_bricks")
        # Top coping (y = 66): polished_tuff + team timber trim on West/East
        b.walls_rect(-15, 66, -11, 15, 66, 11, "polished_tuff")
        b.fill(-15, 66, -5, -15, 66, 5, "crimson_planks")
        b.fill(15, 66, -5, 15, 66, 5, "warped_planks")

        # Corner pilasters & flush pearlescent froglight coping lanterns
        for cx in (-15, 15):
            for cz in (-11, 11):
                b.fill(cx, 64, cz, cx, 66, cz, "polished_deepslate")
                b.setblock(cx, 66, cz, "pearlescent_froglight")
        for lx in (-8, 8):
            b.setblock(lx, 66, -11, "pearlescent_froglight")
            b.setblock(lx, 66, 11, "pearlescent_froglight")
        b.setblock(-15, 66, 0, "pearlescent_froglight")
        b.setblock(15, 66, 0, "pearlescent_froglight")

        # North & South Center Spawner Shrines (z = -11 & z = +11)
        for sz in (-11, 11):
            b.fill(-1, 65, sz, 1, 66, sz, "chiseled_tuff")
            b.setblock(0, 66, sz, "pearlescent_froglight")

        # Invisible upper containment walls (y = 67..70) so balls bounce while sunlight pours in
        b.walls_rect(-15, 67, -11, 15, 70, 11, "barrier")

    # Static invisible ceiling at y = 71 over the 29x21 court (prevents wind_charge vertical ejection)
    b.fill(-15, 71, -11, 15, 71, 11, "barrier", record_cmd=False)
    return b.clear_cmds()


def build_floor_slice(b: VoxelBuilder) -> list[str]:
    """Build the 29x21 Zen Stone Courtyard paintable floor (y=64), all blocks in `#sc:paintable_floor`."""
    b.clear_cmds()
    with b.record_commands():
        # Base Zen raked stone canvas
        b.fill(-14, 64, -10, 14, 64, 10, "light_gray_concrete")

        # Outer courtyard stone border & subtle geometric Zen garden inlays (only tuff/calcite/light_gray_concrete -> 100% paintable!)
        b.fill(-14, 64, -10, 14, 64, -10, "tuff")
        b.fill(-14, 64, 10, 14, 64, 10, "tuff")
        b.fill(-14, 64, -10, -14, 64, 10, "tuff")
        b.fill(14, 64, -10, 14, 64, 10, "tuff")

        # Pale calcite raked-sand inner court rings & central medallion
        b.fill(-13, 64, -9, 13, 64, -9, "calcite")
        b.fill(-13, 64, 9, 13, 64, 9, "calcite")
        b.fill(-5, 64, -5, 5, 64, 5, "calcite")
        b.fill(-4, 64, -4, 4, 64, 4, "light_gray_concrete")
        b.fill(-2, 64, -2, 2, 64, 2, "tuff")
        b.fill(-1, 64, -1, 1, 64, 1, "calcite")
        b.fill(0, 64, -8, 0, 64, 8, "calcite")

        # Tuff plinth rings around the 4 amethyst bumper positions (±3, ±3)
        for bx in (-3, 3):
            for bz in (-3, 3):
                b.setblock(bx, 64, bz, "tuff")

        # Initial 3x5 Red (West) & Blue (East) Team Home Zones (unprotected — paintable by enemy balls!)
        b.fill(-12, 64, -2, -10, 64, 2, "red_concrete")
        b.fill(10, 64, -2, 12, 64, 2, "blue_concrete")

    # Initial preview obstacles in `.mca` world (also refreshed by `reset_round` on match start)
    for fx in (-7, 7):
        for fz1, fz2 in ((-6, -4), (4, 6)):
            b.fill(fx, 65, fz1, fx, 66, fz2, "polished_tuff", record_cmd=False)
            b.fill(fx, 67, fz1, fx, 68, fz2, "barrier", record_cmd=False)
    for bx in (-3, 3):
        for bz in (-3, 3):
            b.setblock(bx, 65, bz, "amethyst_block", record_cmd=False)
            b.setblock(bx, 66, bz, "budding_amethyst", record_cmd=False)
            b.fill(bx, 67, bz, bx, 68, bz, "barrier", record_cmd=False)

    return b.clear_cmds()


def build_north_sakura_lobby(b: VoxelBuilder) -> None:
    """Build the elevated North Sakura Overlook Pavilion (deck y=68, standing y=69/70, z=-22..-12)."""
    # Stepped tuff-brick & calcite pavilion foundation (z = -22 .. -12, y = 64 .. 68)
    b.fill(-16, 64, -22, 16, 67, -12, "tuff_bricks", record_cmd=False)
    b.fill(-16, 68, -22, 16, 68, -12, "polished_tuff", record_cmd=False)
    b.fill(-15, 68, -20, 15, 68, -14, "calcite", record_cmd=False)

    # Front pale-oak veranda boardwalk overlooking the open-air court (z = -13 .. -12)
    b.fill(-15, 68, -13, 15, 68, -12, "pale_oak_planks", record_cmd=False)
    for lx in (-12, -6, 0, 6, 12):
        b.setblock(lx, 68, -12, "pearlescent_froglight", record_cmd=False)

    # Central 3x3 raised spawn dais (standing height Y = 70.0 at 0.5, 70, -16.5)
    b.fill(-3, 68, -19, 3, 68, -14, "polished_tuff", record_cmd=False)
    b.fill(-1, 69, -17, 1, 69, -15, "calcite", record_cmd=False)

    # West Red Team Sakura Gazebo (x = -11 .. -8, z = -17 .. -14, standing y = 69)
    b.fill(-11, 68, -17, -8, 68, -14, "red_concrete", record_cmd=False)
    for px in (-11, -8):
        for pz in (-17, -14):
            b.fill(px, 69, pz, px, 72, pz, "stripped_cherry_log[axis=y]", record_cmd=False)
    for x in range(-12, -7):
        mat = "red_concrete" if x % 2 == 0 else "white_concrete"
        b.fill(x, 73, -18, x, 73, -13, mat, record_cmd=False)

    # East Blue Team Sakura Gazebo (x = +8 .. +11, z = -17 .. -14, standing y = 69)
    b.fill(8, 68, -17, 11, 68, -14, "blue_concrete", record_cmd=False)
    for px in (8, 11):
        for pz in (-17, -14):
            b.fill(px, 69, pz, px, 72, pz, "stripped_cherry_log[axis=y]", record_cmd=False)
    for x in range(7, 13):
        mat = "blue_concrete" if x % 2 == 0 else "white_concrete"
        b.fill(x, 73, -18, x, 73, -13, mat, record_cmd=False)

    # East-wing Spectator Opt-out Pad (x = 13..14, z = -17..-15, standing y = 69)
    b.fill(13, 68, -17, 14, 68, -15, "light_gray_concrete", record_cmd=False)

    # Sakura & azalea moss planters flanking the pavilion back corners
    for fx1, fx2 in ((-15, -13), (13, 15)):
        b.fill(fx1, 69, -19, fx2, 69, -19, "moss_block", record_cmd=False)
        b.setblock((fx1 + fx2) // 2, 70, -19, "flowering_azalea_leaves[persistent=true]", record_cmd=False)

    # North Sakura Timber & Calcite Pavilion Backwall (z = -21, x = -15 .. +15, y = 69 .. 74)
    # Note: central bay x = -4..+4 has NO protruding lamps so `wall_signboard_cmd` sits 100% clear!
    b.fill(-15, 69, -21, 15, 74, -21, "calcite", record_cmd=False)
    b.fill(-15, 72, -21, 15, 72, -21, "polished_tuff", record_cmd=False)
    b.fill(-15, 74, -21, 15, 74, -21, "stripped_dark_oak_log[axis=x]", record_cmd=False)
    for px in (-15, -10, -5, 5, 10, 15):
        b.fill(px, 69, -21, px, 74, -21, "stripped_dark_oak_log[axis=y]", record_cmd=False)
        b.setblock(px, 73, -20, "pearlescent_froglight", record_cmd=False)

    # Curved East-Asian Pagoda Eave & Cherry Ridge Crown (z = -22 .. -19, y = 75 .. 76)
    b.fill(-16, 75, -22, 16, 75, -20, "dark_oak_planks", record_cmd=False)
    b.fill(-16, 75, -19, 16, 75, -19, "dark_oak_slab[type=bottom]", record_cmd=False)
    for cx in (-17, 17):
        b.fill(cx, 75, -22, cx, 75, -20, "dark_oak_slab[type=top]", record_cmd=False)
        b.setblock(cx, 76, -19, "dark_oak_slab[type=bottom]", record_cmd=False)
    b.fill(-14, 76, -21, 14, 76, -21, "cherry_planks", record_cmd=False)
    b.fill(-12, 76, -20, 12, 76, -20, "cherry_slab[type=bottom]", record_cmd=False)

    # Invisible safety barriers around North Pavilion (open sky overhead!)
    b.fill(-16, 69, -22, 16, 75, -22, "barrier", record_cmd=False)
    b.fill(-16, 69, -22, -16, 75, -11, "barrier", record_cmd=False)
    b.fill(16, 69, -22, 16, 75, -11, "barrier", record_cmd=False)
    b.fill(-15, 69, -11, 15, 74, -11, "barrier", record_cmd=False)

    # Interactive lobby controls: Start button in the center of the raised dais, Lectern on the dais's court-side edge facing north
    b.setblock(0, 69, -16, "emerald_block", record_cmd=False)
    b.setblock(0, 70, -16, "stone_button[face=floor,facing=south]", record_cmd=False)
    b.setblock(0, 70, -15, "lectern[facing=north]", record_cmd=False)


def build_voxel_world() -> tuple[VoxelBuilder, list[str], list[str]]:
    b = VoxelBuilder()
    build_island_and_gardens(b)
    perimeter_cmds = build_perimeter_slice(b)
    floor_cmds = build_floor_slice(b)
    build_north_sakura_lobby(b)
    return b, floor_cmds, perimeter_cmds


def build_template_world(world_dir: Path | None = None, cfg: MapProjectConfig | None = None) -> Path:
    proj = cfg or MapProjectConfig.load(ROOT)
    target = world_dir or (ROOT / "world")
    builder, floor_cmds, perimeter_cmds = build_voxel_world()

    builder.write_mcfunction(
        ROOT / "data" / proj.namespace / "function" / "arena" / "floor.mcfunction",
        floor_cmds,
        header="29×21 枯山水可染石庭地面每局重置（自动由 tools/build_map.py 导出）",
    )
    builder.write_mcfunction(
        ROOT / "data" / proj.namespace / "function" / "arena" / "perimeter.mcfunction",
        perimeter_cmds,
        header="29×21 樱庭 3 格雕花矮墙与上层隐形屏障重置（自动由 tools/build_map.py 导出）",
    )

    write_world_save(
        target,
        builder.voxels,
        level_name=proj.title,
        spawn_pos=proj.spawn_pos,
        spawn_yaw=proj.spawn_yaw,
        spawn_pitch=proj.spawn_pitch,
        biome=proj.biome,
        datapack_names=[proj.slug],
        noon_ticks=6000,
    )
    return target


if __name__ == "__main__":
    out = build_template_world()
    print(f"Generated 26.3 Anvil world at {out}")
