# 连锁冲击波：沿爆炸中心指向本球的方向高速弹飞 (1.10 格/tick)；若为未点燃白球则触发 1.5s (30t) 短引信中立爆破
execute store result score #ox2 sc_var run data get entity @s Pos[0] 1000
execute store result score #oz2 sc_var run data get entity @s Pos[2] 1000
scoreboard players operation #in_x sc_var = #ox2 sc_var
scoreboard players operation #in_x sc_var -= #ex_x sc_var
scoreboard players operation #in_z sc_var = #oz2 sc_var
scoreboard players operation #in_z sc_var -= #ex_z sc_var
execute if score #in_x sc_var matches -30..30 if score #in_z sc_var matches -30..30 run scoreboard players set #in_x sc_var 300

scoreboard players set #target_spd sc_var 1100
function sc:util/norm2d
function sc:cube/set_horizontal
data modify entity @s Motion[1] set value 0.14d

# 未点燃中立白球触发 1.5 秒 (30t) 连锁引信（爆炸时若仍未染色则无差别炸伤全场所有人！）
execute if score @s sc_team matches 0 unless score @s sc_fuse matches 1.. run scoreboard players set @s sc_fuse 30
execute if score @s sc_team matches 0 run playsound minecraft:entity.tnt.primed master @a ~ ~0.5 ~ 0.9 1.5
execute if score @s sc_fuse matches 1.. run function sc:cube/update_fuse_ui
