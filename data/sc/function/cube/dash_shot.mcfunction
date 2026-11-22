scoreboard players set @a[tag=sc_hitter] sc_thrust 0
tag @s add sc_impact
scoreboard players set #spd sc_var 1250
function sc:cube/shoot_forward
data modify entity @s Motion[1] set value 0.0d
playsound minecraft:item.trident.throw master @a ~ ~ ~ 0.9 1.4
function sc:cube/impact_sweep
