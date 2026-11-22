scoreboard players set #picked_w sc_var 0
execute as @a[tag=sc_alive,distance=..1.15,sort=nearest,limit=1] run function sc:arena/wpad_give_player
execute if score #picked_w sc_var matches 1 run function sc:arena/wpad_cooldown
