# ===== 硫方涂境 (Sulfur Dodge) · 加载初始化 =====
scoreboard objectives add sc_var dummy
scoreboard objectives add sc_const dummy
scoreboard objectives add sc_tmp dummy
scoreboard objectives add sc_id dummy
scoreboard objectives add sc_gid dummy
scoreboard objectives add sc_team dummy
scoreboard objectives add sc_fuse dummy
scoreboard objectives add sc_width dummy
scoreboard objectives add sc_heavy dummy
scoreboard objectives add sc_swap_cd dummy
scoreboard objectives add sc_bumper_cd dummy
scoreboard objectives add sc_stuck dummy
scoreboard objectives add sc_px dummy
scoreboard objectives add sc_pz dummy
scoreboard objectives add sc_vx dummy
scoreboard objectives add sc_vz dummy
scoreboard objectives add sc_charging dummy
scoreboard objectives add sc_charge_dur dummy
scoreboard objectives add sc_thrust dummy
scoreboard objectives add sc_g_last dummy
scoreboard objectives add sc_g_hold dummy
scoreboard objectives add sc_burn_warn dummy
scoreboard objectives add sc_burn_cd dummy
scoreboard objectives add sc_stam_tmr dummy
scoreboard objectives add sc_hud_dir dummy
scoreboard objectives add sc_cfg trigger
scoreboard objectives add sc_set trigger
scoreboard objectives add sc_death deathCount
scoreboard objectives add sc_left minecraft.custom:minecraft.leave_game
scoreboard objectives add sc_side dummy {text:"💣 硫方涂境 💣",color:"gold",bold:true}

scoreboard players set #-1 sc_const -1
scoreboard players set #2 sc_const 2
scoreboard players set #3 sc_const 3
scoreboard players set #5 sc_const 5
scoreboard players set #10 sc_const 10
scoreboard players set #20 sc_const 20
scoreboard players set #50 sc_const 50
scoreboard players set #100 sc_const 100
scoreboard players set #1000 sc_const 1000
scoreboard players set #10000 sc_const 10000
scoreboard players set #cos6 sc_const 9945

# 默认配置（首次加载初始化，保留已有配置）
execute unless score #o_dur sc_var matches 0..3 run scoreboard players set #o_dur sc_var 1
execute unless score #o_balls sc_var matches 0..2 run scoreboard players set #o_balls sc_var 1
execute unless score #o_blast sc_var matches 0..1 run scoreboard players set #o_blast sc_var 0
execute unless score #o_layout sc_var matches 0..2 run scoreboard players set #o_layout sc_var 0
execute unless score #o_speed sc_var matches 0..2 run scoreboard players set #o_speed sc_var 1
execute unless score #o_grace sc_var matches 0..3 run scoreboard players set #o_grace sc_var 0
execute unless score #o_parry sc_var matches 0..3 run scoreboard players set #o_parry sc_var 1
function sc:cfg/calc
execute unless score #state sc_var matches 0..2 run scoreboard players set #state sc_var 0

# 队伍配置（关闭友伤与玩家碰撞挤压）
team add red {text:"红队",color:"red"}
team add blue {text:"蓝队",color:"blue"}
team add sc_neutral {text:"中立",color:"white"}
team modify red color red
team modify blue color blue
team modify sc_neutral color white
team modify red friendlyFire false
team modify blue friendlyFire false
team modify red collisionRule never
team modify blue collisionRule never
team modify sc_neutral collisionRule never
team modify red prefix {text:"[红] ",color:"red"}
team modify blue prefix {text:"[蓝] ",color:"blue"}

data modify storage sc:t red set value {team:"red",id:1,name:"红队",color:"red",c:16724787}
data modify storage sc:t blue set value {team:"blue",id:2,name:"蓝队",color:"blue",c:3949738}

function sc:cfg/templates

# 计分板侧栏显示名
scoreboard players display name r_tile sc_side {text:"红方领地(格)",color:"red"}
scoreboard players display name b_tile sc_side {text:"蓝方领地(格)",color:"blue"}
scoreboard players display name rem_sec sc_side {text:"剩余时间(秒)",color:"yellow"}

# 顶部 Bossbar 初始化
bossbar add sc:match {text:"硫方涂境",color:"gold"}
execute if score #state sc_var matches 0 run bossbar set sc:match visible false

# 每次 load / reload 重新同步大厅悬浮实体，兼容绑定 .mca 存档即开即玩
scoreboard players set #lobby_synced sc_var 0
