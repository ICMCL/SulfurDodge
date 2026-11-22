# 将贴近即将合拢外墙的玩家或硫方怪平滑推入新墙内侧（保留玩家视角朝向，硫方怪同步向场内反弹，绝不卡墙窒息）
execute store result score #ex sc_var run data get entity @s Pos[0] 1000
execute store result score #ez sc_var run data get entity @s Pos[2] 1000
scoreboard players set #moved sc_var 0

execute if score #ex sc_var < #min_x sc_var run scoreboard players set #moved sc_var 1
execute if score #ex sc_var < #min_x sc_var if entity @s[type=sulfur_cube] store result entity @s Motion[0] double 0.0048 run scoreboard players get #speed_pct sc_var
execute if score #ex sc_var < #min_x sc_var run scoreboard players operation #ex sc_var = #min_x sc_var

execute if score #ex sc_var > #max_x sc_var run scoreboard players set #moved sc_var 1
execute if score #ex sc_var > #max_x sc_var if entity @s[type=sulfur_cube] store result entity @s Motion[0] double -0.0048 run scoreboard players get #speed_pct sc_var
execute if score #ex sc_var > #max_x sc_var run scoreboard players operation #ex sc_var = #max_x sc_var

execute if score #ez sc_var < #min_z sc_var run scoreboard players set #moved sc_var 1
execute if score #ez sc_var < #min_z sc_var if entity @s[type=sulfur_cube] store result entity @s Motion[2] double 0.0048 run scoreboard players get #speed_pct sc_var
execute if score #ez sc_var < #min_z sc_var run scoreboard players operation #ez sc_var = #min_z sc_var

execute if score #ez sc_var > #max_z sc_var run scoreboard players set #moved sc_var 1
execute if score #ez sc_var > #max_z sc_var if entity @s[type=sulfur_cube] store result entity @s Motion[2] double -0.0048 run scoreboard players get #speed_pct sc_var
execute if score #ez sc_var > #max_z sc_var run scoreboard players operation #ez sc_var = #max_z sc_var

execute if score #moved sc_var matches 1 store result storage sc:tmp tp.x double 0.001 run scoreboard players get #ex sc_var
execute if score #moved sc_var matches 1 store result storage sc:tmp tp.z double 0.001 run scoreboard players get #ez sc_var
execute if score #moved sc_var matches 1 run function sc:arena/tp_xz_m with storage sc:tmp tp
