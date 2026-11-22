execute unless score @s sc_id matches 1.. run function sc:player/new_id
execute store result storage sc:tmp id.id int 1 run scoreboard players get @s sc_id
function sc:inv/stash_m with storage sc:tmp id
clear @s
