local mod = get_mod("level_debug")
local debug_utils = get_mod("debug_utils")
local MonsterPacing = require("scripts/managers/pacing/monster_pacing/monster_pacing")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local SharedNav = require("scripts/components/utilities/shared_nav")
local MissionTemplates = require("scripts/settings/mission/mission_templates")


mod:command("drawer", "", function() 
  local local_player = Managers.player:local_player(1)
  local local_player_unit = local_player.player_unit
  local current_position = Unit.local_position(local_player_unit, 1)
  local h = Vector3(0, 0, 1)
  QuickDrawerStay:sphere(current_position, 0.25, Color.light_green())
end)

mod:command("main_path", "", function() 
  local h = Vector3(0, 0, 1)
  local main_path_manager = Managers.state.main_path
  main_path_segments = main_path_manager._main_path_segments
  mod:echo(main_path_segments)
	for i = 1, #main_path_segments, 1 do
		local path = main_path_segments[i].nodes

		for j = 1, #path, 1 do
			local position = Vector3(path[j][1], path[j][2], path[j][3])
      mod:echo(position)
			QuickDrawerStay:sphere(position + h, 0.25, Color.light_green())

			if j == #path and i ~= #main_path_segments then
				local nextPositon = Vector3(main_path_segments[i + 1].nodes[1][1], main_path_segments[i + 1].nodes[1][2], main_path_segments[i + 1].nodes[1][3])

				QuickDrawerStay:line(position + h, nextPositon + h, Color.yellow())
			elseif j ~= #path then
				local nextPositon = Vector3(path[j + 1][1], path[j + 1][2], path[j + 1][3])

				QuickDrawerStay:line(position + h, nextPositon + h, Color.light_green())
			end
		end
	end
end)

mod:command("monsters", "", function() 
  local debug_text = Managers.state.debug_text
  mod:echo(debug_text)
  local h = Vector3(0, 0, 1)
  local main_path_manager = Managers.state.main_path
  main_path_segments = main_path_manager._main_path_segments

  local monster_pacing = Managers.state.pacing._monster_pacing
  -- mod:echo(monster_pacing)
  local spawn_type_point_sections = monster_pacing._spawn_type_point_sections
  -- mod:echo(spawn_type_point_sections)

  local count = 0
  for spawn_type, spawn_type_data in pairs(spawn_type_point_sections) do
    -- mod:echo(spawn_type)
    -- mod:echo(spawn_type_data)
    
    for section, section_data in pairs(spawn_type_data) do
      -- mod:echo(section)
      -- mod:echo(section_data)
      for spawn, spawn_data in pairs(section_data) do
        -- mod:echo(spawn)
        -- mod:echo(spawn_data.spawn_travel_distance)
        -- mod:echo(spawn_data.position)
        local spawn_position = spawn_data.position:unbox()
        local spawn_trigger_position = MainPathQueries.position_from_distance(spawn_data.spawn_travel_distance)
        -- mod:echo(spawn_trigger_position)
        -- mod:echo(spawn_position)
        QuickDrawerStay:sphere(spawn_trigger_position + h, 0.25, Color.red())
        QuickDrawerStay:sphere(spawn_position, 5, Color.red())
        QuickDrawerStay:line(spawn_trigger_position + h, spawn_position, Color.red())
        -- mod:echo(debug_utils.debug_text)
        local text_size = .1
        debug_utils.debug_text:output_world_text(spawn_type, text_size, spawn_trigger_position + h * 1.5 + Vector3(0, 0, .25 * count) , nil, "category: item_spawner_id", Color.yellow())
      end
    end
    count = count + 1
  end

  mod:dump(debug_utils.debug_text, "debug", 4)




end)

mod:command("path_marker", "", function() 
  local h = Vector3(0, 0, 1)
  local main_path_manager = Managers.state.main_path
  local path_markers = main_path_manager._path_markers
  mod:echo(path_markers)
  -- mod:dump(path_markers, "test_mark", 2)
	-- for i = 1, #path_markers, 1 do
  --   mod:echo(i)
	-- 	local postion = path_markers[i]
  --   mod:echo(position)
	-- end
  for key, value in pairs(path_markers) do
    mod:echo(key)
    mod:echo(value.position)
    mod:echo(value.position:unbox())
    QuickDrawerStay:sphere(value.position:unbox(), 1, Color.red())
  end
end)

mod:command("nav_spawn", "", function() 
  -- local pacing = Managers.state.pacing
  -- local monster_pacing = pacing._monster_pacing
  -- local nav_world = monster_pacing._nav_world
  -- mod:echo(nav_world)
  -- mod:dump(pacing, "pacing", 2)

  local nav_info = SharedNav.create_nav_info()
  -- mod:echo(nav_info)
  -- mod:dump(nav_info, "nav_info", 1)
  -- local nav_spawn_points = GwNavSpawnPoints.create(nav_world, nav_triangle_group)
end)

mod:command("position", "", function() 
  local local_player = Managers.player:local_player(1)
  local local_player_unit = local_player.player_unit
  mod:echo(local_player_unit)
  local current_position = Unit.local_position(local_player_unit, 1)
  mod:echo(current_position)
  local path_position, travel_distance = MainPathQueries.closest_position(current_position)
  mod:echo(path_position)
end)


mod:command("mission", "", function() 
  mod:echo(MissionTemplates)
  
  local mission_name = Managers.state.mission:mission_name()
  mod:dump(MissionTemplates[mission_name], "mission_name", 2)
end)
mod:command("dump", "", function() 
  mod:dump(Managers.state.main_path._path_markers, "_path_markers", 5)
end)

mod.current_progress = function() 
  local h = Vector3(0, 0, 1)
  local local_player = Managers.player:local_player(1)
  local local_player_unit = local_player.player_unit
  -- mod:echo(local_player_unit)
  local current_position = Unit.local_position(local_player_unit, 1)
  -- mod:echo(current_position)
  local path_position, travel_distance = MainPathQueries.closest_position(current_position)
  -- mod:echo(path_position)
  QuickDrawer:sphere(path_position + h, 0.25, Color.yellow())
  QuickDrawer:line(path_position + h, current_position + h, Color.yellow())
end

-- mod.update = function()
--   mod.current_progress()

-- end
-- mod.update = function() 
--   local local_player = Managers.player:local_player(1)
--   local local_player_unit = local_player.player_unit
--   local main_path_connection_node = Unit.node(local_player_unit, "main_path_connection")
--   local main_path_connection_position = Unit.world_position(local_player_unit, main_path_connection_node)
-- 	local path_position, travel_distance = MainPathQueries.closest_position(main_path_connection_position)
--   QuickDrawer:sphere(path_position, 0.25, Color.red())
-- end

-- Your mod code goes here.
-- https://vmf-docs.verminti.de
