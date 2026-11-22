# 在主世界执行（使用场底 0 58 0 隐藏箱子中转恢复玩家原背包）
clear @s
data remove storage sc:tmp list
data remove storage sc:tmp eq
execute store result storage sc:tmp id.id int 1 run scoreboard players get @s sc_id
function sc:inv/restore_m with storage sc:tmp id
execute unless block 0 58 0 chest run setblock 0 58 0 chest
execute if data storage sc:tmp list[0] run function sc:inv/put_loop
execute if data storage sc:tmp eq.head run function sc:inv/put_eq {k:"head",s:"armor.head"}
execute if data storage sc:tmp eq.chest run function sc:inv/put_eq {k:"chest",s:"armor.chest"}
execute if data storage sc:tmp eq.legs run function sc:inv/put_eq {k:"legs",s:"armor.legs"}
execute if data storage sc:tmp eq.feet run function sc:inv/put_eq {k:"feet",s:"armor.feet"}
execute if data storage sc:tmp eq.offhand run function sc:inv/put_eq {k:"offhand",s:"weapon.offhand"}
data modify block 0 58 0 Items set value []
