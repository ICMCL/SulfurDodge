# 只染可刷地板，不改变墙体。
execute if score #pt_w sc_var matches 1 if score #pt_team sc_var matches 1 if block ~ 64 ~ #sc:paintable_floor run setblock ~ 64 ~ red_concrete
execute if score #pt_w sc_var matches 1 if score #pt_team sc_var matches 2 if block ~ 64 ~ #sc:paintable_floor run setblock ~ 64 ~ blue_concrete
execute if score #pt_w sc_var matches 3 if score #pt_team sc_var matches 1 run fill ~-1 64 ~-1 ~1 64 ~1 red_concrete replace #sc:paintable_floor
execute if score #pt_w sc_var matches 3 if score #pt_team sc_var matches 2 run fill ~-1 64 ~-1 ~1 64 ~1 blue_concrete replace #sc:paintable_floor
