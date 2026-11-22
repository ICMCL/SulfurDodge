execute if entity @a[tag=sc_alive,scores={sc_team=1}] if entity @a[tag=sc_alive,scores={sc_team=2}] run return 0
# 同时全灭：无尽直接平局；限时沿用领地判定。
execute unless entity @a[tag=sc_alive,scores={sc_team=1..2}] if score #cfg_dur sc_var matches 0 run return run function sc:game/finish {result:"双方同时全灭，平局！",color:"yellow"}
execute unless entity @a[tag=sc_alive,scores={sc_team=1..2}] run return run function sc:game/timeout_judge
execute if score #solo_mode sc_var matches 1 run return 0
function sc:arena/count_tiles
execute if entity @a[tag=sc_alive,scores={sc_team=1}] run return run function sc:game/finish {result:"红队全歼对手，红队获胜！",color:"red"}
function sc:game/finish {result:"蓝队全歼对手，蓝队获胜！",color:"blue"}
