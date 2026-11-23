# ===== 北侧飞檐樱阁大厅实体同步（静态建筑直接保存于 .mca 区块，此处仅刷新悬浮看板与交互实体） =====
setworldspawn 0 70 -17 0 20
kill @e[tag=sc_lobby]

# 北墙中央防穿模固定朝向规则看板（墙体 z=-21 南立面 z=-20.0，看板置于 z=-19.88 悬浮前出 12cm，零穿模）
summon text_display 0.5 71.55 -19.88 {Tags:["sc_lobby","sc_cfg_board"],billboard:"fixed",Rotation:[0.0f,0.0f],line_width:320,background:1073741824,brightness:{sky:15,block:15},transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f],scale:[0.76f,0.76f,0.76f]},text:{text:"硫方涂境",color:"gold"}}
function sc:cfg/lobby_board

# 红/蓝樱亭与东翼旁观席悬浮标识
summon text_display -9.0 70.6 -15.0 {Tags:["sc_lobby"],billboard:"center",brightness:{sky:15,block:15},text:[{text:"🔴 红队樱亭\n",color:"red",bold:true},{text:"走入加入",color:"white",bold:false}]}
summon text_display 10.0 70.6 -15.0 {Tags:["sc_lobby"],billboard:"center",brightness:{sky:15,block:15},text:[{text:"🔵 蓝队樱亭\n",color:"aqua",bold:true},{text:"走入加入",color:"white",bold:false}]}
summon text_display 14.0 70.4 -15.5 {Tags:["sc_lobby"],billboard:"center",brightness:{sky:15,block:15},text:[{text:"👁 旁观席\n",color:"gray",bold:true},{text:"取消选队",color:"white",bold:false}]}

# 中央凸起高台开始按钮 (0, 70, -16) 与临场侧规则讲台 (0, 70, -15) 交互实体
summon text_display 0.5 70.55 -15.5 {Tags:["sc_lobby"],billboard:"center",brightness:{sky:15,block:15},transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f],scale:[0.8f,0.8f,0.8f]},text:{text:"▶ 开始比赛",color:"green",bold:true}}
summon interaction 0.5 70.0 -14.5 {Tags:["sc_lobby","sc_cfgnpc"],width:1.02f,height:1.2f,response:1b}
summon text_display 0.5 71.45 -14.5 {Tags:["sc_lobby"],billboard:"center",brightness:{sky:15,block:15},transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f],scale:[0.8f,0.8f,0.8f]},text:{text:"⚙ 比赛设置（右键）",color:"yellow",bold:true}}
