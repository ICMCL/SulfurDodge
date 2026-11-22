# 每次处理一次命中；调用者在结束后清除 sc_hitter。
execute unless entity @n[type=marker,tag=sc_math] run summon marker 0 64 0 {Tags:["sc_math"]}
execute at @s rotated ~ 0 positioned ^ ^ ^1 run tp @n[type=marker,tag=sc_math] ~ ~ ~
execute store result score #fx sc_var run data get entity @n[type=marker,tag=sc_math] Pos[0] 1000
execute store result score #fz sc_var run data get entity @n[type=marker,tag=sc_math] Pos[2] 1000
execute store result score #ox sc_var run data get entity @s Pos[0] 1000
execute store result score #oz sc_var run data get entity @s Pos[2] 1000
scoreboard players operation #fx sc_var -= #ox sc_var
scoreboard players operation #fz sc_var -= #oz sc_var
scoreboard players operation #hitter_team sc_var = @s sc_team
tag @s add sc_hitter
