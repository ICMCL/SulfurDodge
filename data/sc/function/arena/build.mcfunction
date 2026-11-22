# ===== 下层：29×21 封闭弹珠竞技场永久结构建造（主世界 地板 y=64, 内场 x:-14..14, z:-10..10, 净高 y=65..70） =====
# 清除原版虚空预设可能自带的初始石头平台，保证场馆干净悬浮
fill -20 55 -22 26 82 26 air

# 场底隐藏中转箱（用于暂存与归还玩家原背包，密封在地板托底之下）
fill -1 57 -1 1 59 1 polished_deepslate
setblock 0 58 0 chest

# 竞技场底层托底与初始中立浅灰地面（战场机关与染色仅在每局游戏开始时重置）
fill -15 63 -11 15 63 11 polished_deepslate
fill -14 64 -10 14 64 10 light_gray_concrete
fill -12 64 -2 -10 64 2 red_concrete
fill 10 64 -2 12 64 2 blue_concrete

function sc:arena/perimeter
