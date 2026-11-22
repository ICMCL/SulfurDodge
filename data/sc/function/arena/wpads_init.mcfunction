# 初始化场内东西对称 2 处「可放置反弹墙」固定刷新点 (-4.5, 65.0, 0.5) 与 (5.5, 65.0, 0.5)
summon marker -4.5 65.0 0.5 {Tags:["sc_wpad","sc_wpad_init"]}
summon marker 5.5 65.0 0.5 {Tags:["sc_wpad","sc_wpad_init"]}
execute as @e[type=marker,tag=sc_wpad_init] at @s run function sc:arena/wpad_setup
