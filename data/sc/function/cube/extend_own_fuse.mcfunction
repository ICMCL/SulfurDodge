# 同队击球延后引信：每次戳中己方硫方怪延迟 +1.0 秒 (+20 tick) 爆炸，严格封顶 5.0 秒 (100 tick) 上限
execute if score @s sc_fuse matches 1.. run scoreboard players add @s sc_fuse 20
execute if score @s sc_fuse matches 101.. run scoreboard players set @s sc_fuse 100

# 若该球此前已进入最后 0.5 秒闪烁锁色区间，延时回到 11+ tick 后解除闪烁锁定恢复队伍高亮
execute if score @s sc_fuse matches 11.. run tag @s remove sc_locked
execute if score @s sc_fuse matches 11.. if score @s sc_team matches 1 run team join red @s
execute if score @s sc_fuse matches 11.. if score @s sc_team matches 2 run team join blue @s
playsound minecraft:block.note_block.chime master @a ~ ~0.5 ~ 0.85 1.65
