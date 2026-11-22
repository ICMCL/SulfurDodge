execute store result score #live_red sc_var if entity @a[tag=sc_alive,scores={sc_team=1}]
execute store result score #live_blue sc_var if entity @a[tag=sc_alive,scores={sc_team=2}]
bossbar set sc:match name [{text:"无尽淘汰   |   存活  ",color:"gold"},{text:"红 ",color:"red"},{score:{name:"#live_red",objective:"sc_var"},color:"red"},{text:" : ",color:"gray"},{score:{name:"#live_blue",objective:"sc_var"},color:"blue"},{text:" 蓝",color:"blue"}]
