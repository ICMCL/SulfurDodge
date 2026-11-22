# 单个定位标记按施法者依次复用；没有持续生效的场实体。
execute unless entity @n[type=marker,tag=sc_g_focus] run summon marker ~ ~ ~ {Tags:["sc_g_focus"]}
execute positioned ^ ^ ^2 run tp @n[type=marker,tag=sc_g_focus] ~ ~ ~
execute at @n[type=marker,tag=sc_g_focus] unless block ~ ~ ~ minecraft:air run return 0
execute unless function sc:gravity/visible run return 0
execute at @n[type=marker,tag=sc_g_focus] run particle minecraft:dust{color:[0.65,0.18,1.0],scale:1.1} ~ ~ ~ 0.16 0.12 0.16 0 3
execute store result score #g_x sc_var run data get entity @n[type=marker,tag=sc_g_focus] Pos[0] 1000
execute store result score #g_z sc_var run data get entity @n[type=marker,tag=sc_g_focus] Pos[2] 1000
execute at @n[type=marker,tag=sc_g_focus] positioned ~ ~-0.49 ~ as @e[type=sulfur_cube,tag=sc_ball,tag=!sc_exploding,distance=..4] at @s positioned ~ ~0.49 ~ facing entity @n[type=marker,tag=sc_g_focus] feet if function sc:gravity/visible at @s run function sc:gravity/bend
