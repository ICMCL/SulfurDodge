# 防止按钮长信号重复触发
execute if score #btn_cd sc_var matches 1.. run return 0
scoreboard players set #btn_cd sc_var 25
setblock 0 70 -16 stone_button[face=floor,facing=south,powered=false]

# 若比赛正在进行，提示大厅玩家直接走到前排观景回廊即可实时俯视观战
execute if score #state sc_var matches 1..2 run return run tellraw @p[x=-5,y=68,z=-19,dx=10,dy=5,dz=7] [{text:"[硫方涂境] ",color:"gold"},{text:"下方樱庭正在激战中！走到前排苍白橡木观景回廊即可无遮挡俯瞰全场。",color:"aqua"}]

# 统计两队人数
scoreboard players set #r_cnt sc_var 0
scoreboard players set #b_cnt sc_var 0
execute as @a[team=red] run scoreboard players add #r_cnt sc_var 1
execute as @a[team=blue] run scoreboard players add #b_cnt sc_var 1

execute unless score #r_cnt sc_var matches 1.. run playsound minecraft:block.note_block.bass master @a ~ ~ ~ 1 0.8
execute unless score #r_cnt sc_var matches 1.. run return run tellraw @a [{text:"[硫方涂境] ",color:"gold"},{text:"无法开赛：红队至少需要 1 名玩家！（单人调试可用 /function sc:admin/force_start）",color:"red"}]
execute unless score #b_cnt sc_var matches 1.. run playsound minecraft:block.note_block.bass master @a ~ ~ ~ 1 0.8
execute unless score #b_cnt sc_var matches 1.. run return run tellraw @a [{text:"[硫方涂境] ",color:"gold"},{text:"无法开赛：蓝队至少需要 1 名玩家！（单人调试可用 /function sc:admin/force_start）",color:"red"}]

function sc:game/start
