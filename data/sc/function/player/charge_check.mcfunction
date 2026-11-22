# ===== 1 号位击球长矛：右键架矛冲撞 (Charge) 检测 =====
# 按住右键即刻生效（最长维持 10 秒 = 200 tick 防无限挂机举矛）
execute unless score @s sc_charge_dur matches 1..200 run return 0
execute unless entity @e[type=sulfur_cube,tag=sc_ball,distance=..5.5] run return 0

function sc:player/shot_context
scoreboard players operation #pvx sc_var = @s sc_vx
scoreboard players operation #pvz sc_var = @s sc_vz

scoreboard players set #ray_steps sc_var 18
execute anchored eyes positioned ^ ^ ^0.25 anchored feet run function sc:player/charge_ray
tag @s remove sc_hitter
