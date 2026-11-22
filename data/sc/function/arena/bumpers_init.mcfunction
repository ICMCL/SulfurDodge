# 生成 4 根对称紫水晶加速偏转柱（中心对称点 0.5, 65.0, 0.5，间距 ±3.0 格）
setblock -3 65 -3 amethyst_block
setblock -3 66 -3 budding_amethyst
setblock -3 67 -3 barrier
setblock -3 68 -3 barrier
summon marker -2.5 65.0 -2.5 {Tags:["sc_bumper"]}

setblock -3 65 3 amethyst_block
setblock -3 66 3 budding_amethyst
setblock -3 67 3 barrier
setblock -3 68 3 barrier
summon marker -2.5 65.0 3.5 {Tags:["sc_bumper"]}

setblock 3 65 -3 amethyst_block
setblock 3 66 -3 budding_amethyst
setblock 3 67 -3 barrier
setblock 3 68 -3 barrier
summon marker 3.5 65.0 -2.5 {Tags:["sc_bumper"]}

setblock 3 65 3 amethyst_block
setblock 3 66 3 budding_amethyst
setblock 3 67 3 barrier
setblock 3 68 3 barrier
summon marker 3.5 65.0 3.5 {Tags:["sc_bumper"]}
