# 两段射线（矛→引力点、球→引力点）都必须畅通，最长 4 格。
execute unless block ~ ~ ~ minecraft:air run return 0
execute unless entity @n[type=marker,tag=sc_g_focus,distance=..4.001] run return 0
execute if entity @n[type=marker,tag=sc_g_focus,distance=..0.20] run return 1
execute positioned ^ ^ ^0.2 run return run function sc:gravity/visible
