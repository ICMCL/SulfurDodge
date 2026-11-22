# ===== 上层：露天全景选队大厅（主世界地面 y=71，北侧 z=-17..-12 选队看台） =====
# 只围四边，不封顶：原版重生会把上方的屏障当作落脚面。
fill -16 71 -18 16 77 -18 barrier
fill -16 71 12 16 77 12 barrier
fill -16 71 -17 -16 77 11 barrier
fill 16 71 -17 16 77 11 barrier

# 重新铺设南侧 29×21 全景透明玻璃顶 + 石英边框（确保上面无障碍，视野 100% 通透俯视下方战场）
fill -15 71 -11 15 71 11 quartz_bricks
fill -14 71 -10 14 71 10 glass

# 北侧选队与设置看台地面 (x:-15..15, z:-17..-12, y=71)
fill -15 71 -17 15 71 -12 quartz_bricks
fill -14 71 -16 14 71 -12 smooth_quartz
setblock -14 71 -16 sea_lantern
setblock 14 71 -16 sea_lantern
setblock -14 71 -12 sea_lantern
setblock 14 71 -12 sea_lantern
setblock -15 71 11 sea_lantern
setblock 15 71 11 sea_lantern
fill -1 72 -14 1 72 -12 smooth_quartz
setworldspawn 0 73 -13 0 30

# 红队选区（西侧，正对下方红队西侧出生岛） / 蓝队选区（东侧，正对下方蓝队东侧出生岛） / 旁观取消区（移至看台最东端独立侧翼，彻底错开红蓝选区与中央动线）
fill -9 71 -15 -7 71 -13 red_concrete
fill 7 71 -15 9 71 -13 blue_concrete
fill 12 71 -15 13 71 -13 light_gray_concrete

kill @e[tag=sc_lobby]

# 北墙中央动态规则看板（背靠北墙 z=-17，完全不遮挡南侧球场俯视视线）
summon text_display 0.5 74.8 -16.8 {Tags:["sc_lobby","sc_cfg_board"],billboard:"center",line_width:290,background:1073741824,text:{text:"硫方涂境",color:"gold"}}
function sc:cfg/lobby_board

# 选区悬浮标识
summon text_display -7.5 73.2 -13.5 {Tags:["sc_lobby"],billboard:"center",text:[{text:"🔴 红队\n",color:"red",bold:true},{text:"踩上加入",color:"gray",bold:false}]}
summon text_display 8.5 73.2 -13.5 {Tags:["sc_lobby"],billboard:"center",text:[{text:"🔵 蓝队\n",color:"blue",bold:true},{text:"踩上加入",color:"gray",bold:false}]}
summon text_display 13.0 73.0 -13.5 {Tags:["sc_lobby"],billboard:"center",text:[{text:"👁 旁观席\n",color:"gray",bold:true},{text:"取消选队",color:"white",bold:false}]}

# 开始比赛按钮（北侧背墙）
setblock -3 73 -17 emerald_block
setblock -3 73 -16 stone_button[face=wall,facing=south]
summon text_display -2.5 74.1 -15.9 {Tags:["sc_lobby"],billboard:"center",text:{text:"▶ 开始比赛",color:"green",bold:true}}

# 规则设置讲台 + 交互实体
setblock 3 72 -16 lectern[facing=south]
summon interaction 3.5 72.0 -15.5 {Tags:["sc_lobby","sc_cfgnpc"],width:1.1f,height:1.4f,response:1b}
summon text_display 3.5 73.7 -15.5 {Tags:["sc_lobby"],billboard:"center",text:{text:"⚙ 比赛设置（右键）",color:"yellow",bold:true}}
