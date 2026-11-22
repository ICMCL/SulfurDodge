# ===== 最后 30 秒四面高弹外墙逐圈向内推进合拢（共 6 阶段，y=64..70 整墙内推，自动将贴墙玩家与硫方怪推向场内，发球口同步内移） =====
scoreboard players add #collapse_stage sc_var 1

# 1. 根据当前缩墙阶段设定安全内场边界（单位 0.001 格）与新南北侧墙发球口坐标
execute if score #collapse_stage sc_var matches 1 run scoreboard players set #min_x sc_var -11450
execute if score #collapse_stage sc_var matches 1 run scoreboard players set #max_x sc_var 12450
execute if score #collapse_stage sc_var matches 1 run scoreboard players set #min_z sc_var -8450
execute if score #collapse_stage sc_var matches 1 run scoreboard players set #max_z sc_var 9450
execute if score #collapse_stage sc_var matches 1 run data modify storage sc:tmp lz set value {zn:-8.2d,zs:9.2d,wn:-8.6d,ws:9.6d}

execute if score #collapse_stage sc_var matches 2 run scoreboard players set #min_x sc_var -9450
execute if score #collapse_stage sc_var matches 2 run scoreboard players set #max_x sc_var 10450
execute if score #collapse_stage sc_var matches 2 run scoreboard players set #min_z sc_var -7450
execute if score #collapse_stage sc_var matches 2 run scoreboard players set #max_z sc_var 8450
execute if score #collapse_stage sc_var matches 2 run data modify storage sc:tmp lz set value {zn:-7.2d,zs:8.2d,wn:-7.6d,ws:8.6d}

execute if score #collapse_stage sc_var matches 3 run scoreboard players set #min_x sc_var -8450
execute if score #collapse_stage sc_var matches 3 run scoreboard players set #max_x sc_var 9450
execute if score #collapse_stage sc_var matches 3 run scoreboard players set #min_z sc_var -6450
execute if score #collapse_stage sc_var matches 3 run scoreboard players set #max_z sc_var 7450
execute if score #collapse_stage sc_var matches 3 run data modify storage sc:tmp lz set value {zn:-6.2d,zs:7.2d,wn:-6.6d,ws:7.6d}

execute if score #collapse_stage sc_var matches 4 run scoreboard players set #min_x sc_var -7450
execute if score #collapse_stage sc_var matches 4 run scoreboard players set #max_x sc_var 8450
execute if score #collapse_stage sc_var matches 4 run scoreboard players set #min_z sc_var -5450
execute if score #collapse_stage sc_var matches 4 run scoreboard players set #max_z sc_var 6450
execute if score #collapse_stage sc_var matches 4 run data modify storage sc:tmp lz set value {zn:-5.2d,zs:6.2d,wn:-5.6d,ws:6.6d}
# 第 4 圈收回固定障碍，避免在推进的外墙旁留下夹缝。这不是击球破坏。
execute if score #collapse_stage sc_var matches 4 if score #o_layout sc_var matches 0..1 run function sc:arena/fixed_walls {wall:"air replace stone_bricks",cap:"air replace barrier"}

execute if score #collapse_stage sc_var matches 5 run scoreboard players set #min_x sc_var -6450
execute if score #collapse_stage sc_var matches 5 run scoreboard players set #max_x sc_var 7450
execute if score #collapse_stage sc_var matches 5 run scoreboard players set #min_z sc_var -4450
execute if score #collapse_stage sc_var matches 5 run scoreboard players set #max_z sc_var 5450
execute if score #collapse_stage sc_var matches 5 run data modify storage sc:tmp lz set value {zn:-4.2d,zs:5.2d,wn:-4.6d,ws:5.6d}

execute if score #collapse_stage sc_var matches 6 run scoreboard players set #min_x sc_var -5450
execute if score #collapse_stage sc_var matches 6 run scoreboard players set #max_x sc_var 6450
execute if score #collapse_stage sc_var matches 6 run scoreboard players set #min_z sc_var -3450
execute if score #collapse_stage sc_var matches 6 run scoreboard players set #max_z sc_var 4450
execute if score #collapse_stage sc_var matches 6 run data modify storage sc:tmp lz set value {zn:-3.2d,zs:4.2d,wn:-3.6d,ws:4.6d}

# 2. 先碾碎外圈即将被墙体覆盖的玩家自建墙，并将处于合拢墙带内的存活玩家与硫方怪平滑推向场内，彻底杜绝卡墙窒息！
execute as @e[type=marker,tag=sc_pwall] at @s run function sc:arena/pwall_shrink_check
execute as @a[tag=sc_alive] at @s run function sc:arena/clamp_inward
execute as @e[type=sulfur_cube,tag=sc_ball] at @s run function sc:arena/clamp_inward

# 3. 砌筑四面合拢高弹实体墙 (y=64..70 整体推进，自动覆盖外圈旧地板使其退出面积统计，并在新内壁镶嵌中线发球口与照明灯)
# 阶段 1 (30s -> 内场 25×19: x=-12..12, z=-9..9)
execute if score #collapse_stage sc_var matches 1 run fill -14 64 -10 -13 70 10 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 1 run fill 13 64 -10 14 70 10 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 1 run fill -12 64 -10 12 70 -10 quartz_bricks
execute if score #collapse_stage sc_var matches 1 run fill -12 64 10 12 70 10 quartz_bricks
execute if score #collapse_stage sc_var matches 1 run setblock 0 65 -10 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 1 run setblock 0 66 -10 sea_lantern
execute if score #collapse_stage sc_var matches 1 run setblock 0 65 10 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 1 run setblock 0 66 10 sea_lantern
execute if score #collapse_stage sc_var matches 1 run setblock -13 69 0 sea_lantern
execute if score #collapse_stage sc_var matches 1 run setblock 13 69 0 sea_lantern

# 阶段 2 (25s -> 内场 21×17: x=-10..10, z=-8..8)
execute if score #collapse_stage sc_var matches 2 run fill -12 64 -9 -11 70 9 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 2 run fill 11 64 -9 12 70 9 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 2 run fill -10 64 -9 10 70 -9 quartz_bricks
execute if score #collapse_stage sc_var matches 2 run fill -10 64 9 10 70 9 quartz_bricks
execute if score #collapse_stage sc_var matches 2 run setblock 0 65 -9 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 2 run setblock 0 66 -9 sea_lantern
execute if score #collapse_stage sc_var matches 2 run setblock 0 65 9 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 2 run setblock 0 66 9 sea_lantern
execute if score #collapse_stage sc_var matches 2 run setblock -11 69 0 sea_lantern
execute if score #collapse_stage sc_var matches 2 run setblock 11 69 0 sea_lantern

# 阶段 3 (20s -> 内场 19×15: x=-9..9, z=-7..7)
execute if score #collapse_stage sc_var matches 3 run fill -10 64 -8 -10 70 8 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 3 run fill 10 64 -8 10 70 8 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 3 run fill -9 64 -8 9 70 -8 quartz_bricks
execute if score #collapse_stage sc_var matches 3 run fill -9 64 8 9 70 8 quartz_bricks
execute if score #collapse_stage sc_var matches 3 run setblock 0 65 -8 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 3 run setblock 0 66 -8 sea_lantern
execute if score #collapse_stage sc_var matches 3 run setblock 0 65 8 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 3 run setblock 0 66 8 sea_lantern
execute if score #collapse_stage sc_var matches 3 run setblock -10 69 0 sea_lantern
execute if score #collapse_stage sc_var matches 3 run setblock 10 69 0 sea_lantern

# 阶段 4 (15s -> 内场 17×13: x=-8..8, z=-6..6)
execute if score #collapse_stage sc_var matches 4 run fill -9 64 -7 -9 70 7 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 4 run fill 9 64 -7 9 70 7 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 4 run fill -8 64 -7 8 70 -7 quartz_bricks
execute if score #collapse_stage sc_var matches 4 run fill -8 64 7 8 70 7 quartz_bricks
execute if score #collapse_stage sc_var matches 4 run setblock 0 65 -7 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 4 run setblock 0 66 -7 sea_lantern
execute if score #collapse_stage sc_var matches 4 run setblock 0 65 7 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 4 run setblock 0 66 7 sea_lantern
execute if score #collapse_stage sc_var matches 4 run setblock -9 69 0 sea_lantern
execute if score #collapse_stage sc_var matches 4 run setblock 9 69 0 sea_lantern

# 阶段 5 (10s -> 内场 15×11: x=-7..7, z=-5..5)
execute if score #collapse_stage sc_var matches 5 run fill -8 64 -6 -8 70 6 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 5 run fill 8 64 -6 8 70 6 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 5 run fill -7 64 -6 7 70 -6 quartz_bricks
execute if score #collapse_stage sc_var matches 5 run fill -7 64 6 7 70 6 quartz_bricks
execute if score #collapse_stage sc_var matches 5 run setblock 0 65 -6 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 5 run setblock 0 66 -6 sea_lantern
execute if score #collapse_stage sc_var matches 5 run setblock 0 65 6 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 5 run setblock 0 66 6 sea_lantern
execute if score #collapse_stage sc_var matches 5 run setblock -8 69 0 sea_lantern
execute if score #collapse_stage sc_var matches 5 run setblock 8 69 0 sea_lantern

# 阶段 6 (5s -> 核心高压内场 13×9: x=-6..6, z=-4..4)
execute if score #collapse_stage sc_var matches 6 run fill -7 64 -5 -7 70 5 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 6 run fill 7 64 -5 7 70 5 polished_blackstone_bricks
execute if score #collapse_stage sc_var matches 6 run fill -6 64 -5 6 70 -5 quartz_bricks
execute if score #collapse_stage sc_var matches 6 run fill -6 64 5 6 70 5 quartz_bricks
execute if score #collapse_stage sc_var matches 6 run setblock 0 65 -5 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 6 run setblock 0 66 -5 sea_lantern
execute if score #collapse_stage sc_var matches 6 run setblock 0 65 5 chiseled_quartz_block
execute if score #collapse_stage sc_var matches 6 run setblock 0 66 5 sea_lantern
execute if score #collapse_stage sc_var matches 6 run setblock -7 69 0 sea_lantern
execute if score #collapse_stage sc_var matches 6 run setblock 7 69 0 sea_lantern

playsound minecraft:block.piston.extend master @a 0 66 0 1.4 0.75
playsound minecraft:block.anvil.land master @a 0 66 0 0.55 0.65
function sc:arena/count_tiles
