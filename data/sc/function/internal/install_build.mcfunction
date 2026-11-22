# ===== 区块加载后在主世界建造上下一体双层场馆（下层 29×21 竞技场 + 上层全景玻璃俯视大厅） =====
execute in minecraft:overworld run function sc:arena/build
execute in minecraft:overworld run function sc:lobby/build
execute as @a run function sc:lobby/arrive
execute as @a run gamemode adventure @s
playsound minecraft:ui.toast.challenge_complete master @a ~ ~ ~ 0.8 1.2
tellraw @a [{text:"[硫方涂境] ",color:"gold",bold:true},{text:"上下双层全景场馆建造完毕！脚下玻璃层直通下方竞技场，北侧看台选队与调整规则，每次开赛自动重置战场。",color:"green",bold:false}]
