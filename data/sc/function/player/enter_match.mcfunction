# ===== 参战玩家入场初始化（主世界执行） =====
function sc:inv/stash
tag @s add sc_ingame
scoreboard players operation @s sc_gid = #gid sc_var
execute if entity @s[team=red] run scoreboard players set @s sc_team 1
execute if entity @s[team=blue] run scoreboard players set @s sc_team 2

tag @s add sc_alive
tag @s remove sc_spec
gamemode adventure @s
effect clear @s
attribute @s minecraft:max_health base set 20.0
attribute @s minecraft:knockback_resistance base set 1.0
effect give @s minecraft:instant_health 1 10 true
effect give @s minecraft:saturation 1 19 true
scoreboard players set @s sc_stam_tmr 0
scoreboard players set @s sc_burn_warn 0
scoreboard players set @s sc_burn_cd 0
scoreboard players set @s sc_charging 0
scoreboard players set @s sc_charge_dur 0
scoreboard players set @s sc_thrust 0
scoreboard players reset @s sc_g_last
scoreboard players set @s sc_death 0

execute if score @s sc_team matches 1 run tp @s -10.5 65.0 0.5 -90 0
execute if score @s sc_team matches 2 run tp @s 11.5 65.0 0.5 90 0
execute store result score @s sc_px run data get entity @s Pos[0] 1000
execute store result score @s sc_pz run data get entity @s Pos[2] 1000
scoreboard players set @s sc_vx 0
scoreboard players set @s sc_vz 0
execute if score @s sc_team matches 1 run function sc:player/give_kit with storage sc:t red
execute if score @s sc_team matches 2 run function sc:player/give_kit with storage sc:t blue
