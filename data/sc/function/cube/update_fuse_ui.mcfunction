# 实时刷新已点燃硫方怪头顶爆炸倒计时名称牌 (0.1 秒精度)
scoreboard players operation #ft sc_var = @s sc_fuse
scoreboard players add #ft sc_var 1
scoreboard players operation #ft sc_var /= #2 sc_const

scoreboard players operation #fs sc_var = #ft sc_var
scoreboard players operation #fs sc_var /= #10 sc_const
scoreboard players operation #fd sc_var = #ft sc_var
scoreboard players operation #fd sc_var %= #10 sc_const

execute store result storage sc:tmp f.s int 1 run scoreboard players get #fs sc_var
execute store result storage sc:tmp f.d int 1 run scoreboard players get #fd sc_var

data modify entity @s CustomNameVisible set value 1b
function sc:cube/set_name_m with storage sc:tmp f

# 整数秒倒数提示音 (3.0s / 2.0s / 1.0s)
execute if score @s sc_fuse matches 60 run playsound minecraft:block.note_block.hat master @a ~ ~0.5 ~ 0.65 1.3
execute if score @s sc_fuse matches 40 run playsound minecraft:block.note_block.hat master @a ~ ~0.5 ~ 0.75 1.55
execute if score @s sc_fuse matches 20 run playsound minecraft:block.note_block.hat master @a ~ ~0.5 ~ 0.85 1.8
