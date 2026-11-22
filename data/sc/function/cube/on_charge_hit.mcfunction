# 接管已点燃的非己方球；不修改引信。
tag @s remove sc_impact
scoreboard players operation @s sc_team = #hitter_team sc_var
execute if score @s sc_team matches 1 run team join red @s
execute if score @s sc_team matches 2 run team join blue @s
scoreboard players set @s sc_swap_cd 6
scoreboard players set @s sc_width 3
scoreboard players set @s sc_heavy 1
scoreboard players set #spd sc_var 1250
function sc:cube/shoot_forward
data modify entity @s Motion[1] set value 0.07d
playsound minecraft:item.trident.return master @a ~ ~0.5 ~ 1.4 1.2
particle minecraft:firework ~ ~0.5 ~ 0.35 0.35 0.35 0.25 28 force
title @a[tag=sc_hitter,limit=1] actionbar {text:"反色成功！三格重炮，引信不变",color:"green",bold:true}
function sc:cube/paint
function sc:cube/update_fuse_ui
