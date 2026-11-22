execute unless items entity @s weapon.mainhand minecraft:golden_spear[minecraft:custom_data~{sc_kit:1b}] run return run scoreboard players set @s sc_thrust 0
scoreboard players remove @s sc_thrust 1
execute unless entity @e[type=sulfur_cube,tag=sc_ball,scores={sc_fuse=1..},distance=..3.5] run return 0
function sc:player/shot_context
scoreboard players set #ray_steps sc_var 10
execute positioned ~ ~0.49 ~ rotated ~ 0 positioned ^ ^ ^0.25 run function sc:player/dash_ray
tag @s remove sc_hitter
