# ===== 管理员/单人练习强制开局（无需凑齐两队，未选队自动编入红队并开启单人实机测试） =====
execute if score #state sc_var matches 1..2 run return run tellraw @s {text:"[硫方涂境] 当前已有比赛正在进行，可先输入 /function sc:admin/stop 终止。",color:"red"}
execute unless entity @a[team=red] unless entity @a[team=blue] as @p run function sc:lobby/join with storage sc:t red
execute in minecraft:overworld run function sc:game/start
scoreboard players set #solo_mode sc_var 1
tellraw @a [{text:"[硫方涂境] ",color:"gold",bold:true},{text:"已进入单人/调试强开模式（关闭空队自动判胜，可自由测试双槽长矛、侧墙发球、破墙与坍缩，输入 /function sc:admin/stop 可随时返场）。",color:"aqua",bold:false}]
