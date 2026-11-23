execute unless data entity @s Item.components."minecraft:custom_data".sc_kit run return 0
execute store result score @s sc_tmp run data get entity @s Age
execute if score @s sc_tmp matches 30.. run return run kill @s
data modify entity @s PickupDelay set value 0s
tag @s add sc_it
execute on origin run tp @e[type=item,tag=sc_it,limit=1] @s
tag @s remove sc_it
kill @s
