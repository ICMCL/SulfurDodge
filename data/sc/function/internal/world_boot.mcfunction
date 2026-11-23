# ===== 绑定 .mca 存档自动初始化（仅同步世界规则、大厅悬浮看板与内场动态区，绝不覆盖外围浮岛建筑） =====
gamerule keep_inventory true
gamerule immediate_respawn true
gamerule respawn_radius 0
gamerule block_drops false
gamerule mob_drops false
gamerule mob_griefing false
gamerule spawn_mobs false
gamerule spawn_phantoms false
gamerule advance_time false
gamerule advance_weather false
gamerule fall_damage false
gamerule fire_damage true
gamerule natural_health_regeneration false
gamerule show_advancement_messages false
gamerule send_command_feedback false
gamerule command_block_output false
gamerule max_block_modifications 4000000
gamerule tnt_explodes true
difficulty normal
time set 6000
weather clear

execute in minecraft:overworld run forceload add -32 -32 31 31
execute in minecraft:overworld run function sc:lobby/build
execute unless score #state sc_var matches 1..2 in minecraft:overworld run function sc:arena/reset_round
scoreboard players set #lobby_synced sc_var 1
