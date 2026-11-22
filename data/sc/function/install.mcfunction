# ===== 一次性世界配置与建造 =====
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

tellraw @a [{text:"[硫方涂境] ",color:"gold",bold:true},{text:"正在加载常驻区块，1 秒后在主世界生成上下双层全景弹珠场馆……",color:"yellow",bold:false}]
schedule function sc:internal/install_build 20t
