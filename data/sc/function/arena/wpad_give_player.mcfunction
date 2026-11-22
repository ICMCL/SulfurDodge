execute store result score #has_w sc_var run clear @s minecraft:mud_bricks 0
execute if score #has_w sc_var matches 6.. run return run title @s actionbar {text:"🧱 身上反弹墙已满 (6/6)！切 3 号位右键地面放置",color:"yellow"}

scoreboard players set #picked_w sc_var 1
function sc:player/give_wall_1

playsound minecraft:entity.item.pickup master @a ~ ~0.5 ~ 0.9 1.25
title @s actionbar {text:"泥砖反弹墙 +1，右键地面放置",color:"gold",bold:true}
