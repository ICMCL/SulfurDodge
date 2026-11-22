# 缩墙推进前自动碾碎处于新外墙带内的玩家放置墙
execute store result score #pwx sc_var run data get entity @s Pos[0] 1000
execute store result score #pwz sc_var run data get entity @s Pos[2] 1000
scoreboard players set #crush_pw sc_var 0
execute if score #pwx sc_var < #min_x sc_var run scoreboard players set #crush_pw sc_var 1
execute if score #pwx sc_var > #max_x sc_var run scoreboard players set #crush_pw sc_var 1
execute if score #pwz sc_var < #min_z sc_var run scoreboard players set #crush_pw sc_var 1
execute if score #pwz sc_var > #max_z sc_var run scoreboard players set #crush_pw sc_var 1
execute if score #crush_pw sc_var matches 1 run function sc:arena/pwall_break
