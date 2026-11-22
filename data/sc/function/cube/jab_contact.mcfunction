# @s 是这一刺的原版受击实体，不是按距离二次选择的球。
execute unless entity @a[tag=sc_hitter,limit=1] run return 0
execute if entity @s[type=minecraft:sulfur_cube,tag=sc_ball] at @s run function sc:cube/on_jab_hit
tag @a[tag=sc_hitter] remove sc_hitter
