ExplosionEnum = Class(Enum)

-- Taken from here https://github.com/crosire/scripthookvdotnet/blob/master/source/scripting_v3/GTA/Control.cs
function ExplosionEnum:__init()
    self:EnumInit()

    self.DONTCARE = -1
    self.GRENADE = 0
    self.GRENADELAUNCHER = 1
    self.STICKYBOMB = 2
    self.MOLOTOV = 3
    self.ROCKET = 4
    self.TANKSHELL = 5
    self.HI_OCTANE = 6
    self.CAR = 7
    self.PLANE = 8
    self.PETROL_PUMP = 9
    self.BIKE = 10
    self.DIR_STEAM = 11
    self.DIR_FLAME = 12
    self.DIR_WATER_HYDRANT = 13
    self.DIR_GAS_CANISTER = 14
    self.BOAT = 15
    self.SHIP_DESTROY = 16
    self.TRUCK = 17
    self.BULLET = 18
    self.SMOKEGRENADELAUNCHER = 19
    self.SMOKEGRENADE = 20
    self.BZGAS = 21
    self.FLARE = 22
    self.GAS_CANISTER = 23
    self.EXTINGUISHER = 24
    self._0x988620B8 = 25
    self.EXP_TAG_TRAIN = 26
    self.EXP_TAG_BARREL = 27
    self.EXP_TAG_PROPANE = 28
    self.EXP_TAG_BLIMP = 29
    self.EXP_TAG_DIR_FLAME_EXPLODE = 30
    self.EXP_TAG_TANKER = 31
    self.PLANE_ROCKET = 32
    self.EXP_TAG_VEHICLE_BULLET = 33
    self.EXP_TAG_GAS_TANK = 34
    self.EXP_TAG_BIRD_CRAP = 35
    self.EXP_TAG_RAILGUN = 36
    self.EXP_TAG_BLIMP2 = 37
    self.EXP_TAG_FIREWORK = 38
    self.EXP_TAG_SNOWBALL = 39
    self.EXP_TAG_PROXMINE = 40
    self.EXP_TAG_VALKYRIE_CANNON = 41
    self.EXP_TAG_AIR_DEFENCE = 42
    self.EXP_TAG_PIPEBOMB = 43
    self.EXP_TAG_VEHICLEMINE = 44
    self.EXP_TAG_EXPLOSIVEAMMO = 45
    self.EXP_TAG_APCSHELL = 46
    self.EXP_TAG_BOMB_CLUSTER = 47
    self.EXP_TAG_BOMB_GAS = 48
    self.EXP_TAG_BOMB_INCENDIARY = 49
    self.EXP_TAG_BOMB_STANDARD = 50
    self.EXP_TAG_TORPEDO = 51
    self.EXP_TAG_TORPEDO_UNDERWATER = 52
    self.EXP_TAG_BOMBUSHKA_CANNON = 53
    self.EXP_TAG_BOMB_CLUSTER_SECONDARY = 54
    self.EXP_TAG_HUNTER_BARRAGE = 55
    self.EXP_TAG_HUNTER_CANNON = 56
    self.EXP_TAG_ROGUE_CANNON = 57
    self.EXP_TAG_MINE_UNDERWATER = 58
    self.EXP_TAG_ORBITAL_CANNON = 59
    self.EXP_TAG_BOMB_STANDARD_WIDE = 60
    self.EXP_TAG_EXPLOSIVEAMMO_SHOTGUN = 61
    self.EXP_TAG_OPPRESSOR2_CANNON = 62
    self.EXP_TAG_MORTAR_KINETIC = 63
    self.EXP_TAG_VEHICLEMINE_KINETIC = 64
    self.EXP_TAG_VEHICLEMINE_EMP = 65
    self.EXP_TAG_VEHICLEMINE_SPIKE = 66
    self.EXP_TAG_VEHICLEMINE_SLICK = 67
    self.EXP_TAG_VEHICLEMINE_TAR = 68
    self.EXP_TAG_SCRIPT_DRONE = 69
    self.EXP_TAG_RAYGUN = 70
    self.EXP_TAG_BURIEDMINE = 71
    self.EXP_TAG_SCRIPT_MISSILE = 72
    self.EXP_TAG_RCTANK_ROCKET = 73
    self.EXP_TAG_BOMB_WATER = 74
    self.EXP_TAG_BOMB_WATER_SECONDARY = 75
    self._0xF728C4A9 = 76
    self._0xBAEC056F = 77
    self.EXP_TAG_FLASHGRENADE = 78
    self.EXP_TAG_STUNGRENADE = 79
    self._0x763D3B3B = 80
    self.EXP_TAG_SCRIPT_MISSILE_LARGE = 81
    self.EXP_TAG_SUBMARINE_BIG = 82
end

ExplosionEnum = ExplosionEnum()