# 玩家反弹墙受撞：重炮球 (sc_heavy=1) 直接一击撞碎穿透；普通球撞 1 次裂成泥坯、第 2 次彻底撞碎
scoreboard players set #heavy_pw sc_var 0
execute positioned ~-0.65 ~ ~-0.65 as @e[type=sulfur_cube,tag=sc_ball,tag=!sc_impact,scores={sc_heavy=1..},dx=0.3,dy=1.2,dz=0.3,limit=1] run scoreboard players set #heavy_pw sc_var 1

execute if score #heavy_pw sc_var matches 1 positioned ~-0.65 ~ ~-0.65 as @e[type=sulfur_cube,tag=sc_ball,tag=!sc_impact,scores={sc_heavy=1..},dx=0.3,dy=1.2,dz=0.3,limit=1] run function sc:cube/restore_vel
execute if score #heavy_pw sc_var matches 1 run return run function sc:arena/pwall_break

scoreboard players remove @s sc_id 1
scoreboard players set @s sc_swap_cd 8
execute if score @s sc_id matches ..0 run return run function sc:arena/pwall_break

fill ~ 65 ~ ~ 66 ~ minecraft:packed_mud replace minecraft:mud_bricks
particle minecraft:block{block_state:"minecraft:mud_bricks"} ~ ~1.0 ~ 0.35 0.5 0.35 0.1 20 force
playsound minecraft:block.stone.hit master @a ~ ~1 ~ 1.0 0.95
