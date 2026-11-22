# 宏参数: $(s) 秒整数位, $(d) 十分位
$execute if score @s sc_fuse matches 11.. if score @s sc_team matches 1 run data modify entity @s CustomName set value {text:"🔴 💣 $(s).$(d)s",color:"red",bold:true}
$execute if score @s sc_fuse matches 11.. if score @s sc_team matches 2 run data modify entity @s CustomName set value {text:"🔵 💣 $(s).$(d)s",color:"aqua",bold:true}
$execute if score @s sc_fuse matches 11.. if score @s sc_team matches 0 run data modify entity @s CustomName set value {text:"⚪ 💣 $(s).$(d)s",color:"white",bold:true}

# 最后 0.5 秒 (1..10 tick) 高频闪烁锁色警示
$execute if score @s sc_fuse matches 1..10 if score #g2 sc_var matches 0 run data modify entity @s CustomName set value {text:"⚠ 💥 $(s).$(d)s!",color:"yellow",bold:true}
$execute if score @s sc_fuse matches 1..10 if score #g2 sc_var matches 1 if score @s sc_team matches 1 run data modify entity @s CustomName set value {text:"🔴 💥 $(s).$(d)s!",color:"red",bold:true}
$execute if score @s sc_fuse matches 1..10 if score #g2 sc_var matches 1 if score @s sc_team matches 2 run data modify entity @s CustomName set value {text:"🔵 💥 $(s).$(d)s!",color:"aqua",bold:true}
$execute if score @s sc_fuse matches 1..10 if score #g2 sc_var matches 1 if score @s sc_team matches 0 run data modify entity @s CustomName set value {text:"⚪ 💥 $(s).$(d)s!",color:"white",bold:true}
