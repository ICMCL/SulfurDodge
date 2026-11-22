$team join $(team) @s
$scoreboard players set @s sc_team $(id)
playsound minecraft:entity.experience_orb.pickup master @s ~ ~ ~ 0.8 1.4
$title @s actionbar {text:"已加入 $(name)",color:"$(color)",bold:true}
$tellraw @a [{text:"[硫方涂境] ",color:"gold"},{selector:"@s"},{text:" 加入了 ",color:"white"},{text:"$(name)",color:"$(color)",bold:true}]
