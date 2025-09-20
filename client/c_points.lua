---@class PointProperties
---@field coords vector3
---@field distance number
---@field onEnter? fun(self: CPoint)
---@field onExit? fun(self: CPoint)
---@field onPedStanding? fun(self: CPoint)
---@field [string] any

---@class CPoint : PointProperties
---@field id number
---@field currentDistance number
---@field isClosest? boolean
---@field remove fun()

---@type table<number, CPoint>
local registry_points = {}
---@type CPoint[]
local nearbyPoints = {}
local nearbyCount = 0
---@type CPoint?
local closestPoint
local tick

local listZoneName = {
    ['AIRP'] = 'Los Santos International Airport',
    ['ALAMO'] = 'Alamo Sea',
    ['ALTA'] = 'Alta',
    ['ARMYB'] = 'Fort Zancudo',
    ['BANHAMC'] = 'Banham Canyon Dr',
    ['BANNING'] = 'Banning',
    ['BEACH'] = 'Vespucci Beach',
    ['BHAMCA'] = 'Banham Canyon',
    ['BRADP'] = 'Braddock Pass',
    ['BRADT'] = 'Braddock Tunnel',
    ['BURTON'] = 'Burton',
    ['CALAFB'] = 'Calafia Bridge',
    ['CANNY'] = 'Raton Canyon',
    ['CCREAK'] = 'Cassidy Creek',
    ['CHAMH'] = 'Chamberlain Hills',
    ['CHIL'] = 'Vinewood Hills',
    ['CHU'] = 'Chumash',
    ['CMSW'] = 'Chiliad Mountain State Wilderness',
    ['CYPRE'] = 'Cypress Flats',
    ['DAVIS'] = 'Davis',
    ['DELBE'] = 'Del Perro Beach',
    ['DELPE'] = 'Del Perro',
    ['DELSOL'] = 'La Puerta',
    ['DESRT'] = 'Grand Senora Desert',
    ['DOWNT'] = 'Downtown',
    ['DTVINE'] = 'Downtown Vinewood',
    ['EAST_V'] = 'East Vinewood',
    ['EBURO'] = 'El Burro Heights',
    ['ELGORL'] = 'El Gordo Lighthouse',
    ['ELYSIAN'] = 'Elysian Island',
    ['GALFISH'] = 'Galilee',
    ['GALLI'] = 'Galli',
    ['GOLF'] = 'GWC and Golfing Society',
    ['GRAPES'] = 'Grapeseed',
    ['GREATC'] = 'Great Chaparral',
    ['HARMO'] = 'Harmony',
    ['HAWICK'] = 'Hawick',
    ['HORS'] = 'Vinewood Racetrack',
    ['HUMLAB'] = 'Humane Labs and Research',
    ['JAIL'] = 'Bolingbroke Penitentiary',
    ['KOREAT'] = 'Little Seoul',
    ['LACT'] = 'Land Act Reservoir',
    ['LAGO'] = 'Lago Zancudo',
    ['LDAM'] = 'Land Act Dam',
    ['LEGSQU'] = 'Legion Square',
    ['LMESA'] = 'La Mesa',
    ['LOSPUER'] = 'La Puerta',
    ['MIRR'] = 'Mirror Park',
    ['MORN'] = 'Morningwood',
    ['MOVIE'] = 'Richards Majestic',
    ['MTCHIL'] = 'Mount Chiliad',
    ['MTGORDO'] = 'Mount Gordo',
    ['MTJOSE'] = 'Mount Josiah',
    ['MURRI'] = 'Murrieta Heights',
    ['NCHU'] = 'North Chumash',
    ['NOOSE'] = 'N.O.O.S.E',
    ['OCEANA'] = 'Pacific Ocean',
    ['PALCOV'] = 'Paleto Cove',
    ['PALETO'] = 'Paleto Bay',
    ['PALFOR'] = 'Paleto Forest',
    ['PALHIGH'] = 'Palomino Highlands',
    ['PALMPOW'] = 'Palmer-Taylor Power Station',
    ['PBLUFF'] = 'Pacific Bluffs',
    ['PBOX'] = 'Pillbox Hill',
    ['PROCOB'] = 'Procopio Beach',
    ['RANCHO'] = 'Rancho',
    ['RGLEN'] = 'Richman Glen',
    ['RICHM'] = 'Richman',
    ['ROCKF'] = 'Rockford Hills',
    ['RTRAK'] = 'Redwood Lights Track',
    ['SANAND'] = 'San Andreas',
    ['SANCHIA'] = 'San Chianski Mountain Range',
    ['SANDY'] = 'Sandy Shores',
    ['SKID'] = 'Mission Row',
    ['SLAB'] = 'Stab City',
    ['STAD'] = 'Maze Bank Arena',
    ['STRAW'] = 'Strawberry',
    ['TATAMO'] = 'Tataviam Mountains',
    ['TERMINA'] = 'Terminal',
    ['TEXTI'] = 'Textile City',
    ['TONGVAH'] = 'Tongva Hills',
    ['TONGVAV'] = 'Tongva Valley',
    ['VCANA'] = 'Vespucci Canals',
    ['VESP'] = 'Vespucci',
    ['VINE'] = 'Vinewood',
    ['WINDF'] = 'Ron Alternates Wind Farm',
    ['WVINE'] = 'West Vinewood',
    ['ZANCUDO'] = 'Zancudo River',
    ['ZP_ORT'] = 'Port of South Los Santos',
    ['ZQ_UAR'] = 'Davis Quartz',
    ['PROL'] = 'Prologue / North Yankton',
    ['ISHEIST'] = 'Cayo Perico Island',
    ['OBSERV'] = 'Galileo Observatory',
}

for i, v in pairs(listZoneName) do
	registry_points[i] = {} ---create a empty table without double clear
end

local function removePoint(self)
	if closestPoint?.id == self.id then
		closestPoint = nil
	end

	registry_points[self.zone][self.id] = nil
end


local intervals = {}
--- Dream of a world where this PR gets accepted.
---@param callback function | number
---@param interval? number
---@param ... any
function SetInterval(callback, interval, ...)
	interval = interval or 0

	if type(interval) ~= 'number' then
		return error(('Interval must be a number. Received %s'):format(json.encode(interval --[[@as unknown]])))
	end

	local cbType = type(callback)

	if cbType == 'number' and intervals[callback] then
		intervals[callback] = interval or 0
		return
	end

	if cbType ~= 'function' then
		return error(('Callback must be a function. Received %s'):format(cbType))
	end

	local args, id = { ... }, nil

	Citizen.CreateThreadNow(function(ref)
		id = ref
		intervals[id] = interval or 0
		repeat
			interval = intervals[id]
			Wait(interval)
			callback(table.unpack(args))
		until interval < 0
		intervals[id] = nil
	end)

	return id
end

---@param id number
function ClearInterval(id)
	if type(id) ~= 'number' then
		return error(('Interval id must be a number. Received %s'):format(json.encode(id --[[@as unknown]])))
	end

	if not intervals[id] then
		return error(('No interval exists with id %s'):format(id))
	end

	intervals[id] = -1
end

CreateThread(function()
	while true do
		if nearbyCount ~= 0 then
			table.wipe(nearbyPoints)
			nearbyCount = 0
		end

		local coords = GetEntityCoords(PlayerPedId())
		local zoneName = GetNameOfZone(coords.x, coords.y, coords.z):upper()

		if closestPoint and #(coords - closestPoint.coords) > closestPoint.distance then
			closestPoint = nil
		end

		for _, point in pairs(registry_points[zoneName]) do
			local distance = #(coords - point.coords)

			if distance <= point.distance then
				point.currentDistance = distance

				if closestPoint then
					if distance < closestPoint.currentDistance then
						closestPoint.isClosest = nil
						point.isClosest = true
						closestPoint = point
					end
				elseif distance < point.distance then
					point.isClosest = true
					closestPoint = point
				end

				if point.onPedStanding then
					nearbyCount += 1
					nearbyPoints[nearbyCount] = point
				end

				if point.onEnter and not point.inside then
					point.inside = true
					point:onEnter()
				end
			elseif point.currentDistance then
				if point.onExit then point:onExit() end
				point.inside = nil
				point.currentDistance = nil
			end
		end

		if not tick then
			if nearbyCount ~= 0 then
				tick = SetInterval(function()
					for i = 1, nearbyCount do
						local point = nearbyPoints[i]

						if point then
							point:onPedStanding()
						end
					end
				end)
			end
		elseif nearbyCount == 0 then
			tick = ClearInterval(tick)
		end

		Wait(300)
	end
end)

local function toVector(coords)
	local _type = type(coords)

	if _type ~= 'vector3' then
		if _type == 'table' or _type == 'vector4' then
			return vec3(coords[1] or coords.x, coords[2] or coords.y, coords[3] or coords.z)
		end

		error(("expected type 'vector3' or 'table' (received %s)"):format(_type))
	end

	return coords
end

Point = {
	---@return CPoint
	---@overload fun(data: PointProperties): CPoint
	add = function(...)
		local args = { ... }

		local coords = args[1].coords
		local zoneName = GetNameOfZone(coords.x, coords.y, coords.z):upper()
		local id = #registry_points[zoneName] + 1

		local self

		self = args[1]
		self.id = id
		self.zone = zoneName
		self.remove = removePoint

		self.coords = toVector(self.coords)
		self.distance = self.distance

		registry_points[zoneName][id] = self

		return self
	end,

	getAllPoints = function() return registry_points end,

	getNearbyPoints = function() return nearbyPoints end,

	---@return CPoint?
	getClosestPoint = function() return closestPoint end,
}
