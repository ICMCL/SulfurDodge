# 仅处理准星遇到的第一只球。选择器比较实体脚底，向下偏移半个球高。
execute unless block ~ ~ ~ air run return 0
execute positioned ~ ~-0.49 ~ if entity @e[type=sulfur_cube,tag=sc_ball,distance=..0.6] run return run execute as @n[type=sulfur_cube,tag=sc_ball,distance=..0.6] at @s run function sc:cube/try_charge_hit
scoreboard players remove #ray_steps sc_var 1
execute if score #ray_steps sc_var matches 1.. positioned ^ ^ ^0.25 run function sc:player/charge_ray
