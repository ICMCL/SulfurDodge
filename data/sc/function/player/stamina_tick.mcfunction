# 26.3 的瞬时饱和效果同时加饥饿和隐藏饱和；战袍仅在有隐藏饱和时抵消它，让原版突进 II 的 8 点消耗度扣在鸡腿上。
execute if entity @s[nbt={foodLevel:20}] run return run scoreboard players set @s sc_stam_tmr 0
scoreboard players add @s sc_stam_tmr 1
execute unless score @s sc_stam_tmr matches 50.. run return 0
effect give @s minecraft:saturation 1 0 true
scoreboard players set @s sc_stam_tmr 0
