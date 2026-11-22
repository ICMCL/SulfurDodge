# 粉碎并移除玩家放置的反弹墙
fill ~ 65 ~ ~ 66 ~ air replace minecraft:mud_bricks
fill ~ 65 ~ ~ 66 ~ air replace minecraft:packed_mud
fill ~ 67 ~ ~ 68 ~ air replace minecraft:barrier
particle minecraft:block{block_state:"minecraft:packed_mud"} ~ ~1.0 ~ 0.4 0.6 0.4 0.15 35 force
playsound minecraft:block.stone.break master @a ~ ~1 ~ 1.0 0.9
kill @s
