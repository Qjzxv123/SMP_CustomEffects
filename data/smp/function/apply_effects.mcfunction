# Store the current daytime in a dummy scoreboard variable
execute store result score #daytime smp_timer run time query daytime

# --- Night Vision ---
execute if entity @s[tag=nv_active] run effect give @s minecraft:night_vision 11 0
execute if entity @s[tag=nv_active] if score #daytime smp_timer matches 0..12000 run effect give @s minecraft:weakness 1 0 true
execute if entity @s[tag=nv_active] if score #daytime smp_timer matches 13000..24000 run effect give @s minecraft:strength 1 1 true
execute if entity @s[tag=nv_active] at @s run effect give @e[type=player,tag=!nv_active,distance=..15] minecraft:glowing 1 0 true

# --- Invisibility ---
# 1. Initialize timer score to 0 if null
execute if entity @s[tag=invis_active] unless score @s smp_hit_timer = @s smp_hit_timer run scoreboard players set @s smp_hit_timer 0
# 2. Detect when player takes damage while holding the effect
execute if entity @s[tag=invis_active,scores={smp_took_damage=1..}] run scoreboard players set @s smp_hit_timer 200
execute if entity @s[tag=invis_active,scores={smp_took_damage=1..}] run scoreboard players set @s smp_took_damage 0
# 3. Apply Strength 1 & Invisibility ONLY when the 10-second timer is at 0
execute if entity @s[tag=invis_active] if score @s smp_hit_timer matches 0 run effect give @s minecraft:invisibility 1 0
execute if entity @s[tag=invis_active] if score @s smp_hit_timer matches 0 run effect give @s minecraft:strength 1 0 true
# 4. Count down the 10-second (200 ticks) reveal timer
execute if entity @s[scores={smp_hit_timer=1..}] run scoreboard players remove @s smp_hit_timer 1

# Backstab: sneak to teleport behind the nearest player and deal damage.
execute if entity @s[tag=invis_active] unless score @s smp_backstab_cd = @s smp_backstab_cd run scoreboard players set @s smp_backstab_cd 0
execute if entity @s[scores={smp_backstab_cd=1..}] run scoreboard players remove @s smp_backstab_cd 1
execute if entity @s[tag=invis_active,scores={smp_backstab_cd=0}] run title @s actionbar [{"text":"Backstab Ready","color":"green"}]
execute if entity @s[tag=invis_active,scores={smp_sneak=1..}] if score @s smp_backstab_cd matches 0 run tag @s add backstab_source
execute if entity @s[tag=backstab_source] at @s run tag @p[distance=1..15,sort=nearest] add backstab_target
execute if entity @s[tag=backstab_source] unless entity @a[tag=backstab_target] run title @s actionbar [{"text":"No Players Nearby","color":"dark_red"}]
execute if entity @a[tag=backstab_target] as @a[tag=backstab_target] at @s run tp @a[tag=backstab_source] ^ ^ ^-2
execute if entity @a[tag=backstab_target] as @a[tag=backstab_target] run damage @s 6 minecraft:player_attack
execute if entity @s[tag=backstab_source] run scoreboard players set @s smp_backstab_cd 600
tag @a remove backstab_source
tag @a remove backstab_target

# --- Leaping ---
execute if entity @s[tag=leap_active] run effect give @s minecraft:jump_boost 1 0 
# 1. Initialize cooldown
execute if entity @s[tag=leap_active] unless score @s smp_leap_cd = @s smp_leap_cd run scoreboard players set @s smp_leap_cd 0
# 2. Gives the player a safe fall distance of 1000 blocks when the effect is active, and removes it when inactive
execute if entity @s[tag=leap_active] run attribute @s minecraft:safe_fall_distance modifier add smp:leaping 1000 add_value
execute if entity @s[tag=!leap_active] run attribute @s minecraft:safe_fall_distance modifier remove smp:leaping
# 3. Launch the ground slam when sneaking and cooldown is ready (score = 0)
execute if entity @s[tag=leap_active,scores={smp_sneak=1..}] if score @s smp_leap_cd matches 0 run effect give @s minecraft:levitation 1 15 true
execute if entity @s[tag=leap_active,scores={smp_sneak=1..}] if score @s smp_leap_cd matches 0 run tag @s add leap_slam
execute if entity @s[tag=leap_slam] run attribute @s minecraft:gravity modifier add smp:leap_slam 5 add_value
execute if entity @s[tag=!leap_slam] run attribute @s minecraft:gravity modifier remove smp:leap_slam
execute if entity @s[tag=leap_active,scores={smp_sneak=1..}] if score @s smp_leap_cd matches 0 run scoreboard players set @s smp_leap_cd 200
# 4. Decrement cooldown (60 ticks = 3 second cooldown)
execute if entity @s[scores={smp_leap_cd=1..}] run scoreboard players remove @s smp_leap_cd 1
execute if entity @s[tag=leap_slam,nbt={OnGround:1b},scores={smp_leap_cd=..180}] at @s as @e[distance=..5,tag=!leap_active] run damage @s 6 minecraft:player_attack
execute if entity @s[tag=leap_slam,nbt={OnGround:1b},scores={smp_leap_cd=..180}] run tag @s remove leap_slam

# --- Fire Resistance ---
execute if entity @s[tag=fire_active] run effect give @s minecraft:fire_resistance 1 0
execute if entity @s[tag=fire_active] at @s if block ~ ~ ~ minecraft:water run damage @s 2 minecraft:magic
execute if entity @s[tag=fire_active] at @s if dimension minecraft:the_nether run effect give @s minecraft:strength 1 0 true
execute if entity @s[tag=fire_active] unless score @s smp_fireball_cd = @s smp_fireball_cd run scoreboard players set @s smp_fireball_cd 0
execute if entity @s[scores={smp_fireball_cd=1..}] run scoreboard players remove @s smp_fireball_cd 1
execute if entity @s[tag=fire_active,scores={smp_sneak=1..}] if score @s smp_fireball_cd matches 0 at @s anchored eyes run summon minecraft:fireball ^ ^ ^1 {ExplosionPower:10}
execute if entity @s[tag=fire_active,scores={smp_sneak=1..}] if score @s smp_fireball_cd matches 0 run scoreboard players set @s smp_fireball_cd 600

# --- Speed ---
execute if entity @s[tag=speed_active] run effect give @s minecraft:speed 1 1
execute if entity @s[tag=speed_active] run effect give @s minecraft:hunger 1 2 true
execute if entity @s[tag=speed_active] unless score @s smp_speed_cd = @s smp_speed_cd run scoreboard players set @s smp_speed_cd 0
execute if entity @s[scores={smp_speed_cd=1..}] run scoreboard players remove @s smp_speed_cd 1
execute if entity @s[tag=speed_active,scores={smp_sneak=1..}] if score @s smp_speed_cd matches 0 at @s run tp @s ^ ^ ^20
execute if entity @s[tag=speed_active,scores={smp_sneak=1..}] if score @s smp_speed_cd matches 0 run scoreboard players set @s smp_speed_cd 200

# --- Slowness ---
execute if entity @s[tag=slowness_active] run effect give @s minecraft:strength 1 1 true
execute if entity @s[tag=slowness_active] run effect give @s minecraft:slowness 1 1 
execute if entity @s[tag=slowness_active] run effect give @s minecraft:mining_fatigue 1 0 true

# --- Water Breathing ---
execute if entity @s[tag=water_active] run effect give @s minecraft:water_breathing 1 0 
execute if entity @s[tag=water_active] at @s if block ~ ~ ~ minecraft:water run effect give @s minecraft:dolphins_grace 2 0 true
execute if entity @s[tag=water_active] at @s if block ~ ~ ~ minecraft:water run effect give @s minecraft:regeneration 2 0 true

# --- Instant Health ---
# 1. Initialize health cooldown to 0 if null
execute if entity @s[tag=health_active] unless score @s smp_health_cd = @s smp_health_cd run scoreboard players set @s smp_health_cd 0
# 2. Trigger Instant Health II & sound when sneaking AND cooldown is 0
execute if entity @s[tag=health_active,scores={smp_sneak=1..}] if score @s smp_health_cd matches 0 run effect give @s minecraft:instant_health 1 1 true
execute if entity @s[tag=health_active,scores={smp_sneak=1..}] if score @s smp_health_cd matches 0 at @s run playsound minecraft:entity.splash_potion.throw player @a ~ ~ ~ 1 0
execute if entity @s[tag=health_active,scores={smp_sneak=1..}] if score @s smp_health_cd matches 0 at @s run playsound minecraft:entity.splash_potion.break player @a
# 3. Set the 30-second cooldown (600 ticks) ONLY when triggered
execute if entity @s[tag=health_active,scores={smp_sneak=1..}] if score @s smp_health_cd matches 0 run scoreboard players set @s smp_health_cd 600
# 4. Tick down the cooldown
execute if entity @s[scores={smp_health_cd=1..}] run scoreboard players remove @s smp_health_cd 1

# --- Harming ---
execute if entity @s[tag=harming_active] run attribute @s minecraft:armor modifier add harming -5 add_value
execute if entity @s[tag=!harming_active] run attribute @s minecraft:armor modifier remove harming
execute if entity @s[tag=harming_active] run attribute @s minecraft:attack_damage modifier add harming 5 add_value
execute if entity @s[tag=!harming_active] run attribute @s minecraft:attack_damage modifier remove harming

# --- Poison ---
# Poison nearby entities with Poison II for 10 seconds when sneaking.
execute if entity @s[tag=poison_active] unless score @s smp_poison_cd = @s smp_poison_cd run scoreboard players set @s smp_poison_cd 0
execute if entity @s[tag=poison_active,scores={smp_sneak=1..}] if score @s smp_poison_cd matches 0 at @s run effect give @e[distance=..15,tag=!poison_active] minecraft:poison 10 1
execute if entity @s[tag=poison_active,scores={smp_sneak=1..}] if score @s smp_poison_cd matches 0 at @s run playsound minecraft:entity.ender_dragon.shoot player @a ~ ~ ~ 1 0
execute if entity @s[tag=poison_active,scores={smp_sneak=1..}] if score @s smp_poison_cd matches 0 at @s run particle entity_effect{color:[0.529,0.639,0.388,1.00]} ~ ~ ~ 15 1 15 0 10000 normal
execute if entity @s[tag=poison_active,scores={smp_sneak=1..}] if score @s smp_poison_cd matches 0 run scoreboard players set @s smp_poison_cd 300
execute if entity @s[scores={smp_poison_cd=1..}] run scoreboard players remove @s smp_poison_cd 1

# --- Regeneration ---
execute if entity @s[tag=regen_active] run effect give @s minecraft:regeneration 1 0

# --- Strength ---
execute if entity @s[tag=strength_active] run effect give @s minecraft:strength 1 0
execute if entity @s[tag=strength_active,scores={smp_health=..10}] run effect give @s minecraft:strength 1 2

# --- Weakness ---
execute if entity @s[tag=weakness_active] run effect give @s minecraft:weakness 1 0
execute if entity @s[tag=weakness_active] run effect give @s minecraft:resistance 1 1 true
execute if entity @s[tag=weakness_active] run effect give @s minecraft:speed 1 0 true 

# --- Bad Omen ---
execute if entity @s[tag=bad_omen_active] run attribute @s minecraft:max_health modifier add bad_omen -5 add_value
execute if entity @s[tag=!bad_omen_active] run attribute @s minecraft:max_health modifier remove bad_omen
execute if entity @s[tag=bad_omen_active] run effect give @s minecraft:bad_omen 1 0
execute if entity @s[tag=bad_omen_active] unless score @s smp_bad_omen_cd = @s smp_bad_omen_cd run scoreboard players set @s smp_bad_omen_cd 0
execute if entity @s[tag=bad_omen_active,scores={smp_sneak=1..}] if score @s smp_bad_omen_cd matches 0 at @s run playsound minecraft:block.trial_spawner.spawn_mob player @a ~ ~ ~ 1 1
execute if entity @s[tag=bad_omen_active,scores={smp_sneak=1..}] if score @s smp_bad_omen_cd matches 0 at @s run summon tnt ~ ~15 ~ {NoGravity:1b,fuse:60,explosion_power:10,Motion:[0.0,-0.5,0.0],Tags:["heavycore"],block_state:{Name:"minecraft:air"}}
execute if entity @s[tag=bad_omen_active,scores={smp_sneak=1..}] if score @s smp_bad_omen_cd matches 0 at @s run summon item_display ~ ~10 ~ {Tags:["heavycore"],item_display:"head",Motion:[0.0,-5.0,0.0],transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f],scale:[5f,5f,5f]},item:{id:"minecraft:heavy_core",count:1}}
tp @e[type=item_display,tag=heavycore] @e[type=tnt,tag=heavycore,limit=1]
execute unless entity @e[type=tnt,tag=heavycore] run kill @e[type=item_display,tag=heavycore]
execute if entity @s[tag=bad_omen_active,scores={smp_sneak=1..}] if score @s smp_bad_omen_cd matches 0 run scoreboard players set @s smp_bad_omen_cd 1200
execute if entity @s[scores={smp_bad_omen_cd=1..}] run scoreboard players remove @s smp_bad_omen_cd 1

# --- Haste ---
execute if entity @s[tag=haste_active] run effect give @s minecraft:haste 1 1
execute if entity @s[tag=haste_active] unless score @s smp_haste_cd = @s smp_haste_cd run scoreboard players set @s smp_haste_cd 0
execute if entity @s[scores={smp_haste_cd=1..}] run scoreboard players remove @s smp_haste_cd 1
execute if entity @s[tag=haste_active,scores={smp_sneak=1..}] if score @s smp_haste_cd matches 0 at @s run fill ~-8 ~ ~-8 ~7 ~-15 ~7 minecraft:air
execute if entity @s[tag=haste_active,scores={smp_sneak=1..}] if score @s smp_haste_cd matches 0 at @s run fill ~-8 ~-16 ~-8 ~7 ~-16 ~7 minecraft:pointed_dripstone
execute if entity @s[tag=haste_active,scores={smp_sneak=1..}] if score @s smp_haste_cd matches 0 at @s run setblock ~ ~-1 ~ minecraft:obsidian
execute if entity @s[tag=haste_active,scores={smp_sneak=1..}] if score @s smp_haste_cd matches 0 run scoreboard players set @s smp_haste_cd 6000

# --- Wither ---
execute if entity @s[tag=wither_active] run effect give @s minecraft:wither 1 0
execute if entity @s[tag=wither_active] unless score @s smp_wither_cd = @s smp_wither_cd run scoreboard players set @s smp_wither_cd 0
execute if entity @s[scores={smp_wither_cd=1..}] run scoreboard players remove @s smp_wither_cd 1
execute if entity @s[tag=wither_active,scores={smp_sneak=1..}] if score @s smp_wither_cd matches 0 at @s anchored eyes run summon minecraft:wither_skull ^ ^ ^1 {NoGravity:1b,Tags:["smp_wither_projectile"],dangerous:1b,acceleration_power:1d}
execute if entity @s[tag=wither_active,scores={smp_sneak=1..}] if score @s smp_wither_cd matches 0 at @s anchored eyes rotated as @s positioned 0.0 0.0 0.0 positioned ^ ^ ^2 summon minecraft:area_effect_cloud run data modify entity @e[type=minecraft:wither_skull,tag=smp_wither_projectile,sort=nearest,limit=1] Motion set from entity @s Pos
execute if entity @s[tag=wither_active,scores={smp_sneak=1..}] if score @s smp_wither_cd matches 0 run tag @e[type=minecraft:wither_skull,tag=smp_wither_projectile,sort=nearest,limit=1] remove smp_wither_projectile
execute if entity @s[tag=wither_active,scores={smp_sneak=1..}] if score @s smp_wither_cd matches 0 run scoreboard players set @s smp_wither_cd 200

# --- Luck ---
execute if entity @s[tag=luck_active] run effect give @s minecraft:luck 1 0 
execute if entity @s[tag=luck_active] unless score @s smp_luck_cd = @s smp_luck_cd run scoreboard players set @s smp_luck_cd 0
execute if entity @s[scores={smp_luck_cd=1..}] run scoreboard players remove @s smp_luck_cd 1
execute if entity @s[tag=luck_active,scores={smp_sneak=1..}] if score @s smp_luck_cd matches 0 run tag @s add luck_roll_active
execute if entity @s[tag=luck_roll_active] run execute store result score @s smp_luck_roll run random roll 1..6
execute if entity @s[tag=luck_active,scores={smp_sneak=1..}] if score @s smp_luck_cd matches 0 run scoreboard players set @s smp_luck_cd 600
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=1}] run title @s actionbar [{"text":"Roll 1: Unlucky!","color":"dark_red"}]
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=1}] run damage @s 6 minecraft:magic
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=1}] run effect give @s minecraft:weakness 10 0 true
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=2}] run title @s actionbar [{"text":"Roll 2: Inconvenient!","color":"red"}]
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=2}] run effect give @s minecraft:slowness 10 1 true
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=2}] run effect give @s minecraft:nausea 10 0 true
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=3..4}] run title @s actionbar [{"text":"Roll 3-4: Nothing happens","color":"gray"}]
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=5}] run title @s actionbar [{"text":"Roll 5: Convenient!","color":"green"}]
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=5}] run effect give @s minecraft:speed 10 1 true
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=5}] run effect give @s minecraft:regeneration 10 0 true
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=6}] run title @s actionbar [{"text":"Roll 6: JACKPOT!","color":"gold"}]
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=6}] run effect give @s minecraft:strength 15 1 true
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=6}] run effect give @s minecraft:regeneration 15 1 true
execute if entity @s[tag=luck_roll_active,scores={smp_luck_roll=6}] run effect give @s minecraft:absorption 15 3 true
tag @a remove luck_roll_active

# --- Darkness ---
execute if entity @s[tag=darkness_active] run effect give @s minecraft:darkness 1 0 
execute if entity @s[tag=darkness_active] at @s run effect give @e[distance=..15,tag=!darkness_active] minecraft:glowing 2 0 true
execute if entity @s[tag=darkness_active] unless score @s smp_darkness_cd = @s smp_darkness_cd run scoreboard players set @s smp_darkness_cd 0
execute if entity @s[scores={smp_darkness_cd=1..}] run scoreboard players remove @s smp_darkness_cd 1
execute if entity @s[tag=darkness_active,scores={smp_sneak=1..}] if score @s smp_darkness_cd matches 0 at @s anchored eyes run summon minecraft:marker ^ ^ ^1 {Tags:["smp_sonic_boom"]}
execute if entity @s[tag=darkness_active,scores={smp_sneak=1..}] if score @s smp_darkness_cd matches 0 run data modify entity @e[type=minecraft:marker,tag=smp_sonic_boom,sort=nearest,limit=1] Rotation set from entity @s Rotation
execute if entity @s[tag=darkness_active,scores={smp_sneak=1..}] if score @s smp_darkness_cd matches 0 run playsound minecraft:entity.warden.sonic_boom player @a ~ ~ ~ 1 1
execute if entity @s[tag=darkness_active,scores={smp_sneak=1..}] if score @s smp_darkness_cd matches 0 run scoreboard players set @s smp_darkness_cd 600


# Consume the sneak trigger after the active effect has processed it.
execute if entity @s[scores={smp_sneak=1..}] run scoreboard players set @s smp_sneak 0
