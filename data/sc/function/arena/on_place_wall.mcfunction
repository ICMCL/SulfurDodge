# 玩家放置反弹墙回调：定位 5 格交互半径内新放下的泥砖方块并升起为 2 格高防垫脚可破坏反弹墙
advancement revoke @s only sc:placed_wall
tag @s add sc_placer
execute at @s align xz positioned ~0.5 65.0 ~0.5 run function sc:arena/pwall_scan_x
tag @s remove sc_placer
