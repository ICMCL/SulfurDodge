# 先扫描本刻的水平运动段，避免高速球已经被原版墙体弹回才判定命中。
execute store result storage sc:tmp sweep.x double 0.000125 run data get entity @s Motion[0] 1000
execute store result storage sc:tmp sweep.z double 0.000125 run data get entity @s Motion[2] 1000
scoreboard players set #impact_steps sc_var 8
return run function sc:cube/impact_probe with storage sc:tmp sweep
