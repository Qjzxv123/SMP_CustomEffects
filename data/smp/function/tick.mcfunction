# 1. Reset tags to ensure only one effect is active
tag @a remove nv_active
tag @a remove invis_active
tag @a remove fire_active
tag @a remove water_active
tag @a remove strength_active
tag @a remove slowness_active
tag @a remove speed_active
tag @a remove health_active
tag @a remove leap_active
tag @a remove harming_active
tag @a remove poison_active
tag @a remove regen_active
tag @a remove weakness_active
tag @a remove bad_omen_active
tag @a remove haste_active
tag @a remove luck_active
tag @a remove luck_roll_active
tag @a remove wither_active
tag @a remove darkness_active
tag @a remove ability_selected
tag @a remove backstab_source
tag @a remove backstab_target

# 2. Detect Effects (using custom item components in 1.21+)
# Example: Give an effect using: /give @s paper[custom_data={smp_effect:"night_vision"}]
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"night_vision"}}}]}] run tag @s add nv_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"night_vision"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"invisibility"}}}]}] run tag @s add invis_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"invisibility"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"leaping"}}}]}] run tag @s add leap_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"leaping"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"fire_resistance"}}}]}] run tag @s add fire_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"fire_resistance"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"water_breathing"}}}]}] run tag @s add water_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"water_breathing"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"strength"}}}]}] run tag @s add strength_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"strength"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"weakness"}}}]}] run tag @s add weakness_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"weakness"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"slowness"}}}]}] run tag @s add slowness_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"slowness"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"speed"}}}]}] run tag @s add speed_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"speed"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"instant_health"}}}]}] run tag @s add health_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"instant_health"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"harming"}}}]}] run tag @s add harming_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"harming"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"poison"}}}]}] run tag @s add poison_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"poison"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"regeneration"}}}]}] run tag @s add regen_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"regeneration"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"bad_omen"}}}]}] run tag @s add bad_omen_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"bad_omen"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"haste"}}}]}] run tag @s add haste_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"haste"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"luck"}}}]}] run tag @s add luck_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"luck"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"wither"}}}]}] run tag @s add wither_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"wither"}}}]}] run tag @s add ability_selected
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"darkness"}}}]}] run tag @s add darkness_active
execute as @a[tag=!ability_selected,nbt={Inventory:[{components:{"minecraft:custom_data":{smp_effect:"darkness"}}}]}] run tag @s add ability_selected

# 3. Apply Effect Logic
execute as @a run function smp:apply_effects
tag @e[type=minecraft:wither_skull,tag=smp_wither_projectile] remove smp_wither_projectile
execute as @e[type=minecraft:marker,tag=smp_sonic_boom] at @s run tp @s ^ ^ ^1
execute as @e[type=minecraft:marker,tag=smp_sonic_boom] at @s run particle minecraft:sonic_boom ~ ~ ~
execute as @e[type=minecraft:marker,tag=smp_sonic_boom] at @s as @e[distance=..1,tag=!smp_sonic_boom] run damage @s 10 minecraft:sonic_boom
execute as @e[type=minecraft:marker,tag=smp_sonic_boom] run scoreboard players add @s smp_sonic_age 1
kill @e[type=minecraft:marker,tag=smp_sonic_boom,scores={smp_sonic_age=20..}]
