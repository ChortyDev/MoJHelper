script_author('Chorty')
script_version(1.1)
script_name('MOJ Helper (Helper for the Ministry of Justice)')
-- // --- [Require] --- \\ --
local imgui = require('imgui')
local memory = require("memory")
local encoding = require 'encoding'
local wm = require 'lib.windows.message'
local fa = require 'fAwesome6'
require("moonloader")
require("sampfuncs")
require 'vkeys'
local vasd = require 'vkeys'.id_to_name
local pie = require("imgui_piemenu")
local cjson = require( "cjson" )
-- \\ --- ------- ---- // --
encoding.default = 'CP1251'
u8 = encoding.UTF8

local main_table = {
    main = {
        cmd_act = 'moj',
		f_name = '',
		female = 0,
		rang1 = '',
		phone = '',
		frak = '',
		tegr = '',
		tegf = '',
		dop_channel = false,
		frakid = 0,
		theme = 0,
		dop_channel = false,
		rp_arrest = false,
		rpgun = true,
		dopsu = false,
		dopticket = false,
		new_arrest = false,
		dop_channel = true,
		rp_say = false,
		not_update_codecs = false,
		opt_enb = false,
		rp_point = false,
		autoskreen = false,
		off_podskaz = false,
		wait_cmd = 1.200,
		hud1 = false,
		hud_city = false,
		hud_zone = false,
		hud_kvadrat = false,
		hud_post = false,
		hud_channel = false,
		hud_cardinalpoints = false,
		hud_hp = false,
		hud_armour = false,
		hud_ping = false,
		hud_time = false,
		hud_radio_title = false,
		hud_icon = false,
		colors1_hud_r = -1,
		colors1_hud_g = -1,
		colors1_hud_b = -1,
		colors1_hud_a = -1,
    }
}
-- HOTKEY
local tBlockKeys = {[VK_RETURN] = true, [VK_T] = true, [VK_F6] = true, [VK_F8] = true}
local tBlockChar = {[116] = true, [84] = true}
local tModKeys = {[VK_MENU] = true, [VK_SHIFT] = true, [VK_CONTROL] = true}
local tBlockNextDown = {}

local tHotKeyData = {
    edit = nil,
	save = {},
   lastTick = os.clock(),
   tickState = false
}
local tKeys = {}
-- END HOTKEY

local keys_lis2 = {
	{
		"�������� � ������",
		"������������ ������� ������� - /su [ID]. ������� ��� ������ �������, ����� ������������ ��� �������� ������ - ����� ����� ������ �������.",
		2
	},
	{
		"����� ������",
		"������������ ������� ������� - /clear. ������� ��� �������� ������ �������.",
		2
	},
	{
		"�������������/�����",
		"������������ ������� ������� - /�� [ID]. ������� ��� ������������ �������������/������.",
		3
	},
	{
		"��������� ���������",
		"������������ ������� ������� - /pas. ������� ��� ������������� � ������� ���������� ���������.",
		2
	},
	{
		"������ ���������",
		"������������ ������� ������� - /�uff [ID]. ������� ��� �������� ������������� ����������.",
		2
	},
	{
		"����� �� �����",
		"������������ ������� ������� - /gotome [ID]. ������� ��� �������� ������������� ����������� ������� ������ � ����������.",
		2
	},
	{
		"�������� � �/�",
		"������������ ������� ������� - /incar [ID]. ������� ��� ������� �������� ����������� � �/�.",
		2
	},
	{
		"�������� �����",
		"������������ ������� ������� - /�����. ������� ��� ����������� ���� ���������� ��� ����������.",
		3
	},
	{
		"�������� �����",
		"������������ ������� ������� - /frisk [ID]. ������� ��� �������� ���������� ������.",
		2
	},
	{
		"�������� �����",
		"������������ ������� ������� - /arrest [ID]. ������� ��� �������� ������ �����������.",
		2
	},
	{
		"�������",
		"������������ ������� ������� - /take [ID]. ������� ��� ������� ����-����. ��������, ����������.",
		2
	},
	{
		"����� �����-���",
		"������������ ������� ������� - /r. ������� ��� ������������� ���� �����������.",
		1
	},
	{
		"OOC - ��� � �����",
		"������������ ������� ������� - /rn. �OC - ��������� � ����� ������������.",
		1
	},
	{
		"����������� �����",
		"������������ ������� ������� - /d. ������� ��� ������������� ����������� �����.",
		1
	},
	{
		"������",
		"������������ ������� ������� � /meg ��� /�������. ������� ��� ������������� �������� � ������, ����� �� ��������� ��� ��� ����� ������.",
		3
	},
	{
		"�������� �����",
		"������������ ������� ������� - /ticket [ID]. ������� ��� ������� ������.",
		2
	},
	{
		"�����",
		"������������ ������� ������� - /��������. ������� ��� ������� RP - ��������� ������ ��� ����������.",
		3
	},
	{
		"���./����. �����",
		"������� ��� ���������/���������� ������������ ������. � ������ ��������� ������� ����� ��������� ������� �� ����. ����������� �� ��������, ������� �������.",
		1
	},
	{
		"��������� RP - ���������",
		"��������� ���������� ����������� RP - ���������, ���� ��� �������� �� ������.",
		1
	},
	{
		"������� ��������",
		"������������ ������� ������� - /sc. ������� ��������� ������ ������� ����� screenshot ��� ���� /time ����� ����� �������������.",
		1
	},
	{
		"������� MoJ Helper",
		"������������ ������� ������� - /mh. ������� ��������� ������ ������� ����������, �� ��������� �������.",
		1
	},
	{
		"����� ����� �����",
		"������������ ������� ������� - /channel. ������� ��� ������� ��������� ������ ���������� �������� ����� � �����.",
		1
	},
	{
		"���./����. ����������",
		"������� ��� ���������/���������� ������ � �������.",
		2
	},
	{
		"����������� ������",
		"������� ��� ������� �������� ������� � �����. ����������� ��� ������������ ��� �� ������� � ������� ����. ",
		2
	},
	{
		"���������� ���������",
		"������� ��� �������� ������ ���� ����������� ����������� ����������. ����� �� ������ ������������ ������� � /patrol ��� ����������� ���������, ����� �������� � ����������� ����������. ",
		2
	},
	{
		"������-����",
		[[
������������ ������� ������� � /traf. ������� ��� ������������� �������� � ������, ���� ��������� ����������� � ��������� ����������, ��������, ��� �������� ���������� ��� ���� ����. ������������� ������������ �� � ������.

������� ����������.
Traffic Stop (Ten-code 10-55) � ��������� �������� ��� �� �������� ���������� �� ��������� ���������.

High-risk Traffic Stop (Ten-code 10-66) � �������������� ��������� ��������, ��� ������� ������������� ��� �����, ������� ������������� � ������.]],
		3
	}
}

local key_set = {}
for i, v in ipairs(keys_lis2) do
	key_set[i] = {0}
end

local keys_table = {
	key_set = key_set
}

local fast_table = {
	main = {
		vidget = false,
		act = false,
		mark = false,
		big_mark = false,
	},
	menu = {
		[1] = {
			name = '�����-�',
			menu = {
				[1] = {"������.","{F6}/pas {id_marker}","1.5"}, [2] = {"�����.","/unmask {id_marker}","1.5"},
				[3] = {"������",
				"/me ��������� ���� ������� �������.&/m ��������, ���������� ���� ������������ ��������.&/m ����������, ���������� � �������, ��������� ��������� � ��������.",
				"1.5"}, [4] = {'', '', '1.0'},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[2] = {
			name = '�����-�',
			menu = {
				[1] = {"������","/pursuit","1.5"}, [2] = {"������","{F6}/su ","1.5"}, [3] = {"�����","{F6}/z ","1.5"}, [4] = {"�����","{F6}/find{}","1.5"},
				[5] = {"�����",
				"/me �������� ���� � ������� �������� � ������ ��������� ��������, ������� ����� �� ����, ...&/me ... ����� ����� ��������� ���������� ��������, ���������� �� ��������� ��� ��������.&/frisk {id_marker}",
				"1.5"}, [6] = {"�����.",
				"/me ��������� �� ���� ��������������, ����� ������� �� ����� ��������� ...&/me ... �, ������� �� �� ��������, ������� �� ��������������.&/cuff {id_marker}",
				"1.5"}, [7] = {"�����",
				"/me ������ ����� �� ����� ����� � � ����� ������� �������� ��������.&/todo ��� ������ ��������!*������� ����� ������.&/gotome {id_marker}",
				"1.5"}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[3] = {
			name = '�����',
			menu = {
				[1] = {"CODE 0","/r ���� ������ CODE 1! �������� ��� ����! ��������� ������, ����������!","1.5"},
				[2] = {"�����","/r ��������� �������, ������ ��������!&/r ����� ���������� � ������������, ���� ������ ������� �� �����.","1.5"},
				[3] = {"10-99","/r {patrol_unit} �� CONTROL. '99, ����������� � ��������������, ��������.","1.5"}, [4] = {"10-66",
				"/m �������� {meg_c_model} {color_car} ����� � N-{meg_c_id}!&/m ���������� � �������, ��������� ��������� � ������� ���� �� ����!&/m � ������ ������������ ��������� ���������� ����� ������ �����!&/r {patrol_unit} �� CONTROL. ������� '66 � ������ {zone}, �'4, ����������.&/r ���������� {meg_c_model} {color_car} ����� � N-{meg_c_id}.",
				"1.5"},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[4] = {
			name = '������',
			menu = {
				[1] = {"���","/home","1.5"}, [2] = {"�����","/key","1.5"}, [3] = {"�����","/lock","1.5"}, [4] = {"����",
				"/do �� ���� ����� ���� Apple Watch Series 4.&/todo ������ Siri, ������� ���?*������� ���� � ������ � ����&/do ������ {surname}, ������ {H}:{M} �����, {day}.&/time",
				"1.5"},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[5] = {
			name = '������',
			menu = {
				[1] = {"���","���������� ��� �� �������.","1.0"}, [2] = {"�����","�������� ����������� ������.","1.0"},
				[3] = {"������","���������� ���������� �������","1.0"}, [4] = {"�������","������ ��� ��� ���������� � �����:&1. ��.&2. ��.&3. �����.","1.0"},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[6] = {
			name = '',
			menu = {
				[1] = {'', '', '1.0'}, [2] = {'', '', '1.0'}, [3] = {'', '', '1.0'}, [4] = {'', '', '1.0'},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[7] = {
			name = '',
			menu = {
				[1] = {'', '', '1.0'}, [2] = {'', '', '1.0'}, [3] = {'', '', '1.0'}, [4] = {'', '', '1.0'},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[8] = {
			name = '',
			menu = {
				[1] = {'', '', '1.0'}, [2] = {'', '', '1.0'}, [3] = {'', '', '1.0'}, [4] = {'', '', '1.0'},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[9] = {
			name = '',
			menu = {
				[1] = {'', '', '1.0'}, [2] = {'', '', '1.0'}, [3] = {'', '', '1.0'}, [4] = {'', '', '1.0'},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[10] = {
			name = '',
			menu = {
				[1] = {'', '', '1.0'}, [2] = {'', '', '1.0'}, [3] = {'', '', '1.0'}, [4] = {'', '', '1.0'},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
	}
}

local stand_comand_list = {
	{
		"/cuff",
		"������� ��� �������� ������������� ����������.",
	},
	{
		"/uncuff",
		"������� ��� �������� ������ ����������.",
	},
	{
		"/incar",
		"������� ��� ������� ��������/���������� �������� �/�� �/�.",
	},
	{
		"/inmoto",
		"������� ��� RP - ��������� ���������� � ���������.",
	},
	{
		"/eject",
		"������� ��� ���� ����� �������� �� �/C.",
	},
	{
		"/ticket",
		"������� ��� ������� ������.",
	},
	{
		"/mask",
		"������� ��� ������������� �����.",
	},
	{
		"/clear",
		"������� ��� ��������/������ ������� �� ���� ������.",
	},
	{
		"/search",
		"������� ��� �������� ���������� ������.",
	},
	{
		"/arrest",
		"������� ��� �������� ������ ��������.",
	},
	{
		"/su",
		"������� ��� ������ ������� ����� ������ ����� � ����� ������ �������.",
	},
	{
		"/pas",
		"������� ��� ������������� � ������� ���������� ���������.",
	},
	{
		"/frisk",
		"������� ��� �������� ���������� ������.",
	},
	{
		"/gotome",
		"������� ��� �������� ������� �������� � ����������.",
	},
	{
		"/ungotome",
		"������� ��� ������ �������� ������� �������� � ����������.",
	},
	{
		"/sc",
		"�������, ����� ������� �������������� �������� � /time � /� 60.",
	},
	{
		"/find",
		"������� ��� ������ �������� �� ���� ������.",
	},
	{
		"/rn",
		"������� ��� �OC - ��������� � ����� ������������.",
	},
	{
		"/post",
		"������� ��� ������� � �����.",
	},
	{
		"/pull",
		"������� ��� ������� RP - ��������� ���������� �� �/�.",
	},
	{
		"/usemed",
		"������� ��� ������������� �������.",
	},
	{
		"/meg",
		"������� ��� ��������� �������� � ������ ������.",
	},
	{
		"/traf",
		"������� ��� ��������� �������� � ������ ������-�����.",
	}
}

local stand_comand_setting_table = {}

for i, v in ipairs(stand_comand_list) do
	v[3] = true
	stand_comand_setting_table[i] = v
end

local binder_table = {}

for i = 1, 50 do
	binder_table[i] = {name = '', act = {v = {0}}, wait = '', text = ''}
end

local main_dir = getWorkingDirectory() .. "\\MoJ Helper"
local set_dir = main_dir .. '\\settings'
local main_json = set_dir .. "\\settings.json"
local keys_json = set_dir .. "\\keys.json"
local fast_json = set_dir .. "\\fastmenu.json"
local scs_json = set_dir .. "\\stand_comand.json"
local dop_json = set_dir .. "\\dop_comand.json"
local binder_json = set_dir .. "\\binder.json"

local git_url = "https://github.com/ChortyDev/MoJHelper/tree/main/moonloader/MoJ%20Helper/"

function tableWDefine(table1, table2)
	for i, v in pairs(table2) do
		if table1[i] == nil then
			table1[i] = v
		elseif type(v) == "table" then
			table1[i] = tableWDefine(table1[i], v)
		end
	end

	return table1
end

function loadJson(json)
	local file = io.open(json)
	if file then
		local read = file:read("*a")
		file:close()
		local dec = cjson.decode(read)
		if dec then
			return dec
		else
			return nil
		end
	else
		return nil
	end
end

function saveJson(json, tab)
	local file = io.open(json, "w+")
	if file then
		file:write(cjson.encode(tab))
		file:close()
		return true
	else
		return false
	end
end

local dop_table = {}

for i = 1, 50 do
	dop_table[i] = {comand_name = '', comand_text = '', comand_wait = '1.5', p1act = false, p2act = false, p3act = false} 
end

if not loadJson(main_json) then
	saveJson(main_json, main_table)
else
	saveJson(main_json, tableWDefine(loadJson(main_json), main_table))
end
if not loadJson(keys_json) then
	saveJson(keys_json, keys_table)
else
	saveJson(keys_json, tableWDefine(loadJson(keys_json), keys_table))
end
if not loadJson(fast_json) then
	saveJson(fast_json, fast_table)
else
	saveJson(fast_json, tableWDefine(loadJson(fast_json), fast_table))
end
if not loadJson(scs_json) then
	saveJson(scs_json, stand_comand_setting_table)
else
	saveJson(scs_json, tableWDefine(loadJson(scs_json), stand_comand_setting_table))
end
if not loadJson(dop_json) then
	saveJson(dop_json, dop_table)
else
	saveJson(dop_json, tableWDefine(loadJson(dop_json), dop_table))
end
if not loadJson(binder_json) then
	saveJson(binder_json, binder_table)
else
	saveJson(binder_json, tableWDefine(loadJson(binder_json), binder_table))
end

local loaded = loadJson(main_json)
local keys_loaded = loadJson(keys_json)
local fast_loaded = loadJson(fast_json)
local scs_loaded = loadJson(scs_json)
local dop_loaded = loadJson(dop_json)
local binder_loaded = loadJson(binder_json)

function save()
	saveJson(main_json, loaded)
end
function saveFast()
	saveJson(fast_json, fast_loaded)
end
function saveScs()
	saveJson(scs_json, scs_loaded)
end
function saveDop()
	saveJson(dop_json, dop_loaded)
end
function saveBinder()
	saveJson(binder_json, binder_loaded)
end


local im2 = imgui.ImVec2

local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

local big_font = nil
local big_fa = nil
function imgui.BeforeDrawFrame()
    local glyph_ranges_cyrillic = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    if fa_font == nil then
        imgui.GetIO().Fonts:Clear()
        imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/centurygothic_bold.ttf', 14, nil, glyph_ranges_cyrillic)
        imgui.RebuildFonts()
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85(), 14.0, font_config, fa_glyph_ranges)
    end
    if big_font == nil then
        big_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/centurygothic_bold.ttf', 18, nil, glyph_ranges_cyrillic)
    end
	if big_fa == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        big_fa = imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85(), 18.0, font_config, fa_glyph_ranges)
    end
end

local main_window = imgui.ImBool(false)
local show_taglist = imgui.ImBool(false)
local show_taglist2 = imgui.ImBool(false)
local show_taglist_param = imgui.ImBool(false)

local set_size_x = 950

local keys_menu = {
	{v = keys_loaded.key_set[1], f = function() sampAddChatMessage(1,-1) end},
	{v = keys_loaded.key_set[2], f = function() sampAddChatMessage(2,-1) end},
	{v = keys_loaded.key_set[3], f = function() sampAddChatMessage(3,-1) end},
	{v = keys_loaded.key_set[4], f = function() sampAddChatMessage(4,-1) end},
	{v = keys_loaded.key_set[5], f = function() sampAddChatMessage(5,-1) end},
	{v = keys_loaded.key_set[6], f = function() sampAddChatMessage(6,-1) end},
	{v = keys_loaded.key_set[7], f = function() sampAddChatMessage(7,-1) end},
	{v = keys_loaded.key_set[8], f = function() sampAddChatMessage(8,-1) end},
	{v = keys_loaded.key_set[9], f = function() sampAddChatMessage(9,-1) end},
	{v = keys_loaded.key_set[10], f = function() sampAddChatMessage(10,-1) end},
	{v = keys_loaded.key_set[11], f = function() sampAddChatMessage(11,-1) end},
	{v = keys_loaded.key_set[12], f = function() sampAddChatMessage(12,-1) end},
	{v = keys_loaded.key_set[13], f = function() sampAddChatMessage(13,-1) end},
	{v = keys_loaded.key_set[14], f = function() sampAddChatMessage(14,-1) end},
	{v = keys_loaded.key_set[15], f = function() sampAddChatMessage(15,-1) end},
	{v = keys_loaded.key_set[16], f = function() sampAddChatMessage(16,-1) end},
	{v = keys_loaded.key_set[17], f = function() sampAddChatMessage(17,-1) end},
	{v = keys_loaded.key_set[18], f = function() sampAddChatMessage(18,-1) end},
	{v = keys_loaded.key_set[19], f = function() sampAddChatMessage(19,-1) end},
	{v = keys_loaded.key_set[20], f = function() sampAddChatMessage(21,-1) end},
	{v = keys_loaded.key_set[21], f = function() main_window.v = not main_window.v end},
	{v = keys_loaded.key_set[22], f = function() sampAddChatMessage(23,-1) end},
	{v = keys_loaded.key_set[23], f = function() sampAddChatMessage(24,-1) end},
	{v = keys_loaded.key_set[24], f = function() sampAddChatMessage(25,-1) end},
	{v = keys_loaded.key_set[25], f = function() sampAddChatMessage(26,-1) end},
	{v = keys_loaded.key_set[26], f = function() sampAddChatMessage(27,-1) end},
}
function saveKeys()
	for i, v in ipairs(keys_menu) do
		keys_loaded.key_set[i] = v.v
	end
	saveJson(keys_json, keys_loaded)
end
--[[
	"�������� � ������":1,
	"����� ������":2,
	"�������������\/�����":3,
	"��������� ���������":4,
	"������ ���������":5,
	"����� �� �����":6,
	"�������� � �\/�":7,
	"�������� �����":8,
	"�������� �����":9,
	"�������� �����":10,
	"�������":11,
	"����� �����-���":12,
	"OOC - ��� � �����":13,
	"����������� �����":14,
	"������":15
	"�������� �����":16,
	"�����":17,
	"���.\/����. �����":18,
	"��������� RP - ���������":19,
	"������� ��������":20,
	"������� MoJ Helper":21,
	"����� ����� �����":22,
	"���.\/����. ����������":23,
	"����������� ������":24,
	"���������� ���������":25,
	"������-����":26,
]]

local getid = true
local id_player = -1
local nick_player = nil
local nick_player1 = nil
local nick_player2 = nil

local time_post_update = 0

local colors_list = {
	[0] = {
		"׸�����",
		"׸����"
	},
	{
		"������",
		"�����"
	},
	{
		"��������",
		"�������"
	},
	{
		"��������",
		"�������"
	},
	{
		"Ҹ���-�������",
		"Ҹ���-�������"
	},
	{
		"����������",
		"���������"
	},
	{
		"Ƹ�����",
		"Ƹ����"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"������������",
		"�����������"
	},
	{
		"������",
		"�����"
	},
	{
		"����-������",
		"����-�����"
	},
	{
		"������",
		"�����"
	},
	{
		"����-������",
		"����-�����"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"������",
		"�����"
	},
	{
		"������",
		"�����"
	},
	{
		"�������",
		"������"
	},
	{
		"��������",
		"�������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-�������"
	},
	{
		"������������",
		"�����������"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"���������",
		"��������"
	},
	{
		"������������",
		"�����������"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"������������",
		"�����������"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"������������",
		"�����������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-�������"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"������",
		"�����"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"׸�����",
		"׸����"
	},
	{
		"Ҹ���-�������",
		"Ҹ���-������"
	},
	{
		"������������",
		"�����������"
	},
	{
		"������",
		"�����"
	},
	{
		"Ҹ���-�����������",
		"Ҹ���-����������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-�������"
	},
	{
		"��������",
		"�������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-�������"
	},
	{
		"Ҹ���-�������",
		"Ҹ���-������"
	},
	{
		"��������",
		"�������"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-�������"
	},
	{
		"��������",
		"�������"
	},
	{
		"������-������������ ",
		"������-�����������"
	},
	{
		"����������-������",
		"����������-�����"
	},
	{
		"Ҹ���-�������",
		"Ҹ���-������"
	},
	{
		"������",
		"�����"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"����-������",
		"����-�����"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"������������",
		"�����������"
	},
	{
		"����-�����������",
		"����-����������"
	},
	{
		"��������",
		"�������"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"������������",
		"�����������"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"��������",
		"�������"
	},
	{
		"������������",
		"�����������"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"�����������",
		"����������"
	},
	{
		"���������",
		"��������"
	},
	{
		"������",
		"�����"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"��������",
		"�������"
	},
	{
		"����-������",
		"����-�����"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-�������"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"������������",
		"�����������"
	},
	{
		"����-�����������",
		"����-����������"
	},
	{
		"��������",
		"�������"
	},
	{
		"������",
		"�����"
	},
	{
		"����������",
		"���������"
	},
	{
		"������",
		"�����"
	},
	{
		"��������",
		"�������"
	},
	{
		"׸���-�������",
		"׸���-������"
	},
	{
		"�����������",
		"����������"
	},
	{
		"��������",
		"�������"
	},
	{
		"�������",
		"������"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"������",
		"�����"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"������",
		"�����"
	},
	{
		"����������",
		"���������"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"����-������",
		"����-�����"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"������",
		"�����"
	},
	{
		"��������-������",
		"��������-�����"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-�������"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"������",
		"�����"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"������",
		"�����"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"����-��������",
		"����-�������"
	},
	{
		"������",
		"�����"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"����������-������",
		"����������-�����"
	},
	{
		"����-������",
		"����-�����"
	},
	{
		"�����������",
		"����������"
	},
	{
		"Ҹ���-�������",
		"Ҹ���-������"
	},
	{
		"��������",
		"�������"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"��������",
		"�������"
	},
	{
		"������������",
		"�����������"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"��������",
		"�������"
	},
	{
		"������������",
		"�����������"
	},
	{
		"Ҹ���-�����������",
		"Ҹ���-����������"
	},
	{
		"��������",
		"�������"
	},
	{
		"������",
		"�����"
	},
	{
		"��������",
		"�������"
	},
	{
		"׸�����",
		"׸����"
	},
	{
		"������-�������",
		"������-������"
	},
	{
		"���������-��������",
		"���������-�������"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"���������-�����������",
		"���������-����������"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"׸�����",
		"׸����"
	},
	{
		"�����������",
		"����������"
	},
	{
		"����������",
		"���������"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"������-�������",
		"������-������"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"��������-������",
		"��������-�����"
	},
	{
		"������������",
		"�����������"
	},
	{
		"������",
		"�����"
	},
	{
		"������-����������",
		"������-���������"
	},
	{
		"����������",
		"���������"
	},
	{
		"�����������",
		"����������"
	},
	{
		"������-�������",
		"������-������"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"�����������",
		"����������"
	},
	{
		"׸�����",
		"׸����"
	},
	{
		"���������-�������",
		"���������-������"
	},
	{
		"׸�����",
		"׸����"
	},
	{
		"����-�������",
		"����-������"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"�������",
		"������"
	},
	{
		"������-�������",
		"������-������"
	},
	{
		"����������",
		"���������"
	},
	{
		"������������",
		"�����������"
	},
	{
		"����-������",
		"����-�����"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-�������"
	},
	{
		"�����������",
		"����������"
	},
	{
		"Ҹ���-�������",
		"Ҹ���-������"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"������",
		"�����"
	},
	{
		"����������",
		"���������"
	},
	{
		"׸���-������",
		"׸���-�����"
	},
	{
		"Ҹ���-����������",
		"Ҹ���-���������"
	},
	{
		"��������",
		"�������"
	},
	{
		"�����������",
		"����������"
	},
	{
		"�����������",
		"����������"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"�����������",
		"����������"
	},
	{
		"Ҹ���-�������",
		"Ҹ���-������"
	},
	{
		"�����������",
		"����������"
	},
	{
		"�����������",
		"����������"
	},
	{
		"��������",
		"�������"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"�����������",
		"����������"
	},
	{
		"Ҹ���-�����������",
		"Ҹ���-����������"
	},
	{
		"����������",
		"���������"
	},
	{
		"��������",
		"�������"
	},
	{
		"����������",
		"���������"
	},
	{
		"����������",
		"���������"
	},
	{
		"��������-��������",
		"��������-�������"
	},
	{
		"����-��������",
		"����-�������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-������"
	},
	{
		"��������",
		"�������"
	},
	{
		"�������",
		"������"
	},
	{
		"��������",
		"�������"
	},
	{
		"������",
		"�����"
	},
	{
		"Ƹ�����",
		"Ƹ����"
	},
	{
		"�����������",
		"����������"
	},
	{
		"������",
		"�����"
	},
	{
		"Ƹ�����",
		"Ƹ����"
	},
	{
		"������",
		"�����"
	},
	{
		"Ҹ���-����������",
		"Ҹ���-���������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-�������"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-������"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"Ҹ���-�����������",
		"Ҹ���-����������"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"������-������",
		"������-�����"
	},
	{
		"������",
		"�����"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"�����������",
		"����������"
	},
	{
		"����������",
		"���������"
	},
	{
		"������������",
		"�����������"
	},
	{
		"Ƹ���-��������",
		"Ƹ���-�������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-������"
	},
	{
		"����������",
		"���������"
	},
	{
		"����������",
		"���������"
	},
	{
		"������-��������",
		"������-�������"
	},
	{
		"����������",
		"���������"
	},
	{
		"��������",
		"�������"
	},
	{
		"��������-�������",
		"��������-������"
	},
	{
		"����������",
		"���������"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"Ҹ���-����������",
		"Ҹ���-���������"
	},
	{
		"������-�������",
		"������-������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-������"
	},
	{
		"Ƹ�����",
		"Ƹ����"
	},
	{
		"������-�������",
		"������-������"
	},
	{
		"������",
		"�����"
	},
	{
		"������-�����������",
		"������-����������"
	},
	{
		"��������",
		"�������"
	},
	{
		"��������",
		"�������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-������"
	},
	{
		"���������",
		"��������"
	},
	{
		"����������-������",
		"����������-�����"
	},
	{
		"��������",
		"�������"
	},
	{
		"���������-��������",
		"���������-�������"
	},
	{
		"����������",
		"���������"
	},
	{
		"����������",
		"���������"
	},
	{
		"����������",
		"���������"
	},
	{
		"����������",
		"���������"
	},
	{
		"�������",
		"������"
	},
	{
		"Ҹ���-�����������",
		"Ҹ���-����������"
	},
	{
		"Ҹ���-��������",
		"Ҹ���-������"
	},
	{
		"����-��������",
		"����-�������"
	},
	{
		"����-������",
		"����-�����"
	},
	{
		"��������",
		"�������"
	},
	{
		"��������-�����������",
		"��������-����������"
	},
	{
		"���������-��������",
		"���������-�������"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	},
	{
		"������",
		"�����"
	},
	{
		"������",
		"�����"
	},
	{
		"���������",
		"��������"
	},
	{
		"Ҹ���-������",
		"Ҹ���-�����"
	}
}
local gun_list = {
	{
		1,
		"������"
	},
	{
		2,
		"������ ��� ������"
	},
	{
		3,
		"����������� �������"
	},
	{
		4,
		"���"
	},
	{
		5,
		"����������� ����"
	},
	{
		6,
		"������"
	},
	{
		7,
		"���"
	},
	{
		8,
		"������"
	},
	{
		9,
		"���������"
	},
	{
		10,
		"������������� �����"
	},
	{
		11,
		"�����"
	},
	{
		12,
		"��������"
	},
	{
		13,
		"���������� ��������"
	},
	{
		14,
		"����� ������"
	},
	{
		15,
		"������"
	},
	{
		16,
		"�������"
	},
	{
		17,
		"������������ ���"
	},
	{
		18,
		"�������� ��������"
	},
	{
		22,
		"�������� 9��"
	},
	{
		23,
		"�������� 9�� � ����������"
	},
	{
		24,
		"�������� Desert Eagle"
	},
	{
		25,
		"������� ��������"
	},
	{
		26,
		"�����"
	},
	{
		27,
		"�������������� ��������"
	},
	{
		28,
		"���"
	},
	{
		29,
		"MP5"
	},
	{
		30,
		"������� �����������"
	},
	{
		31,
		"�������� M4"
	},
	{
		32,
		"Tec-9"
	},
	{
		33,
		"��������� �����"
	},
	{
		34,
		"����������� ��������"
	},
	{
		35,
		"���"
	},
	{
		36,
		"��������������� ������ HS"
	},
	{
		37,
		"�������"
	},
	{
		38,
		"�������"
	},
	{
		39,
		"����� � ��������"
	},
	{
		41,
		"��������� � �������"
	},
	{
		42,
		"������������"
	},
	{
		43,
		"�����������"
	},
	{
		46,
		"�������"
	}
}
local cardinal_points = {
	{
		"�����",
		"��������",
		"��������"
	},
	{
		"������-������",
		"������-���������",
		"������-���������"
	},
	{
		"������",
		"���������",
		"���������"
	},
	{
		"���-������",
		"���-���������",
		"���-���������"
	},
	{
		"��",
		"�����",
		"�����"
	},
	{
		"���-�����",
		"���-��������",
		"���-��������"
	},
	{
		"�����",
		"��������",
		"��������"
	},
	{
		"������-�����",
		"������-��������",
		"������-��������"
	},
	{
		"�����",
		"��������",
		"��������"
	}
}

local mass_consol_megafon = {}
local mass_consol_megafon_new = {}
local mass_consol_chat = {}

local naparnik_id = ""
local naparnik_nick = ""
local model_car_megafon = ""
local name_car_megafon = ""
local color_car_megafon = ""
local name_car_distance = ""
local id_vodil_megafon = 0
local speed_megafon = 0

local check_car = {}

function chPlayers()
	while true do
		wait(0)
		local coordX, coordY, coordZ = getCharCoordinates(playerPed)
		for i = 0, 1000 do
			if sampIsPlayerConnected(i) then
				local res, id = sampGetCharHandleBySampPlayerId(i)
				if doesCharExist(id) then
					local px, py, pz = getCharCoordinates(id)
					local pcolor = sampGetPlayerColor(i)
					local distToP = getDistanceBetweenCoords3d(px, py, pz, coordX, coordY, coordZ)
					if distToP <= 10 and (pcolor == -2147464705 or pcolor == -16776961 or pcolor == -2147463425) then
						local nick_actor = sampGetPlayerNickname(i)
						local name_actor, sur_actor = string.match(nick_actor, "(%S+)_(%S+)")

						if name_actor ~= nil and sur_actor ~= nil then
							kname = string.match(name_acto, "%S")
							naparnik_id = naparnik_id .. string.format("%s ", i)
							naparnik_nick = naparnik_nick .. string.format("%s. %s, ", kname, sur_actor)
						else
							naparnik_id = naparnik_id .. string.format("%s ", i)
							naparnik_nick = naparnik_nick .. string.format("%s, ", nick_actor)
						end
					end

					if distToP <= 40 and pcolor ~= -2147464705 and pcolor ~= -16776961 and pcolor ~= -2147463425 and isCharInAnyCar(id) then
						local PedCar = storeCarCharIsInNoSave(id)
						local PedDriver = getDriverOfCar(PedCar)

						if PedDriver and PedDriver ~= -1 then
							local res, id_Driver = sampGetPlayerIdByCharHandle(PedDriver)

							local dcolor = sampGetPlayerColor(id_Driver)
							if id_Driver ~= nil and dcolor ~= -2147464705 and dcolor ~= -16776961 and dcolor ~= -2147463425 then
								model_car_megafon = getCarModel(PedCar)
								name_car_megafon = getNameOfVehicleModel(model_car_megafon)
								if name_car_megafon == nil then
									name_car_megafon = "������������"
								end

								color_nick_megafon = dcolor
								car_color1, car_color2 = getCarColours(PedCar)
								color_car_megafon = rusLower(colors_list[car_color1][1])
								color_car_megafon2 = rusLower(colors_list[car_color1][2])
								name_car_distance = distToP
								id_vodil_megafon = id_Driver
								speed_megafon = getCarSpeed(PedCar)

								if name_car_distance ~= "" and check_car[id_Driver] == nil and auto_radar == 1 then
									if show_radar_window.v then
										if time_find2 < os.time() then
											time_find2 = os.time() + 3
										end

										check_car[id_Driver] = true

										cmd_find2(id_Driver)
										wait(1000)

										if string.find(servername, "Arizona") then
											speed_megafon2 = speed_megafon * 3.625
											speed_megafon2 = math_round(speed_megafon2, 1)
										else
											speed_megafon2 = speed_megafon * 2
											speed_megafon2 = math_round(speed_megafon2, 1)
										end


										if sampGetPlayerNickname(id_Driver) ~= nick_player then
											if radar_speed then
												AddLogMegafon(string.format([[
�������� �/� #%s [%s]
��������: %s ��/�
��������: %s[%s]
������: %s]], model_car_megafon, name_car_megafon, speed_megafon2, sampGetPlayerNickname(id_Driver), id_Driver, su_info_status))
												AddNewLogMegafon(model_car_megafon, name_car_megafon, speed_megafon2, sampGetPlayerNickname(id_Driver), id_Driver, su_info_status, color_car_megafon2)
											else
												AddLogMegafon(string.format("�������� �/� #%s [%s]\n��������: %s[%s]\n������: %s", model_car_megafon, name_car_megafon, sampGetPlayerNickname(id_Driver), id_Driver, su_info_status))
												AddNewLogMegafon(model_car_megafon, name_car_megafon, 0, sampGetPlayerNickname(id_Driver), id_Driver, su_info_status, color_car_megafon2)
											end

											if su_info_status == "� �������" and radar_autostop then
												auto_radar = 0

												if radar_autostop1 then
													modSendChat(string.format("/pursuit %s", id_Driver))
												end

												if radar_autostop2 then
													modSendChat(string.format("/z %s", id_Driver))
												end
											end
										end
									else
										auto_radar = 0
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function math_round(s0, s1)
	return tonumber(string.format("%0." .. s1 .. "f", s0))
end

function AddLogMegafon(text)
	local x, y, z = getCharCoordinates(playerPed)

	if radar_audio then
		addOneOffSound(x, y, z, 1132)
	end

	table.insert(mass_consol_megafon, string.format([[

[%s]
%s
]], os.date("%X"), text))
end

function AddNewLogMegafon(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local x, y, z = getCharCoordinates(playerPed)

	if radar_audio then
		addOneOffSound(x, y, z, 1132)
	end

	table.insert(mass_consol_megafon_new, {
		os.date("%X"),
		arg1,
		arg2,
		arg3,
		arg4,
		arg5,
		arg6,
		arg7
	})
end

function SuInfo(id)
	su_info = true
	su_time = os.time()

	if string.find(servername, "Arizona") then
		modSendChat(string.format("/find %s", id))
	else
		modSendChat(string.format("/setmark %s", id))
	end
end

function modSendChat(text)
	if rp_point.v and string.find(text, "/me") then
		if string.match(text, "[^�-�][�-�]*$") == "." then
			text = text:sub(1, -2)
		end

		if string.match(text, "[^�-�][�-�]*$") == "." then
			text = text .. "."
		end
	end

	sampSendChat(text)
end

function cmd_find2(id)
	if id ~= nil then
		id = tonumber(string.match(id, "(%d+)"))
	end

	if id ~= nil and id >= 0 and id <= 999 then
		SuInfo(id)
	else
		msg("�����������: /find2 [ID]")
	end
end

function cmd_radar()
	if mod_6 then
		if isCharInAnyCar(playerPed) then
			if getCarModel(storeCarCharIsInNoSave(playerPed)) == 541 or slot1 == 586 or slot1 == 429 or slot1 == 490 or slot1 == 497 or slot1 == 528 or slot1 == 596 or slot1 == 597 or slot1 == 598 or slot1 == 599 or slot1 == 523 or slot1 == 427 or slot1 == 415 or slot1 == 559 or slot1 == 525 then
				show_radar_window.v = not show_radar_window.v

				if show_radar_window then
					auto_radar = 1

					if radar_rp then
						cmd_radar_rp = true
					end
				end

				if show_radar_window.v and new_radar == nil then
					new_radar = true
					slot2 = uv0.load(nil, "MVDHelp\\setting.ini")
					slot2.main.new_radar = true

					uv0.save(slot2, "MVDHelp\\setting.ini")
					addsampchatmvd("��� ���������� �������� ����������� ������� Y ���� F6.")
					addsampchatmvd("��� ���������� ���� ������ ������� ������� /radar ��� ���. ")
				end
			else
				addsampchatmvd("��� ��������� ������ Johnny-3000 ���������� ���������� � ����������� ����������. ")
			end
		else
			addsampchatmvd("��� ��������� ������ Johnny-3000 ���������� ���������� � ����������� ����������. ")
		end
	else
		addsampchatmvd("����������� ����������� �� ���������� ����: /mh - MoJ Helper Plus - ����� Johnny-3000.")
	end
end
local russian_characters = {
	[168] = '�', [184] = '�', [192] = '�', [193] = '�', [194] = '�', [195] = '�', [196] = '�', [197] = '�', [198] = '�', [199] = '�', [200] = '�', [201] = '�', [202] = '�', [203] = '�', [204] = '�', [205] = '�', [206] = '�', [207] = '�', [208] = '�', [209] = '�', [210] = '�', [211] = '�', [212] = '�', [213] = '�', [214] = '�', [215] = '�', [216] = '�', [217] = '�', [218] = '�', [219] = '�', [220] = '�', [221] = '�', [222] = '�', [223] = '�', [224] = '�', [225] = '�', [226] = '�', [227] = '�', [228] = '�', [229] = '�', [230] = '�', [231] = '�', [232] = '�', [233] = '�', [234] = '�', [235] = '�', [236] = '�', [237] = '�', [238] = '�', [239] = '�', [240] = '�', [241] = '�', [242] = '�', [243] = '�', [244] = '�', [245] = '�', [246] = '�', [247] = '�', [248] = '�', [249] = '�', [250] = '�', [251] = '�', [252] = '�', [253] = '�', [254] = '�', [255] = '�',
}
function rusLower(s)
	local strlen = s:len()
	if strlen == 0 then return s end
	s = s:lower()
	local output = ''
	for i = 1, strlen do
	  local ch = s:byte(i)
	  if ch >= 192 and ch <= 223 then -- upper russian characters
		output = output .. russian_characters[ch+32]
	  elseif ch == 168 then -- �
		output = output .. russian_characters[184]
	  else
		output = output .. string.char(ch)
	  end
	end
	return output
end
function rusUpper(s)
	local strlen = s:len()
	if strlen == 0 then return s end
	s = s:upper()
	local output = ''
	for i = 1, strlen do
	  local ch = s:byte(i)
	  if ch >= 224 and ch <= 255 then -- lower russian characters
		output = output .. russian_characters[ch-32]
	  elseif ch == 184 then -- �
		output = output .. russian_characters[168]
	  else
		output = output .. string.char(ch)
	  end
	end
	return output
end

local show_color1_tag = imgui.ImBool(false)

function main() -- PIZDA
    while not isSampAvailable() do wait(200) end
	sampRegisterChatCommand(loaded.main.cmd_act,function()
		main_window.v = not main_window.v
	end)
	selectTheme()
	lua_thread.create(tridmark)
	chp = lua_thread.create(chPlayers)
	msg('������� ��������! ������� ����: /'..loaded.main.cmd_act)
    while true do
        wait(0)
        imgui.Process = main_window.v or show_taglist_param.v or show_taglist.v or show_color1_tag.v
		if getid then
			if sampGetGamestate() == 3 then
				_, id_player = sampGetPlayerIdByCharHandle(1)
				nick_player = sampGetPlayerNickname(id_player)
				if nick_player:find('_') then
					nick_player1, nick_player2 = nick_player:match('(.+)_(.+)')
				else
					nick_player1 = nick_player
					nick_player2 = ''
				end
				if id_player ~= -1 and nick_player ~= nil then
					getid = false
				end
			end
		else
			if sampGetGamestate() ~= 3 then
				getid = true
			end
		end
		local acx, acy, acz = getActiveCameraCoordinates()
		local acpx, axpy, axpz = getActiveCameraPointAt()
		local res_storona = 0
		if math.atan2(acpx - acx, axpy - acy) * 180 / math.pi < 0 then
			res_storona = res_storona + 360
		end

		if res_storona > 0 and res_storona < 22.5 then
			storona = 1
		elseif res_storona > 22.5 and res_storona < 67.5 then
			storona = 2
		elseif res_storona > 67.5 and res_storona < 112.5 then
			storona = 3
		elseif res_storona > 112.5 and res_storona < 157.5 then
			storona = 4
		elseif res_storona > 157.5 and res_storona < 202.5 then
			storona = 5
		elseif res_storona > 202.5 and res_storona < 247.5 then
			storona = 6
		elseif res_storona > 247.5 and res_storona < 292.5 then
			storona = 7
		elseif res_storona > 292.5 and res_storona < 337.5 then
			storona = 8
		elseif res_storona > 337.5 then
			storona = 1
		end
		if time_post_update < os.time() then
			local cityid = getCityPlayerIsIn(id_player)

			if cityid == 1 then
				cityname = "��� ������"
			elseif cityid == 2 then
				cityname = "��� ������"
			elseif cityid == 3 then
				cityname = "��� ��������"
			else
				cityname = oprZone()
			end

			if string.find(sampGetCurrentServerName(), "Arizona") then
				post = oprPost()
			else
				post = "���"
			end

			zone = oprZone()
			time_post_update = os.time() + 5
		end
		local wep = getCurrentCharWeapon(playerPed)
		if wep > 0 then
			gun_name = getweaponname(wep)
		else
			gun_name = ""
		end
		for i, v in ipairs(keys_menu) do
			if #v.v > 0 and v.v[1] ~= 0 then
				if #v.v == 1 then
					if isKeyJustPressed(v.v[1]) then
						v.f()
					end
				elseif #v.v > 1 then
					if isKeyDown(v.v[1]) and isKeyJustPressed(v.v[2]) then
						v.f()
					end
				end	
			end	
		end
		if resize ~= nil then
			if set_size_x == resize then
				resize = nil
			else
				if resize < set_size_x then
					set_size_x = set_size_x-10
				else
					set_size_x = set_size_x+10
				end
				wait(0.01)
			end
		end
    end
end
function getnacional(skin_id)
	return ({
		[0] = "����-����������",
		"����������",
		"��������",
		"�������",
		"����-����������",
		"����-����������",
		"����������",
		"����-����������",
		"����������",
		"����-����������",
		"����������",
		"����-����������",
		"������",
		"����-����������",
		"����-����������",
		"�������",
		"����-����������",
		"����-����������",
		"����-����������",
		"����-����������",
		"����������",
		"����-����������",
		"����-����������",
		"����������",
		"����-����������",
		"����-����������",
		"����������",
		"����������",
		"����-����������",
		"����������",
		"������-����������",
		"����������",
		"����������",
		"������-����������",
		"����������",
		"������-����������",
		"����-����������",
		"����������",
		"������-����������",
		"����������",
		"�������",
		"�������",
		"������-����������",
		"����������",
		"����������",
		"����������",
		"�������",
		"����������",
		"����������",
		"������",
		"����������",
		"����-����������",
		"��������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"������-����������",
		"�������",
		"������-����������",
		"����-����������",
		"����-����������",
		"����������",
		"�������",
		"����������",
		"����������",
		"����������",
		"����������",
		nil,
		"�������",
		"������-����������",
		"����������",
		"����������",
		"����-����������",
		"����-����������",
		"����������",
		"����������",
		"����-����������",
		"������-����������",
		"�������",
		"����-����������",
		"����������",
		"����������",
		"����������",
		"�������",
		"�������",
		"����������",
		"����������",
		"����������",
		"����������",
		"�������",
		"����������",
		"���������",
		"��������",
		"����������",
		"����������",
		"����-����������",
		"����-����������",
		"����-����������",
		"����-����������",
		"����-����������",
		"����-����������",
		"������-����������",
		"������-����������",
		"������-����������",
		"�������",
		"�������",
		"���������",
		"����������",
		"����������",
		"����������",
		"������",
		"������",
		"���������",
		"������",
		"������",
		"������",
		"������",
		"���������",
		"�������",
		"�������",
		"���������",
		"�������",
		"����������",
		"����������",
		"�������",
		"����������",
		"����������",
		"����-����������",
		"��������",
		"����-����������",
		"������-����������",
		"����������",
		"����-����������",
		"�������",
		"����������",
		"����-����������",
		"����-����������",
		"����-����������",
		"������-����������",
		"����������",
		"����������",
		"������-����������",
		"����-����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����-����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����-����������",
		"������-����������",
		"����������",
		"����-����������",
		"����������",
		"����-����������",
		"������",
		"����������",
		"������-����������",
		"����������",
		"������-����������",
		"������-����������",
		"������-����������",
		"����-����������",
		"����������",
		"����������",
		"��������",
		"������-����������",
		"����������",
		"����-����������",
		"����-����������",
		"������-����������",
		"����������",
		"������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"������",
		"����������",
		"����-����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"������",
		"������",
		"����������",
		"����������",
		"������-����������",
		"������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"���������",
		"����-����������",
		"����������",
		"����������",
		"������-����������",
		"������-����������",
		"����-����������",
		"����-����������",
		"����-����������",
		"���������",
		"������",
		"������",
		"������-����������",
		"����������",
		"����������",
		"������",
		"����������",
		"����������",
		"����������",
		"�������",
		"����������",
		"����������",
		"����������",
		"�������",
		"������-����������",
		"����������",
		"���������",
		"����-����������",
		"����������",
		"������-����������",
		"����-����������",
		"����-����������",
		"����������",
		"����������",
		"����������",
		"����-����������",
		"����������",
		"����������",
		"���������",
		"����-����������",
		"����������",
		"����������",
		"����-����������",
		"����������",
		"������-����������",
		"����������",
		"����-����������",
		"����������",
		"����-����������",
		"������",
		"����������",
		"����-����������",
		"�����",
		"����������",
		"����������",
		"����-����������",
		"����-����������",
		"����-����������",
		"�������",
		"����������",
		"����-����������",
		"������-����������",
		"����������",
		"����������",
		"����-����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����-����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"��������",
		"����������",
		"����-���������",
		"������",
		"����������",
		"����-����������",
		"����-����������",
		"�������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����������",
		"����-����������",
		"����������",
		"������-����������",
		"����������",
		"����������"
	})[skin_id]
end
function getweaponname(weap_id)
	return ({
		[0] = "",
		"������",
		"������ ��� ������",
		"����������� �������",
		"Knife",
		"Baseball Bat",
		"Shovel",
		"Pool Cue",
		"Katana",
		"Chainsaw",
		"Purple Dildo",
		"Dildo",
		"Vibrator",
		"Silver Vibrator",
		"Flowers",
		"Cane",
		"Grenade",
		"Tear Gas",
		"Molotov Cocktail",
		nil,
		nil,
		nil,
		"9mm",
		"Silenced 9mm",
		"Desert Eagle",
		"Shotgun",
		"Sawnoff Shotgun",
		"Combat Shotgun",
		"Micro SMG/Uzi",
		"MP5",
		"AK-47",
		"M4",
		"Tec-9",
		"Country Rifle",
		"Sniper Rifle",
		"RPG",
		"HS Rocket",
		"Flamethrower",
		"Minigun",
		"Satchel Charge",
		"Detonator",
		"Spraycan",
		"Fire Extinguisher",
		"Camera",
		"Night Vis Goggles",
		"Thermal Goggles",
		"Parachute"
	})[weap_id]
end
function dayname()
	return ({
		[0] = "�����������",
		"�����������",
		"�������",
		"�����",
		"�������",
		"�������",
		"�������"
	})[tonumber(os.date("%w"))]
end
function mesname()
	return ({
		"������",
		"�������",
		"����",
		"������",
		"���",
		"����",
		"����",
		"������",
		"��������",
		"�������",
		"������",
		"�������"
	})[tonumber(os.date("%m"))]
end
function oprPost()
	local x, y, z = getCharCoordinates(playerPed)
    local posts = {
		{"����������� ����", 1394.3744, -1863.6901, 1.7979, 1527.8936, -1578.9664, 100},
		{"���", 1532.8394, -1655.124, 2.5315, 1591.2151, -1603.675, 100},
		{"�������� ��", 1138.8849, -1387.8881, 0.009, 1252.5458, -1247.9099, 100},
		{"������� ��-��", -10.0753, -1590.4454, -39.9974, 114.5343, -1502.3046, 100},
		{"������� ��-��", 1638.5343, -823.3046, 14.6011, 1726.064, -630.532, 100},
		{"����� ��", 1451.2023, -1320.3397, 0, 1535.6632, -1211.2609, 100},
		{"����������� �����", 1051.524, -1548.4238, 0, 1177.4086, -1392.0896, 100},
		{"��� ��", 1620.7903, -1735.1667, 0, 1695.285, -1657.7039, 100},
		{"���������", -2132.9829, -1077.4011, 0, -1886.8691, -698.4249, 100},
		{"�� ��", -2025.5016, 58.7853, 11.2769, -1897.6361, 224.9209, 48.7579},
		{"���������", -2136.2292, -130.4842, 25.6789, -1997.2661, -60.0742, 47.4639},
		{"������� ��-��", -1795.1125, -816.5402, -8.9159, -1501.1254, -686.5373, 74.1878},
		{"������� ��-��", -1609.3582, 578.6608, 23.8739, -1448.6035, 797.5581, 106.4763},
		{"������� ��-��", -1658.5999, 526.7474, 28.7922, -1562.8611, 682.9404, 61.6484},
		{"�������� ��", -2743.5232, 573.9707, 2.3322, -2614.4087, 698.1281, 88.2686},
		{"���-1", -1608.7949, 631.6048, -1.0945, -1543.1639, 691.499, 15.7108},
		{"���-2", -1723.8849, 653.8339, 19.6651, -1676.6998, 715.0552, 36.7264},
		{"�������� ��", 1562.2344, 1715.9434, -1.0594, 1667.147, 1872.7228, 47.0605},
		{"�� ��", 2733.6272, 1211.5406, -13.6819, 2869.2107, 1397.9591, 46.3719},
		{"���-1", 2330.6814, 2407.8245, 3.6589, 2360.2805, 2444.5332, 18.808},
		{"���-2", 2229.5854, 2429.189, 8.3063, 2254.6479, 2498.783, 24.7113},
		{"������� ��-��", 1737.3713, 581.9952, -22.9514, 1834.1492, 878.7039, 41.8146},
		{"������� ��-��", 965.7903, 720.4094, -11.7455, 1344.7903, 1058.4094, 56.6468},
		{"������", 1845.3638, 872.8126, 0, 2042.9298, 1091.4816, 100},
		{"���������", -1543.5377, 424.495, -2.7875, -1221.449, 537.2685, 66.6995},
	}
    for i, v in ipairs(posts) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return '����������'
end
function greeting()
	local dt = tonumber(os.date("%H"))
	if dt >= 0 and dt < 5 then
		return "������ ����"
	elseif dt >= 5 and dt < 11 then
		return "������ ����"
	elseif dt >= 11 and dt < 16 then
		return "������ ����"
	elseif dt >= 16 and dt < 22 then
		return "������ �����"
	elseif dt >= 22 then
		return "������ ����"
	end
end
function oprZone()
	local x, y, z = getCharCoordinates(playerPed)
    local streets = {
		{"���� ������ ������", -2667.81, -302.135, -28.831, -2646.4, -262.32, 71.169},
		{"�������� ����� ���", -1315.42, -405.388, 15.406, -1264.4, -209.543, 25.406},
		{"���� ������ ������", -2550.04, -355.493, 0, -2470.04, -318.493, 39.7},
		{"�������� ������ ���", -1490.33, -209.543, 15.406, -1264.4, -148.388, 25.406},
		{"������", -2395.14, -222.589, -5.3, -2354.09, -204.792, 200},
		{"����� �����", -1632.83, -2263.44, -3, -1601.33, -2231.79, 200},
		{"��������� ���-������", 2381.68, -1494.03, -89.084, 2421.03, -1454.35, 110.916},
		{"�������� ���� ���-���������", 1236.63, 1163.41, -89.084, 1277.05, 1203.28, 110.916},
		{"����������� ���������", 1277.05, 1044.69, -89.084, 1315.35, 1087.63, 110.916},
		{"���� ������ ������", -2470.04, -355.493, 0, -2270.04, -318.493, 46.1},
		{"������", 1252.33, -926.999, -89.084, 1357, -910.17, 110.916},
		{"������� ��������", 1692.62, -1971.8, -20.492, 1812.62, -1932.8, 79.508},
		{"�������� ���� ���-���������", 1315.35, 1044.69, -89.084, 1375.6, 1087.63, 110.916},
		{"��������� ���-�������", 2581.73, -1454.35, -89.084, 2632.83, -1393.42, 110.916},
		{"������ ������� ��", 2437.39, 1858.1, -39.084, 2495.09, 1970.85, 60.916},
		{"���. ����� �� ������� �����", -1132.82, -787.391, 0, -956.476, -768.027, 200},
		{"����� ���-�������", 1370.85, -1170.87, -89.084, 1463.9, -1130.85, 110.916},
		{"�������� ����", -1620.3, 1176.52, -4.5, -1580.01, 1274.26, 200},
		{"������� ������", 787.461, -1410.93, -34.126, 866.009, -1310.21, 65.874},
		{"�� ������ ���-��������", 2811.25, 1229.59, -39.594, 2861.25, 1407.59, 60.406},
		{"����������� ����������", 1582.44, 347.457, 0, 1664.62, 401.75, 200},
		{"���� ��������-�����", 2759.25, 296.501, 0, 2774.25, 594.757, 200},
		{"������� ���o� ���", 1377.48, 2600.43, -21.926, 1492.45, 2687.36, 78.074},
		{"����� ���-�������", 1507.51, -1385.21, 110.916, 1582.55, -1325.31, 335.916},
		{"����������", 2185.33, -1210.74, -89.084, 2281.45, -1154.59, 110.916},
		{"����������", 1318.13, -910.17, -89.084, 1357, -768.027, 110.916},
		{"���� ������ ������", -2361.51, -417.199, 0, -2270.04, -355.493, 200},
		{"����������", 1996.91, -1449.67, -89.084, 2056.86, -1350.72, 110.916},
		{"��������� ���� �������", 1236.63, 2142.86, -89.084, 1297.47, 2243.23, 110.916},
		{"����������", 2124.66, -1494.03, -89.084, 2266.21, -1449.67, 110.916},
		{"�������� ���� �������", 1848.4, 2478.49, -89.084, 1938.8, 2553.49, 110.916},
		{"�����", 422.68, -1570.2, -89.084, 466.223, -1406.05, 110.916},
		{"�� ��", -2007.83, 56.306, 0, -1922, 224.782, 100},
		{"����� ���-�������", 1391.05, -1026.33, -89.084, 1463.9, -926.999, 110.916},
		{"�������� ����", 1704.59, 2243.23, -89.084, 1777.39, 2342.83, 110.916},
		{"��������� �������", 1758.9, -1722.26, -89.084, 1812.62, -1577.59, 110.916},
		{"������ ����������", 1375.6, 823.228, -89.084, 1457.39, 919.447, 110.916},
		{"�������� ���-������", 1974.63, -2394.33, -39.084, 2089, -2256.59, 60.916},
		{"����� ��� ", -399.633, -1075.52, -1.489, -319.033, -977.516, 198.511},
		{"�����", 334.503, -1501.95, -89.084, 422.68, -1406.05, 110.916},
		{"������", 225.165, -1369.62, -89.084, 334.503, -1292.07, 110.916},
		{"����� ���-�������", 1724.76, -1250.9, -89.084, 1812.62, -1150.87, 110.916},
		{"����������� ����� ��", 2027.4, 1703.23, -89.084, 2137.4, 1783.23, 110.916},
		{"����� ���-�������", 1378.33, -1130.85, -89.084, 1463.9, -1026.33, 110.916},
		{"������ ����������", 1197.39, 1044.69, -89.084, 1277.05, 1163.39, 110.916},
		{"���������-�����", 1073.22, -1842.27, -89.084, 1323.9, -1804.21, 110.916},
		{"����������", 1451.4, 347.457, -6.1, 1582.44, 420.802, 200},
		{"������-�����", -2270.04, -430.276, -1.2, -2178.69, -324.114, 200},
		{"������� ���������", 1325.6, 596.349, -89.084, 1375.6, 795.01, 110.916},
		{"�������� ���-�������", 2051.63, -2597.26, -39.084, 2152.45, -2394.33, 60.916},
		{"����������", 1096.47, -910.17, -89.084, 1169.13, -768.027, 110.916},
		{"����� ����", 1457.46, 2723.23, -89.084, 1534.56, 2863.23, 110.916},
		{"����������� ����� ��", 2027.4, 1783.23, -89.084, 2162.39, 1863.23, 110.916},
		{"����������", 2056.86, -1210.74, -89.084, 2185.33, -1126.32, 110.916},
		{"����������", 952.604, -937.184, -89.084, 1096.47, -860.619, 110.916},
		{"����������� �������� �������", -1372.14, 2498.52, 0, -1277.59, 2615.35, 200},
		{"���-�������", 2126.86, -1126.32, -89.084, 2185.33, -934.489, 110.916},
		{"���-�������", 1994.33, -1100.82, -89.084, 2056.86, -920.815, 110.916},
		{"������", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
		{"�������� ���� ���-���������", 1277.05, 1087.63, -89.084, 1375.6, 1203.28, 110.916},
		{"�������� ���� �������", 1377.39, 2433.23, -89.084, 1534.56, 2507.23, 110.916},
		{"����������", 2201.82, -2095, -89.084, 2324, -1989.9, 110.916},
		{"�������� ���� �������", 1704.59, 2342.83, -89.084, 1848.4, 2433.23, 110.916},
		{"�����", 1252.33, -1130.85, -89.084, 1378.33, -1026.33, 110.916},
		{"��������� �������", 1701.9, -1842.27, -89.084, 1812.62, -1722.26, 110.916},
		{"�����", -2411.22, 373.539, 0, -2253.54, 458.411, 200},
		{"�������� ���-��������", 1515.81, 1586.4, -12.5, 1729.95, 1714.56, 87.5},
		{"������", 225.165, -1292.07, -89.084, 466.223, -1235.07, 110.916},
		{"�����", 1252.33, -1026.33, -89.084, 1391.05, -926.999, 110.916},
		{"��������� ���-������", 2266.26, -1494.03, -89.084, 2381.68, -1372.04, 110.916},
		{"��������� ���� �������", 2623.18, 943.235, -89.084, 2749.9, 1055.96, 110.916},
		{"����������", 2541.7, -1941.4, -89.084, 2703.58, -1852.87, 110.916},
		{"���-�������", 2056.86, -1126.32, -89.084, 2126.86, -920.815, 110.916},
		{"��������� ���� �������", 2625.16, 2202.76, -89.084, 2685.16, 2442.55, 110.916},
		{"�����", 225.165, -1501.95, -89.084, 334.503, -1369.62, 110.916},
		{"����������� ������� ��", -365.167, 2123.01, -3, -208.57, 2217.68, 200},
		{"��������� ���� �������", 2536.43, 2442.55, -89.084, 2685.16, 2542.55, 110.916},
		{"�����", 334.503, -1406.05, -89.084, 466.223, -1292.07, 110.916},
		{"�������", 647.557, -1227.28, -89.084, 787.461, -1118.28, 110.916},
		{"�����", 422.68, -1684.65, -89.084, 558.099, -1570.2, 110.916},
		{"�������� ���� �������", 2498.21, 2542.55, -89.084, 2685.16, 2626.55, 110.916},
		{"����� ���-�������", 1724.76, -1430.87, -89.084, 1812.62, -1250.9, 110.916},
		{"�����", 225.165, -1684.65, -89.084, 312.803, -1501.95, 110.916},
		{"����������", 2056.86, -1449.67, -89.084, 2266.21, -1372.04, 110.916},
		{"������� ����� ", 603.035, 264.312, 0, 761.994, 366.572, 200},
		{"�����", 1096.47, -1130.84, -89.084, 1252.33, -1026.33, 110.916},
		{"���� �������", -1087.93, 855.37, -89.084, -961.95, 986.281, 110.916},
		{"���� ������", 1046.15, -1722.26, -89.084, 1161.52, -1577.59, 110.916},
		{"���������", 1323.9, -1722.26, -89.084, 1440.9, -1577.59, 110.916},
		{"����������", 1357, -926.999, -89.084, 1463.9, -768.027, 110.916},
		{"�����", 466.223, -1570.2, -89.084, 558.099, -1385.07, 110.916},
		{"����������", 911.802, -860.619, -89.084, 1096.47, -768.027, 110.916},
		{"����������", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
		{"����� ���� �������", 2377.39, 788.894, -89.084, 2537.39, 897.901, 110.916},
		{"������", 1812.62, -1852.87, -89.084, 1971.66, -1742.31, 110.916},
		{"����� ����", 2089, -2394.33, -89.084, 2201.82, -2235.84, 110.916},
		{"���������", 1370.85, -1577.59, -89.084, 1463.9, -1384.95, 110.916},
		{"�������� ���� �������", 2121.4, 2508.23, -89.084, 2237.4, 2663.17, 110.916},
		{"�����", 1096.47, -1026.33, -89.084, 1252.33, -910.17, 110.916},
		{"����-����", 1812.62, -1449.67, -89.084, 1996.91, -1350.72, 110.916},
		{"�������� ��", -1242.98, -50.096, 0, -1213.91, 578.396, 200},
		{"������ �����", -222.179, 293.324, 0, -122.126, 476.465, 200},
		{"����������� ����� ��", 2106.7, 1863.23, -89.084, 2162.39, 2202.76, 110.916},
		{"����������", 2541.7, -2059.23, -89.084, 2703.58, -1941.4, 110.916},
		{"������", 807.922, -1577.59, -89.084, 926.922, -1416.25, 110.916},
		{"�������� ���-��������", 1457.37, 1143.21, -89.084, 1777.4, 1203.28, 110.916},
		{"������", 1812.62, -1742.31, -89.084, 1951.66, -1602.31, 110.916},
		{"�������� ���������", -1580.01, 1025.98, -6.1, -1499.89, 1274.26, 200},
		{"����� ���-�������", 1370.85, -1384.95, -89.084, 1463.9, -1170.87, 110.916},
		{"���� ����", 1664.62, 401.75, 0, 1785.14, 567.203, 200},
		{"�����", 312.803, -1684.65, -89.084, 422.68, -1501.95, 110.916},
		{"������� ��������", 1440.9, -1722.26, -89.084, 1583.5, -1577.59, 110.916},
		{"����������", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
		{"���� ������", -2741.07, 1490.47, -6.1, -2616.4, 1659.68, 200},
		{"���-�������", 2185.33, -1154.59, -89.084, 2281.45, -934.489, 110.916},
		{"����������", 1169.13, -910.17, -89.084, 1318.13, -768.027, 110.916},
		{"�������� ���� �������", 1938.8, 2508.23, -89.084, 2121.4, 2624.23, 110.916},
		{"���������", 1667.96, -1577.59, -89.084, 1812.62, -1430.87, 110.916},
		{"�����", 72.648, -1544.17, -89.084, 225.165, -1404.97, 110.916},
		{"���� ���������", 2536.43, 2202.76, -89.084, 2625.16, 2442.55, 110.916},
		{"�����", 72.648, -1684.65, -89.084, 225.165, -1544.17, 110.916},
		{"������", 952.663, -1310.21, -89.084, 1072.66, -1130.85, 110.916},
		{"���-�������", 2632.74, -1135.04, -89.084, 2747.74, -945.035, 110.916},
		{"����������", 861.085, -674.885, -89.084, 1156.55, -600.896, 110.916},
		{"�����", -2253.54, 373.539, -9.1, -1993.28, 458.411, 200},
		{"�������� ����", 1848.4, 2342.83, -89.084, 2011.94, 2478.49, 110.916},
		{"�����", -1580.01, 744.267, -6.1, -1499.89, 1025.98, 200},
		{"���������-�����", 1046.15, -1804.21, -89.084, 1323.9, -1722.26, 110.916},
		{"������", 647.557, -1118.28, -89.084, 787.461, -954.662, 110.916},
		{"����� �����", -2994.49, 277.411, -9.1, -2867.85, 458.411, 200},
		{"������� ���������", 964.391, 930.89, -89.084, 1166.53, 1044.69, 110.916},
		{"����-����", 1812.62, -1100.82, -89.084, 1994.33, -973.38, 110.916},
		{"�������� ���� ���-���������", 1375.6, 919.447, -89.084, 1457.37, 1203.28, 110.916},
		{"������", -405.77, 1712.86, -3, -276.719, 1892.75, 200},
		{"���� ������", 1161.52, -1722.26, -89.084, 1323.9, -1577.59, 110.916},
		{"��������� ���-������", 2281.45, -1372.04, -89.084, 2381.68, -1135.04, 110.916},
		{"��������", 2137.4, 1703.23, -89.084, 2437.39, 1783.23, 110.916},
		{"������", 1951.66, -1742.31, -89.084, 2124.66, -1602.31, 110.916},
		{"�������", 2624.4, 1383.23, -89.084, 2685.16, 1783.23, 110.916},
		{"������", 2124.66, -1742.31, -89.084, 2222.56, -1494.03, 110.916},
		{"�����", -2533.04, 458.411, 0, -2329.31, 578.396, 200},
		{"�����", -1871.72, 1176.42, -4.5, -1620.3, 1274.26, 200},
		{"���������", 1583.5, -1722.26, -89.084, 1758.9, -1577.59, 110.916},
		{"��������� ���-������", 2381.68, -1454.35, -89.084, 2462.13, -1135.04, 110.916},
		{"������", 647.712, -1577.59, -89.084, 807.922, -1416.25, 110.916},
		{"������", 72.648, -1404.97, -89.084, 225.165, -1235.07, 110.916},
		{"�������", 647.712, -1416.25, -89.084, 787.461, -1227.28, 110.916},
		{"��������� ���-������", 2222.56, -1628.53, -89.084, 2421.03, -1494.03, 110.916},
		{"�����", 558.099, -1684.65, -89.084, 647.522, -1384.93, 110.916},
		{"��������� ������", -1709.71, -833.034, -1.5, -1446.01, -730.118, 200},
		{"�����", 466.223, -1385.07, -89.084, 647.522, -1235.07, 110.916},
		{"�������� ����", 1817.39, 2202.76, -89.084, 2011.94, 2342.83, 110.916},
		{"������ ������", 2162.39, 1783.23, -89.084, 2437.39, 1883.23, 110.916},
		{"������", 1971.66, -1852.87, -89.084, 2222.56, -1742.31, 110.916},
		{"����������� ����������", 1546.65, 208.164, 0, 1745.83, 347.457, 200},
		{"����������", 2089, -2235.84, -89.084, 2201.82, -1989.9, 110.916},
		{"�����", 952.663, -1130.84, -89.084, 1096.47, -937.184, 110.916},
		{"����� ����", 1848.4, 2553.49, -89.084, 1938.8, 2863.23, 110.916},
		{"�������� ���-������", 1400.97, -2669.26, -39.084, 2189.82, -2597.26, 60.916},
		{"���� ������", -1213.91, 950.022, -89.084, -1087.93, 1178.93, 110.916},
		{"���� ������", -1339.89, 828.129, -89.084, -1213.91, 1057.04, 110.916},
		{"���� �������", -1339.89, 599.218, -89.084, -1213.91, 828.129, 110.916},
		{"���� �������", -1213.91, 721.111, -89.084, -1087.93, 950.022, 110.916},
		{"���� ������", 930.221, -2006.78, -89.084, 1073.22, -1804.21, 110.916},
		{"¸����� ����� ", 1073.22, -2006.78, -89.084, 1249.62, -1842.27, 110.916},
		{"�������", 787.461, -1130.84, -89.084, 952.604, -954.662, 110.916},
		{"�������", 787.461, -1310.21, -89.084, 952.663, -1130.84, 110.916},
		{"���������", 1463.9, -1577.59, -89.084, 1667.96, -1430.87, 110.916},
		{"������", 787.461, -1416.25, -89.084, 1072.66, -1310.21, 110.916},
		{"�������� ������", 2377.39, 596.349, -89.084, 2537.39, 788.894, 110.916},
		{"�������� ���� �������", 2237.4, 2542.55, -89.084, 2498.21, 2663.17, 110.916},
		{"��������� ����", 2632.83, -1668.13, -89.084, 2747.74, -1393.42, 110.916},
		{"���� ������", 434.341, 366.572, 0, 603.035, 555.68, 200},
		{"����������", 2089, -1989.9, -89.084, 2324, -1852.87, 110.916},
		{"���������", -2274.17, 578.396, -7.6, -2078.67, 744.17, 200},
		{"���-��������-����-������", -208.57, 2337.18, 0, 8.43, 2487.18, 200},
		{"����� ����", 2324, -2145.1, -89.084, 2703.58, -2059.23, 110.916},
		{"����� ��� ��������", -1132.82, -768.027, 0, -956.476, -578.118, 200},
		{"����� �����", 1817.39, 1703.23, -89.084, 2027.4, 1863.23, 110.916},
		{"����� �����", -2994.49, -430.276, -1.2, -2831.89, -222.589, 200},
		{"������", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
		{"���� ���� ", 176.581, 1305.45, -3, 338.658, 1520.72, 200},
		{"������", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
		{"������ �������", 2162.39, 1883.23, -89.084, 2437.39, 2012.18, 110.916},
		{"��������� ����", 2747.74, -1668.13, -89.084, 2959.35, -1498.62, 110.916},
		{"����������", 2056.86, -1372.04, -89.084, 2281.45, -1210.74, 110.916},
		{"����� ���-�������", 1463.9, -1290.87, -89.084, 1724.76, -1150.87, 110.916},
		{"����� ���-�������", 1463.9, -1430.87, -89.084, 1724.76, -1290.87, 110.916},
		{"���� ������", -1499.89, 696.442, -179.615, -1339.89, 925.353, 20.385},
		{"����� ���� �������", 1457.39, 823.228, -89.084, 2377.39, 863.229, 110.916},
		{"��������� ���-������", 2421.03, -1628.53, -89.084, 2632.83, -1454.35, 110.916},
		{"������� ���������", 964.391, 1044.69, -89.084, 1197.39, 1203.22, 110.916},
		{"���-�������", 2747.74, -1120.04, -89.084, 2959.35, -945.035, 110.916},
		{"����������", 737.573, -768.027, -89.084, 1142.29, -674.885, 110.916},
		{"����� ����", 2201.82, -2730.88, -89.084, 2324, -2418.33, 110.916},
		{"��������� ���-������", 2462.13, -1454.35, -89.084, 2581.73, -1135.04, 110.916},
		{"������", 2222.56, -1722.33, -89.084, 2632.83, -1628.53, 110.916},
		{"���� ������ ������", -2831.89, -430.276, -6.1, -2646.4, -222.589, 200},
		{"����������", 1970.62, -2179.25, -89.084, 2089, -1852.87, 110.916},
		{"�������� ���������", -1982.32, 1274.26, -4.5, -1524.24, 1358.9, 200},
		{"��� �o����", 1817.39, 1283.23, -89.084, 2027.39, 1469.23, 110.916},
		{"����� ����", 2201.82, -2418.33, -89.084, 2324, -2095, 110.916},
		{"������ ���� ����", 1823.08, 596.349, -89.084, 1997.22, 823.228, 110.916},
		{"������� ������ ", -2353.17, 2275.79, 0, -2153.17, 2475.79, 200},
		{"�����", -2329.31, 458.411, -7.6, -1993.28, 578.396, 200},
		{"���-������", 1692.62, -2179.25, -89.084, 1812.62, -1842.27, 110.916},
		{"������� ���������", 1375.6, 596.349, -89.084, 1558.09, 823.228, 110.916},
		{"������� ������", 1817.39, 1083.23, -89.084, 2027.39, 1283.23, 110.916},
		{"��������� ���������� ��������", 1197.39, 1163.39, -89.084, 1236.63, 2243.23, 110.916},
		{"��� ������", 2581.73, -1393.42, -89.084, 2747.74, -1135.04, 110.916},
		{"�����", 1817.39, 1863.23, -89.084, 2106.7, 2011.83, 110.916},
		{"������� �����", 1938.8, 2624.23, -89.084, 2121.4, 2861.55, 110.916},
		{"���� ������", 851.449, -1804.21, -89.084, 1046.15, -1577.59, 110.916},
		{"����������� ������", -1119.01, 1178.93, -89.084, -862.025, 1351.45, 110.916},
		{"������ ����", 2749.9, 943.235, -89.084, 2923.39, 1198.99, 110.916},
		{"��������� ����", 2703.58, -2302.33, -89.084, 2959.35, -2126.9, 110.916},
		{"������ ����", 2324, -2059.23, -89.084, 2541.7, -1852.87, 110.916},
		{"�����������", -2411.22, 265.243, -9.1, -1993.28, 373.539, 200},
		{"������������", 1323.9, -1842.27, -89.084, 1701.9, -1722.26, 110.916},
		{"����������", 1269.13, -768.027, -89.084, 1414.07, -452.425, 110.916},
		{"������", 647.712, -1804.21, -89.084, 851.449, -1577.59, 110.916},
		{"����� �������", -2741.07, 1268.41, -4.5, -2533.04, 1490.47, 200},
		{"������ ������� �������", 1817.39, 863.232, -89.084, 2027.39, 1083.23, 110.916},
		{"������ ����", 964.391, 1203.22, -89.084, 1197.39, 1403.22, 110.916},
		{"�������� ���������� ��������", 1534.56, 2433.23, -89.084, 1848.4, 2583.23, 110.916},
		{"���� ��� ������ ������� �������", 1117.4, 2723.23, -89.084, 1457.46, 2863.23, 110.916},
		{"������� ������", 1812.62, -1602.31, -89.084, 2124.66, -1449.67, 110.916},
		{"��������� ������� �����", 1297.47, 2142.86, -89.084, 1777.39, 2243.23, 110.916},
		{"�������", -2270.04, -324.114, -1.2, -1794.92, -222.589, 200},
		{"����� ��������", 967.383, -450.39, -3, 1176.78, -217.9, 200},
		{"���-���������", -926.13, 1398.73, -3, -719.234, 1634.69, 200},
		{"������ � ������� ������", 1817.39, 1469.23, -89.084, 2027.4, 1703.23, 110.916},
		{"������ ��������������", -2867.85, 277.411, -9.1, -2593.44, 458.411, 200},
		{"����������� ���� �������", -2646.4, -355.493, 0, -2270.04, -222.589, 200},
		{"������", 2027.4, 863.229, -89.084, 2087.39, 1703.23, 110.916},
		{"�������", -2593.44, -222.589, -1, -2411.22, 54.722, 200},
		{"������������� ��", 1852, -2394.33, -89.084, 2089, -2179.25, 110.916},
		{"��������� ��������", 1098.31, 1726.22, -89.084, 1197.39, 2243.23, 110.916},
		{"���������� �������������", -789.737, 1659.68, -89.084, -599.505, 1929.41, 110.916},
		{"��� ������", 1812.62, -2179.25, -89.084, 1970.62, -1852.87, 110.916},
		{"�����������", -1700.01, 744.267, -6.1, -1580.01, 1176.52, 200},
		{"������-�����", -2178.69, -1250.97, 0, -1794.92, -1115.58, 200},
		{"���-���������", -354.332, 2580.36, 2, -133.625, 2816.82, 200},
		{"������� ������", -936.668, 2611.44, 2, -715.961, 2847.9, 200},
		{"����������� ���������", 1166.53, 795.01, -89.084, 1375.6, 1044.69, 110.916},
		{"������", 2222.56, -1852.87, -89.084, 2632.83, -1722.33, 110.916},
		{"�������� ������������ ������", -1213.91, -730.118, 0, -1132.82, -50.096, 200},
		{"�������� ������� �����", 1817.39, 2011.83, -89.084, 2106.7, 2202.76, 110.916},
		{"��������� ����������", -1499.89, 578.396, -79.615, -1339.89, 1274.26, 20.385},
		{"������ ��������", 2087.39, 1543.23, -89.084, 2437.39, 1703.23, 110.916},
		{"����������� ������", 2087.39, 1383.23, -89.084, 2437.39, 1543.23, 110.916},
		{"������", 72.648, -1235.07, -89.084, 321.356, -1008.15, 110.916},
		{"������ �������� ������", 2437.39, 1783.23, -89.084, 2685.16, 2012.18, 110.916},
		{"����������", 1281.13, -452.425, -89.084, 1641.13, -290.913, 110.916},
		{"�����������", -1982.32, 744.17, -6.1, -1871.72, 1274.26, 200},
		{"����������", 2576.92, 62.158, 0, 2759.25, 385.503, 200},
		{"K.A.C.C. ������� �������", 2498.21, 2626.55, -89.084, 2749.9, 2861.55, 110.916},
		{"����� ����-�������", 1777.39, 863.232, -89.084, 1817.39, 2342.83, 110.916},
		{"������� ��������", -2290.19, 2548.29, -89.084, -1950.19, 2723.29, 110.916},
		{"��������� ����", 2324, -2302.33, -89.084, 2703.58, -2145.1, 110.916},
		{"������", 321.356, -1044.07, -89.084, 647.557, -860.619, 110.916},
		{"������������ ������������ ����������", 1558.09, 596.349, -89.084, 1823.08, 823.235, 110.916},
		{"��������� ����", 2632.83, -1852.87, -89.084, 2959.35, -1668.13, 110.916},
		{"��������� ����", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
		{"��������", 19.607, -404.136, 3.8, 349.607, -220.137, 200},
		{"������� �������", 2749.9, 1198.99, -89.084, 2923.39, 1548.99, 110.916},
		{"���� �����", 1812.62, -1350.72, -89.084, 2056.86, -1100.82, 110.916},
		{"�����������", -1993.28, 265.243, -9.1, -1794.92, 578.396, 200},
		{"�������� ������� �����", 1377.39, 2243.23, -89.084, 1704.59, 2433.23, 110.916},
		{"������", 321.356, -1235.07, -89.084, 647.522, -1044.07, 110.916},
		{"���� ����", -2741.45, 1659.68, -6.1, -2616.4, 2175.15, 200},
		{"��� ������", -90.218, 1286.85, -3, 153.859, 1554.12, 200},
		{"����������� �������", -187.7, -1596.76, -89.084, 17.063, -1276.6, 110.916},
		{"���-�������", 2281.45, -1135.04, -89.084, 2632.74, -945.035, 110.916},
		{"�������� ������ �������", 2749.9, 1548.99, -89.084, 2923.39, 1937.25, 110.916},
		{"���������� ������", 2011.94, 2202.76, -89.084, 2237.4, 2508.23, 110.916},
		{"���-��������-����-������", -208.57, 2123.01, -7.6, 114.033, 2337.18, 200},
		{"����� �����", -2741.07, 458.411, -7.6, -2533.04, 793.411, 200},
		{"�����-����-�������", 2703.58, -2126.9, -89.084, 2959.35, -1852.87, 110.916},
		{"��������", 926.922, -1577.59, -89.084, 1370.85, -1416.25, 110.916},
		{"�������", -2593.44, 54.722, 0, -2411.22, 458.411, 200},
		{"����������� ���������", 1098.39, 2243.23, -89.084, 1377.39, 2507.23, 110.916},
		{"���������", 2121.4, 2663.17, -89.084, 2498.21, 2861.55, 110.916},
		{"��������", 2437.39, 1383.23, -89.084, 2624.4, 1783.23, 110.916},
		{"������ ����", 964.391, 1403.22, -89.084, 1197.39, 1726.22, 110.916},
		{"'������� ���", -410.02, 1403.34, -3, -137.969, 1681.23, 200},
		{"��������", 580.794, -674.885, -9.5, 861.085, -404.79, 200},
		{"��� ���������", -1645.23, 2498.52, 0, -1372.14, 2777.85, 200},
		{"�������� ���������", -2533.04, 1358.9, -4.5, -1996.66, 1501.21, 200},
		{"�������� ����������� �����", -1499.89, -50.096, -1, -1242.98, 249.904, 200},
		{"������� ������", 1916.99, -233.323, -100, 2131.72, 13.8, 200},
		{"����������", 1414.07, -768.027, -89.084, 1667.61, -452.425, 110.916},
		{"��������� ����", 2747.74, -1498.62, -89.084, 2959.35, -1120.04, 110.916},
		{"���� ���-�������", 2450.39, 385.503, -100, 2759.25, 562.349, 200},
		{"����� ����", -2030.12, -2174.89, -6.1, -1820.64, -1771.66, 200},
		{"��������", 1072.66, -1416.25, -89.084, 1370.85, -1130.85, 110.916},
		{"�������� �������� �����", 1997.22, 596.349, -89.084, 2377.39, 823.228, 110.916},
		{"������� �����", 1534.56, 2583.23, -89.084, 1848.4, 2863.23, 110.916},
		{"���������� �������", -1794.92, -50.096, -1.04, -1499.89, 249.904, 200},
		{"����������", -1166.97, -1856.03, 0, -815.624, -1602.07, 200},
		{"��� �������� ������", 1457.39, 863.229, -89.084, 1777.4, 1143.21, 110.916},
		{"������� �����", 1117.4, 2507.23, -89.084, 1534.56, 2723.23, 110.916},
		{"��������", 104.534, -220.137, 2.3, 349.607, 152.236, 200},
		{"���-��������-����-������", -464.515, 2217.68, 0, -208.57, 2580.36, 200},
		{"�����������", -2078.67, 578.396, -7.6, -1499.89, 744.267, 200},
		{"��������� �������� �����", 2537.39, 676.549, -89.084, 2902.35, 943.235, 110.916},
		{"����� ���-�����", -2616.4, 1501.21, -3, -1996.66, 1659.68, 200},
		{"��������", -2741.07, 793.411, -6.1, -2533.04, 1268.41, 200},
		{"�����������", 2087.39, 1203.23, -89.084, 2640.4, 1383.23, 110.916},
		{"������ ������ ���������", 2162.39, 2012.18, -89.084, 2685.16, 2202.76, 110.916},
		{"����������� �����������", -2533.04, 578.396, -7.6, -2274.17, 968.369, 200},
		{"��������� �����������", -2533.04, 968.369, -6.1, -2274.17, 1358.9, 200},
		{"���� ���������", 2237.4, 2202.76, -89.084, 2536.43, 2542.55, 110.916},
		{"��������� ���������� ��������", 2685.16, 1055.96, -89.084, 2749.9, 2626.55, 110.916},
		{"���� ������", 647.712, -2173.29, -89.084, 930.221, -1804.21, 110.916},
		{"������-�����", -2178.69, -599.884, -1.2, -1794.92, -324.114, 200},
		{"���� ������", -901.129, 2221.86, 0, -592.09, 2571.97, 200},
		{"������ ������", -792.254, -698.555, -5.3, -452.404, -380.043, 200},
		{"�����", -1209.67, -1317.1, 114.981, -908.161, -787.391, 251.981},
		{"������� �������", -968.772, 1929.41, -3, -481.126, 2155.26, 200},
		{"�������� ���������", -1996.66, 1358.9, -4.5, -1524.24, 1592.51, 200},
		{"����������", -1871.72, 744.17, -6.1, -1701.3, 1176.42, 300},
		{"������", -2411.22, -222.589, -1.14, -2173.04, 265.243, 200},
		{"����������", 1119.51, 119.526, -3, 1451.4, 493.323, 200},
		{"�����", 2749.9, 1937.25, -89.084, 2921.62, 2669.79, 110.916},
		{"������������� ���� ���-�������", 1249.62, -2394.33, -89.084, 1852, -2179.25, 110.916},
		{"���� ������ ������", 72.648, -2173.29, -89.084, 342.648, -1684.65, 110.916},
		{"����������� �����������", 1463.9, -1150.87, -89.084, 1812.62, -768.027, 110.916},
		{"���������� �����", -2324.94, -2584.29, -6.1, -1964.22, -2212.11, 200},
		{"������ ����", 37.032, 2337.18, -3, 435.988, 2677.9, 200},
		{"��������� �������", 338.658, 1228.51, 0, 664.308, 1655.05, 200},
		{"�������", 2087.39, 943.235, -89.084, 2623.18, 1203.23, 110.916},
		{"�������� ������� �����", 1236.63, 1883.11, -89.084, 1777.39, 2142.86, 110.916},
		{"���� ������ ������", 342.648, -2173.29, -89.084, 647.712, -1684.65, 110.916},
		{"���������� �����", 1249.62, -2179.25, -89.084, 1692.62, -1842.27, 110.916},
		{"�������� ����-��������", 1236.63, 1203.28, -89.084, 1457.37, 1883.11, 110.916},
		{"������� ������", -594.191, -1648.55, 0, -187.7, -1276.6, 200},
		{"���������� �����", 930.221, -2488.42, -89.084, 1249.62, -2006.78, 110.916},
		{"��������-����", 2160.22, -149.004, 0, 2576.92, 228.322, 200},
		{"��������� ����", 2373.77, -2697.09, -89.084, 2809.22, -2330.46, 110.916},
		{"�������� ������������ ������", -1213.91, -50.096, -4.5, -947.98, 578.396, 200},
		{"��������� ��������", 883.308, 1726.22, -89.084, 1098.31, 2507.23, 110.916},
		{"������� �������", -2274.17, 744.17, -6.1, -1982.32, 1358.9, 200},
		{"���������� �������", -1794.92, 249.904, -9.1, -1242.98, 578.396, 200},
		{"����� � ���-������", -321.744, -2224.43, -89.084, 44.615, -1724.43, 110.916},
		{"�������", -2173.04, -222.589, -1, -1794.92, 265.243, 200},
		{"���� ������", -2178.69, -2189.91, -47.917, -2030.12, -1771.66, 576.083},
		{"���� ������", -376.233, 826.326, -3, 123.717, 1220.44, 200},
		{"������-�����", -2178.69, -1115.58, 0, -1794.92, -599.884, 200},
		{"��������� �������", -2994.49, -222.589, -1, -2593.44, 277.411, 200},
		{"���� ����", 508.189, -139.259, 0, 1306.66, 119.526, 200},
		{"�������", -2741.07, 2175.15, 0, -2353.17, 2722.79, 200},
		{"�������� ����-��������", 1457.37, 1203.28, -89.084, 1777.39, 1883.11, 110.916},
		{"�������� ���������", -319.676, -220.137, 0, 104.534, 293.324, 200},
		{"����������� ������", -2994.49, 458.411, -6.1, -2741.07, 1339.61, 200},
		{"�������� ������", 2285.37, -768.027, 0, 2770.59, -269.74, 200},
		{"��������� ������", 337.244, 710.84, -115.239, 860.554, 1031.71, 203.761},
		{"������������� ���� ���-�������", 1382.73, -2730.88, -89.084, 2201.82, -2394.33, 110.916},
		{"��������� ����", -2994.49, -811.276, 0, -2178.69, -430.276, 200},
		{"����� ���-�����", -2616.4, 1659.68, -3, -1996.66, 2175.15, 200},
		{"��������� ����", -91.586, 1655.05, -50, 421.234, 2123.01, 250},
		{"���� ������", -2997.47, -1115.58, -47.917, -2178.69, -971.913, 576.083},
		{"���� ������", -2178.69, -1771.66, -47.917, -1936.12, -1250.97, 576.083},
		{"�������� ������������ ������", -1794.92, -730.118, -3, -1213.91, -50.096, 200},
		{"����������", -947.98, -304.32, -1.1, -319.676, 327.071, 200},
		{"����� ����", -1820.64, -2643.68, -8, -1226.78, -1771.66, 200},
		{"����� o ���", -1166.97, -2641.19, 0, -321.744, -1856.03, 200},
		{"���� ������", -2994.49, -2189.91, -47.917, -2178.69, -1115.58, 576.083},
		{"������ ������", -1213.91, 596.349, -242.99, -480.539, 1659.68, 900},
		{"����� ������", -1213.91, -2892.97, -242.99, 44.615, -768.027, 900},
		{"��������� ������", -2997.47, -2892.97, -242.99, -1213.91, -1115.58, 900},
		{"�������� �����", -480.539, 596.349, -242.99, 869.461, 2993.87, 900},
		{"������ ������", -2997.47, 1659.68, -242.99, -480.539, 2993.87, 900},
		{"���-������", -2997.47, -1115.58, -242.99, -1213.91, 1659.68, 900},
		{"���-��������", 869.461, 596.349, -242.99, 2997.06, 2993.87, 900},
		{"������� �����", -1213.91, -768.027, -242.99, 2997.06, 596.349, 900},
		{"���-������", 44.615, -2892.97, -242.99, 2997.06, -768.027, 900},
		{"����� ������", 37.7141, -3373.5518, -242.99, 986.0303, -2450.5461, 900},
    }
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return '����������'
end
function kvadrat()
	local x, y, z = getCharCoordinates(1)

	if ({
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�",
		"�"
	})[math.ceil((y * -1 + 3000) / 250)] == nil or math.ceil((x + 3000) / 250) == nil then
		return "-"
	else
		return y .. "-" .. x
	end
end
function hint(text)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
            imgui.PushTextWrapPos(600)
                imgui.TextUnformatted(text)
            imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end
function onWindowMessage(msg, wparam, lparam)
    if (msg == 256 or msg == 257) and wparam == 27 and imgui.Process and not isPauseMenuActive() and not sampIsCursorActive() then
        consumeWindowMessage(true, true)
        if msg == 257 and tHotKeyData.edit == nil then
			if show_taglist_param.v then
				show_taglist_param.v = false
			elseif show_taglist.v then
				show_taglist.v = false
			elseif show_color1_tag.v then
				show_color1_tag.v = false
			elseif main_window.v then
				main_window.v = false
			end
        end
    end
	if tHotKeyData.edit ~= nil and msg == wm.WM_CHAR then
        if tBlockChar[wparam] then
            consumeWindowMessage(true, true)
        end
    end
    if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
        if tHotKeyData.edit ~= nil and wparam == VK_ESCAPE then
            tKeys = {}
            tHotKeyData.edit = nil
            consumeWindowMessage(true, true)
        end
        if tHotKeyData.edit ~= nil and wparam == VK_BACK then
            tHotKeyData.save = {tHotKeyData.edit, {}}
            tHotKeyData.edit = nil
            consumeWindowMessage(true, true)
        end
        local num = getKeyNumber(wparam)
        if num == -1 then
            tKeys[#tKeys + 1] = wparam
            if tHotKeyData.edit ~= nil then
                if not imgui.isKeyModified(wparam) or #tKeys == 2 then
                    tHotKeyData.save = {tHotKeyData.edit, tKeys}
                    tHotKeyData.edit = nil
                    tKeys = {}
                    consumeWindowMessage(true, true)
                end
            end
        end
        reloadKeysList()
        if tHotKeyData.edit ~= nil then
            consumeWindowMessage(true, true)
        end
    elseif msg == wm.WM_KEYUP or msg == wm.WM_SYSKEYUP then
        local num = getKeyNumber(wparam)
        if num > -1 then
            tKeys[num] = nil
        end
        reloadKeysList()
        if tHotKeyData.edit ~= nil then
            consumeWindowMessage(true, true)
        end
    end
end
function onScriptTerminate(scr,quitGame)
    if scr == thisScript() then
        showCursor(false, false)
		removeBlip(marker1)
    end
end
local btns = {
    sel = 1,
    btns = {
        {fa.HOUSE, u8' �������'},
        {fa.GEAR, u8' ���������'},
        {fa.KEYBOARD, u8' ������'}, 
        {fa.RAYGUN, u8' ��������� ������'},
		{fa.CHART_PIE, u8' ������ ����'},
        {fa.ROCKET_LAUNCH, u8' ������'},
        {fa.CIRCLE_INFO, u8' ����������'},
    }
}
function imgui.DisButton(...)
    local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
        imgui.Button(...)
    imgui.PopStyleColor()
    imgui.PopStyleColor()
    imgui.PopStyleColor()
end
function imgui.SetCur(numX, numY)
    if type(numX) == 'number' and type(numY) == 'number' then
        local x = imgui.GetCursorPos()
        imgui.SetCursorPos(im2(x.x+numX, x.y+numY))
    else
        print('Eror in function imgui.SetY type(numX or numY) != number')
    end
end

function imgui.SetMCur(numX, numY)
    if type(numX) == 'number' and type(numY) == 'number' then
        local x = imgui.GetCursorPos()
        imgui.SetCursorPos(im2(x.x-numX, x.y-numY))
    else
        print('Eror in function imgui.SetY type(numX or numY) != number')
    end
end
-- // -- IMGUI Im's -- \\ --  
local act_menu        	= imgui.ImBuffer(u8(loaded.main.cmd_act), 35)
local f_name          	= imgui.ImBuffer(u8(loaded.main.f_name), 45)
local rang1           	= imgui.ImBuffer(u8(loaded.main.rang1), 35)
local phone          	= imgui.ImBuffer(u8(loaded.main.phone), 25)
local frak           	= imgui.ImBuffer(u8(loaded.main.frak), 35)
local tegr           	= imgui.ImBuffer(u8(loaded.main.tegr), 35)
local tegf           	= imgui.ImBuffer(u8(loaded.main.tegf), 35)

local frakid          	= imgui.ImInt(loaded.main.frakid)
local female          	= imgui.ImInt(loaded.main.female)
local theme           	= imgui.ImInt(loaded.main.theme)
   
local dop_channel		= imgui.ImBool(loaded.main.dop_channel)
local rp_arrest			= imgui.ImBool(loaded.main.rp_arrest)
local rpgun				= imgui.ImBool(loaded.main.rpgun)
local dopsu				= imgui.ImBool(loaded.main.dopsu)
local dopticket			= imgui.ImBool(loaded.main.dopticket)
local new_arrest		= imgui.ImBool(loaded.main.new_arrest)
local rp_say			= imgui.ImBool(loaded.main.rp_say)
local not_update_codecs	= imgui.ImBool(loaded.main.not_update_codecs)
local opt_enb			= imgui.ImBool(loaded.main.opt_enb)
local rp_point			= imgui.ImBool(loaded.main.rp_point)
local autoskreen		= imgui.ImBool(loaded.main.autoskreen)
local off_podskaz 		= imgui.ImBool(loaded.main.off_podskaz)

local fast_vidget 		= fast_loaded.main.vidget
local fast_big_mark 	= imgui.ImBool(fast_loaded.main.big_mark)
local fast_act 			= imgui.ImBool(fast_loaded.main.act)
local fast_mark 		= imgui.ImBool(fast_loaded.main.mark)

local fast_categ_name  	= imgui.ImBuffer('', 15)
local fast_slot_name  	= imgui.ImBuffer('', 15)
local fast_delay	  	= imgui.ImBuffer('', 10)
local fast_text		  	= imgui.ImBuffer('', 2560)

local show_radar_window = imgui.ImBool(false)

local slider_int_wait = imgui.ImFloat(loaded.main.wait_cmd/1000)
local wait_cmd = slider_int_wait.v

local comand_name		  	= imgui.ImBuffer('', 20)
local comand_wait		  	= imgui.ImBuffer('', 10)
local comand_text		  	= imgui.ImBuffer('', 2560)

local comand_param1_act		= imgui.ImBool(false)
local comand_param2_act		= imgui.ImBool(false)
local comand_param3_act		= imgui.ImBool(false)

local binder_name		  	= imgui.ImBuffer('', 20)
local binder_wait		  	= imgui.ImBuffer('', 10)
local binder_text		  	= imgui.ImBuffer('', 2560)

local hud1					= imgui.ImBool(false)
local hud_city				= imgui.ImBool(false)
local hud_zone				= imgui.ImBool(false)
local hud_kvadrat			= imgui.ImBool(false)
local hud_post				= imgui.ImBool(false)
local hud_channel			= imgui.ImBool(false)
local hud_cardinalpoints	= imgui.ImBool(false)
local hud_hp				= imgui.ImBool(false)
local hud_armour			= imgui.ImBool(false)
local hud_ping				= imgui.ImBool(false)
local hud_time				= imgui.ImBool(false)
local hud_radio_title		= imgui.ImBool(false)
local hud_icon				= imgui.ImBool(false)

if loaded.main.colors1_hud_r >= 0 and loaded.main.colors1_hud_g >= 0 and loaded.main.colors1_hud_b >= 0 and loaded.main.colors1_hud_a >= 0 then
	colors_1_hud = imgui.ImColor(loaded.main.colors1_hud_r, loaded.main.colors1_hud_g, loaded.main.colors1_hud_b, loaded.main.colors1_hud_a):GetVec4()
else
	colors_1_hud = imgui.ImColor(0, 0, 0, 100):GetVec4()
end

-- \\ -- ---------- -- // --

function imgui.OnDrawFrame()
    if main_window.v then
        local resX, resY = getScreenResolution()
        local sizeX, sizeY = set_size_x, 500 -- WINDOW SIZE
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2 - sizeX / 2, resY / 2 - sizeY / 2), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.Always)
        imgui.Begin('##main_window', main_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
        imgui.BeginChild('##panel_button', im2(160, -1))
        -- imgui.SameLine(5)
        -- imgui.DisButton('MOJ Helper', im2(150, 30))
        imgui.SetCur(0, 10)
        imgui.PushFont(big_font)
        imgui.CenterText('MoJ Helper')
        imgui.PopFont()
        imgui.SetCur(0, 10)
        imgui.NewLine()
		imgui.SameLine(5)
		imgui.BeginGroup('##panel_btn')
        for i, v in ipairs(btns.btns) do
            if imgui.Button(v[1]..v[2], im2(150, 30)) then
                btns.sel = i
				if i == 2 then
					resize = 1110
				else
					resize = 950
				end
            end
        end
        imgui.SetCursorPosY(imgui.GetWindowSize().y-70)
		if imgui.Button(fa.POWER_OFF..u8' ���������', im2(150, 30)) then
			imgui.OpenPopup(u8"���������?")
		end
		if imgui.Button(fa.ROTATE..u8' �������������', im2(150, 30)) then
			imgui.OpenPopup(u8"�������������?")
		end
		if imgui.BeginPopupModal(u8"���������?", nil, imgui.WindowFlags.AlwaysAutoResize) then
			imgui.Text(u8("�� ������� ��� ������ ��������� MoJ Helper?\n��������� ������ ����� �������� ������ ��� ���������� � ����. "))
			imgui.Separator()

			if imgui.Button(u8("��"), imgui.ImVec2(-0.1, 0)) then
				thisScript():unload()
			end

			if imgui.Button(u8("���"), imgui.ImVec2(-0.1, 0)) then
				imgui.CloseCurrentPopup()
			end

			imgui.EndPopup()
		end
		if imgui.BeginPopupModal(u8"�������������?", nil, imgui.WindowFlags.AlwaysAutoResize) then
			imgui.Text(u8("�� ������� ��� ������ ������������� MoJ Helper?"))
			imgui.Separator()

			if imgui.Button(u8("��"), imgui.ImVec2(-0.1, 0)) then
				thisScript():reload()
			end

			if imgui.Button(u8("���"), imgui.ImVec2(-0.1, 0)) then
				imgui.CloseCurrentPopup()
			end

			imgui.EndPopup()
		end
		imgui.EndGroup()
        imgui.EndChild()

        imgui.SameLine()
        imgui.BeginGroup('##forw')
        imgui.BeginChild('##panel_title', im2(-1, 30))
        local sel_curr = {}
        for i, v in ipairs(btns.btns) do
            if i == btns.sel then
                sel_curr = v
            end
        end
        imgui.SetCursorPos(im2(imgui.GetWindowSize().x/2 - 50, 5))
        imgui.PushFont(big_fa)
        imgui.CenterText(sel_curr[1], sel_curr[1]..sel_curr[2])
        imgui.PopFont()
        imgui.SameLine()
        imgui.PushFont(big_font)
        imgui.Text(sel_curr[2])
        imgui.PopFont()
        imgui.SetCursorPos(im2(imgui.GetWindowSize().x - 25, 5))
        if imgui.Button(fa.XMARK, im2(20, 20)) then
            main_window.v = false 
        end
        imgui.EndChild()

        imgui.BeginChild('##main_menu', im2(-1, -1))
        local x = imgui.GetCursorPos()
        imgui.SetCursorPos(im2(x.x+5, x.y+5))
        imgui.BeginGroup('##main_group')
		
        if btns.sel == 1 then
			panel_main()
        elseif btns.sel == 2 then
            panel_settings()
        elseif btns.sel == 3 then
            bind_set()
        elseif btns.sel == 4 then
            panel_rpgun()
        elseif btns.sel == 5 then
			panel_fast()
		elseif btns.sel == 6 then
            panel_other()
        elseif btns.sel == 7 then
            panel_info()
        end
        imgui.EndGroup()
        imgui.EndChild()
        
        imgui.EndGroup()
        imgui.End()
    end
	if show_taglist.v then
		if not id_marker then
			tid_marker = "[��� �� �����]"
		else
			tid_marker = id_marker
		end

		if not name_marker then
			tname_marker = "[��� �� �����]"
		else
			tname_marker = name_marker
		end

		if not surname_marker then
			tsurname_marker = "[��� �� �����]"
		else
			tsurname_marker = surname_marker
		end

		if rang1.v == "" then
			trang1 = "[��� �� �����]"
		else
			trang1 = u8:decode(rang1.v)
		end

		if not phone.v or phone.v == "" then
			tphone = "[��� �� �����]"
		else
			tphone = phone.v
		end

		if not gun_name or gun_name == "" then
			tgun_name = "[��� �� �����]"
		else
			tgun_name = gun_name
		end

		if tegr.v == "" then
			ttegr = "��� �� �����"
		else
			ttegr = u8:decode(tegr.v)
		end

		if frak.v == "" then
			tfrak = "[��� �� �����]"
		else
			tfrak = u8:decode(frak.v)
		end

		if tegf.v == "" then
			ttegf = "��� �� �����"
		else
			ttegf = u8:decode(tegf.v)
		end

		if not post or post == "" or post == "���" then
			tpost = "[��� �� �����]"
		else
			tpost = post
		end

		if not naparnik_id or naparnik_id == "" then
			tnaparnik_id = "[�� ������]"
		else
			tnaparnik_id = naparnik_id
		end

		if not naparnik_nicks or naparnik_nicks == "" then
			tnaparnik_nicks = "[�� ������]"
		else
			tnaparnik_nicks = naparnik_nicks
		end

		if not name_car_megafon or name_car_megafon == "" then
			tname_car_megafon = "[�� ������]"
		else
			tname_car_megafon = name_car_megafon
		end

		if not id_vodil_megafon or id_vodil_megafon == "" then
			tid_vodil_megafon = "[�� ������]"
		else
			tid_vodil_megafon = id_vodil_megafon
		end

		if not zone or zone == "" or zone == "���" then
			tzone = "[�� ������]"
		else
			tzone = zone
		end

		if not color_car_megafon or color_car_megafon == "" then
			tcolor_car_megafon = "[�� ������]"
		else
			tcolor_car_megafon = color_car_megafon
		end

		local taglist_mass = {
			{
				6,
				"{wait_600}",
				"����� ���-�� ������ ��� �������� ����� �������� (� ����).",
				string.format("{wait_800}"),
				"{wait_800}"
			},
			{
				1,
				"{name}",
				"���� ���.",
				string.format("���� ����� %s.", nick_player1),
				"���� ����� {name}."
			},
			{
				1,
				"{surname}",
				"���� �������.",
				string.format("��� ������� %s.", nick_player2),
				"��� ������� {surname}."
			},
			{
				1,
				"{id}",
				"��� ������� ID.",
				string.format("/n ������� ������� /pass %s.", id_player),
				"/n ������� ������� /pass {id}."
			},
			{
				1,
				"{rang}",
				"���� ���������/������.",
				string.format("�� ����� %s.", trang1),
				"�� ����� {rang} {surname}."
			},
			{
				1,
				"{frak}",
				"�������� ����� �����������.",
				string.format("���� �����! ��� %s.", tfrak),
				"���� �����! ��� {frak}."
			},
			{
				1,
				"{phone}",
				"����� ��������.",
				string.format("��� ����� %s.", tphone),
				"��� ����� {phone}."
			},
			{
				3,
				"{time1}",
				"������� ���� � �����.",
				string.format("������ %s.", os.date("%d %m %Y, %X")),
				"������ {time1}."
			},
			{
				3,
				"{time2}",
				"������� �����.",
				string.format("������ �� ����� %s.", os.date("%X")),
				"������ �� ����� {time2}."
			},
			{
				1,
				"{greeting}",
				"����������� �� ������� �����.",
				string.format("%s, ��� ��� ������.", greeting()),
				"{greeting}, ��� ��� ������."
			},
			{
				1,
				"{weapon}",
				"�������� ������.",
				string.format("������ %s.", tgun_name),
				"������ {weapon}."
			},
			{
				2,
				"{city}",
				"������� �����.",
				string.format("������ � � %s.", cityname),
				"������ � � {city}."
			},
			{
				2,
				"{zone}",
				"������� �����.",
				string.format("��� �� ������ %s.", tzone),
				"��� �� ������ {zone}"
			},
			{
				1,
				"{tag_r}",
				"������ ��� ��� /r.",
				string.format("[%s] �������� ���� ������!", ttegr),
				"{tag_r} �������� ���� ������!"
			},
			{
				1,
				"{tag_f}",
				"������ ��� ��� /f.",
				string.format("[%s] LSPD, �� �����...", ttegf),
				"{tag_f} LSPD, �� �����..."
			},
			{
				2,
				"{post}",
				"������� ����.",
				string.format("�������� �� ����� %s.", tpost),
				"�������� �� ����� {post}."
			},
			{
				2,
				"{kvadrat}",
				"������� �������.",
				string.format("�������� � �������� %s.", kvadrat()),
				"�������� � �������� {kvadrat}."
			},
			{
				4,
				"{id_marker}",
				"ID ������, ����������� �������� ����� ���.",
				string.format("/cuff %s", tid_marker),
				"/cuff {id_marker}."
			},
			{
				4,
				"{name_marker}",
				"��� ������, ����������� �������� ����� ���.",
				string.format("%s", tname_marker),
				"������, {name_marker}. "
			},
			{
				4,
				"{surname_marker}",
				"������� ������, ����������� �������� ����� ���.",
				string.format("������������, ������ %s.", tsurname_marker),
				"������������, ������ {surname_marker}."
			},
			{
				5,
				"{partner_ids}",
				"ID ���������(-��).",
				string.format("� ������� ����� ������ N-%s", tnaparnik_id),
				"� ������� ����� ������ N-{partner_ids}."
			},
			{
				5,
				"{partner_nicks}",
				"���(-�) ���������(-��).",
				string.format("� ������� ����� %s", tnaparnik_nicks),
				"� ������� ����� {partner_nicks}."
			},
			{
				5,
				"{meg_c_model}",
				"�������� �/c ��� ��������.",
				string.format("���������� ����� %s.", tname_car_megafon),
				"���������� ����� {meg_c_model}."
			},
			{
				5,
				"{meg_c_id}",
				"ID �������� ��� ��������",
				string.format("�������� c ������� �/� N-%s.", tid_vodil_megafon),
				"�������� c ������� �/� N-{meg_c_id}."
			},
			{
				6,
				"{F6}",
				"���� �������� ������� ������ � ����� ������� � ���� �����.",
				string.format("������� ���� �����."),
				"{F6}����� �����."
			},
			{
				6,
				"{message}",
				"���� �������� ������� ������ � ������ ����� �������� � ��� ������������.",
				string.format("��������� �������� � �����������."),
				"{message}����� �����."
			},
			{
				6,
				"{F8}",
				"���� �������� ������� ������ � ����� ������ ��������.",
				string.format("������ ��������."),
				"{F8}����� �����."
			},
			{
				6,
				"{}",
				"���-������.",
				string.format("������ ������."),
				"{F6}�������:{}"
			},
			{
				3,
				"{dd}",
				"������� ����.",
				string.format("%s ����(-��).", os.date("%d")),
				"{dd} ����(-��)."
			},
			{
				3,
				"{mm}",
				"������� ����� ������.",
				string.format("%s �����(-��).", os.date("%m")),
				"{mm} �����(-��)."
			},
			{
				3,
				"{YY}",
				"������� ��� (4 �����).",
				string.format("������ %s ���.", os.date("%Y")),
				"������ {YY} ���."
			},
			{
				3,
				"{yy}",
				"������� ��� (2 �����).",
				string.format("%s ���.", os.date("%y")),
				"{yy} ���."
			},
			{
				3,
				"{H}",
				"������� ���.",
				string.format("������ %s ���(-��).", os.date("%H")),
				"������ {H} ���(-��)."
			},
			{
				3,
				"{M}",
				"������� ������.",
				string.format("%s �����(-�).", os.date("%M")),
				"{M} �����(-�)."
			},
			{
				3,
				"{S}",
				"������� �������. ",
				string.format("%s ������(-�).", os.date("%S")),
				"{S} ������(-�)."
			},
			{
				3,
				"{day}",
				"������� �������� ��� ������.",
				string.format("������� %s.", dayname()),
				"������� {day}."
			},
			{
				3,
				"{month}",
				"������� �������� ������.",
				string.format("������ %s.", mesname()),
				"������ {month}."
			},
			{
				5,
				"{color_car}",
				"���� ���������� ��� ��������",
				string.format("�������� ���������� %s �����.", tcolor_car_megafon),
				"�������� ���������� {color_car} �����."
			},
			{
				2,
				"{cardinalp}",
				"����������� ������.",
				string.format("���������� ������� � %s �����������", storona and cardinal_points[storona][2] or '�����������'),
				"���������� ������� � {cardinalp} �����������"
			}
		}

		local rx, ry = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(rx / 5 - 200, ry / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(650, 500), imgui.Cond.FirstUseEver)
		imgui.Begin(u8("MoJ Helper | ������ �����"), show_taglist)

		if copy_tag and os.time() <= copy_tag_time then
			imgui.CenterText(u8(string.format("������! ��� ���������� � ����� ������.")))
		else
			imgui.CenterText(u8("�������� ������ ��� � ������� �� ������ � ���� ����� � �������Ż ��� �����������."))
		end

		imgui.Columns(3)
		imgui.Separator()
		imgui.SetColumnWidth(-1, 130)
		imgui.Text(u8("���� � ��������"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 250)
		imgui.Text(u8("������"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 300)
		imgui.Text(u8("���������"))
		imgui.NextColumn()
		imgui.Separator()

		for i = 0, #taglist_mass do
			if taglist_mass[i] and taglist_mass[i][1] == 1 then
				if imgui.Button(taglist_mass[i][2], imgui.ImVec2(120, 0)) then
					setClipboardText(taglist_mass[i][2])

					copy_tag = true
					copy_tag_time = os.time() + 1
				end

				hint(u8(taglist_mass[i][3]))
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][5]), 300)
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][4]), 300)
				imgui.NextColumn()
				imgui.Separator()
			end
		end

		for i = 0, #taglist_mass do
			if taglist_mass[i] and taglist_mass[i][1] == 2 then
				if imgui.Button(taglist_mass[i][2], imgui.ImVec2(120, 0)) then
					setClipboardText(taglist_mass[i][2])

					copy_tag = true
					copy_tag_time = os.time() + 1
				end

				hint(u8(taglist_mass[i][3]))
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][5]), 300)
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][4]), 300)
				imgui.NextColumn()
				imgui.Separator()
			end
		end

		for i = 0, #taglist_mass do
			if taglist_mass[i] and taglist_mass[i][1] == 3 then
				if imgui.Button(taglist_mass[i][2], imgui.ImVec2(120, 0)) then
					setClipboardText(taglist_mass[i][2])

					copy_tag = true
					copy_tag_time = os.time() + 1
				end

				hint(u8(taglist_mass[i][3]))
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][5]), 300)
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][4]), 300)
				imgui.NextColumn()
				imgui.Separator()
			end
		end

		for i = 0, #taglist_mass do
			if taglist_mass[i] and taglist_mass[i][1] == 4 then
				if imgui.Button(taglist_mass[i][2], imgui.ImVec2(120, 0)) then
					setClipboardText(taglist_mass[i][2])

					copy_tag = true
					copy_tag_time = os.time() + 1
				end

				hint(u8(taglist_mass[i][3]))
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][5]), 300)
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][4]), 300)
				imgui.NextColumn()
				imgui.Separator()
			end
		end

		for i = 0, #taglist_mass do
			if taglist_mass[i] and taglist_mass[i][1] == 5 then
				if imgui.Button(taglist_mass[i][2], imgui.ImVec2(120, 0)) then
					setClipboardText(taglist_mass[i][2])

					copy_tag = true
					copy_tag_time = os.time() + 1
				end

				hint(u8(taglist_mass[i][3]))
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][5]), 300)
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][4]), 300)
				imgui.NextColumn()
				imgui.Separator()
			end
		end

		for i = 0, #taglist_mass do
			if taglist_mass[i] and taglist_mass[i][1] == 6 then
				if imgui.Button(taglist_mass[i][2], imgui.ImVec2(120, 0)) then
					setClipboardText(taglist_mass[i][2])

					copy_tag = true
					copy_tag_time = os.time() + 1
				end

				hint(u8(taglist_mass[i][3]))
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][5]), 300)
				imgui.NextColumn()
				imgui.Text(u8(taglist_mass[i][4]), 300)
				imgui.NextColumn()
				imgui.Separator()
			end
		end

		imgui.End()
	end
	if show_taglist_param.v then
		local rs, ry = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(rs / 5 - 200, ry / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(400, 300), imgui.Cond.FirstUseEver)
		imgui.Begin(u8("MoJ Helper | ���� ���������� � ������"), show_taglist_param)

		local wrap_width = 380

		imgui.PushTextWrapPos(imgui.GetCursorPos().x + wrap_width)

		if imgui.Button(u8("{param1}")) then
			setClipboardText("{param1}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("�������� ��������� 1 ����� �������")))

		if imgui.Button(u8("{name_param1}")) then
			setClipboardText("{name_param1}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("��� ������ � ID ��������� 1")))

		if imgui.Button(u8("{surname_param1}")) then
			setClipboardText("{surname_param1}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("������� ������ � ID ��������� 1")))
		imgui.Text(u8(string.format("")))

		if imgui.Button(u8("{param2}")) then
			setClipboardText("{param2}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("�������� ��������� 2 ����� �������")))

		if imgui.Button(u8("{name_param2}")) then
			setClipboardText("{name_param2}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("��� ������ � ID ��������� 2")))

		if imgui.Button(u8("{surname_param2}")) then
			setClipboardText("{surname_param2}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("������� ������ � ID ��������� 2")))
		imgui.Text(u8(string.format("")))

		if imgui.Button(u8("{param3}")) then
			setClipboardText("{param3}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("�������� ��������� 3 ����� �������")))

		if imgui.Button(u8("{name_param3}")) then
			setClipboardText("{name_param3}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("��� ������ � ID ��������� 3")))

		if imgui.Button(u8("{surname_param3}")) then
			setClipboardText("{surname_param3}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("������� ������ � ID ��������� 3")))
		imgui.End()
	end
	if show_color1_tag.v then
		local resX, resY = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
		imgui.Begin(u8("��������� �����"), show_color1_tag)

		if imgui.ColorPicker4("##2", colors_1_hud, imgui.ColorEditFlags.AlphaBar) then
			loaded.main.colors1_hud_r, loaded.main.colors1_hud_g, loaded.main.colors1_hud_b, loaded.main.colors1_hud_a = imgui.ImColor(colors_1_hud):GetRGBA()
			save()
		end

		if imgui.Button(u8("�������")) then
			show_color1_tag.v = false
		end

		imgui.SameLine()

		if imgui.Button(u8("��������")) then
			colors_1_hud = imgui.ImColor(0, 0, 0, 100):GetVec4()
			loaded.main.colors1_hud_r = 0
			loaded.main.colors1_hud_g = 0
			loaded.main.colors1_hud_b = 0
			loaded.main.colors1_hud_a = 100
			save()
		end

		imgui.End()
	end
end

function msg(text)
	local text = tostring(text)
	if text ~= nil then
		sampAddChatMessage('[MoJ Helper] {f9f9f9}'..text, 0xaaccbb)
	end
end

function InputText(text, ...)
    imgui.Text(text)
    imgui.SameLine()
    return imgui.InputText('##'..text, ...)
end

function panel_main()

end

function panel_fast()
	if not fast_vidget then
		imgui.BeginChild("otstup", imgui.ImVec2(0, imgui.GetWindowSize().y / 2 - 78), false)
		imgui.EndChild()
		imgui.NewLine()
		imgui.SameLine(imgui.GetWindowSize().x / 2 - 22.5)
		imgui.SetCursorPosY(imgui.GetCursorPos().y+10)
		imgui.PushFont(big_fa)
		imgui.CenterText(fa.ROCKET_LAUNCH)
		imgui.PopFont()
		imgui.CenterText(u8"���������� �������� �����\n    �������� � ����������\n   ������������ �������.")
		imgui.NewLine()
		imgui.SameLine(imgui.GetWindowSize().x / 2 - 72)

		if imgui.Button(u8("������������ ������"), imgui.ImVec2(144, 20)) then
			fast_loaded.main.vidget = true
			fast_vidget = true
			saveFast()
		end
	else
		if imgui.Checkbox(u8'���. ������� ����', fast_act) then
			fast_loaded.main.act = fast_act.v
			saveFast()
		end
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetCursorPosX()+5)
		if imgui.Checkbox(u8'������ ��� �������', fast_mark) then
			fast_loaded.main.mark = fast_mark.v
			saveFast()
		end
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetCursorPosX()+5)
		if imgui.Checkbox(u8'������� ������ �������', fast_big_mark) then
			fast_loaded.main.big_mark = fast_big_mark.v
			saveFast()
		end
		imgui.Separator()
		imgui.BeginChild("setting_c", imgui.ImVec2(120, 0), true)
		for k, v in pairs(fast_loaded.menu) do
			local slo = v.name == '' and true or false
			if imgui.Selectable(k..(slo == false and ('. '..u8(v.name)) or '.'), selected_fast_menu == k and true or false) then
				selected_fast_menu = k
				fast_categ_name.v = u8(v.name)
				selected_fast_menu_categ = 0
			end
			if slo == true then
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0, 255, 0, 1), u8("���������"))
			end
		end
		imgui.EndChild()
		if selected_fast_menu ~= nil then
			imgui.SameLine()
			imgui.BeginChild("setting_c2", imgui.ImVec2(120, 0), true)
			for k, v in pairs(fast_loaded.menu) do
				if selected_fast_menu == k then
					for k2, v2 in pairs(v.menu) do
						local slo = v2[1] == '' and true or false
						if imgui.Selectable(k2..'. '..u8(v2[1]), selected_fast_menu_categ == k2 and true or false) then
							selected_fast_menu_categ = k2
							local ftext = v2[2]:gsub("&", "\n")
							fast_slot_name.v = u8(v2[1])
							fast_delay.v = u8(v2[3])
							fast_text.v = u8(ftext)
						end
						if slo == true then
							imgui.SameLine()
							imgui.TextColored(imgui.ImVec4(0, 255, 0, 1), u8("C���"))
						end
					end
				end
			end
			imgui.EndChild()
		end
		imgui.SameLine()
		imgui.BeginChild("setting_c3", imgui.ImVec2(0, 0), true)
		if selected_fast_menu == nil or selected_fast_menu_categ == 0 then
			imgui.BeginChild("otstup", imgui.ImVec2(0, imgui.GetWindowSize().y / 2 - 78), false)
			imgui.EndChild()
			imgui.NewLine()
			imgui.SameLine(imgui.GetWindowSize().x / 2 - 22.5)
			imgui.PushFont(big_fa)
			imgui.CenterText(fa.LAYER_PLUS)
			imgui.PopFont()
			imgui.CenterText(u8"������� ��������� ����������!")
		else
			imgui.Text(u8("��� ���������:"))

			imgui.PushItemWidth(300)
			if imgui.InputText('##cat_name', fast_categ_name) then
				fast_loaded.menu[selected_fast_menu].name = u8:decode(fast_categ_name.v)
				saveFast()
			end
			imgui.PopItemWidth()

			imgui.Text(u8("��� �����:"))

			imgui.PushItemWidth(300)
			if imgui.InputText('##slot_name', fast_slot_name) then
				fast_loaded.menu[selected_fast_menu].menu[selected_fast_menu_categ][1] = u8:decode(fast_slot_name.v)
				saveFast()
			end
			imgui.PopItemWidth()

			imgui.SameLine()
			if imgui.Button(u8("�")) then
				fast_loaded.menu[selected_fast_menu].menu[selected_fast_menu_categ][1] = ''
				fast_loaded.menu[selected_fast_menu].menu[selected_fast_menu_categ][2] = ''
				fast_loaded.menu[selected_fast_menu].menu[selected_fast_menu_categ][3] = '1000' 
				selected_fast_menu_categ = 0
				saveFast()
			end
			hint(u8'�������')

			imgui.Text(u8("�������� � �������� (�� 0.1 �� 15.0 ���):"))

			imgui.PushItemWidth(300)
			if imgui.InputText('##delay', fast_delay) then
				local num = tonumber(fast_delay.v)
				if num ~= nil then
					if num >= 0 and num <= 15 then
						fast_loaded.menu[selected_fast_menu].menu[selected_fast_menu_categ][3] = u8:decode(fast_delay.v)
						saveFast()
					end
				end
			end
			imgui.PopItemWidth()

			if fast_delay.v ~= "" then
				local num = tonumber(fast_delay.v)
				if num ~= nil then
					if num <= 0 or num > 15 then
						imgui.TextColoredRGB("{FF3B3B}[!] {FFFFFF}������� ��������� ���� � ���������.")
					end
				else
					imgui.TextColoredRGB("{FF3B3B}[!] {FFFFFF}������� ��������� ���� � ���������.")
				end
			end

			imgui.Text(u8("����� �����:"))

			if imgui.InputTextMultiline("##source", fast_text, imgui.ImVec2(-1, imgui.GetTextLineHeight() * 8)) then
				fast_loaded.menu[selected_fast_menu].menu[selected_fast_menu_categ][2] = u8:decode(fast_text.v):gsub('\n', '&')
				saveFast()
			end
			if imgui.Button(u8("������ �����")) then
				show_taglist.v = not show_taglist.v
			end

			imgui.Separator()
			imgui.CenterText(u8("��������� (� ����������� �����):"))
			if fast_text.v ~= '' then
				imgui.Text(string.gsub(preobr_message(fast_text.v), "&", "\n"))
			end
			imgui.Text(u8("\n"))
		end
		imgui.EndChild()
	end
end

local selected = 1
local fraks = {
	u8("�� �������"),
	u8("LSPD"),
	u8("SFPD"),
	u8("LVPD"),
	u8("RCPD"),
	u8("FBI"),
	u8("������")
}

local selected_key = 0

function tridmark()
	nick_marker = nil
	tridmark_nick = nil
	mass_nickmark = {}
	mark_num = 0
	marker_add = false
	id_marker = nil
	name_marker = nil
	surname_marker = nil

	while true do
		wait(0)
		local coordX, coordY, coordZ = getCharCoordinates(playerPed)
		if fast_act.v then
			local res, pTarg = getCharPlayerIsTargeting(playerHandle)
			if res then
				local res, playerid = sampGetPlayerIdByCharHandle(pTarg)
				if playerid >= 0 and playerid <= 999 then
					local nick_target = sampGetPlayerNickname(playerid)
					if marker_add ~= true then
						local res, charTarg = sampGetCharHandleBySampPlayerId(playerid)
						local targX, targY, targZ = getCharCoordinates(charTarg)
						local dist = getDistanceBetweenCoords3d(targX, targY, targZ, coordX, coordY, coordZ)
						if fast_big_mark.v then
							if dist <= 80 then
								if fast_mark.v then
									marker1 = addBlipForChar(charTarg)
									changeBlipColour(marker1, 0)
									blip_mark = true
								end
								marker_add = true
								nick_marker = nick_target
								id_marker = playerid
								name_marker, surname_marker = string.match(nick_target, "(%S+)_(%S+)")
							end
						elseif dist <= 5 then
							if fast_mark.v then
								marker1 = addBlipForChar(charTarg)
								changeBlipColour(marker1, 0)
								blip_mark = true
							end
							marker_add = true
							nick_marker = nick_target
							id_marker = playerid
							name_marker, surname_marker = string.match(nick_target, "(%S+)_(%S+)")
						end
					end

					if nick_target ~= nick_marker and marker_add == true then
						removeBlip(marker1)

						nick_marker = nil
						marker_add = false
						nick_target = sampGetPlayerNickname(playerid)
						slot2, charTarg = sampGetCharHandleBySampPlayerId(playerid)
						targX, targY, targZ = getCharCoordinates(charTarg)

						if getDistanceBetweenCoords3d(targX, targY, targZ, coordX, coordY, coordZ) <= 5 then
							if fast_mark.v then
								marker1 = addBlipForChar(charTarg)

								changeBlipColour(marker1, 0)

								blip_mark = true
							end

							marker_add = true

							nick_marker = nick_target
							id_marker = playerid
							name_marker, surname_marker = string.match(nick_target, "(%S+)_(%S+)")
						end
					end
				end
			end

			for i = 0, 1000 do
				if sampIsPlayerConnected(i) then
					local res, char = sampGetCharHandleBySampPlayerId(i)

					if doesCharExist(char) then
						local x, y, z = getCharCoordinates(char)
						local dist = getDistanceBetweenCoords3d(x, y, z, coordX, coordY, coordZ)
						slot12 = sampGetPlayerColor(i)
						nick_actor = sampGetPlayerNickname(i)

						if nick_target == nick_actor then
							if dist > 7 and blip_mark == true then
								blip_mark = false

								removeBlip(marker1)
								print(string.format("������ ������ %s (%s)", nick_actor, dist))
							end

							if dist > 20 then
								removeBlip(marker1)
								print(string.format("������ ����� %s (%s)", nick_actor, dist))

								nick_marker = nil
								marker_add = false
								name_marker = nil
								surname_marker = nil
								nick_target = nil
								id_marker = nil
							end
						end
					end
				end
			end
		end
	end
end

function imgui.ButtonClickable(clickable, ...)
    if clickable then
        return imgui.Button(...)

    else
        local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
        imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
            imgui.Button(...)
        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()
    end
end

local change_hotkey = 1

local big_imgui_text_enb = [[
������ ������� ���������� ����������� ��� ����� ���������� ������ ���������� � �������������� ENB.
����������� ������������� ����������� ��� ������ ���� � ����������� ���� ������� ���� �� ���� ���������� (����� ��������� ���, ���� ������� ����).

�������� �������:
> �� �������� ������� ����
> ������ ������� �� �������� ���� �������� (������ �������)
> ������ ����������������� � ����������� ���� (����������)

����������, �� ����������� ��� ������� ��� ����������.]]

local selected_fast_menu = nil
local selected_fast_menu_categ = 0

function preobr_message(text)
	if id_player ~= nil then
		text = string.gsub(string.gsub(string.gsub(text, "{name}", nick_player1), "{surname}", nick_player2), "{id}", id_player)
	end
	
	if rang1.v ~= nil then
		text = string.gsub(text, "{rang}", rang1.v)
	end

	if phone.v ~= nil then
		text = string.gsub(text, "{phone}", phone.v)
	end

	if frak.v ~= nil then
		text = string.gsub(text, "{frak}", frak.v)
	end

	if cityname ~= nil then
		text = text:gsub("{city}", u8(cityname))
	end

	if gun_name ~= nil then
		text = string.gsub(text, "{weapon}", u8(gun_name))
	end

	if zone ~= nil then
		text = string.gsub(text, "{zone}", u8(zone))
	end

	if tegr.v ~= nil then
		text = string.gsub(text, "{tag_r}", tegr.v)
	end

	if tegf.v ~= nil then
		text = string.gsub(text, "{tag_f}", tegf.v)
	end

	if post ~= nil then
		text = string.gsub(text, "{post}", u8(post))
	end

	if kvadrat() ~= nil then
		text = string.gsub(text, "{kvadrat}", kvadrat())
	end
	text = id_marker ~= nil and text:gsub("{id_marker}", id_marker) or text:gsub("{id_marker}", '')
	text = name_marker ~= nil and text:gsub("{name_marker}", name_marker) or text:gsub("{name_marker}", '')
	text = surname_marker ~= nil and text:gsub("{surname_marker}", surname_marker) or text:gsub("{surname_marker}", '')
	return text:gsub("{meg_c_model}", name_car_megafon)
	:gsub("{time1}", os.date("%d %m %Y, %X"))
	:gsub("{time2}", os.date("%X"))
	:gsub("{greeting}", u8(greeting()))
	:gsub("{F6}", "")
	:gsub("{message}", "")
	:gsub("{wait_(%S+)}", u8"[�������� %1 ��.]")
	:gsub("{F8}", "")
	:gsub("{}", " ")
	:gsub("{color_car}", u8(color_car_megafon))
	:gsub("{cardinalp}", storona ~= nil and u8(cardinal_points[storona][2]) or '')
	:gsub("{meg_c_id}", id_vodil_megafon)
	:gsub("{dd}", os.date("%d"))
	:gsub("{mm}", os.date("%m"))
	:gsub("{YY}", os.date("%Y"))
	:gsub("{yy}", os.date("%y"))
	:gsub("{H}", os.date("%H"))
	:gsub("{M}", os.date("%M"))
	:gsub("{S}", os.date("%S"))
	:gsub("{day}", u8(dayname()))
	:gsub("{month}", u8(mesname()))
end

local selected_stand_comand = 1
local selected_dop_comand = 0
local selected_binder = 0

local cuff_dop = [[
/do ��������� �� �����.
/me ���� ��������� � �����
/me ����� ����������� ���� �� �����
/me ����� ��������� �� ���� ����������� � ��������� ��
/cuff {param1}]]

local ticket_dop = [[
/me ������ ����� � �����
/do ����� � ����� � �����.
/me �������� ��������� �����
/do ����� ��������
/me ������� ����� ����������
/ticket {param1} {param2} {param3}]]

function imgui.DecorButton(...)
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.Button])
	imgui.PushStyleColor(imgui.Col.ButtonActive,  imgui.GetStyle().Colors[imgui.Col.Button])
	imgui.Button(...)
	imgui.PopStyleColor(2)
end	

function panel_settings()
	imgui.BeginChild("left pane", im2(185, 437), true)
		if imgui.Selectable(u8("�������� ���������"), selected == 1 and true or false) then
			selected = 1
		end
		if imgui.Selectable(u8("��������� ������"), selected == 2 and true or false) then
			selected = 2
		end
		if imgui.Selectable(u8("����������� �������"), selected == 4 and true or false) then
			selected = 4
		end
		if imgui.Selectable(u8("�������������� �������"), selected == 5 and true or false) then
			selected = 5
		end
		if imgui.Selectable(u8("��������� �������"), selected == 7 and true or false) then
			selected = 7
		end
		if imgui.Selectable(u8("��������� ���������"), selected == 8 and true or false) then
			selected = 8
		end
		if dop_channel.v then
			if imgui.Selectable(u8("��������� �����"), selected == 9 and true or false) then
				selected = 9
			end
		end
		if imgui.Selectable(u8("��������� �������������"), selected == 10 and true or false) then
			selected = 10
		end

		if imgui.Selectable(u8("��������� ���������"), selected == 11 and true or false) then
			selected = 11
		end

		if imgui.Selectable(u8("��������� ��������"), selected == 12 and true or false) then
			selected = 12
		end

		imgui.NewLine()
		imgui.NewLine()
	imgui.EndChild()
	imgui.SameLine()
	local x = imgui.GetWindowSize().x-imgui.GetCursorPos().x-5
	imgui.BeginChild('##menu_second', im2(x, 437), true)
	if selected == 1 then      -- �������� ���������
		baseSettings()
	elseif selected == 2 then  -- ��������� ������
		local wrap_width = imgui.GetWindowSize().x - 10

		imgui.PushTextWrapPos(imgui.GetCursorPos().x + wrap_width)
		imgui.Text(u8(string.format("������! �� ���������� � ������� �������� ����������� ������. ������ ������� �� ����� ������ ����� �������� ����� ����������. ��� ����������� �������� ������� �������������� � MoJ Helper. ������ ������ ������� ���� � ��, ��� �� ������ ������� � ���� ��������.")), wrap_width)
		imgui.Separator()
		imgui.BeginChild("setting_a1", imgui.ImVec2(-1, 35), true)
		if selected_key ~= 0 then
			for i, v in ipairs(keys_lis2) do
				if selected_key == i then
					if keys_menu[i].v[1] == 0 then
						asd = '���'
					else
						asd = table.concat(getKeysName(keys_menu[i].v), ' + ')
					end
					if change_hotkey == 1 then
						imgui.TextColoredRGB('{FF3B3B}������� �������: {ffffff} '..v[1]..'  [ ���������: {ff3f3f}'..asd..'{ffffff} ]')
					else
						imgui.TextColoredRGB('{FF3B3B}������� �������: {ffffff} '..v[1])
					end
				end
			end
			imgui.SameLine()
			if change_hotkey == 1 then
				local x = imgui.GetWindowSize().x-(2*75)-10
				imgui.SetCursorPosX(x)
				imgui.SetCursorPosY(imgui.GetCursorPos().y-1.5)
			else
				local x = imgui.GetWindowSize().x-(2*75)-(5*5)-190
				imgui.SetCursorPosX(x)
				imgui.SetCursorPosY(imgui.GetCursorPos().y-1.5)
				if imgui.HotKey(u8"##key"..selected_key, keys_menu[selected_key], nil, 100) then
					saveKeys()
				end
				imgui.SameLine()
				if imgui.Button(u8'�����', im2(95, 22)) then
					change_hotkey = 1
				end	
				imgui.SameLine()
			end
			if imgui.ButtonClickable(change_hotkey == 1, u8'��������', im2(75, 22)) then
				change_hotkey = 2
			end	
			imgui.SameLine()
			if imgui.ButtonClickable(change_hotkey == 1, u8'��������', im2(75, 22)) then
				keys_menu[selected_key].v = {0}
				saveKeys()
			end
		else
			imgui.TextColoredRGB('{FF3B3B}������� �������: {ffffff} ���')
		end
		imgui.EndChild()
		imgui.Separator()
		imgui.BeginGroup("##bottom_selectable")
		imgui.BeginChild('##list_key1', im2(225, -1))
		for i, v in ipairs(keys_lis2) do
			if v[3] == 1 then
				if imgui.Selectable(u8(v[1]), selected_key == i and true or false) then
					selected_key = selected_key == i and 0 or i
					change_hotkey = 1
				end
				hint(u8(v[2]))
				imgui.SameLine(156)
				if keys_menu[i].v[1] == 0 then
					imgui.Text(u8'���')
				else
					local keys = getKeysName(keys_menu[i].v)
					for i,v in ipairs(keys) do
						keys[i] = v:gsub('Numpad ', 'Num')
					end
					imgui.Text(table.concat(keys, ' + '))
				end
			end
		end
		imgui.EndChild()
		imgui.SameLine()
		verLine("one")
		imgui.BeginChild('##list_key2', im2(225, -1))
		for i, v in ipairs(keys_lis2) do
			if v[3] == 2 then
				if imgui.Selectable(u8(v[1]), selected_key == i and true or false) then
					selected_key = selected_key == i and 0 or i
					change_hotkey = 1
				end
				hint(u8(v[2]))
				imgui.SameLine(156)
				if keys_menu[i].v[1] == 0 then
					imgui.Text(u8'���')
				else
					local keys = getKeysName(keys_menu[i].v)
					for i,v in ipairs(keys) do
						keys[i] = v:gsub('Numpad', 'Num')
					end
					imgui.Text(table.concat(keys, ' + '))
				end
			end
		end
		imgui.EndChild()
		imgui.SameLine()
		verLine("second")
		imgui.BeginChild('##list_key3', im2(225, -1))
		for i, v in ipairs(keys_lis2) do
			if v[3] == 3 then
				if imgui.Selectable(u8(v[1]), selected_key == i and true or false) then
					selected_key = selected_key == i and 0 or i
					change_hotkey = 1
				end
				hint(u8(v[2]))
				imgui.SameLine(156)
				if keys_menu[i].v[1] == 0 then
					imgui.Text(u8'���')
				else
					local keys = getKeysName(keys_menu[i].v)
					for i,v in ipairs(keys) do
						keys[i] = v:gsub('Numpad', 'Num')
					end
					imgui.Text(table.concat(keys, ' + '))
				end
			end
		end
		imgui.EndChild()
		imgui.EndGroup()
		
	elseif selected == 4 then  -- ����������� �������
		imgui.BeginGroup()
		imgui.BeginChild("setting_c5", imgui.ImVec2(0, 60), true)
		imgui.SameLine()
		local wrap_width = imgui.GetWindowSize().x - 10

		imgui.PushTextWrapPos(imgui.GetCursorPos().x + wrap_width)

		if rp_say.v then
			imgui.Text(u8(string.format("������ � ���� ��������� ��� ����������� ������� � RP-���������. ��� ������ ����� ������ ����.")), wrap_width)
		else
			imgui.Text(u8(string.format("������! �� ���������� � ������� �������� ����������� ������. ������ ����������� ������� ����� ���� RP-���������. ��������� �� ��� �������� � ���� ����� ��������� RP-���������. �� ������ ��������� ��� ����������� ������� ���� � ��������� ���� � ������� ��������������� ��������")), wrap_width)
		end

		imgui.EndChild()

		imgui.Separator()
		imgui.BeginChild("setting_napar2", imgui.ImVec2(imgui.GetWindowSize().x / 2, 40), false)
		imgui.BeginChild("butt2", imgui.ImVec2(0, 0), false)
		imgui.Text(u8("�������� RP - ���������:"))
		imgui.BeginChild("input7", imgui.ImVec2(490, 20), false)

		if imgui.SliderFloat(u8(""), slider_int_wait, 0.5, 5) then
			loaded.main.wait_cmd = slider_int_wait.v * 1000
			save()
		end

		imgui.EndChild()

		imgui.EndChild()
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild("setting_c3", imgui.ImVec2(0, 50), false)
		imgui.NewLine()
		imgui.SetCursorPos(im2(imgui.GetCursorPosX() + 80, imgui.GetCursorPosY()-5))

		if imgui.Button(rp_say.v and u8'�������� ��� ����������� �������' or u8'��������� ��� ����������� �������', im2(-1, 25)) then
			rp_say.v = not rp_say.v
			loaded.main.rp_say = rp_say.v
			save()
		end

		imgui.EndChild()
		imgui.Separator()
		if not rp_say.v then
			imgui.BeginChild("setting_c2", imgui.ImVec2(0, 0), false)

			imgui.Columns(3)
			imgui.SetColumnWidth(-1, 130)
			imgui.Text(u8("�������"))
			imgui.NextColumn()
			imgui.SetColumnWidth(-1, 535)
			imgui.Text(u8("��������"))
			imgui.NextColumn()
			imgui.SetColumnWidth(-1, 50)
			imgui.Text(u8(""))
			imgui.NextColumn()
			imgui.Separator()
			for i, v in ipairs(scs_loaded) do
			    if imgui.Button(v[1], imgui.ImVec2(120, 0)) then
					setClipboardText(v[1])
				end
				hint(u8("�������, ����� ����������� ������� � ����� ������. ����� ������� ����� �������� � ��� (F6) ����������� ������ Ctrl + V."))
				imgui.NextColumn()
				imgui.Text(u8(v[2]))
				imgui.NextColumn()
				if ToggleButton('##tb'..i, imgui.ImBool(v[3])) then
					v[3] = not v[3]
					scs_loaded[i] = v
					saveScs()
				end
				imgui.NextColumn()
				imgui.Separator()
			end
			imgui.EndChild()
		end
		imgui.EndGroup()
	elseif selected == 5 then  -- �������������� �������
		imgui.BeginChild("setting_c", imgui.ImVec2(200, 0), true)
		for i, v in ipairs(dop_loaded) do
			local sel_act = false
			if v.comand_name == "" then
				if imgui.Selectable(i..'. ', selected_dop_comand == i and true or false) then
					sel_act = true
				end
				imgui.SameLine()
				imgui.TextColoredRGB('{3BFF3B}��������� ����')
			else
				if imgui.Selectable(i..'. '..v.comand_name, selected_dop_comand == i and true or false) then
					sel_act = true
				end
			end
			if sel_act then
				sel_act = false
				selected_dop_comand = i
				comand_name.v = u8(v.comand_name)
				comand_wait.v = v.comand_wait
				comand_text.v = u8(v.comand_text):gsub('&', '\n')
				comand_param1_act.v = v.p1act
				comand_param2_act.v = v.p2act
				comand_param3_act.v = v.p3act
			end
		end
		imgui.SetCursorPosY(imgui.GetCursorPosY()+3)
		imgui.EndChild()
		if selected_dop_comand ~= 0 then
			imgui.SameLine()
			imgui.BeginChild("body_c", imgui.ImVec2(-1, -1), true)
			imgui.Text(u8'�������� �������')
			imgui.Text('/')
			imgui.SameLine()
			imgui.PushItemWidth(150)
			if imgui.InputText('##comand_name', comand_name) then
				dop_loaded[selected_dop_comand].comand_name = u8:decode(comand_name.v)
				saveDop()
			end
			imgui.PopItemWidth()
			if comand_param1_act.v then 
				imgui.SameLine()
				imgui.Text(' {param1} ')
			end
			if comand_param2_act.v then 
				imgui.SameLine()
				imgui.Text(' {param2} ')
			end
			if comand_param3_act.v then 
				imgui.SameLine()
				imgui.Text(' {param3}')
			end
			if comand_name.v ~= '' then
				imgui.SameLine()
				if imgui.Button('X') then
					comand_name.v = ''
					dop_loaded[selected_dop_comand].comand_name = comand_name.v
					saveDop()
				end
			end
			if comand_param1_act.v then
				if imgui.ButtonClickable(not comand_param2_act.v, u8'������� �������� [1]') then
					comand_param1_act.v = false
					dop_loaded[selected_dop_comand].p1act = comand_param1_act.v
					saveDop()
				end	
				if comand_param2_act.v then hint(u8'������� 2-�� ��������, ���-�� �������������� �������� �������') end
				imgui.SameLine()
				if comand_param2_act.v then
					if imgui.ButtonClickable(not comand_param3_act.v, u8'������� �������� [2]') then
						comand_param2_act.v = false
						dop_loaded[selected_dop_comand].p2act = comand_param2_act.v
						saveDop()
					end	
					if comand_param3_act.v then hint(u8'������� 3-�� ��������, ���-�� �������������� �������� �������') end
					imgui.SameLine()
					if imgui.Button(comand_param3_act.v and u8'������� �������� [3]' or u8'������� �������� [3]') then
						comand_param3_act.v = not comand_param3_act.v
						dop_loaded[selected_dop_comand].p3act = comand_param3_act.v
						saveDop()
					end	
				else
					if imgui.Button(u8'������� �������� [2]') then
						comand_param2_act.v = true
						dop_loaded[selected_dop_comand].p2act = comand_param2_act.v
						saveDop()
					end
				end
			else
				if imgui.Button(u8'������� �������� [1]') then
					comand_param1_act.v = true
					dop_loaded[selected_dop_comand].p1act = comand_param1_act.v
					saveDop()
				end
			end
			imgui.Text(u8("�������� � �������� (�� 0.1 �� 15 ���):"))
			imgui.PushItemWidth(100)
			local no_wait = false
			if imgui.InputText('##comand_wait', comand_wait) then
				local num = tonumber(comand_wait.v)
				if num ~= nil then
					if num >= 0 and num <= 15 then
						dop_loaded[selected_dop_comand].comand_wait = tostring(num)
						saveDop()
					end
				end
			end
			imgui.SameLine()
			imgui.Text(u8'������')
			imgui.PopItemWidth()

			if comand_wait.v == "" then
				no_wait = true
			else
				local num = tonumber(comand_wait.v)
				if num ~= nil then
					if num <= 0 or num > 15 then
						no_wait = true
					end
				else
					no_wait = true
				end
			end
			if no_wait then
				imgui.TextColoredRGB("{FF3B3B}[!] {FFFFFF}������� ��������� ���� � ���������.")
			end
			imgui.Text(u8("����� �����:"))

			if imgui.InputTextMultiline("##source", comand_text, imgui.ImVec2(-1, imgui.GetTextLineHeight() * 8)) then
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v):gsub('\n', '&')
				saveDop()
			end

			-- ---------------------------------------

			if imgui.Button(u8("������ �����")) then
				show_taglist.v = not show_taglist.v
			end

			if comand_param1_act.v then
				imgui.SameLine()

				if imgui.Button(u8("���� ����������")) then
					show_taglist_param.v = not show_taglist_param.v
				end
			end

			if imgui.Button(u8("������ #1")) then
				comand_text.v = u8(tostring("{greeting}, ��� ��������� {rang} {frak} {name} {surname}.\n������ �������, ������������ ��������, �������������� ���� ��������. "))
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v)
				saveDop()
			end

			imgui.SameLine()

			if imgui.Button(u8("������ #2")) then
				comand_text.v = u8(tostring("/do �� ������� ����� �Rolex�: {time2}, {day}.\n/c 60"))
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v)
				saveDop()
			end

			imgui.SameLine()

			if imgui.Button(u8("������ /cuff")) then
				comand_text.v = u8(tostring(cuff_dop))
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v)
				saveDop()
			end

			imgui.SameLine()

			if imgui.Button(u8("������ /ticket")) then
				comand_text.v = u8(tostring(ticket_dop))
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v)
				saveDop()
			end

			imgui.SameLine()

			if imgui.Button(u8("������ /������")) then
				comand_text.v = u8(tostring("/r ��� ���� {id}. ���� ������� � �. {zone}. {param1}, ����� �����."))
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v)
				saveDop()
			end

			imgui.Text("")
			imgui.Separator()
			imgui.SameLine(180)
			imgui.SetCursorPosY(imgui.GetCursorPosY()+2)
			imgui.CenterText(u8("��������� (� ����������� �����):"))
			imgui.Text(string.gsub(preobr_message(comand_text.v), "&", "\n"))
			imgui.EndChild()
		end
	elseif selected == 7 then  -- ��������� �������
		imgui.BeginGroup()
		imgui.BeginChild("item view", imgui.ImVec2(0, 0), true)

		if imgui.Checkbox(u8("���������� ������"), hud1) then
			loaded.main.hud_city = hud1.v
			save()
		end

		imgui.SameLine()

		if imgui.Button(u8("�������� ��������������"), imgui.ImVec2(214, 20)) then
			set_coord_huud = true
		end

		imgui.SameLine()

		if imgui.Button(u8("�������� ����������"), imgui.ImVec2(214, 20)) then
			show_color1_tag.v = not show_color1_tag.v
		end

		imgui.Separator()
		imgui.BeginChild("menu1", imgui.ImVec2(350, 0), false)
		imgui.DecorButton(fa.MAP..u8' ���������', im2((imgui.GetWindowSize().x)*0.85, 25))

		if imgui.Checkbox(u8("���������� �������� ������"), hud_city) then
			loaded.main.hud_city = hud_city.v
			save()
		end

		if imgui.Checkbox(u8("���������� �����"), hud_zone) then
			loaded.main.hud_zone = hud_zone.v
			save()
		end

		if imgui.Checkbox(u8("���������� ������� �������"), hud_kvadrat) then
			loaded.main.hud_kvadrat = hud_kvadrat.v
			save()
		end

		if imgui.Checkbox(u8("���������� �������� ����"), hud_post) then
			loaded.main.hud_post = hud_post.v
			save()
		end

		if imgui.Checkbox(u8("���������� ����� �����"), hud_channel) then
			loaded.main.hud_channel = hud_channel.v
			save()
		end

		if imgui.Checkbox(u8("���������� ����������� ������"), hud_cardinalpoints) then
			loaded.main.hud_cardinalpoints = hud_cardinalpoints.v
			save()
		end

		imgui.NewLine()
		imgui.DecorButton(fa.BORDER_OUTER..u8' ������� �����', im2((imgui.GetWindowSize().x)*0.85, 25))

		if imgui.Checkbox(u8("���������� ��������� ��������"), hud_hp) then
			loaded.main.hud_hp = hud_hp.v
			save()
		end

		if imgui.Checkbox(u8("���������� ��������� �����"), hud_armour) then
			loaded.main.hud_armour = hud_armour.v
			save()
		end

		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild("menu2", imgui.ImVec2(0, 0), false)
		imgui.DecorButton(fa.BARS..u8' ������', im2((imgui.GetWindowSize().x)*0.85, 25))
		if imgui.Checkbox(u8("���������� ������� ����"), hud_ping) then
			loaded.main.hud_ping = hud_ping.v
			save()
		end

		if imgui.Checkbox(u8("���������� ������� �����"), hud_time) then
			loaded.main.hud_time = hud_time.v
			save()
		end

		if imgui.Checkbox(u8("���������� ������� ����"), hud_radio_title) then
			loaded.main.hud_radio_title = hud_radio_title.v
			save()
		end

		if imgui.Checkbox(u8("���������� ������������� ����"), hud_icon) then
			loaded.main.hud_icon = hud_icon.v
			save()
		end

		imgui.EndChild()
		imgui.EndChild()
		imgui.EndGroup()
	elseif selected == 8 then  -- ��������� ���������
		imgui.BeginGroup()
		imgui.BeginChild("item view", imgui.ImVec2(0, 0))
		imgui.SameLine(imgui.GetWindowSize().x / 2 - 150)
		imgui.BeginChild("inputs", imgui.ImVec2(300, 130), true)
		imgui.BeginChild("photo", imgui.ImVec2(90, 90), false)

		if sampgui_texture_photo_disp == nil and napar_skin ~= nil then
			sampgui_texture_photo_disp = imgui.CreateTextureFromFile(getGameDirectory() .. "\\moonloader\\MVDHelp\\img\\newnapar\\" .. napar_skin .. ".png")
		end

		if sampgui_texture_photo_disp then
			imgui.Image(sampgui_texture_photo_disp, imgui.ImVec2(80, 80))
		end

		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild("photo2", imgui.ImVec2(0, 0), false)
		napar_list()

		if imgui.Checkbox(u8("�������� �������"), imgui.ImBool(napar_active)) then
			napar_active = not napar_active
			slot0 = uv0.load(nil, "MVDHelp\\setting.ini")
			slot0.main.napar_active = napar_active

			uv0.save(slot0, "MVDHelp\\setting.ini")

			if napar_active then
				dialog_napar = true

				set_event_napar(0)
			else
				dialog_napar = false
			end
		end

		imgui.Text(u8("��������:"))

		if imgui.Combo(u8("##styleedit"), combo_naparid, {
			u8("��������"),
			u8("������"),
			u8("������"),
			u8("����"),
			u8("����"),
			u8("��������"),
			u8("�����"),
			u8("������"),
			u8("������"),
			u8("�����"),
			u8("�������"),
			u8("��������"),
			u8("�������"),
			u8("������"),
			u8("������"),
			u8("�����")
		}) then
			napar_id = combo_naparid.v
			sampgui_texture_photo_disp = nil
			napar_skin = nil
			slot1 = uv0.load(nil, "MVDHelp\\setting.ini")
			slot1.main.napar_id = napar_id

			uv0.save(slot1, "MVDHelp\\setting.ini")
		end

		imgui.Text(u8("����� �������:"))

		if imgui.Combo(u8("##styleedit2"), combo_doklad_style, {
			"",
			u8("� ���-������"),
			u8("�����������")
		}) then
			doklad_style = combo_doklad_style.v
			slot2 = uv0.load(nil, "MVDHelp\\setting.ini")
			slot2.main.doklad_style = doklad_style

			uv0.save(slot2, "MVDHelp\\setting.ini")
		end

		if doklad_style == 0 then
			ShowHelpMarker2(u8("��������� ������� ��������� ���� ����������� ������ ������� �� �����. ������� ��� ��������� �� �������� ����� ������� �� �����. "))
		elseif doklad_style == 1 then
			ShowHelpMarker2(u8(string.format("������ �������:\n�����������: %s. ������� ������� �. %s, ����� %s. ���-4, ����� �����. ", f_name, cityname, zone)))
		elseif doklad_style == 2 then
			ShowHelpMarker2(u8(string.format("������ �������:\n�����������: %s. ������� ������� �. %s, ����� %s.", f_name, cityname, zone)))
		end

		imgui.EndChild()
		imgui.EndChild()
		imgui.BeginChild("inputs2", imgui.ImVec2(0, 0), true)

		wrap_width = imgui.GetWindowSize().x - 11

		imgui.PushTextWrapPos(imgui.GetCursorPos().x + wrap_width)
		imgui.Text(u8(string.format("������, %s!", nick_player1)), wrap_width)
		imgui.Text(u8(string.format("������ ���� �������� ������ ���������, ������� �� ������� ���� � ������� �������� � ������ ����� ���������� �� ������! ")), wrap_width)
		imgui.Text(u8(string.format("�������� ������ ������������� ��������� ��������, ������� ����� ����������� � ����� �� ����� ������ � ������ ������. ")), wrap_width)
		imgui.Text(u8(string.format("��������, �� �������� ����������� ���� �������� ����������, � ���� �� ���� ������� ����� - �������� ������ ������� ������. ")), wrap_width)
		imgui.Text(u8(string.format("��� � ������ ������ ��� ���� ����� ��������� ����� �������!")), wrap_width)
		imgui.EndChild()
		imgui.EndChild()
		imgui.EndGroup()
	elseif selected == 9 then  -- ��������� �����
	elseif selected == 10 then -- ��������� �������������
	elseif selected == 11 then -- ��������� ���������
	elseif selected == 12 then -- ��������� ��������

	end
	imgui.EndChild()
	-- if InputText(u8'��������� ����  /', act_menu) then
    --     sampUnregisterChatCommand(loaded.main.cmd_act)
    --     loaded.main.cmd_act = act_menu.v
    --     save()
    --     sampRegisterChatCommand(loaded.main.cmd_act,function()
    --         main_window.v = not main_window.v
    --     end)
    -- end
end

function baseSettings()
	imgui.BeginGroup('##selected1')
	imgui.Text(u8("���� �������� ���:"))
	
	imgui.PushItemWidth(200)
	if imgui.InputText("##f_name", f_name) then
		loaded.main.f_name = u8:decode(f_name.v)
		save()
	end
	imgui.PopItemWidth()

	hint(u8("�������� ����� ����� ������������ � ����� �������������/������. "))
	imgui.Text(u8("��������� ��� ������:"))

	imgui.PushItemWidth(200)
	if imgui.InputText('##rang1', rang1) then
		loaded.main.rang1 = u8:decode(rang1.v)
		save()
	end
	imgui.PopItemWidth()

	hint(u8("�������� ����� ����� ������������ � ����� �������������/������. "))
	imgui.Text(u8("����� ��������:"))

	imgui.PushItemWidth(200)
	if imgui.InputText('##phone', phone) then
		loaded.main.phone = u8:decode(phone.v)
		save()
	end
	imgui.PopItemWidth()

	imgui.Text(u8("�������� �����������:"))

	imgui.PushItemWidth(200)
	if imgui.InputText('##frak', frak) then
		loaded.main.frak = u8:decode(frak.v)
		save()
	end
	imgui.PopItemWidth()

	hint(u8("�������� ����� ����� ������������ � ����� �������������/������. "))
	if not dop_channel.v then
		imgui.Text(u8("��� � ����� ����������� (/r):"))

		imgui.PushItemWidth(200)
		if imgui.InputText('##tegr', tegr) then
			loaded.main.tegr = u8:decode(tegr.v)
			save()
		end
		imgui.PopItemWidth()

		hint(u8("�������� ����� ����� ������������� �������� ��� ������������� ������� /r\n��� ���������� �� ����� ������������ ������. "))
		imgui.Text(u8("��� � ����� ���� �����-��� (/f):"))
		hint(u8("�������� ����� ����� ������������� �������� ��� ������������� ������� /f\n��� ���������� �� ����� ������������ ������. "))

		imgui.PushItemWidth(200)
		if imgui.InputText('##tegf', tegf) then
			loaded.main.tegf = u8:decode(tegf.v)
			save()
		end
		imgui.PopItemWidth()

		hint(u8("�������� ����� ����� ������������� �������� ��� ������������� ������� /f\n��� ���������� �� ����� ������������ ������. "))
	end

	imgui.Text(u8("���� �����������:"))

	imgui.PushItemWidth(200)
	if imgui.Combo(u8("##org_frak"), frakid, fraks) then
		loaded.main.frakid = frakid.v
		save()
	end
	imgui.PopItemWidth()
	hint(u8("������������ ��� �������� ��������, ��������� � ������ ����������. "))
	imgui.Text(u8("��� ���:"))

	imgui.PushItemWidth(200)
	if imgui.Combo(u8("##female_combo"), female, {
		u8("�������"),
		u8("�������")
	}) then
		loaded.main.female = female.v
		save()
	end
	imgui.PopItemWidth()

	hint(u8("������� ��������� �������� ��� ��� ��������� ����������� ������."))

	imgui.PushItemWidth(200)
	imgui.SetCur(0, 50)
	imgui.Text(u8("����������:"))
	if imgui.Combo("##styleedit", theme, {
		u8"�����",
		u8"������ ������",
		u8"����������",
		u8"Ҹ��� ������",
		u8"�������",
		u8"׸����",
		u8"Ҹ��� �������",
		u8"�������",
		u8"�����",
	}) then
		loaded.main.theme = theme.v
		selectTheme()
		save()
	end
	imgui.PopItemWidth()
	imgui.EndGroup()
	imgui.SameLine()
	imgui.BeginChild("line2", imgui.ImVec2(5, -1), false)
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild("line3", imgui.ImVec2(1, -1), true)
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild("line4", imgui.ImVec2(5, -1), false)
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild("Checkboxs", imgui.ImVec2(0, 0), false)
		imgui.CenterText(u8("�������������� ���������"))
		if imgui.Checkbox(u8("�������������� �������� ��� ������� � �����"), autoskreen) then
			loaded.main.autoskreen = autoskreen.v
			save()
		end

		hint(u8("������������� ������� �������� ��� ������������� ������ /���� /arrest."))

		if imgui.Checkbox(u8("�������������� ������ � ����� ��� ������"), rp_arrest) then
			loaded.main.rp_arrest = rp_arrest.v
			save()
		end

		hint(u8("��������� ����������� ������ ����� ���������� ����������� �������� /arrest."))

		if su_list then
			if imgui.Checkbox(u8("����� ����� ������ �������"), dopsu) then
				loaded.main.dopsu = dopsu.v
				save()
			end

			hint(u8("� ������� ���� ������� �� ����������� ����� ��. ���������� ������ ������ ������� � ������� ���������. MoJ Helper ��� ������ ����������� ��������� � ������ ������ �������."))
		end

		if ticket_list then
			if imgui.Checkbox(u8("����� ����� ������ ������"), dopticket) then
				loaded.main.dopticket = dopticket.v
				save()
			end

			hint(u8("���������� ������� � �������� ����� ������ ������. ������ ��� ������������� ����� ���������������� ������ � ���. ��� ��������� �� ��������� �� �� ����� ������� ��� ��������� � MoJ Helper � ������ � �������������. ������� ������� ��� ������ ������ � ���������� ��������� ������� ���������. ������������� ��������� ����������� � ������ ������, ���� ��� �������. ��������, /ticket ID."))
		end

		if imgui.Checkbox(u8("������������ ���� ������� �� ������"), new_arrest) then
			loaded.main.new_arrest = new_arrest.v
			save()
		end

		hint(u8("��� ������ (/arrest) ������� ���������� ���������� ����, ������� ��������� ��������� ���������� � ���������� ������ �����������. �� ��������� ������� �������."))

		if imgui.Checkbox(u8("����� ��������� �����"), dop_channel) then
			loaded.main.dop_channel = dop_channel.v
			save()
		end

		hint(u8("����� ��������� ����� ���������� ������ ���������� �������� ����� �����. ��������� ������ �������, �� ������ ��������� ������ ���� ��� ������ ����������� ����� ������������, ��� ������ ������ �������������, ��� � ��� ���."))
		imgui.NewLine()
		imgui.NewLine()
		imgui.SameLine(10)
		imgui.BeginChild("line5", imgui.ImVec2(415, 1), true)
		imgui.EndChild()
		imgui.CenterText(u8("��������� ���������"))

		if imgui.Checkbox(u8("��������� ��� ����������� �������"), rp_say) then
			loaded.main.rp_say = rp_say.v
			save()
		end

		hint(u8("������ ��������� ��������� ��������� ��� ��������� ��� ������ ������� (�������� /arrest, /cuff).\n����� ����������, �� ������ ������� ��� ������� ��������������, ����� ��������� �������������� ������. "))

		if imgui.Checkbox(u8("��������� ���������"), off_podskaz) then
			loaded.main.off_podskaz = off_podskaz.v
			save()
		end

		hint(u8("��������� ��� ���������� ��������� ����������.  "))

		if imgui.Checkbox(u8("��������� ���������� ��������"), not_update_codecs) then
			loaded.main.not_update_codecs = not_update_codecs.v
			save()
		end

		hint(u8("��������� ���� ������� ��������� ��������� �������������� ���������� /��, /��, /�����. "))

		if imgui.Checkbox(u8("����� ����������� ��� ENB"), opt_enb) then 
			if opt_enb.v then
				imgui.OpenPopup(u8("����������� � ENB"))
			end
			loaded.main.opt_enb = opt_enb.v
			save()
		end

		hint(u8("���� �� ����������� ENB - ����������� ��� �������, � ��������� ����������� �������� ����� ������������ ����� �������, ��� �� ��������� ����������� ��������� ����. "))

		if imgui.BeginPopupModal(u8("����������� � ENB"), nil, imgui.WindowFlags.AlwaysAutoResize) then
			local wrap_width = 600

			imgui.PushTextWrapPos(imgui.GetCursorPos().x + wrap_width)
			imgui.Text(u8("ENB - ����� ����������� ��� ���, ����������� ����� ��������� �����������, �������� � ���������� ��������� (��������, ��� ������� �����-������ ���� ������). ENB ����������� ��� ���� ���, ���� ����� � ��������� ������� ������� ���� �������� ��� ������������� ������ ����������� �����������, ������ ���� � ������ - ��� ������ ���� ��������� ���� ����� ��������, ������� ����������� �������� ��������� �� �� �����."), wrap_width)
			imgui.Separator()
			imgui.Text(u8(big_imgui_text_enb), wrap_width)
			imgui.Separator()

			if imgui.Button(u8("��, � ��������� ENB"), imgui.ImVec2(-0.1, 0)) then
				opt_enb.v = true
				imgui.CloseCurrentPopup()
			end

			if imgui.Button(u8("���, ��� �� �����"), imgui.ImVec2(-0.1, 0)) then
				opt_enb.v = false
				imgui.CloseCurrentPopup()
			end

			imgui.EndPopup()
		end

		if imgui.Checkbox(u8("����� �������� ����� � RP-���������� (/me)"), rp_point) then
			loaded.main.rp_point = rp_point.v
			save()
		end
		hint(u8("���� �� ����� ������� ������������� �������, ��� ���������� ����� � ����� ����������� ������� /me ��������� ������� Role Play - ����������� ���� ����� � �� ���� ����������� RP-���������� ���������� ����� � ����� ������ ����� �������, � ������� Role Play ����� ����������� �����!"))
	imgui.EndChild()
end

local change_hotkey_binder = 1

function bind_set()
	imgui.BeginChild("setting_c", imgui.ImVec2(200, 0), true)
	for i, v in ipairs(binder_loaded) do
		if imgui.Selectable(i..'. '..v.name, selected_binder == i and true or false) then
			selected_binder = i
			binder_name.v = u8(v.name)
			binder_wait.v = v.wait
			binder_text.v = u8(v.text)
		end
		if v.name == '' then
			imgui.SameLine()
			imgui.TextColoredRGB('{3bff3b}��������� ����')
		end
	end
	imgui.EndChild()
	if selected_binder ~= 0 then
		imgui.SameLine()
		imgui.BeginChild("setting_c2", imgui.ImVec2(0, 0), true)
		imgui.Text(u8'��� �����')
		imgui.PushItemWidth(200)
		if imgui.InputText('##name_bind', binder_name) then
			binder_loaded[selected_binder].name = tostring(binder_name.v)
			saveBinder()
		end
		imgui.PopItemWidth()
		imgui.SameLine()
		imgui.NewLine()
		imgui.Text(u8'���������:')
		if imgui.HotKey(u8"##key"..selected_binder, binder_loaded[selected_binder].act, nil, 100) then
			saveBinder()
		end
		imgui.SameLine()
		if imgui.Button(u8'��������', im2(75, 20)) then
			binder_loaded[selected_binder].act.v = {0}
			saveBinder()
		end

		imgui.Text(u8("�������� � �������� (�� 0.1 �� 15)"))

		imgui.PushItemWidth(300)
		if imgui.InputText('##wait_bind', binder_wait) then
			local num = tonumber(binder_wait.v)
			if num ~= nil then
				if num >= 0 and num <= 15 then
					binder_loaded[selected_binder].wait = binder_wait.v
					saveBinder()
				end
			end
		end
		imgui.PopItemWidth()

		if binder_wait.v ~= "" then
			local num = tonumber(binder_wait.v)
			if num ~= nil then
				if num <= 0 or num > 15 then
					imgui.TextColoredRGB("{FF3B3B}[!] {FFFFFF}������� ��������� ���� � ���������.")
				end
			else
				imgui.TextColoredRGB("{FF3B3B}[!] {FFFFFF}������� ��������� ���� � ���������.")
			end
		end

		imgui.Text(u8("����� �����:"))

		if imgui.InputTextMultiline("##source", binder_text, imgui.ImVec2(-1, imgui.GetTextLineHeight() * 8)) then
			binder_loaded[selected_binder].text = u8:decode(binder_text.v):gsub('\n', '&')
			saveBinder()
		end
		if imgui.Button(u8("������ �����")) then
			show_taglist.v = not show_taglist.v
		end
		if imgui.Button(u8("������ #1")) then
			binder_text.v = u8(tostring("{greeting}, ��� ��������� {rang} {frak} {name} {surname}.\n������ �������, ������������ ��������, �������������� ���� ��������. "))
			binder_loaded[selected_binder].text = u8:decode(binder_text.v)
			saveBinder()
		end

		imgui.SameLine()

		if imgui.Button(u8("������ #2")) then
			binder_text.v = u8(tostring("/do �� ������� ����� �Rolex�: {time2}, {day}.\n/c 60"))
			binder_loaded[selected_binder].text = u8:decode(binder_text.v)
			saveBinder()
		end

		imgui.SameLine()

		if imgui.Button(u8("������ #3")) then
			binder_text.v = u8(tostring("/r �����������: {surname}. ���������� ����� {zone}, {city}.\n{F6}/r ���������: \n{F8}"))
			binder_loaded[selected_binder].text = u8:decode(binder_text.v)
			saveBinder()
		end
		imgui.Separator()
		imgui.CenterText(u8("��������� (� ����������� �����):"))
		if binder_text.v ~= '' then
			imgui.Text(string.gsub(preobr_message(binder_text.v), "&", "\n"))
		end

		imgui.EndChild()
	else
		imgui.SameLine()
		imgui.BeginChild("setting_c2", imgui.ImVec2(0, 0), false)
		imgui.BeginChild("otstup", imgui.ImVec2(0, imgui.GetWindowSize().y / 2 - 78), false)
		imgui.EndChild()
		imgui.NewLine()
		imgui.SameLine(imgui.GetWindowSize().x / 2 - 22.5)
		imgui.PushFont(big_fa)
		imgui.CenterText(fa.LAYER_PLUS)
		imgui.PopFont()
		imgui.CenterText(u8"������� ��������� ����������!")
		imgui.EndChild()
	end
end

ToggleButton = function(str_id, bool)
	local rBool = false

	if LastActiveTime == nil then
		LastActiveTime = {}
	end
	if LastActive == nil then
		LastActive = {}
	end

	local function ImSaturate(f)
		return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
	end
	
	local p = imgui.GetCursorScreenPos()
	local draw_list = imgui.GetWindowDrawList()

	local height = imgui.GetTextLineHeightWithSpacing()
	local width = height * 1.55
	local radius = height * 0.50
	local ANIM_SPEED = 0.15

	if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
		bool.v = not bool.v
		rBool = true
		LastActiveTime[tostring(str_id)] = os.clock()
		LastActive[tostring(str_id)] = true
	end

	local t = bool.v and 1.0 or 0.0

	if LastActive[tostring(str_id)] then
		local time = os.clock() - LastActiveTime[tostring(str_id)]
		if time <= ANIM_SPEED then
			local t_anim = ImSaturate(time / ANIM_SPEED)
			t = bool.v and t_anim or 1.0 - t_anim
		else
			LastActive[tostring(str_id)] = false
		end
	end

	local col_bg
	if bool.v then
		col_bg = imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
	else
		col_bg = imgui.ImColor(100, 100, 100, 180):GetU32()
	end

	draw_list:AddRectFilled(imgui.ImVec2(p.x, p.y + (height / 6)), imgui.ImVec2(p.x + width - 1.0, p.y + (height - (height / 6))), col_bg, 5.0)
	draw_list:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 0.75, imgui.GetColorU32(bool.v and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.ImColor(150, 150, 150, 255):GetVec4()))

	return rBool
end

function getKeysName(keys)
	if type(keys) ~= "table" then
	   print("[RKeys | getKeysName]: Bad argument #1. Value \"", tostring(keys), "\" is not table.")
	   return false
	else
	   local tKeysName = {}
	   for k, v in ipairs(keys) do
		  tKeysName[k] = vasd(v):gsub('Numpad ', 'Num')
	   end
	   return tKeysName
	end
end

function verLine(tag)
	imgui.SameLine()
	imgui.BeginChild("line1##"..tag, imgui.ImVec2(1, -1), false)
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild("line2##"..tag, imgui.ImVec2(1, -1), true)
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild("line3##"..tag, imgui.ImVec2(1, -1), false)
	imgui.EndChild()
	imgui.SameLine()
end

function panel_rpgun()
	if imgui.Checkbox(u8("����� RP ��������� ������"), rpgun) then
		loaded.main.rpgun = rpgun.v
		save()
	end

	hint(u8("�������������� RP-��������� ��� ������������� ������. "))
end
function panel_other()

end
function panel_info()

end

function imgui.TextColoredRGB(text)
	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImVec4 = imgui.ImVec4

	local explode_argb = function(argb)
		local a = bit.band(bit.rshift(argb, 24), 0xFF)
		local r = bit.band(bit.rshift(argb, 16), 0xFF)
		local g = bit.band(bit.rshift(argb, 8), 0xFF)
		local b = bit.band(argb, 0xFF)
		return a, r, g, b
	end

	local getcolor = function(color)
		if color:sub(1, 6):upper() == 'SSSSSS' then
			local r, g, b = colors[1].x, colors[1].y, colors[1].z
			local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
			return ImVec4(r, g, b, a / 255)
		end
		local color = type(color) == 'string' and tonumber(color, 16) or color
		if type(color) ~= 'number' then return end
		local r, g, b, a = explode_argb(color)
		return imgui.ImColor(r, g, b, a):GetVec4()
	end

	local render_text = function(text_)
		for w in text_:gmatch('[^\r\n]+') do
			local text, colors_, m = {}, {}, 1
			w = w:gsub('{(......)}', '{%1FF}')
			while w:find('{........}') do
				local n, k = w:find('{........}')
				local color = getcolor(w:sub(n + 1, k - 1))
				if color then
					text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
					colors_[#colors_ + 1] = color
					m = n
				end
				w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
			end
			if text[0] then
				for i = 0, #text do
					imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
					imgui.SameLine(nil, 0)
				end
				imgui.NewLine()
			else imgui.Text(u8(w)) end
		end
	end

	render_text(text)
end

function imgui.CenterText(text, counter)
    if counter == nil then
        imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - imgui.CalcTextSize(text).x / 2)
    else
        imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - imgui.CalcTextSize(counter).x / 2)
    end
    imgui.Text(text)
end

-- // ----- HOTKEY ----- \\ --
imgui.HotKey = function(name, keys, lastkeys, width)
    local width = width or 90
    local name = tostring(name)
    local lastkeys = lastkeys or {}
    local keys, bool = keys or {}, false
    lastkeys.v = keys.v

    local sKeys = table.concat(imgui.getKeysName(keys.v), " + ")

    if #tHotKeyData.save > 0 and tostring(tHotKeyData.save[1]) == name then
        keys.v = tHotKeyData.save[2]
        sKeys = table.concat(imgui.getKeysName(keys.v), " + ")
        tHotKeyData.save = {}
        bool = true
    elseif tHotKeyData.edit ~= nil and tostring(tHotKeyData.edit) == name then
		if #tKeys == 0 then
			if os.clock() - tHotKeyData.lastTick > 0.5 then
            tHotKeyData.lastTick = os.clock()
            tHotKeyData.tickState = not tHotKeyData.tickState
         end
         sKeys = tHotKeyData.tickState and u8'����' or " "
        else
            sKeys = table.concat(imgui.getKeysName(tKeys), " + ")
        end
    end

    imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.FrameBg])
    if imgui.Button((tostring(sKeys):len() == 0 and u8'����' or sKeys) .. name, imgui.ImVec2(width, 0)) then
        tHotKeyData.edit = name
    end
    imgui.PopStyleColor(1)
    return bool
end

function imgui.getCurrentEdit()
    return tHotKeyData.edit ~= nil
end
function imgui.getKeysList(bool)
   local bool = bool or false
   local tKeysList = {}
   
   if bool then
      for k, v in ipairs(tKeys) do
         tKeysList[k] = vasd(v)
      end
   else
      tKeysList = tKeys
   end
   return tKeysList
end

function imgui.getKeysName(keys)
    if type(keys) ~= "table" then
       return false
    else
       local tKeysName = {}
       for k, v in ipairs(keys) do
          tKeysName[k] = vasd(v)
       end
       return tKeysName
    end
end

function getKeyNumber(id)
   for k, v in ipairs(tKeys) do
      if v == id then
         return k
      end
   end
   return -1
end

function reloadKeysList()
    local tNewKeys = {}
    for k, v in pairs(tKeys) do
       tNewKeys[#tNewKeys + 1] = v
    end
    tKeys = tNewKeys
    return true
end
function imgui.isKeyModified(id)
	if type(id) ~= "number" then
	   return false
	end
	return (tModKeys[id] or false) or (tBlockKeys[id] or false)
end
-- \\ ------------------------ // --

function selectTheme()
	local style = imgui.GetStyle()
	style.WindowPadding = imgui.ImVec2(8, 8)
	style.WindowRounding = 10
	style.ChildWindowRounding = 10
	style.FramePadding = imgui.ImVec2(5, 3)
	style.FrameRounding = 6
	style.ItemSpacing = imgui.ImVec2(5, 4)
	style.ItemInnerSpacing = imgui.ImVec2(4, 4)
	style.IndentSpacing = 21
	style.ScrollbarSize = 10
	style.ScrollbarRounding = 15
	style.GrabMinSize = 15
	style.GrabRounding = 7
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
	if loaded.main.theme == 0 then
		gray_theme()
	elseif loaded.main.theme == 1 then
		green_white()
	elseif loaded.main.theme == 2 then
		violet_theme()
	elseif loaded.main.theme == 3 then
		darkgreentheme()
	elseif loaded.main.theme == 4 then
		glamourPink()
	elseif loaded.main.theme == 5 then
		elegant_black()
	elseif loaded.main.theme == 6 then
		black_red()
	elseif loaded.main.theme == 7 then
		red_theme()
	elseif loaded.main.theme == 8 then
		blue_theme()
	end
end

function green_white()
	imgui.SwitchContext()

	local style = imgui.GetStyle()
	style.Colors[imgui.Col.Text] = imgui.ImVec4(0, 0, 0, 0.65)
	style.Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0, 0, 0, 0.3)
	style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(1, 1, 1, 1)
	style.Colors[imgui.Col.ChildWindowBg] = imgui.ImVec4(0.96, 0.96, 0.96, 1)
	style.Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.92, 0.92, 0.92, 1)
	style.Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.5, 0.5)
	style.Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0, 0, 0, 0)
	style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.88, 0.88, 0.88, 1)
	style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0, 0, 0, 0)
	style.Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.02, 0.5, 0, 1)
	style.Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.02, 0.4, 0, 1)
	style.Colors[imgui.Col.ComboBg] = imgui.ImVec4(0.92, 0.92, 0.92, 1)
	style.Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.02, 0.4, 0, 1)
	style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0, 0.49, 1, 0.59)
	style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0, 0.49, 1, 0.71)
	style.Colors[imgui.Col.Button] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.02, 0.4, 0, 1)
	style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.02, 0.3, 0, 1)
	style.Colors[imgui.Col.Header] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.02, 0.5, 0, 1)
	style.Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.02, 0.4, 0, 1)
	style.Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.02, 0.5, 0, 1)
	style.Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.02, 0.4, 0, 1)
	style.Colors[imgui.Col.CloseButton] = imgui.ImVec4(0.02, 0.4, 0, 1)
	style.Colors[imgui.Col.CloseButtonHovered] = imgui.ImVec4(0.02, 0.3, 0, 1)
	style.Colors[imgui.Col.CloseButtonActive] = imgui.ImVec4(0.02, 0.2, 0, 1)
	style.Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(0.02, 0.5, 0, 1)
	style.Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(0.02, 0.5, 0, 1)
	style.Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.02, 0.49, 0, 1)
	style.Colors[imgui.Col.ModalWindowDarkening] = imgui.ImVec4(0.2, 0.2, 0.2, 0.35)
end
function violet_theme()
	imgui.SwitchContext()

	local style = imgui.GetStyle()
	style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.14, 0.12, 0.16, 1)
	style.Colors[imgui.Col.Text] = imgui.ImVec4(0.95, 0.96, 0.98, 1)
	style.Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.29, 0.29, 0.29, 1)
	style.Colors[imgui.Col.ChildWindowBg] = imgui.ImVec4(0.3, 0.2, 0.39, 0)
	style.Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.05, 0.05, 0.1, 0.9)
	style.Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.5, 0.5)
	style.Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0, 0, 0, 0)
	style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.3, 0.2, 0.39, 1)
	style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.68)
	style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1)
	style.Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.41, 0.19, 0.63, 0.45)
	style.Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.41, 0.19, 0.63, 0.35)
	style.Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.41, 0.19, 0.63, 0.78)
	style.Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.3, 0.2, 0.39, 0.57)
	style.Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.3, 0.2, 0.39, 1)
	style.Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.41, 0.19, 0.63, 0.31)
	style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.78)
	style.Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1)
	style.Colors[imgui.Col.ComboBg] = imgui.ImVec4(0.3, 0.2, 0.39, 1)
	style.Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.56, 0.61, 1, 1)
	style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.41, 0.19, 0.63, 0.24)
	style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1)
	style.Colors[imgui.Col.Button] = imgui.ImVec4(0.41, 0.19, 0.63, 0.44)
	style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.86)
	style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.64, 0.33, 0.94, 1)
	style.Colors[imgui.Col.Header] = imgui.ImVec4(0.41, 0.19, 0.63, 0.76)
	style.Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.86)
	style.Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1)
	style.Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.41, 0.19, 0.63, 0.2)
	style.Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.78)
	style.Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1)
	style.Colors[imgui.Col.CloseButton] = imgui.ImVec4(1, 1, 1, 0.75)
	style.Colors[imgui.Col.CloseButtonHovered] = imgui.ImVec4(0.88, 0.74, 1, 0.59)
	style.Colors[imgui.Col.CloseButtonActive] = imgui.ImVec4(0.88, 0.85, 0.92, 1)
	style.Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.89, 0.85, 0.92, 0.63)
	style.Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 1)
	style.Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.89, 0.85, 0.92, 0.63)
	style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 1)
	style.Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.41, 0.19, 0.63, 0.43)
	style.Colors[imgui.Col.ModalWindowDarkening] = imgui.ImVec4(0.2, 0.2, 0.2, 0.35)
end
function darkgreentheme()
	imgui.SwitchContext()

	local style = imgui.GetStyle()
	style.Colors[imgui.Col.Text] = imgui.ImVec4(0.9, 0.9, 0.9, 1)
	style.Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.6, 0.6, 0.6, 1)
	style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.08, 0.08, 0.08, 1)
	style.Colors[imgui.Col.ChildWindowBg] = imgui.ImVec4(0.1, 0.1, 0.1, 1)
	style.Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.08, 0.08, 0.08, 1)
	style.Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.5, 0.5)
	style.Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0, 0, 0, 0)
	style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.15, 0.15, 0.15, 1)
	style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.19, 0.19, 0.19, 0.71)
	style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.34, 0.34, 0.34, 0.79)
	style.Colors[imgui.Col.TitleBg] = imgui.ImVec4(0, 0.69, 0.33, 0.8)
	style.Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0, 0.74, 0.36, 1)
	style.Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0, 0.69, 0.33, 0.5)
	style.Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0, 0.8, 0.38, 1)
	style.Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.16, 0.16, 0.16, 1)
	style.Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0, 0.69, 0.33, 1)
	style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0, 0.82, 0.39, 1)
	style.Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0, 1, 0.48, 1)
	style.Colors[imgui.Col.ComboBg] = imgui.ImVec4(0.2, 0.2, 0.2, 0.99)
	style.Colors[imgui.Col.CheckMark] = imgui.ImVec4(0, 0.69, 0.33, 1)
	style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0, 0.69, 0.33, 1)
	style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0, 0.77, 0.37, 1)
	style.Colors[imgui.Col.Button] = imgui.ImVec4(0, 0.69, 0.33, 1)
	style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0, 0.82, 0.39, 1)
	style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0, 0.87, 0.42, 1)
	style.Colors[imgui.Col.Header] = imgui.ImVec4(0, 0.69, 0.33, 1)
	style.Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0, 0.76, 0.37, 0.57)
	style.Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0, 0.88, 0.42, 0.89)
	style.Colors[imgui.Col.Separator] = imgui.ImVec4(1, 1, 1, 0.4)
	style.Colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(1, 1, 1, 0.6)
	style.Colors[imgui.Col.SeparatorActive] = imgui.ImVec4(1, 1, 1, 0.8)
	style.Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0, 0.69, 0.33, 1)
	style.Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0, 0.76, 0.37, 1)
	style.Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0, 0.86, 0.41, 1)
	style.Colors[imgui.Col.CloseButton] = imgui.ImVec4(0, 0.82, 0.39, 1)
	style.Colors[imgui.Col.CloseButtonHovered] = imgui.ImVec4(0, 0.88, 0.42, 1)
	style.Colors[imgui.Col.CloseButtonActive] = imgui.ImVec4(0, 1, 0.48, 1)
	style.Colors[imgui.Col.PlotLines] = imgui.ImVec4(0, 0.69, 0.33, 1)
	style.Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(0, 0.74, 0.36, 1)
	style.Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0, 0.69, 0.33, 1)
	style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(0, 0.8, 0.38, 1)
	style.Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0, 0.69, 0.33, 0.72)
	style.Colors[imgui.Col.ModalWindowDarkening] = imgui.ImVec4(0.17, 0.17, 0.17, 0.48)
end
function glamourPink()
	imgui.SwitchContext()

	local style = imgui.GetStyle()
	style.Colors[imgui.Col.Text] = imgui.ImVec4(0, 0, 0, 1)
	style.Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.22, 0.22, 0.22, 1)
	style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(1, 1, 1, 1)
	style.Colors[imgui.Col.ChildWindowBg] = imgui.ImVec4(0.92, 0.92, 0.92, 0)
	style.Colors[imgui.Col.PopupBg] = imgui.ImVec4(1, 1, 1, 0.94)
	style.Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.5, 0.5)
	style.Colors[imgui.Col.BorderShadow] = imgui.ImVec4(1, 1, 1, 0)
	style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.77, 0.49, 0.66, 0.54)
	style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(1, 1, 1, 0.4)
	style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(1, 1, 1, 0.67)
	style.Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.76, 0.51, 0.66, 0.71)
	style.Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.97, 0.74, 0.88, 0.74)
	style.Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(1, 1, 1, 0.67)
	style.Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(1, 1, 1, 0.54)
	style.Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.81, 0.81, 0.81, 0.54)
	style.Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.78, 0.28, 0.58, 0.13)
	style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(1, 1, 1, 1)
	style.Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.51, 0.51, 0.51, 1)
	style.Colors[imgui.Col.ComboBg] = imgui.ImVec4(0.2, 0.2, 0.2, 0.99)
	style.Colors[imgui.Col.CheckMark] = imgui.ImVec4(1, 1, 1, 1)
	style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.71, 0.39, 0.39, 1)
	style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.76, 0.51, 0.66, 0.46)
	style.Colors[imgui.Col.Button] = imgui.ImVec4(0.78, 0.28, 0.58, 0.54)
	style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.77, 0.52, 0.67, 0.54)
	style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.2, 0.2, 0.2, 0.5)
	style.Colors[imgui.Col.Header] = imgui.ImVec4(0.78, 0.28, 0.58, 0.54)
	style.Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.78, 0.28, 0.58, 0.25)
	style.Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.79, 0.04, 0.48, 0.63)
	style.Colors[imgui.Col.Separator] = imgui.ImVec4(0.43, 0.43, 0.5, 0.5)
	style.Colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.79, 0.44, 0.65, 0.64)
	style.Colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.79, 0.17, 0.54, 0.77)
	style.Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.87, 0.36, 0.66, 0.54)
	style.Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.76, 0.51, 0.66, 0.46)
	style.Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.76, 0.51, 0.66, 0.46)
	style.Colors[imgui.Col.CloseButton] = imgui.ImVec4(0.41, 0.41, 0.41, 1)
	style.Colors[imgui.Col.CloseButtonHovered] = imgui.ImVec4(0.76, 0.46, 0.64, 0.71)
	style.Colors[imgui.Col.CloseButtonActive] = imgui.ImVec4(0.78, 0.28, 0.58, 0.79)
	style.Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1)
	style.Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(0.92, 0.92, 0.92, 1)
	style.Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.9, 0.7, 0, 1)
	style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1, 0.6, 0, 1)
	style.Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.26, 0.59, 0.98, 0.35)
	style.Colors[imgui.Col.ModalWindowDarkening] = imgui.ImVec4(0.8, 0.8, 0.8, 0.35)
end
function elegant_black()
	imgui.SwitchContext()

	local style = imgui.GetStyle()
	style.Colors[imgui.Col.Text] = imgui.ImVec4(0.8, 0.8, 0.83, 1)
	style.Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.24, 0.23, 0.29, 1)
	style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.06, 0.05, 0.07, 1)
	style.Colors[imgui.Col.ChildWindowBg] = imgui.ImVec4(0.07, 0.07, 0.09, 1)
	style.Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.07, 0.07, 0.09, 1)
	style.Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.5, 0.5)
	style.Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.92, 0.91, 0.88, 0)
	style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.1, 0.09, 0.12, 1)
	style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.24, 0.23, 0.29, 1)
	style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.56, 0.56, 0.58, 1)
	style.Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.1, 0.09, 0.12, 1)
	style.Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(1, 0.98, 0.95, 0.75)
	style.Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.07, 0.07, 0.09, 1)
	style.Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.1, 0.09, 0.12, 1)
	style.Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.1, 0.09, 0.12, 1)
	style.Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.8, 0.8, 0.83, 0.31)
	style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.56, 0.56, 0.58, 1)
	style.Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.06, 0.05, 0.07, 1)
	style.Colors[imgui.Col.ComboBg] = imgui.ImVec4(0.19, 0.18, 0.21, 1)
	style.Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.8, 0.8, 0.83, 0.31)
	style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.8, 0.8, 0.83, 0.31)
	style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.06, 0.05, 0.07, 1)
	style.Colors[imgui.Col.Button] = imgui.ImVec4(0.1, 0.09, 0.12, 1)
	style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.24, 0.23, 0.29, 1)
	style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.56, 0.56, 0.58, 1)
	style.Colors[imgui.Col.Header] = imgui.ImVec4(0.1, 0.09, 0.12, 1)
	style.Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.56, 0.56, 0.58, 1)
	style.Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.06, 0.05, 0.07, 1)
	style.Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0, 0, 0, 0)
	style.Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.56, 0.56, 0.58, 1)
	style.Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.06, 0.05, 0.07, 1)
	style.Colors[imgui.Col.CloseButton] = imgui.ImVec4(0.4, 0.39, 0.38, 0.16)
	style.Colors[imgui.Col.CloseButtonHovered] = imgui.ImVec4(0.4, 0.39, 0.38, 0.39)
	style.Colors[imgui.Col.CloseButtonActive] = imgui.ImVec4(0.4, 0.39, 0.38, 1)
	style.Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.4, 0.39, 0.38, 0.63)
	style.Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(0.25, 1, 0, 1)
	style.Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.4, 0.39, 0.38, 0.63)
	style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(0.25, 1, 0, 1)
	style.Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.25, 1, 0, 0.43)
	style.Colors[imgui.Col.ModalWindowDarkening] = imgui.ImVec4(1, 0.98, 0.95, 0.73)
end
function black_red()
	imgui.SwitchContext()

	local style = imgui.GetStyle()
	style.Colors[imgui.Col.Text] = imgui.ImVec4(0.95, 0.96, 0.98, 1)
	style.Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.29, 0.29, 0.29, 1)
	style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.14, 0.14, 0.14, 1)
	style.Colors[imgui.Col.ChildWindowBg] = imgui.ImVec4(0.12, 0.12, 0.12, 1)
	style.Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.08, 0.08, 0.08, 0.94)
	style.Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.5, 0.5)
	style.Colors[imgui.Col.BorderShadow] = imgui.ImVec4(1, 1, 1, 0.1)
	style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.22, 0.22, 0.22, 1)
	style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.18, 0.18, 0.18, 1)
	style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.09, 0.12, 0.14, 1)
	style.Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.14, 0.14, 0.14, 0.7)
	style.Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.14, 0.14, 0.14, 0.7)
	style.Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0, 0, 0, 0.7)
	style.Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.2, 0.2, 0.2, 1)
	style.Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.02, 0.02, 0.02, 0.39)
	style.Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.36, 0.36, 0.36, 1)
	style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.18, 0.22, 0.25, 1)
	style.Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.24, 0.24, 0.24, 1)
	style.Colors[imgui.Col.ComboBg] = imgui.ImVec4(0.24, 0.24, 0.24, 1)
	style.Colors[imgui.Col.CheckMark] = imgui.ImVec4(1, 0.28, 0.28, 1)
	style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(1, 0.28, 0.28, 1)
	style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(1, 0.28, 0.28, 1)
	style.Colors[imgui.Col.Button] = imgui.ImVec4(1, 0.28, 0.28, 1)
	style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(1, 0.39, 0.39, 1)
	style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(1, 0.21, 0.21, 1)
	style.Colors[imgui.Col.Header] = imgui.ImVec4(1, 0.28, 0.28, 1)
	style.Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(1, 0.39, 0.39, 1)
	style.Colors[imgui.Col.HeaderActive] = imgui.ImVec4(1, 0.21, 0.21, 1)
	style.Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(1, 0.28, 0.28, 1)
	style.Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(1, 0.39, 0.39, 1)
	style.Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(1, 0.19, 0.19, 1)
	style.Colors[imgui.Col.CloseButton] = imgui.ImVec4(0.4, 0.39, 0.38, 0.16)
	style.Colors[imgui.Col.CloseButtonHovered] = imgui.ImVec4(0.4, 0.39, 0.38, 0.39)
	style.Colors[imgui.Col.CloseButtonActive] = imgui.ImVec4(0.4, 0.39, 0.38, 1)
	style.Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1)
	style.Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(1, 0.43, 0.35, 1)
	style.Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(1, 0.21, 0.21, 1)
	style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1, 0.18, 0.18, 1)
	style.Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(1, 0.32, 0.32, 1)
	style.Colors[imgui.Col.ModalWindowDarkening] = imgui.ImVec4(0.26, 0.26, 0.26, 0.6)
end
function red_theme()
	imgui.SwitchContext()

	local style = imgui.GetStyle()
	style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.48, 0.16, 0.16, 0.54)
	style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.98, 0.26, 0.26, 0.4)
	style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.98, 0.26, 0.26, 0.67)
	style.Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.04, 0.04, 0.04, 1)
	style.Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.48, 0.16, 0.16, 1)
	style.Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0, 0, 0, 0.51)
	style.Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.98, 0.26, 0.26, 1)
	style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.88, 0.26, 0.24, 1)
	style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.98, 0.26, 0.26, 1)
	style.Colors[imgui.Col.Button] = imgui.ImVec4(0.98, 0.26, 0.26, 0.4)
	style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.98, 0.26, 0.26, 1)
	style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.98, 0.06, 0.06, 1)
	style.Colors[imgui.Col.Header] = imgui.ImVec4(0.98, 0.26, 0.26, 0.31)
	style.Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.98, 0.26, 0.26, 0.8)
	style.Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.98, 0.26, 0.26, 1)
	style.Colors[imgui.Col.Separator] = style.Colors[imgui.Col.Border]
	style.Colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.75, 0.1, 0.1, 0.78)
	style.Colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.75, 0.1, 0.1, 1)
	style.Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.98, 0.26, 0.26, 0.25)
	style.Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.98, 0.26, 0.26, 0.67)
	style.Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.98, 0.26, 0.26, 0.95)
	style.Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.98, 0.26, 0.26, 0.35)
	style.Colors[imgui.Col.Text] = imgui.ImVec4(1, 1, 1, 1)
	style.Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.5, 0.5, 0.5, 1)
	style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.06, 0.06, 0.06, 1)
	style.Colors[imgui.Col.ChildWindowBg] = imgui.ImVec4(1, 1, 1, 0)
	style.Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.08, 0.08, 0.08, 0.94)
	style.Colors[imgui.Col.ComboBg] = style.Colors[imgui.Col.PopupBg]
	style.Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.5, 0.5)
	style.Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0, 0, 0, 0)
	style.Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.14, 0.14, 0.14, 1)
	style.Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.02, 0.02, 0.02, 0.53)
	style.Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.31, 0.31, 0.31, 1)
	style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.41, 0.41, 1)
	style.Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.51, 0.51, 0.51, 1)
	style.Colors[imgui.Col.CloseButton] = imgui.ImVec4(0.41, 0.41, 0.41, 0.5)
	style.Colors[imgui.Col.CloseButtonHovered] = imgui.ImVec4(0.98, 0.39, 0.36, 1)
	style.Colors[imgui.Col.CloseButtonActive] = imgui.ImVec4(0.98, 0.39, 0.36, 1)
	style.Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1)
	style.Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(1, 0.43, 0.35, 1)
	style.Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.9, 0.7, 0, 1)
	style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1, 0.6, 0, 1)
	style.Colors[imgui.Col.ModalWindowDarkening] = imgui.ImVec4(0.8, 0.8, 0.8, 0.35)
end
function gray_theme()
	imgui.SwitchContext()

	local style = imgui.GetStyle()
	style.Colors[imgui.Col.Text] = imgui.ImVec4(0.95, 0.96, 0.98, 1)
	style.Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.36, 0.42, 0.47, 1)
	style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.11, 0.15, 0.17, 1)
	style.Colors[imgui.Col.ChildWindowBg] = imgui.ImVec4(0.15, 0.18, 0.22, 1)
	style.Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.08, 0.08, 0.08, 0.94)
	style.Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.5, 0.5)
	style.Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0, 0, 0, 0)
	style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.2, 0.25, 0.29, 1)
	style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.12, 0.2, 0.28, 1)
	style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.09, 0.12, 0.14, 1)
	style.Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.09, 0.12, 0.14, 0.65)
	style.Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0, 0, 0, 0.51)
	style.Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.08, 0.1, 0.12, 1)
	style.Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.15, 0.18, 0.22, 1)
	style.Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.02, 0.02, 0.02, 0.39)
	style.Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.2, 0.25, 0.29, 1)
	style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.18, 0.22, 0.25, 1)
	style.Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.09, 0.21, 0.31, 1)
	style.Colors[imgui.Col.ComboBg] = imgui.ImVec4(0.2, 0.25, 0.29, 1)
	style.Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.28, 0.56, 1, 1)
	style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.28, 0.56, 1, 1)
	style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.37, 0.61, 1, 1)
	style.Colors[imgui.Col.Separator] = style.Colors[imgui.Col.Border]
	style.Colors[imgui.Col.Button] = imgui.ImVec4(0.2, 0.25, 0.29, 1)
	style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.28, 0.56, 1, 1)
	style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.06, 0.53, 0.98, 1)
	style.Colors[imgui.Col.Header] = imgui.ImVec4(0.2, 0.25, 0.29, 0.55)
	style.Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.8)
	style.Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.26, 0.59, 0.98, 1)
	style.Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.26, 0.59, 0.98, 0.25)
	style.Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.67)
	style.Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.06, 0.05, 0.07, 1)
	style.Colors[imgui.Col.CloseButton] = imgui.ImVec4(0.4, 0.39, 0.38, 0.16)
	style.Colors[imgui.Col.CloseButtonHovered] = imgui.ImVec4(0.4, 0.39, 0.38, 0.39)
	style.Colors[imgui.Col.CloseButtonActive] = imgui.ImVec4(0.4, 0.39, 0.38, 1)
	style.Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1)
	style.Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(1, 0.43, 0.35, 1)
	style.Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.9, 0.7, 0, 1)
	style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1, 0.6, 0, 1)
	style.Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.25, 1, 0, 0.43)
	style.Colors[imgui.Col.ModalWindowDarkening] = imgui.ImVec4(1, 0.98, 0.95, 0.73)
end
function blue_theme()
	imgui.SwitchContext()

	local style = imgui.GetStyle()
	style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.16, 0.29, 0.48, 0.54)
	style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.4)
	style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.26, 0.59, 0.98, 0.67)
	style.Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.04, 0.04, 0.04, 1)
	style.Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.16, 0.29, 0.48, 1)
	style.Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0, 0, 0, 0.51)
	style.Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.26, 0.59, 0.98, 1)
	style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.24, 0.52, 0.88, 1)
	style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.26, 0.59, 0.98, 1)
	style.Colors[imgui.Col.Button] = imgui.ImVec4(0.26, 0.59, 0.98, 0.4)
	style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 1)
	style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.06, 0.53, 0.98, 1)
	style.Colors[imgui.Col.Header] = imgui.ImVec4(0.26, 0.59, 0.98, 0.31)
	style.Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.8)
	style.Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.26, 0.59, 0.98, 1)
	style.Colors[imgui.Col.Separator] = style.Colors[imgui.Col.Border]
	style.Colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.78)
	style.Colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.26, 0.59, 0.98, 1)
	style.Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.26, 0.59, 0.98, 0.25)
	style.Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.67)
	style.Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.26, 0.59, 0.98, 0.95)
	style.Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.26, 0.59, 0.98, 0.35)
	style.Colors[imgui.Col.Text] = imgui.ImVec4(1, 1, 1, 1)
	style.Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.5, 0.5, 0.5, 1)
	style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.06, 0.06, 0.06, 1)
	style.Colors[imgui.Col.ChildWindowBg] = imgui.ImVec4(1, 1, 1, 0)
	style.Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.08, 0.08, 0.08, 1)
	style.Colors[imgui.Col.ComboBg] = style.Colors[imgui.Col.PopupBg]
	style.Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.5, 0.5)
	style.Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0, 0, 0, 0)
	style.Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.14, 0.14, 0.14, 1)
	style.Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.02, 0.02, 0.02, 0.53)
	style.Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.31, 0.31, 0.31, 1)
	style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.41, 0.41, 1)
	style.Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.51, 0.51, 0.51, 1)
	style.Colors[imgui.Col.CloseButton] = imgui.ImVec4(0.41, 0.41, 0.41, 0.5)
	style.Colors[imgui.Col.CloseButtonHovered] = imgui.ImVec4(0.98, 0.39, 0.36, 1)
	style.Colors[imgui.Col.CloseButtonActive] = imgui.ImVec4(0.98, 0.39, 0.36, 1)
	style.Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1)
	style.Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(1, 0.43, 0.35, 1)
	style.Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.9, 0.7, 0, 1)
	style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1, 0.6, 0, 1)
	style.Colors[imgui.Col.ModalWindowDarkening] = imgui.ImVec4(0.8, 0.8, 0.8, 0.35)
end

local style = imgui.GetStyle()
style.WindowPadding = imgui.ImVec2(8, 8)
style.WindowRounding = 10
style.ChildWindowRounding = 10
style.FramePadding = imgui.ImVec2(5, 3)
style.FrameRounding = 6
style.ItemSpacing = imgui.ImVec2(5, 4)
style.ItemInnerSpacing = imgui.ImVec2(4, 4)
style.IndentSpacing = 21
style.ScrollbarSize = 10
style.ScrollbarRounding = 15
style.GrabMinSize = 15
style.GrabRounding = 7
style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)