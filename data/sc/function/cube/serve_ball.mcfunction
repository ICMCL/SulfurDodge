# 从原点的局部前方取一个固定模长的向量：只随机方向，球速倍率仍由 init 施加一次。
execute unless entity @n[type=marker,tag=sc_math] run summon marker ~ ~ ~ {Tags:["sc_math"]}
execute positioned 0.0 0.05 0.0 positioned ^ ^ ^0.68 run tp @n[type=marker,tag=sc_math] ~ ~ ~
summon minecraft:sulfur_cube ~ ~ ~ {Tags:["sc_ball","sc_new"],Size:1,PersistenceRequired:1b,Glowing:1b,fuse:-1,equipment:{body:{id:"minecraft:tnt",count:1}},drop_chances:{body:0.0f}}
data modify entity @n[type=sulfur_cube,tag=sc_new] Motion set from entity @n[type=marker,tag=sc_math] Pos
execute as @n[type=sulfur_cube,tag=sc_new] at @s run function sc:cube/init
