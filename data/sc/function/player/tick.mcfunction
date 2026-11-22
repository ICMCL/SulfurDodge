# ===== 对局存活玩家每刻更新（主世界执行） =====
# 先处理本刻死亡淘汰的玩家
execute as @a[tag=sc_alive,scores={sc_death=1..}] at @s run function sc:player/eliminate
function sc:game/check_alive
execute unless score #state sc_var matches 2 run return 0

# 二层大厅观战玩家防越界与保护（保持在 y=72 玻璃顶之上）
execute if score #g20 sc_var matches 0 run effect give @a[tag=sc_spec] minecraft:saturation 2 0 true
execute if score #g20 sc_var matches 0 run effect give @a[tag=sc_spec] minecraft:resistance 2 4 true

# 存活参战玩家主逻辑
execute as @a[tag=sc_alive] at @s run function sc:player/alive_step
