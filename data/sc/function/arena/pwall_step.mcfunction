# 玩家放置的可破坏反弹墙每刻受撞检测
execute if score @s sc_swap_cd matches 1.. run scoreboard players remove @s sc_swap_cd 1
execute unless score @s sc_swap_cd matches 1.. positioned ~-0.65 ~ ~-0.65 if entity @e[type=sulfur_cube,tag=sc_ball,tag=!sc_impact,dx=0.3,dy=1.2,dz=0.3] at @s run function sc:arena/pwall_hit
