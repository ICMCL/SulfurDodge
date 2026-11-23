execute as @a[tag=sc_spec] run function sc:lobby/ensure_present
execute if block 0 69 -16 emerald_block as @a[tag=!sc_ingame,gamemode=adventure,x=-14,y=64,z=-10,dx=28,dy=6,dz=20] run function sc:lobby/arrive

# 大厅踩区选队（北侧樱阁甲板 y=68，站立高度 y=69）
execute if score #btn_cd sc_var matches 1.. run scoreboard players remove #btn_cd sc_var 1
execute as @a[tag=!sc_ingame,team=!red,x=-11,y=69,z=-17,dx=3,dy=2,dz=3] run function sc:lobby/join with storage sc:t red
execute as @a[tag=!sc_ingame,team=!blue,x=8,y=69,z=-17,dx=3,dy=2,dz=3] run function sc:lobby/join with storage sc:t blue
execute as @a[tag=!sc_ingame,team=!,x=13,y=69,z=-17,dx=1,dy=2,dz=2] run function sc:lobby/leave

# 开始按钮与讲台交互
execute if block 0 70 -16 stone_button[powered=true] run function sc:lobby/button
execute as @e[type=interaction,tag=sc_cfgnpc] if data entity @s interaction run function sc:cfg/npc
execute as @e[type=interaction,tag=sc_cfgnpc] if data entity @s attack run function sc:cfg/npc

# 大厅保护与虚空防掉落
execute if score #g20 sc_var matches 0 run effect give @a[tag=!sc_ingame] minecraft:saturation 2 0 true
execute if score #g20 sc_var matches 0 run effect give @a[tag=!sc_ingame] minecraft:resistance 2 4 true
execute if score #g20 sc_var matches 0 run effect give @a[tag=!sc_ingame] minecraft:regeneration 2 4 true
execute if block 0 69 -16 emerald_block as @a[tag=!sc_ingame,gamemode=adventure] at @s if entity @s[y=-64,dy=122] run function sc:lobby/arrive
