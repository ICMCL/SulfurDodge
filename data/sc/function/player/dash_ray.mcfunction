execute unless block ~ ~ ~ air run return 0
execute if score #hitter_team sc_var matches 1 positioned ~ ~-0.49 ~ as @n[type=sulfur_cube,tag=sc_ball,scores={sc_team=1,sc_fuse=1..},distance=..0.5] at @s run return run function sc:cube/dash_shot
execute if score #hitter_team sc_var matches 2 positioned ~ ~-0.49 ~ as @n[type=sulfur_cube,tag=sc_ball,scores={sc_team=2,sc_fuse=1..},distance=..0.5] at @s run return run function sc:cube/dash_shot
scoreboard players remove #ray_steps sc_var 1
execute if score #ray_steps sc_var matches 1.. positioned ^ ^ ^0.25 run function sc:player/dash_ray
