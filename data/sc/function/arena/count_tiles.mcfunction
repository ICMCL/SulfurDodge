# 无尽只统计存活人数，染地仍影响走位和伤害。
execute if score #cfg_dur sc_var matches 0 run return 0
execute store result score #r_tiles sc_var run clone -14 64 -10 14 64 10 -14 10 -10 filtered minecraft:red_concrete force
execute store result score #b_tiles sc_var run clone -14 64 -10 14 64 10 -14 11 -10 filtered minecraft:blue_concrete force
fill -14 10 -10 14 11 10 air
scoreboard players operation r_tile sc_side = #r_tiles sc_var
scoreboard players operation b_tile sc_side = #b_tiles sc_var
