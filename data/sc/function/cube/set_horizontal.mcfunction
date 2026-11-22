# 新冲量统一按档位缩放一次（千分格/tick）。穿墙时恢复的是缓存的实际速度，不再缩放。
scoreboard players operation @s sc_vx = #out_x sc_var
scoreboard players operation @s sc_vx *= #speed_pct sc_var
scoreboard players operation @s sc_vx /= #100 sc_const
scoreboard players operation @s sc_vz = #out_z sc_var
scoreboard players operation @s sc_vz *= #speed_pct sc_var
scoreboard players operation @s sc_vz /= #100 sc_const
function sc:cube/restore_vel
