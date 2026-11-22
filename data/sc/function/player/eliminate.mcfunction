# ===== 玩家阵亡出局处理 =====
scoreboard players set @s sc_death 0
particle minecraft:angry_villager ~ ~1.0 ~ 0.4 0.5 0.4 0.1 15 force
particle minecraft:poof ~ ~0.8 ~ 0.35 0.5 0.35 0.08 25 force
playsound minecraft:entity.lightning_bolt.impact master @a ~ ~ ~ 0.7 1.35

execute if score @s sc_team matches 1 run tellraw @a [{text:"[硫方涂境] ",color:"gold"},{text:"🔴 ",color:"red"},{selector:"@s"},{text:" 已淘汰出局！",color:"yellow"}]
execute if score @s sc_team matches 2 run tellraw @a [{text:"[硫方涂境] ",color:"gold"},{text:"🔵 ",color:"blue"},{selector:"@s"},{text:" 已淘汰出局！",color:"yellow"}]

function sc:player/make_spectator
title @s title {text:"已淘汰",color:"red",bold:true}
title @s subtitle {text:"已回到选队大厅，可透过玻璃观看比赛",color:"gray"}
