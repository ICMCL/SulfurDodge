execute store result score #bx sc_var run data get entity @s Pos[0] 1000
execute store result score #bz sc_var run data get entity @s Pos[2] 1000
execute as @e[type=sulfur_cube,tag=sc_ball,tag=!sc_impact,distance=..1.38] unless score @s sc_bumper_cd matches 1.. at @s run function sc:arena/bumper_bounce
