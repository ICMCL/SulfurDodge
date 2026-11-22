# ===== 小局场地重置（29×21 地板 + 出生初始色块 + 动态弹珠台机关） =====
# 安全移除旧硫方怪（先去装备传虚空再清理，避免分裂）
execute as @e[type=sulfur_cube] run data remove entity @s equipment
tp @e[type=sulfur_cube] 0 -200 0
kill @e[type=sulfur_cube]
kill @e[type=wind_charge]
kill @e[type=item,x=-15,y=64,z=-11,dx=30,dy=6,dz=22]
kill @e[type=marker,tag=sc_pwall]
kill @e[type=marker,tag=sc_wpad]
kill @e[tag=sc_wpad_ui]
kill @e[type=marker,tag=sc_bumper]

# 清空内场障碍层 (y=65..70)
fill -14 65 -10 14 70 10 air
function sc:arena/perimeter

# 铺设 29×21 中立浅灰地板 + 红蓝两侧初始 3×5 色块（无永久保护，可被敌球重刷）
fill -14 64 -10 14 64 10 light_gray_concrete
fill -12 64 -2 -10 64 2 red_concrete
fill 10 64 -2 12 64 2 blue_concrete

# 重置缩墙阶段与南北发球口；不更改顶部大厅。
scoreboard players set #collapse_stage sc_var 0
scoreboard players set #spawn_cd sc_var 20
scoreboard players set #launch_side sc_var 0
data modify storage sc:tmp lz set value {zn:-9.2d,zs:10.2d,wn:-9.6d,ws:10.6d}

execute if score #o_layout sc_var matches 0..1 run function sc:arena/fixed_walls {wall:"stone_bricks",cap:"barrier"}

# 生成 4 根对称紫水晶弹珠加速偏转柱 (#o_layout 为 0 时启用)
execute if score #o_layout sc_var matches 0 run function sc:arena/bumpers_init

# 生成场内固定「可放置反弹墙」对称补给点
function sc:arena/wpads_init

# 刷新实时地板格数统计
function sc:arena/count_tiles
