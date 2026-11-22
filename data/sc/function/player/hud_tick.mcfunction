# ===== 第一人称视野辅助 HUD（脚下灼烧警告 > 10格内敌球方向雷达 > 实时领地比分） =====
execute if entity @s[tag=sc_on_hazard] if score @s sc_burn_warn < #grace_ticks sc_var run return run title @s actionbar {text:"🔥 ⚠ 脚下异色预警！快离开！ ⚠ 🔥",color:"yellow",bold:true}
execute if entity @s[tag=sc_on_hazard] if score @s sc_burn_warn >= #grace_ticks sc_var run return run title @s actionbar {text:"🔥🔥 正在灼烧 (-1.5❤)！切 2 号位突进飞离！ 🔥🔥",color:"red",bold:true}

scoreboard players set @s sc_hud_dir 0
tag @e[type=sulfur_cube,tag=sc_hud_b] remove sc_hud_b
scoreboard players operation #viewer_team sc_var = @s sc_team
execute as @e[type=sulfur_cube,tag=sc_ball,scores={sc_fuse=1..},distance=..10] unless score @s sc_team = #viewer_team sc_var run tag @s add sc_hud_b

execute if entity @e[type=sulfur_cube,tag=sc_hud_b] run function sc:player/hud_ball_calc
execute if score @s sc_hud_dir matches 1 if score @s sc_charge_dur matches 1..200 run return run title @s actionbar [{text:"已架矛：迎面闭合速度 ≥ ",color:"aqua",bold:true},{score:{name:"#parry_mps",objective:"sc_var"}},{text:" 格/秒才能反色"}]
execute if score @s sc_hud_dir matches 1 run return run title @s actionbar {text:"▲ 前方有倒计时来球！",color:"gold",bold:true}
execute if score @s sc_hud_dir matches 2 run return run title @s actionbar {text:"▼ 小心背后的倒计时来球！",color:"red",bold:true}
execute if score @s sc_hud_dir matches 3 run return run title @s actionbar {text:"«« 左侧有倒计时来球！",color:"gold",bold:true}
execute if score @s sc_hud_dir matches 4 run return run title @s actionbar {text:"右侧有倒计时来球！ »»",color:"gold",bold:true}

# 安全常态：显示实时领地格数对比与架矛就绪状态
execute if score #cfg_dur sc_var matches 0 if score @s sc_charge_dur matches 1..200 run return run title @s actionbar {text:"架矛迎击就绪",color:"aqua"}
execute if score #cfg_dur sc_var matches 0 run return run title @s actionbar {text:"无尽淘汰 · 全歼对手获胜",color:"gray"}
execute if score @s sc_charge_dur matches 1..200 run return run title @s actionbar [{text:"⚡ 架矛迎击就绪 ⚡  ",color:"aqua",bold:true},{text:"红 ",color:"red",bold:false},{score:{name:"#r_tiles",objective:"sc_var"},color:"red",bold:true},{text:" : ",color:"gray"},{score:{name:"#b_tiles",objective:"sc_var"},color:"blue",bold:true},{text:" 蓝",color:"blue",bold:false}]

title @s actionbar [{text:"🔴 红方领地 ",color:"red"},{score:{name:"#r_tiles",objective:"sc_var"},color:"red",bold:true},{text:" 格   |   ",color:"dark_gray"},{text:"🔵 蓝方领地 ",color:"blue"},{score:{name:"#b_tiles",objective:"sc_var"},color:"blue",bold:true},{text:" 格",color:"blue"}]
