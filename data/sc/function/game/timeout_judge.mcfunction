execute if score #cfg_dur sc_var matches 0 run return 0
function sc:arena/count_tiles
execute if score #r_tiles sc_var > #b_tiles sc_var run return run function sc:game/finish {result:"红队领地更多，红队获胜！",color:"red"}
execute if score #b_tiles sc_var > #r_tiles sc_var run return run function sc:game/finish {result:"蓝队领地更多，蓝队获胜！",color:"blue"}
function sc:game/finish {result:"领地相同，双方平局！",color:"yellow"}
