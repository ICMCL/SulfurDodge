scoreboard players set @s sc_left 0
# 若玩家在上一场比赛结束或中途掉线重连：检查局号是否仍匹配当前活跃对局
execute if entity @s[tag=sc_ingame] unless score #state sc_var matches 1..2 run function sc:player/cleanup_to_lobby
execute if entity @s[tag=sc_ingame] if score #state sc_var matches 1..2 unless score @s sc_gid = #gid sc_var run function sc:player/cleanup_to_lobby
# 若仍在当前对局但已阵亡或掉线期间血空，送至顶棚观战席
execute if entity @s[tag=sc_ingame] if score #state sc_var matches 1..2 if score @s sc_gid = #gid sc_var run function sc:player/make_spectator
