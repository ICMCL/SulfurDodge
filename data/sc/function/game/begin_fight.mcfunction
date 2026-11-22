scoreboard players set #state sc_var 2
scoreboard players set #spawn_cd sc_var 20
execute as @a[tag=sc_alive] run execute store result score @s sc_px run data get entity @s Pos[0] 1000
execute as @a[tag=sc_alive] run execute store result score @s sc_pz run data get entity @s Pos[2] 1000
execute as @a[tag=sc_alive] run scoreboard players set @s sc_vx 0
execute as @a[tag=sc_alive] run scoreboard players set @s sc_vz 0

title @a[tag=sc_ingame] times 0 18 8
title @a[tag=sc_ingame] title {text:"开战！",color:"green",bold:true}
title @a[tag=sc_ingame] subtitle {text:"侧墙硫方怪即将射出！踩敌色地板会灼烧扣血！",color:"yellow"}
playsound minecraft:entity.ender_dragon.growl master @a[tag=sc_ingame] ~ ~ ~ 0.55 1.4
playsound minecraft:block.bell.use master @a[tag=sc_ingame] ~ ~ ~ 1.2 1.2
function sc:game/second_ui
