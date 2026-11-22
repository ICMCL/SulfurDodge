# 连续无断点刷地：先在上一刻与当前刻的中点刷一次，再在当前位置刷一次（保证 1.3 格/tick 高速重炮不断线）
execute store result score #cx sc_var run data get entity @s Pos[0] 1000
execute store result score #cz sc_var run data get entity @s Pos[2] 1000
scoreboard players operation #mx sc_var = #cx sc_var
scoreboard players operation #mx sc_var += @s sc_px
scoreboard players operation #mx sc_var /= #2 sc_const
scoreboard players operation #mz sc_var = #cz sc_var
scoreboard players operation #mz sc_var += @s sc_pz
scoreboard players operation #mz sc_var /= #2 sc_const

execute unless entity @n[type=marker,tag=sc_math] run summon marker 0 64 0 {Tags:["sc_math"]}
execute store result entity @n[type=marker,tag=sc_math] Pos[0] double 0.001 run scoreboard players get #mx sc_var
data modify entity @n[type=marker,tag=sc_math] Pos[1] set value 65.0d
execute store result entity @n[type=marker,tag=sc_math] Pos[2] double 0.001 run scoreboard players get #mz sc_var

scoreboard players operation #pt_team sc_var = @s sc_team
scoreboard players operation #pt_w sc_var = @s sc_width
execute at @n[type=marker,tag=sc_math] run function sc:cube/paint_at
function sc:cube/paint_at
