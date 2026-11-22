# 校验并生成玩家放置的 2 格高可破坏反弹墙 (y=65..66 泥砖 + y=67..68 隐形屏障防站立)
scoreboard players set #bad_pw sc_var 0
execute unless block ~ 64 ~ #sc:paintable_floor run scoreboard players set #bad_pw sc_var 1
execute unless block ~ 66 ~ air run scoreboard players set #bad_pw sc_var 1
execute unless block ~ 67 ~ air run scoreboard players set #bad_pw sc_var 1
execute unless block ~ 68 ~ air run scoreboard players set #bad_pw sc_var 1
execute if entity @e[type=marker,tag=sc_wpad,distance=..0.85] run scoreboard players set #bad_pw sc_var 1
execute if block ~ 65 ~-1 minecraft:chiseled_quartz_block run scoreboard players set #bad_pw sc_var 1
execute if block ~ 65 ~1 minecraft:chiseled_quartz_block run scoreboard players set #bad_pw sc_var 1

# 若堵在补给点或南北发球口正前方，自动撤回并退还物品
execute if score #bad_pw sc_var matches 1 run setblock ~ 65 ~ air
execute if score #bad_pw sc_var matches 1 as @a[tag=sc_placer,limit=1] run function sc:player/give_wall_1
execute if score #bad_pw sc_var matches 1 as @a[tag=sc_placer,limit=1] run playsound minecraft:block.note_block.bass master @s ~ ~ ~ 0.9 0.8
execute if score #bad_pw sc_var matches 1 as @a[tag=sc_placer,limit=1] run return run title @s actionbar {text:"⚠ 不能堵住发球口或刷墙补给点！已退还反弹墙",color:"red"}

setblock ~ 65 ~ minecraft:mud_bricks
setblock ~ 66 ~ minecraft:mud_bricks
setblock ~ 67 ~ minecraft:barrier
setblock ~ 68 ~ minecraft:barrier

summon marker ~ 65.0 ~ {Tags:["sc_pwall","sc_pw_new"]}
execute as @e[type=marker,tag=sc_pw_new] run scoreboard players set @s sc_id 2
execute as @e[type=marker,tag=sc_pw_new] run scoreboard players set @s sc_swap_cd 6
tag @e[type=marker,tag=sc_pw_new] remove sc_pw_new

particle minecraft:wax_off ~ ~1.0 ~ 0.3 0.5 0.3 0.05 10 force
playsound minecraft:block.stone.place master @a ~ ~1 ~ 0.95 1.15
