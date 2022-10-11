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
		"Объявить в розыск",
		"Использовать клавишу вручную - /su [ID]. Клавиша для выдачи розыска, также используется для быстрого вызова - Режим умной выдачи розыска.",
		2
	},
	{
		"Снять розыск",
		"Использовать клавишу вручную - /clear. Клавиша для быстрого снятия розыска.",
		2
	},
	{
		"Удостоверение/Жетон",
		"Использовать клавишу вручную - /уд [ID]. Клавиша для предъявления удостоверения/жетона.",
		3
	},
	{
		"Запросить документы",
		"Использовать клавишу вручную - /pas. Клавиша для представления и запроса предъявить документы.",
		2
	},
	{
		"Надеть наручники",
		"Использовать клавишу вручную - /сuff [ID]. Клавиша для быстрого использования наручников.",
		2
	},
	{
		"Вести за собой",
		"Использовать клавишу вручную - /gotome [ID]. Клавиша для быстрого использования возможности захвата игрока в наручниках.",
		2
	},
	{
		"Посадить в Т/С",
		"Использовать клавишу вручную - /incar [ID]. Клавиша для быстрой погрузки преступника в Т/С.",
		2
	},
	{
		"Зачитать права",
		"Использовать клавишу вручную - /права. Клавиша для озвучивания прав гражданина при задержании.",
		3
	},
	{
		"Провести обыск",
		"Использовать клавишу вручную - /frisk [ID]. Клавиша для быстрого проведения обыска.",
		2
	},
	{
		"Провести арест",
		"Использовать клавишу вручную - /arrest [ID]. Клавиша для быстрого ареста преступника.",
		2
	},
	{
		"Изъятие",
		"Использовать клавишу вручную - /take [ID]. Клавиша для изъятия чего-либо. Например, наркотиков.",
		2
	},
	{
		"Рация орган-ции",
		"Использовать клавишу вручную - /r. Клавиша для использования чата организации.",
		1
	},
	{
		"OOC - чат в рацию",
		"Использовать клавишу вручную - /rn. ОOC - сообщение в рацию департамента.",
		1
	},
	{
		"Федеральная рация",
		"Использовать клавишу вручную - /d. Клавиша для использования федеральной рации.",
		1
	},
	{
		"Погоня",
		"Использовать клавишу вручную — /meg или /мегафон. Клавиша для использования мегафона в случае, когда вы начинаете или уже ведёте погоню.",
		3
	},
	{
		"Выписать штраф",
		"Использовать клавишу вручную - /ticket [ID]. Клавиша для выписки штрафа.",
		2
	},
	{
		"Штурм",
		"Использовать клавишу вручную - /кричалка. Клавиша для быстрой RP - отыгровки штурма или задержания.",
		3
	},
	{
		"Вкл./Выкл. радар",
		"Клавиша для включения/выключения сканирования радара. В режиме реального времени радар сканирует игроков за рулём. Проверяется их скорость, наличие розыска.",
		1
	},
	{
		"Остановка RP - отыгровки",
		"Позволяет остановить стандартную RP - отыгровку, если она запущена по ошибке.",
		1
	},
	{
		"Быстрый скриншот",
		"Использовать клавишу вручную - /sc. Клавиша позволяет быстро сделать любой screenshot при этом /time будет введён автоматически.",
		1
	},
	{
		"Открыть MoJ Helper",
		"Использовать клавишу вручную - /mh. Клавиша позволяет быстро открыть приложение, не используя команду.",
		1
	},
	{
		"Выбор волны рации",
		"Использовать клавишу вручную - /channel. Клавиша для быстрой активации панели управления каналами связи в рации.",
		1
	},
	{
		"Вкл./выкл. спецсигнал",
		"Клавиша для включения/выключения сирены и мигалки.",
		2
	},
	{
		"Стандартный доклад",
		"Клавиша для быстрой отправки доклада в рацию. Применяется как альтернатива той же функции в быстром меню. ",
		2
	},
	{
		"Патрульный ассистент",
		"Клавиша для быстрого вызова окна регистрации патрульного ассистента. Также вы можете использовать команду — /patrol или уведомление напарника, когда садитесь в полицейский автомобиль. ",
		2
	},
	{
		"Трафик-стоп",
		[[
Использовать клавишу вручную — /traf. Клавиша для использования мегафона в случае, если возникает потребность в остановке автомобиля, например, для проверки документов или иных нужд. Рекомендуется использовать не в погоне.

Краткая информация.
Traffic Stop (Ten-code 10-55) — остановка саспекта или же обычного гражданина по видимости нарушения.

High-risk Traffic Stop (Ten-code 10-66) — принудительная остановка саспекта, при котором задействованы все юниты, которые задействованы в погоне.]],
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
			name = 'Гражд-н',
			menu = {
				[1] = {"Удоств.","{F6}/pas {id_marker}","1.5"}, [2] = {"Маска.","/unmask {id_marker}","1.5"},
				[3] = {"Трафик",
				"/me движением руки включил мегафон.&/m Водитель, остановите ваше транспортное средство.&/m Пожалуйста, прижмитесь к обочине, заглушите двигатель и ожидайте.",
				"1.5"}, [4] = {'', '', '1.0'},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[2] = {
			name = 'Прест-к',
			menu = {
				[1] = {"Погоня","/pursuit","1.5"}, [2] = {"Розыск","{F6}/su ","1.5"}, [3] = {"Метка","{F6}/z ","1.5"}, [4] = {"Поиск","{F6}/find{}","1.5"},
				[5] = {"Обыск",
				"/me протянул руку к заднему подсумку и достал резиновые перчатки, которые надел на руки, ...&/me ... затем начал тщательно обыскивать человека, выкладывая всё найденное для изучения.&/frisk {id_marker}",
				"1.5"}, [6] = {"Наруч.",
				"/me схватился за руки подозреваемого, затем нащупал на поясе наручники ...&/me ... и, вытащив их из подсумка, нацепил на подозреваемого.&/cuff {id_marker}",
				"1.5"}, [7] = {"Вести",
				"/me держит рукой за левое плечо и с силой сжимает запястье человека.&/todo Без резких движений!*повысив тембр голоса.&/gotome {id_marker}",
				"1.5"}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[3] = {
			name = 'Рация',
			menu = {
				[1] = {"CODE 0","/r Всем постам CODE 1! Нахожусь под огнём! Требуется помощь, недоступен!","1.5"},
				[2] = {"Строй","/r Уважаемые коллеги, минуту внимания!&/r Общее построение в департаменте, всем постам прибыть на место.","1.5"},
				[3] = {"10-99","/r {patrol_unit} на CONTROL. '99, возвращаюсь к патрулированию, доступен.","1.5"}, [4] = {"10-66",
				"/m Водитель {meg_c_model} {color_car} цвета с N-{meg_c_id}!&/m Прижмитесь к обочине, заглушите двигатель и держите руки на руле!&/m В случае неподчинения законному требованию будет открыт огонь!&/r {patrol_unit} на CONTROL. Провожу '66 в районе {zone}, С'4, недоступен.&/r Автомобиль {meg_c_model} {color_car} цвета с N-{meg_c_id}.",
				"1.5"},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[4] = {
			name = 'Другое',
			menu = {
				[1] = {"Дом","/home","1.5"}, [2] = {"Ключи","/key","1.5"}, [3] = {"Дверь","/lock","1.5"}, [4] = {"Часы",
				"/do На руке умные часы Apple Watch Series 4.&/todo Привет Siri, который час?*поднеся руку с часами к лицу&/do Мистер {surname}, сейчас {H}:{M} минут, {day}.&/time",
				"1.5"},
				[5] = {'', '', '1.0'}, [6] = {'', '', '1.0'}, [7] = {'', '', '1.0'}, [8] = {'', '', '1.0'},
				[9] = {'', '', '1.0'}, [10] = {'', '', '1.0'}
			}
		},
		[5] = {
			name = 'Лекции',
			menu = {
				[1] = {"ПДД","Соблюдении ПДД на дорогах.","1.0"}, [2] = {"Арест","Методика безопасного ареста.","1.0"},
				[3] = {"Допрос","Технология проведения допроса","1.0"}, [4] = {"Экзамен","Список тем для подготовки к сдаче:&1. УК.&2. АК.&3. Устав.","1.0"},
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
		"Команда для быстрого использования наручников.",
	},
	{
		"/uncuff",
		"Команда для быстрого снятия наручников.",
	},
	{
		"/incar",
		"Команда для быстрой погрузки/извлечения саспекта в/из Т/С.",
	},
	{
		"/inmoto",
		"Команда для RP - отыгровки извлечения с мотоцикла.",
	},
	{
		"/eject",
		"Команда для того чтобы выкинуть из Т/C.",
	},
	{
		"/ticket",
		"Команда для выписки штрафа.",
	},
	{
		"/mask",
		"Команда для использования маски.",
	},
	{
		"/clear",
		"Команда для удаления/снятия розыска из базы данных.",
	},
	{
		"/search",
		"Команда для быстрого проведения обыска.",
	},
	{
		"/arrest",
		"Команда для быстрого ареста саспекта.",
	},
	{
		"/su",
		"Команда для выдачи розыска через ручной режим и умную выдачу розыску.",
	},
	{
		"/pas",
		"Команда для представления и запроса предъявить документы.",
	},
	{
		"/frisk",
		"Команда для быстрого проведения обыска.",
	},
	{
		"/gotome",
		"Команда для быстрого захвата саспекта в наручниках.",
	},
	{
		"/ungotome",
		"Команда для отмены действия захвата саспекта в наручниках.",
	},
	{
		"/sc",
		"Команда, чтобы сделать автоматический скриншот с /time и /с 60.",
	},
	{
		"/find",
		"Команда для поиска саспекта по базе данных.",
	},
	{
		"/rn",
		"Команда для ОOC - сообщение в рацию департамента.",
	},
	{
		"/post",
		"Команда для доклада с поста.",
	},
	{
		"/pull",
		"Команда для быстрой RP - отыгровки извлечения из Т/С.",
	},
	{
		"/usemed",
		"Команда для использования аптечки.",
	},
	{
		"/meg",
		"Команда для активации мегафона в режиме погони.",
	},
	{
		"/traf",
		"Команда для активации мегафона в режиме трафик-стопа.",
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
	"Объявить в розыск":1,
	"Снять розыск":2,
	"Удостоверение\/Жетон":3,
	"Запросить документы":4,
	"Надеть наручники":5,
	"Вести за собой":6,
	"Посадить в Т\/С":7,
	"Зачитать права":8,
	"Провести обыск":9,
	"Провести арест":10,
	"Изъятие":11,
	"Рация орган-ции":12,
	"OOC - чат в рацию":13,
	"Федеральная рация":14,
	"Погоня":15
	"Выписать штраф":16,
	"Штурм":17,
	"Вкл.\/Выкл. радар":18,
	"Остановка RP - отыгровки":19,
	"Быстрый скриншот":20,
	"Открыть MoJ Helper":21,
	"Выбор волны рации":22,
	"Вкл.\/выкл. спецсигнал":23,
	"Стандартный доклад":24,
	"Патрульный ассистент":25,
	"Трафик-стоп":26,
]]

local getid = true
local id_player = -1
local nick_player = nil
local nick_player1 = nil
local nick_player2 = nil

local time_post_update = 0

local colors_list = {
	[0] = {
		"Чёрного",
		"Чёрный"
	},
	{
		"Белого",
		"Белый"
	},
	{
		"Голубого",
		"Голубой"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Тёмно-зелёного",
		"Тёмно-зеленый"
	},
	{
		"Пурпурного",
		"Пурпурный"
	},
	{
		"Жёлтого",
		"Жёлтый"
	},
	{
		"Светло-голубого",
		"Светло-голубой"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Сине-серого",
		"Сине-серый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Сине-серого",
		"Сине-серый"
	},
	{
		"Тёмно-серого",
		"Тёмно-серый"
	},
	{
		"Белого",
		"Белый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Зелёного",
		"Зелёный"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Тёмно-красного",
		"Тёмно-красный"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Светло-синего",
		"Светло-синий"
	},
	{
		"Светло-красного",
		"Светло-красный"
	},
	{
		"Бордового",
		"Бордовый"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Тёмно-серого",
		"Тёмно-серый"
	},
	{
		"Тёмно-серого",
		"Тёмно-серый"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Тёмно-серого",
		"Тёмно-серый"
	},
	{
		"Светло-синего",
		"Светло-синий"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Тёмно-красного",
		"Тёмно-красный"
	},
	{
		"Светло-красного",
		"Светло-красный"
	},
	{
		"Светло-серого",
		"Светло-серый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Тёмно-серого",
		"Тёмно-серый"
	},
	{
		"Тёмно-серого",
		"Тёмно-серый"
	},
	{
		"Чёрного",
		"Чёрный"
	},
	{
		"Тёмно-зелёного",
		"Тёмно-зелёный"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Тёмно-коричневого",
		"Тёмно-коричневый"
	},
	{
		"Тёмно-бежевого",
		"Тёмно-бежевый"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Тёмно-красного",
		"Тёмно-красный"
	},
	{
		"Тёмно-зелёного",
		"Тёмно-зелёный"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Светло-бежевого",
		"Светло-бежевый"
	},
	{
		"Тёмно-бежевого",
		"Тёмно-бежевый"
	},
	{
		"Бежевого",
		"Бежевый"
	},
	{
		"Светло-серебристого ",
		"Светло-серебристый"
	},
	{
		"Серебристо-серого",
		"Серебристо-серый"
	},
	{
		"Тёмно-зелёного",
		"Тёмно-зелёный"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Тёмно-синего",
		"Тёмно-синий"
	},
	{
		"Серо-синего",
		"Серо-синей"
	},
	{
		"Красно-коричневого",
		"Красно-коричневый"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Серо-коричневого",
		"Серо-коричневый"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Светло-синего",
		"Светло-синий"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Светло-коричневого",
		"Светло-коричневый"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Светло-бежевого",
		"Светло-бежевый"
	},
	{
		"Золотистого",
		"Золотистый"
	},
	{
		"Бордового",
		"Бордовый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Светло-бежевого",
		"Светло-бежевый"
	},
	{
		"Светло-розового",
		"Светло-розовый"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Сине-серого",
		"Сине-серый"
	},
	{
		"Тёмно-серого",
		"Тёмно-серый"
	},
	{
		"Светло-бежевого",
		"Светло-бежевый"
	},
	{
		"Тёмно-красного",
		"Тёмно-красный"
	},
	{
		"Тёмно-синего",
		"Тёмно-синий"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Серо-коричневого",
		"Серо-коричневый"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Синего",
		"Синий"
	},
	{
		"Малинового",
		"Малиновый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Чёрно-зелёного",
		"Чёрно-зелёный"
	},
	{
		"Шоколадного",
		"Шоколадный"
	},
	{
		"Вишнёвого",
		"Вишнёвый"
	},
	{
		"Зелёного",
		"Зелёный"
	},
	{
		"Светло-синего",
		"Светло-синий"
	},
	{
		"Светло-красного",
		"Светло-красный"
	},
	{
		"Светло-бежевого",
		"Светло-бежевый"
	},
	{
		"Белого",
		"Белый"
	},
	{
		"Тёмно-серого",
		"Тёмно-серый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Бирюзового",
		"Бирюзовый"
	},
	{
		"Светло-синего",
		"Светло-синий"
	},
	{
		"Сине-серого",
		"Сине-серый"
	},
	{
		"Светло-бежевого",
		"Светло-бежевый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Бирюзово-синего",
		"Бирюзово-синий"
	},
	{
		"Светло-коричневого",
		"Светло-коричневый"
	},
	{
		"Тёмно-голубого",
		"Тёмно-голубой"
	},
	{
		"Тёмно-синего",
		"Тёмно-синий"
	},
	{
		"Светло-коричневого",
		"Светло-коричневый"
	},
	{
		"Синего",
		"Синий"
	},
	{
		"Светло-коричневого",
		"Светло-коричневый"
	},
	{
		"Светло-серого",
		"Светло-серый"
	},
	{
		"Синего",
		"Синий"
	},
	{
		"Светло-коричневого",
		"Светло-коричневый"
	},
	{
		"Серо-голубого",
		"Серо-голубой"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Светло-коричневого",
		"Светло-коричневый"
	},
	{
		"Серебристо-серого",
		"Серебристо-серый"
	},
	{
		"Сине-серого",
		"Сине-серый"
	},
	{
		"Коричневого",
		"Коричневый"
	},
	{
		"Тёмно-зелёного",
		"Тёмно-зелёный"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Тёмно-синего",
		"Тёмно-синий"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Бежево-серого",
		"Бежево-серый"
	},
	{
		"Светло-бежевого",
		"Светло-бежевый"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Тёмно-коричневого",
		"Тёмно-коричневый"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Синего",
		"Синий"
	},
	{
		"Розового",
		"Розовый"
	},
	{
		"Чёрного",
		"Чёрный"
	},
	{
		"Светло-зелёного",
		"Светло-зелёный"
	},
	{
		"Черновато-красного",
		"Черновато-красный"
	},
	{
		"Светло-голубого",
		"Светло-голубой"
	},
	{
		"Желтовато-коричневого",
		"Желтовато-коричневый"
	},
	{
		"Красно-коричневого",
		"Красно-коричневый"
	},
	{
		"Чёрного",
		"Чёрный"
	},
	{
		"Фиолетового",
		"Фиолетовый"
	},
	{
		"Бирюзового",
		"Бирюзовый"
	},
	{
		"Светло-фиолетового",
		"Светло-фиолетовый"
	},
	{
		"Светло-зелёного",
		"Светло-зелёный"
	},
	{
		"Светло-серого",
		"Светло-серый"
	},
	{
		"Пурпурно-синего",
		"Пурпурно-синий"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Светло-оливкового",
		"Светло-оливковый"
	},
	{
		"Сиреневого",
		"Сиреневый"
	},
	{
		"Фиолетового",
		"Фиолетовый"
	},
	{
		"Светло-зелёного",
		"Светло-зелёный"
	},
	{
		"Светло-фиолетового",
		"Светло-фиолетовый"
	},
	{
		"Фиолетового",
		"Фиолетовый"
	},
	{
		"Чёрного",
		"Чёрный"
	},
	{
		"Коричнево-чёрного",
		"Коричнево-чёрный"
	},
	{
		"Чёрного",
		"Чёрный"
	},
	{
		"Сине-зелёного",
		"Сине-зелёный"
	},
	{
		"Светло-синего",
		"Светло-синий"
	},
	{
		"Зелёного",
		"Зелёный"
	},
	{
		"Светло-зелёного",
		"Светло-зелёный"
	},
	{
		"Бирюзового",
		"Бирюзовый"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Сине-серого",
		"Сине-серый"
	},
	{
		"Тёмно-красного",
		"Тёмно-красный"
	},
	{
		"Коричневого",
		"Коричневый"
	},
	{
		"Тёмно-зелёного",
		"Тёмно-зелёный"
	},
	{
		"Светло-розового",
		"Светло-розовый"
	},
	{
		"Синего",
		"Синий"
	},
	{
		"Бирюзового",
		"Бирюзовый"
	},
	{
		"Чёрно-серого",
		"Чёрно-серый"
	},
	{
		"Тёмно-бирюзового",
		"Тёмно-бирюзовый"
	},
	{
		"Голубого",
		"Голубой"
	},
	{
		"Фиолетового",
		"Фиолетовый"
	},
	{
		"Шоколадного",
		"Шоколадный"
	},
	{
		"Светло-фиолетового",
		"Светло-фиолетовый"
	},
	{
		"Светло-фиолетового",
		"Светло-фиолетовый"
	},
	{
		"Фиолетового",
		"Фиолетовый"
	},
	{
		"Тёмно-зелёного",
		"Тёмно-зелёный"
	},
	{
		"Шоколадного",
		"Шоколадный"
	},
	{
		"Шоколадного",
		"Шоколадный"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Светло-фиолетового",
		"Светло-фиолетовый"
	},
	{
		"Светло-фиолетового",
		"Светло-фиолетовый"
	},
	{
		"Фиолетового",
		"Фиолетовый"
	},
	{
		"Тёмно-фиолетового",
		"Тёмно-фиолетовый"
	},
	{
		"Морковного",
		"Морковный"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Морковного",
		"Морковный"
	},
	{
		"Морковного",
		"Морковный"
	},
	{
		"Пурпурно-красного",
		"Пурпурно-красный"
	},
	{
		"Серо-розового",
		"Серо-розовый"
	},
	{
		"Тёмно-зеленого",
		"Тёмно-зелёный"
	},
	{
		"Тёмно-зеленого",
		"Тёмно-зелёный"
	},
	{
		"Тёмно-зеленого",
		"Тёмно-зелёный"
	},
	{
		"Тёмно-зеленого",
		"Тёмно-зелёный"
	},
	{
		"Розового",
		"Розовый"
	},
	{
		"Зелёного",
		"Зелёный"
	},
	{
		"Бежевого",
		"Бежевый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Жёлтого",
		"Жёлтый"
	},
	{
		"Золотистого",
		"Золотистый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Жёлтого",
		"Жёлтый"
	},
	{
		"Синего",
		"Синий"
	},
	{
		"Тёмно-оливкового",
		"Тёмно-оливковый"
	},
	{
		"Тёмно-бежевого",
		"Тёмно-бежевый"
	},
	{
		"Тёмно-синего",
		"Тёмно-синий"
	},
	{
		"Тёмно-зеленого",
		"Тёмно-зелёный"
	},
	{
		"Тёмно-синего",
		"Тёмно-синий"
	},
	{
		"Светло-синего",
		"Светло-синий"
	},
	{
		"Тёмно-фиолетового",
		"Тёмно-фиолетовый"
	},
	{
		"Тёмно-синего",
		"Тёмно-синий"
	},
	{
		"Тёмно-синего",
		"Тёмно-синий"
	},
	{
		"Светло-синего",
		"Светло-синий"
	},
	{
		"Синего",
		"Синий"
	},
	{
		"Тёмно-синего",
		"Тёмно-синий"
	},
	{
		"Фиолетового",
		"Фиолетовый"
	},
	{
		"Морковного",
		"Морковный"
	},
	{
		"Серебристого",
		"Серебристый"
	},
	{
		"Жёлто-зеленого",
		"Жёлто-зеленый"
	},
	{
		"Тёмно-зеленого",
		"Тёмно-зелёный"
	},
	{
		"Морковного",
		"Морковный"
	},
	{
		"Бирюзового",
		"Бирюзовый"
	},
	{
		"Светло-розового",
		"Светло-розовый"
	},
	{
		"Оранжевого",
		"Оранжевый"
	},
	{
		"Розового",
		"Розовый"
	},
	{
		"Оливкого-желтого",
		"Оливкого-желтый"
	},
	{
		"Морковного",
		"Морковный"
	},
	{
		"Тёмно-синего",
		"Тёмно-синий"
	},
	{
		"Красно-коричневого",
		"Красно-коричневый"
	},
	{
		"Тёмно-оливкового",
		"Тёмно-оливковый"
	},
	{
		"Светло-зелёного",
		"Светло-зелёный"
	},
	{
		"Тёмно-зеленого",
		"Тёмно-зелёный"
	},
	{
		"Жёлтого",
		"Жёлтый"
	},
	{
		"Светло-зелёного",
		"Светло-зелёный"
	},
	{
		"Бурого",
		"Бурый"
	},
	{
		"Светло-коричневого",
		"Светло-коричневый"
	},
	{
		"Розового",
		"Розовый"
	},
	{
		"Розового",
		"Розовый"
	},
	{
		"Тёмно-зеленого",
		"Тёмно-зелёный"
	},
	{
		"Болотного",
		"Болотный"
	},
	{
		"Зеленовато-синего",
		"Зеленовато-синий"
	},
	{
		"Розового",
		"Розовый"
	},
	{
		"Коричнево-бежевого",
		"Коричнево-бежевый"
	},
	{
		"Морковного",
		"Морковный"
	},
	{
		"Бирюзового",
		"Бирюзовый"
	},
	{
		"Салатового",
		"Салатовый"
	},
	{
		"Пурпурного",
		"Пурпурный"
	},
	{
		"Зелёного",
		"Зелёный"
	},
	{
		"Тёмно-коричневого",
		"Тёмно-коричневый"
	},
	{
		"Тёмно-зеленого",
		"Тёмно-зелёный"
	},
	{
		"Серо-голубого",
		"Серо-голубой"
	},
	{
		"Серо-синего",
		"Серо-синей"
	},
	{
		"Красного",
		"Красный"
	},
	{
		"Пурпурно-фиолетового",
		"Пурпурно-фиолетовый"
	},
	{
		"Серебряно-бежевого",
		"Серебряно-бежевый"
	},
	{
		"Тёмно-серого",
		"Тёмно-серый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Серого",
		"Серый"
	},
	{
		"Кофейного",
		"Кофейный"
	},
	{
		"Тёмно-синего",
		"Тёмно-синий"
	}
}
local gun_list = {
	{
		1,
		"Кастет"
	},
	{
		2,
		"Клюшка для гольфа"
	},
	{
		3,
		"Полицейская дубинка"
	},
	{
		4,
		"Нож"
	},
	{
		5,
		"Бейсбольная бита"
	},
	{
		6,
		"Лопата"
	},
	{
		7,
		"Кий"
	},
	{
		8,
		"Катана"
	},
	{
		9,
		"Бензопила"
	},
	{
		10,
		"Двухсторонний дилдо"
	},
	{
		11,
		"Дилдо"
	},
	{
		12,
		"Вибратор"
	},
	{
		13,
		"Серебряный вибратор"
	},
	{
		14,
		"Букет цветов"
	},
	{
		15,
		"Трость"
	},
	{
		16,
		"Граната"
	},
	{
		17,
		"Слезоточивый газ"
	},
	{
		18,
		"Коктейль Молотова"
	},
	{
		22,
		"Пистолет 9мм"
	},
	{
		23,
		"Пистолет 9мм с глушителем"
	},
	{
		24,
		"Пистолет Desert Eagle"
	},
	{
		25,
		"Обычный дробовик"
	},
	{
		26,
		"Обрез"
	},
	{
		27,
		"Скорострельный дробовик"
	},
	{
		28,
		"Узи"
	},
	{
		29,
		"MP5"
	},
	{
		30,
		"Автомат Калашникова"
	},
	{
		31,
		"Винтовка M4"
	},
	{
		32,
		"Tec-9"
	},
	{
		33,
		"Охотничье ружье"
	},
	{
		34,
		"Снайперская винтовка"
	},
	{
		35,
		"РПГ"
	},
	{
		36,
		"Самонаводящиеся ракеты HS"
	},
	{
		37,
		"Огнемет"
	},
	{
		38,
		"Миниган"
	},
	{
		39,
		"Сумка с тротилом"
	},
	{
		41,
		"Баллончик с краской"
	},
	{
		42,
		"Огнетушитель"
	},
	{
		43,
		"Фотоаппарат"
	},
	{
		46,
		"Парашют"
	}
}
local cardinal_points = {
	{
		"Север",
		"северном",
		"северное"
	},
	{
		"Северо-Восток",
		"северо-восточном",
		"северо-восточное"
	},
	{
		"Восток",
		"восточном",
		"восточное"
	},
	{
		"Юго-Восток",
		"юго-восточном",
		"юго-восточное"
	},
	{
		"Юг",
		"южном",
		"южное"
	},
	{
		"Юго-Запад",
		"юго-западном",
		"юго-западное"
	},
	{
		"Запад",
		"западном",
		"западное"
	},
	{
		"Северо-Запад",
		"северо-западном",
		"северо-западное"
	},
	{
		"Север",
		"северном",
		"северное"
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
									name_car_megafon = "Неопределена"
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
Проверка Т/С #%s [%s]
Скорость: %s км/ч
Владелец: %s[%s]
Статус: %s]], model_car_megafon, name_car_megafon, speed_megafon2, sampGetPlayerNickname(id_Driver), id_Driver, su_info_status))
												AddNewLogMegafon(model_car_megafon, name_car_megafon, speed_megafon2, sampGetPlayerNickname(id_Driver), id_Driver, su_info_status, color_car_megafon2)
											else
												AddLogMegafon(string.format("Проверка Т/С #%s [%s]\nВладелец: %s[%s]\nСтатус: %s", model_car_megafon, name_car_megafon, sampGetPlayerNickname(id_Driver), id_Driver, su_info_status))
												AddNewLogMegafon(model_car_megafon, name_car_megafon, 0, sampGetPlayerNickname(id_Driver), id_Driver, su_info_status, color_car_megafon2)
											end

											if su_info_status == "В розыске" and radar_autostop then
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
		if string.match(text, "[^Ђ-ї][Ђ-ї]*$") == "." then
			text = text:sub(1, -2)
		end

		if string.match(text, "[^Ђ-ї][Ђ-ї]*$") == "." then
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
		msg("Используйте: /find2 [ID]")
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
					addsampchatmvd("Для управления курсором используйте клавишу Y либо F6.")
					addsampchatmvd("Для отключения окна радара введите команду /radar еще раз. ")
				end
			else
				addsampchatmvd("Для активации радара Johnny-3000 необходимо находиться в полицейском транспорте. ")
			end
		else
			addsampchatmvd("Для активации радара Johnny-3000 необходимо находиться в полицейском транспорте. ")
		end
	else
		addsampchatmvd("Активируйте модификацию по следующему пути: /mh - MoJ Helper Plus - Радар Johnny-3000.")
	end
end
local russian_characters = {
	[168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
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
	  elseif ch == 168 then -- Ё
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
	  elseif ch == 184 then -- ё
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
	msg('Успешно загружен! Открыть меню: /'..loaded.main.cmd_act)
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
				cityname = "Лос Сантос"
			elseif cityid == 2 then
				cityname = "Сан Фиерро"
			elseif cityid == 3 then
				cityname = "Лас Вентурас"
			else
				cityname = oprZone()
			end

			if string.find(sampGetCurrentServerName(), "Arizona") then
				post = oprPost()
			else
				post = "Нет"
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
		[0] = "Афро-Американец",
		"Американец",
		"Британец",
		"Русский",
		"Афро-американец",
		"Афро-Американец",
		"Американец",
		"Афро-Американец",
		"Американец",
		"Афро-Американка",
		"Американка",
		"Афро-Американка",
		"Японка",
		"Афро-Американка",
		"Афро-Американец",
		"Кубинец",
		"Афро-Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Американец",
		"Американец",
		"Афро-Американец",
		"Американец",
		"Латино-Американец",
		"Американка",
		"Американец",
		"Латино-Американец",
		"Американец",
		"Латино-Американец",
		"Афро-Американец",
		"Американец",
		"Латино-Американец",
		"Американка",
		"Кубинка",
		"Кубинка",
		"Латино-Американец",
		"Мексиканец",
		"Мексиканец",
		"Мексиканец",
		"Русский",
		"Мексиканец",
		"Мексиканец",
		"Японец",
		"Американец",
		"Афро-Американец",
		"Британец",
		"Американка",
		"Американка",
		"Американка",
		"Американка",
		"Американец",
		"Американец",
		"Американец",
		"Американец",
		"Американец",
		"Американец",
		"Латино-Американка",
		"Русская",
		"Латино-Американка",
		"Афро-Американец",
		"Афро-Американец",
		"Американец",
		"Кубинка",
		"Американец",
		"Американец",
		"Американец",
		"Американец",
		nil,
		"Русская",
		"Латино-Американка",
		"Американка",
		"Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Американец",
		"Американец",
		"Афро-Американец",
		"Латино-Американец",
		"Русская",
		"Афро-Американец",
		"Американка",
		"Американка",
		"Американка",
		"Кубинка",
		"Русская",
		"Американка",
		"Американка",
		"Американец",
		"Американец",
		"Кубинец",
		"Американец",
		"Итальянец",
		"Британец",
		"Американец",
		"Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Латино-Американец",
		"Латино-Американец",
		"Латино-Американец",
		"Русский",
		"Русский",
		"Итальянец",
		"Мексиканец",
		"Мексиканец",
		"Мексиканец",
		"Японец",
		"Японец",
		"Итальянец",
		"Японец",
		"Японец",
		"Японец",
		"Японец",
		"Итальянец",
		"Русский",
		"Русский",
		"Итальянец",
		"Кубинец",
		"Американка",
		"Американка",
		"Кубинка",
		"Мексиканец",
		"Американец",
		"Афро-Американец",
		"Британец",
		"Афро-Американец",
		"Латино-Американец",
		"Американка",
		"Афро-Американка",
		"Кубинка",
		"Американка",
		"Афро-Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Латино-Американка",
		"Мексиканец",
		"Американец",
		"Латино-Американка",
		"Афро-Американец",
		"Американка",
		"Американка",
		"Американка",
		"Американец",
		"Американец",
		"Американец",
		"Афро-Американец",
		"Мексиканка",
		"Мексиканец",
		"Американец",
		"Американец",
		"Мексиканец",
		"Американец",
		"Афро-Американец",
		"Латино-Американец",
		"Американец",
		"Афро-Американец",
		"Американец",
		"Афро-Американец",
		"Японка",
		"Американец",
		"Латино-Американец",
		"Американка",
		"Латино-Американец",
		"Латино-Американец",
		"Латино-Американец",
		"Афро-Американец",
		"Американец",
		"Американка",
		"Британец",
		"Латино-Американец",
		"Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Латино-Американец",
		"Мексиканец",
		"Японец",
		"Американец",
		"Американец",
		"Американец",
		"Американка",
		"Американка",
		"Американка",
		"Японка",
		"Американка",
		"Афро-Американка",
		"Американка",
		"Американка",
		"Американка",
		"Американка",
		"Американец",
		"Американка",
		"Американец",
		"Японец",
		"Японец",
		"Американка",
		"Американец",
		"Латино-Американка",
		"Японец",
		"Американец",
		"Американец",
		"Американка",
		"Американец",
		"Американец",
		"Итальянка",
		"Афро-Американка",
		"Американка",
		"Американец",
		"Латино-Американка",
		"Латино-Американка",
		"Афро-Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Итальянец",
		"Японка",
		"Японка",
		"Латино-Американка",
		"Американец",
		"Американец",
		"Японец",
		"Американец",
		"Американка",
		"Американка",
		"Русская",
		"Американец",
		"Американец",
		"Американец",
		"Русская",
		"Латино-Американка",
		"Американец",
		"Итальянец",
		"Афро-Американец",
		"Мексиканец",
		"Латино-Американка",
		"Афро-Американка",
		"Афро-Американка",
		"Американка",
		"Американец",
		"Американец",
		"Афро-Американец",
		"Американец",
		"Американка",
		"Итальянец",
		"Афро-Американец",
		"Американец",
		"Американец",
		"Афро-Американка",
		"Американка",
		"Латино-Американец",
		"Американец",
		"Афро-Американец",
		"Американец",
		"Афро-Американец",
		"Японка",
		"Американец",
		"Афро-Американец",
		"Поляк",
		"Мексиканец",
		"Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Русский",
		"Мексиканец",
		"Афро-Американец",
		"Латино-Американец",
		"Американец",
		"Американец",
		"Афро-Американец",
		"Американец",
		"Американец",
		"Американец",
		"Американец",
		"Американец",
		"Афро-Американец",
		"Американец",
		"Американец",
		"Американец",
		"Американец",
		"Американец",
		"Американец",
		"Британец",
		"Мексиканец",
		"Афро-Америанец",
		"Японец",
		"Американец",
		"Афро-Американец",
		"Афро-Американец",
		"Кубинка",
		"Американец",
		"Американец",
		"Мексиканец",
		"Американец",
		"Американец",
		"Американец",
		"Американец",
		"Американец",
		"Афро-Американка",
		"Американка",
		"Латино-Американка",
		"Американец",
		"Американец"
	})[skin_id]
end
function getweaponname(weap_id)
	return ({
		[0] = "",
		"Кастет",
		"Клюшка для гольфа",
		"Полицейская дубинка",
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
		[0] = "Воскресенье",
		"Понедельник",
		"Вторник",
		"Среда",
		"Четверг",
		"Пятница",
		"Суббота"
	})[tonumber(os.date("%w"))]
end
function mesname()
	return ({
		"Январь",
		"Февраль",
		"Март",
		"Апрель",
		"Май",
		"Июнь",
		"Июль",
		"Август",
		"Сентябрь",
		"Октябрь",
		"Ноябрь",
		"Декабрь"
	})[tonumber(os.date("%m"))]
end
function oprPost()
	local x, y, z = getCharCoordinates(playerPed)
    local posts = {
		{"Центральный Банк", 1394.3744, -1863.6901, 1.7979, 1527.8936, -1578.9664, 100},
		{"КПП", 1532.8394, -1655.124, 2.5315, 1591.2151, -1603.675, 100},
		{"Больница ЛС", 1138.8849, -1387.8881, 0.009, 1252.5458, -1247.9099, 100},
		{"Таможня ЛС-СФ", -10.0753, -1590.4454, -39.9974, 114.5343, -1502.3046, 100},
		{"Таможня ЛС-ЛВ", 1638.5343, -823.3046, 14.6011, 1726.064, -630.532, 100},
		{"Мэрия ЛС", 1451.2023, -1320.3397, 0, 1535.6632, -1211.2609, 100},
		{"Центральный рынок", 1051.524, -1548.4238, 0, 1177.4086, -1392.0896, 100},
		{"СМИ ЛС", 1620.7903, -1735.1667, 0, 1695.285, -1657.7039, 100},
		{"Автобазар", -2132.9829, -1077.4011, 0, -1886.8691, -698.4249, 100},
		{"ЖД СФ", -2025.5016, 58.7853, 11.2769, -1897.6361, 224.9209, 48.7579},
		{"Автошкола", -2136.2292, -130.4842, 25.6789, -1997.2661, -60.0742, 47.4639},
		{"Таможня СФ-ЛС", -1795.1125, -816.5402, -8.9159, -1501.1254, -686.5373, 74.1878},
		{"Таможня СФ-ЛВ", -1609.3582, 578.6608, 23.8739, -1448.6035, 797.5581, 106.4763},
		{"Таможня СФ-ЛВ", -1658.5999, 526.7474, 28.7922, -1562.8611, 682.9404, 61.6484},
		{"Больница СФ", -2743.5232, 573.9707, 2.3322, -2614.4087, 698.1281, 88.2686},
		{"КПП-1", -1608.7949, 631.6048, -1.0945, -1543.1639, 691.499, 15.7108},
		{"КПП-2", -1723.8849, 653.8339, 19.6651, -1676.6998, 715.0552, 36.7264},
		{"Больница ЛВ", 1562.2344, 1715.9434, -1.0594, 1667.147, 1872.7228, 47.0605},
		{"ЖД ЛВ", 2733.6272, 1211.5406, -13.6819, 2869.2107, 1397.9591, 46.3719},
		{"КПП-1", 2330.6814, 2407.8245, 3.6589, 2360.2805, 2444.5332, 18.808},
		{"КПП-2", 2229.5854, 2429.189, 8.3063, 2254.6479, 2498.783, 24.7113},
		{"Таможня ЛВ-ЛС", 1737.3713, 581.9952, -22.9514, 1834.1492, 878.7039, 41.8146},
		{"Таможня ЛВ-СФ", 965.7903, 720.4094, -11.7455, 1344.7903, 1058.4094, 56.6468},
		{"Казино", 1845.3638, 872.8126, 0, 2042.9298, 1091.4816, 100},
		{"Авианосец", -1543.5377, 424.495, -2.7875, -1221.449, 537.2685, 66.6995},
	}
    for i, v in ipairs(posts) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return 'Неизвестно'
end
function greeting()
	local dt = tonumber(os.date("%H"))
	if dt >= 0 and dt < 5 then
		return "Доброй ночи"
	elseif dt >= 5 and dt < 11 then
		return "Доброе утро"
	elseif dt >= 11 and dt < 16 then
		return "Добрый день"
	elseif dt >= 16 and dt < 22 then
		return "Добрый вечер"
	elseif dt >= 22 then
		return "Доброй ночи"
	end
end
function oprZone()
	local x, y, z = getCharCoordinates(playerPed)
    local streets = {
		{"Клуб Ависпа Кантри", -2667.81, -302.135, -28.831, -2646.4, -262.32, 71.169},
		{"Аэропорт Истэр Бей", -1315.42, -405.388, 15.406, -1264.4, -209.543, 25.406},
		{"Клуб Ависпа Кантри", -2550.04, -355.493, 0, -2470.04, -318.493, 39.7},
		{"Аэропорт «Истэр Бей»", -1490.33, -209.543, 15.406, -1264.4, -148.388, 25.406},
		{"Гарсия", -2395.14, -222.589, -5.3, -2354.09, -204.792, 200},
		{"Шейди Кэбэн", -1632.83, -2263.44, -3, -1601.33, -2231.79, 200},
		{"Восточный Лос-Сантос", 2381.68, -1494.03, -89.084, 2421.03, -1454.35, 110.916},
		{"Грузовое депо Лас-Вентураса", 1236.63, 1163.41, -89.084, 1277.05, 1203.28, 110.916},
		{"Пересечение Блэкфилда", 1277.05, 1044.69, -89.084, 1315.35, 1087.63, 110.916},
		{"Клуб Ависпа Кантри", -2470.04, -355.493, 0, -2270.04, -318.493, 46.1},
		{"Темпэл", 1252.33, -926.999, -89.084, 1357, -910.17, 110.916},
		{"Станция Единства", 1692.62, -1971.8, -20.492, 1812.62, -1932.8, 79.508},
		{"Грузовое депо Лас-Вентураса", 1315.35, 1044.69, -89.084, 1375.6, 1087.63, 110.916},
		{"Цветочный Лос-Сантоса", 2581.73, -1454.35, -89.084, 2632.83, -1393.42, 110.916},
		{"Казино Старфиш ЛВ", 2437.39, 1858.1, -39.084, 2495.09, 1970.85, 60.916},
		{"Хим. завод на острове Пасхи", -1132.82, -787.391, 0, -956.476, -768.027, 200},
		{"Центр Лос-Сантоса", 1370.85, -1170.87, -89.084, 1463.9, -1130.85, 110.916},
		{"Эспланда Уэст", -1620.3, 1176.52, -4.5, -1580.01, 1274.26, 200},
		{"Станция Маркет", 787.461, -1410.93, -34.126, 866.009, -1310.21, 65.874},
		{"ЖД вокзал Лас-Вентурас", 2811.25, 1229.59, -39.594, 2861.25, 1407.59, 60.406},
		{"Пересечение Монтгомери", 1582.44, 347.457, 0, 1664.62, 401.75, 200},
		{"Мост Фредерик-Бридж", 2759.25, 296.501, 0, 2774.25, 594.757, 200},
		{"Станция Йелoу Бел", 1377.48, 2600.43, -21.926, 1492.45, 2687.36, 78.074},
		{"Центр Лос-Сантоса", 1507.51, -1385.21, 110.916, 1582.55, -1325.31, 335.916},
		{"Джефферсон", 2185.33, -1210.74, -89.084, 2281.45, -1154.59, 110.916},
		{"Малхолланд", 1318.13, -910.17, -89.084, 1357, -768.027, 110.916},
		{"Клуб Ависпа Кантри", -2361.51, -417.199, 0, -2270.04, -355.493, 200},
		{"Джефферсон", 1996.91, -1449.67, -89.084, 2056.86, -1350.72, 110.916},
		{"Восточный Юлий Траувей", 1236.63, 2142.86, -89.084, 1297.47, 2243.23, 110.916},
		{"Джефферсон", 2124.66, -1494.03, -89.084, 2266.21, -1449.67, 110.916},
		{"Северный Юлий Траувей", 1848.4, 2478.49, -89.084, 1938.8, 2553.49, 110.916},
		{"Родео", 422.68, -1570.2, -89.084, 466.223, -1406.05, 110.916},
		{"ЖД СФ", -2007.83, 56.306, 0, -1922, 224.782, 100},
		{"Центр Лос-Сантоса", 1391.05, -1026.33, -89.084, 1463.9, -926.999, 110.916},
		{"Рэдсендс Уэст", 1704.59, 2243.23, -89.084, 1777.39, 2342.83, 110.916},
		{"Маленькая Мексика", 1758.9, -1722.26, -89.084, 1812.62, -1577.59, 110.916},
		{"Пилсэн Интэрсекшн", 1375.6, 823.228, -89.084, 1457.39, 919.447, 110.916},
		{"Аэропорт Лос-Сантос", 1974.63, -2394.33, -39.084, 2089, -2256.59, 60.916},
		{"Бикэн Хил ", -399.633, -1075.52, -1.489, -319.033, -977.516, 198.511},
		{"Родео", 334.503, -1501.95, -89.084, 422.68, -1406.05, 110.916},
		{"Ричмэн", 225.165, -1369.62, -89.084, 334.503, -1292.07, 110.916},
		{"Центр Лос-Сантоса", 1724.76, -1250.9, -89.084, 1812.62, -1150.87, 110.916},
		{"Центральная улица ЛВ", 2027.4, 1703.23, -89.084, 2137.4, 1783.23, 110.916},
		{"Центр Лос-Сантоса", 1378.33, -1130.85, -89.084, 1463.9, -1026.33, 110.916},
		{"Пилсэн Интэрсекшн", 1197.39, 1044.69, -89.084, 1277.05, 1163.39, 110.916},
		{"Конференц-центр", 1073.22, -1842.27, -89.084, 1323.9, -1804.21, 110.916},
		{"Монтгомери", 1451.4, 347.457, -6.1, 1582.44, 420.802, 200},
		{"Фостер-Валли", -2270.04, -430.276, -1.2, -2178.69, -324.114, 200},
		{"Часовня Блэкфилда", 1325.6, 596.349, -89.084, 1375.6, 795.01, 110.916},
		{"Аэропорт Лос-Сантоса", 2051.63, -2597.26, -39.084, 2152.45, -2394.33, 60.916},
		{"Малхолланд", 1096.47, -910.17, -89.084, 1169.13, -768.027, 110.916},
		{"Гольф клуб", 1457.46, 2723.23, -89.084, 1534.56, 2863.23, 110.916},
		{"Центральная улица ЛВ", 2027.4, 1783.23, -89.084, 2162.39, 1863.23, 110.916},
		{"Джефферсон", 2056.86, -1210.74, -89.084, 2185.33, -1126.32, 110.916},
		{"Малхолланд", 952.604, -937.184, -89.084, 1096.47, -860.619, 110.916},
		{"Заброшенная каменная деревня", -1372.14, 2498.52, 0, -1277.59, 2615.35, 200},
		{"Лас-Колинас", 2126.86, -1126.32, -89.084, 2185.33, -934.489, 110.916},
		{"Лас-Колинас", 1994.33, -1100.82, -89.084, 2056.86, -920.815, 110.916},
		{"Ричмэн", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
		{"Грузовое депо Лас-Вентураса", 1277.05, 1087.63, -89.084, 1375.6, 1203.28, 110.916},
		{"Северный Юлий Траувей", 1377.39, 2433.23, -89.084, 1534.56, 2507.23, 110.916},
		{"Виллоуфилд", 2201.82, -2095, -89.084, 2324, -1989.9, 110.916},
		{"Северный Юлий Траувей", 1704.59, 2342.83, -89.084, 1848.4, 2433.23, 110.916},
		{"Темпл", 1252.33, -1130.85, -89.084, 1378.33, -1026.33, 110.916},
		{"Маленькая Мексика", 1701.9, -1842.27, -89.084, 1812.62, -1722.26, 110.916},
		{"Квинс", -2411.22, 373.539, 0, -2253.54, 458.411, 200},
		{"Аэропорт Лас-Вентурас", 1515.81, 1586.4, -12.5, 1729.95, 1714.56, 87.5},
		{"Ричмэн", 225.165, -1292.07, -89.084, 466.223, -1235.07, 110.916},
		{"Темпл", 1252.33, -1026.33, -89.084, 1391.05, -926.999, 110.916},
		{"Восточный Лос-Сантос", 2266.26, -1494.03, -89.084, 2381.68, -1372.04, 110.916},
		{"Восточный Юлий Траувей", 2623.18, 943.235, -89.084, 2749.9, 1055.96, 110.916},
		{"Виллоуфилд", 2541.7, -1941.4, -89.084, 2703.58, -1852.87, 110.916},
		{"Лас-Колинас", 2056.86, -1126.32, -89.084, 2126.86, -920.815, 110.916},
		{"Восточный Юлий Траувей", 2625.16, 2202.76, -89.084, 2685.16, 2442.55, 110.916},
		{"Родео", 225.165, -1501.95, -89.084, 334.503, -1369.62, 110.916},
		{"Заброшенная деревня ЛВ", -365.167, 2123.01, -3, -208.57, 2217.68, 200},
		{"Восточный Юлий Траувей", 2536.43, 2442.55, -89.084, 2685.16, 2542.55, 110.916},
		{"Родео", 334.503, -1406.05, -89.084, 466.223, -1292.07, 110.916},
		{"Вайнвуд", 647.557, -1227.28, -89.084, 787.461, -1118.28, 110.916},
		{"Родео", 422.68, -1684.65, -89.084, 558.099, -1570.2, 110.916},
		{"Северный Юлий Траувей", 2498.21, 2542.55, -89.084, 2685.16, 2626.55, 110.916},
		{"Центр Лос-Сантоса", 1724.76, -1430.87, -89.084, 1812.62, -1250.9, 110.916},
		{"Родео", 225.165, -1684.65, -89.084, 312.803, -1501.95, 110.916},
		{"Джефферсон", 2056.86, -1449.67, -89.084, 2266.21, -1372.04, 110.916},
		{"Хэмптэн Барнз ", 603.035, 264.312, 0, 761.994, 366.572, 200},
		{"Тэмпл", 1096.47, -1130.84, -89.084, 1252.33, -1026.33, 110.916},
		{"Мост Кинкейд", -1087.93, 855.37, -89.084, -961.95, 986.281, 110.916},
		{"Пляж Вероны", 1046.15, -1722.26, -89.084, 1161.52, -1577.59, 110.916},
		{"Коммерция", 1323.9, -1722.26, -89.084, 1440.9, -1577.59, 110.916},
		{"Малхолланд", 1357, -926.999, -89.084, 1463.9, -768.027, 110.916},
		{"Родео", 466.223, -1570.2, -89.084, 558.099, -1385.07, 110.916},
		{"Малхолланд", 911.802, -860.619, -89.084, 1096.47, -768.027, 110.916},
		{"Малхолланд", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
		{"Южный Юлий Траувей", 2377.39, 788.894, -89.084, 2537.39, 897.901, 110.916},
		{"Идлвуд", 1812.62, -1852.87, -89.084, 1971.66, -1742.31, 110.916},
		{"Оушен Докс", 2089, -2394.33, -89.084, 2201.82, -2235.84, 110.916},
		{"Коммерция", 1370.85, -1577.59, -89.084, 1463.9, -1384.95, 110.916},
		{"Северный Юлий Траувей", 2121.4, 2508.23, -89.084, 2237.4, 2663.17, 110.916},
		{"Тэмпл", 1096.47, -1026.33, -89.084, 1252.33, -910.17, 110.916},
		{"Глен-Парк", 1812.62, -1449.67, -89.084, 1996.91, -1350.72, 110.916},
		{"Аэропорт СФ", -1242.98, -50.096, 0, -1213.91, 578.396, 200},
		{"Мартин Бридж", -222.179, 293.324, 0, -122.126, 476.465, 200},
		{"Центральная улица ЛВ", 2106.7, 1863.23, -89.084, 2162.39, 2202.76, 110.916},
		{"Виллоуфилд", 2541.7, -2059.23, -89.084, 2703.58, -1941.4, 110.916},
		{"Марина", 807.922, -1577.59, -89.084, 926.922, -1416.25, 110.916},
		{"Аэропорт Лас-Вентурас", 1457.37, 1143.21, -89.084, 1777.4, 1203.28, 110.916},
		{"Идлвуд", 1812.62, -1742.31, -89.084, 1951.66, -1602.31, 110.916},
		{"Западная Эспланада", -1580.01, 1025.98, -6.1, -1499.89, 1274.26, 200},
		{"Центр Лос-Сантоса", 1370.85, -1384.95, -89.084, 1463.9, -1170.87, 110.916},
		{"Мако Спан", 1664.62, 401.75, 0, 1785.14, 567.203, 200},
		{"Родео", 312.803, -1684.65, -89.084, 422.68, -1501.95, 110.916},
		{"Площадь Першинга", 1440.9, -1722.26, -89.084, 1583.5, -1577.59, 110.916},
		{"Малхолланд", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
		{"Мост Гарвер", -2741.07, 1490.47, -6.1, -2616.4, 1659.68, 200},
		{"Лас-Колинас", 2185.33, -1154.59, -89.084, 2281.45, -934.489, 110.916},
		{"Малхолланд", 1169.13, -910.17, -89.084, 1318.13, -768.027, 110.916},
		{"Северный Юлий Траувей", 1938.8, 2508.23, -89.084, 2121.4, 2624.23, 110.916},
		{"Коммерция", 1667.96, -1577.59, -89.084, 1812.62, -1430.87, 110.916},
		{"Родео", 72.648, -1544.17, -89.084, 225.165, -1404.97, 110.916},
		{"Рока Эскаланте", 2536.43, 2202.76, -89.084, 2625.16, 2442.55, 110.916},
		{"Родео", 72.648, -1684.65, -89.084, 225.165, -1544.17, 110.916},
		{"Маркет", 952.663, -1310.21, -89.084, 1072.66, -1130.85, 110.916},
		{"Лас-Колинас", 2632.74, -1135.04, -89.084, 2747.74, -945.035, 110.916},
		{"Малхолланд", 861.085, -674.885, -89.084, 1156.55, -600.896, 110.916},
		{"Кингс", -2253.54, 373.539, -9.1, -1993.28, 458.411, 200},
		{"Рэдсендс Уэст", 1848.4, 2342.83, -89.084, 2011.94, 2478.49, 110.916},
		{"Центр", -1580.01, 744.267, -6.1, -1499.89, 1025.98, 200},
		{"Конференц-центр", 1046.15, -1804.21, -89.084, 1323.9, -1722.26, 110.916},
		{"Ричмэн", 647.557, -1118.28, -89.084, 787.461, -954.662, 110.916},
		{"Оушэн Флэтс", -2994.49, 277.411, -9.1, -2867.85, 458.411, 200},
		{"Колледж Греггласс", 964.391, 930.89, -89.084, 1166.53, 1044.69, 110.916},
		{"Глен-Парк", 1812.62, -1100.82, -89.084, 1994.33, -973.38, 110.916},
		{"Грузовое депо Лас-Вентураса", 1375.6, 919.447, -89.084, 1457.37, 1203.28, 110.916},
		{"Гейзер", -405.77, 1712.86, -3, -276.719, 1892.75, 200},
		{"Пляж Вероны", 1161.52, -1722.26, -89.084, 1323.9, -1577.59, 110.916},
		{"Восточный Лос-Сантос", 2281.45, -1372.04, -89.084, 2381.68, -1135.04, 110.916},
		{"Калигула", 2137.4, 1703.23, -89.084, 2437.39, 1783.23, 110.916},
		{"Идлвуд", 1951.66, -1742.31, -89.084, 2124.66, -1602.31, 110.916},
		{"Пилгрим", 2624.4, 1383.23, -89.084, 2685.16, 1783.23, 110.916},
		{"Идлвуд", 2124.66, -1742.31, -89.084, 2222.56, -1494.03, 110.916},
		{"Квинс", -2533.04, 458.411, 0, -2329.31, 578.396, 200},
		{"Центр", -1871.72, 1176.42, -4.5, -1620.3, 1274.26, 200},
		{"Коммерция", 1583.5, -1722.26, -89.084, 1758.9, -1577.59, 110.916},
		{"Восточный Лос-Сантос", 2381.68, -1454.35, -89.084, 2462.13, -1135.04, 110.916},
		{"Марина", 647.712, -1577.59, -89.084, 807.922, -1416.25, 110.916},
		{"Ричмэн", 72.648, -1404.97, -89.084, 225.165, -1235.07, 110.916},
		{"Вайнвуд", 647.712, -1416.25, -89.084, 787.461, -1227.28, 110.916},
		{"Восточный Лос-Сантос", 2222.56, -1628.53, -89.084, 2421.03, -1494.03, 110.916},
		{"Родео", 558.099, -1684.65, -89.084, 647.522, -1384.93, 110.916},
		{"Восточный тунель", -1709.71, -833.034, -1.5, -1446.01, -730.118, 200},
		{"Родео", 466.223, -1385.07, -89.084, 647.522, -1235.07, 110.916},
		{"Рэдсендс Уэст", 1817.39, 2202.76, -89.084, 2011.94, 2342.83, 110.916},
		{"Карман клоуна", 2162.39, 1783.23, -89.084, 2437.39, 1883.23, 110.916},
		{"Идлвуд", 1971.66, -1852.87, -89.084, 2222.56, -1742.31, 110.916},
		{"Пересечение Монтгомери", 1546.65, 208.164, 0, 1745.83, 347.457, 200},
		{"Виллоуфилд", 2089, -2235.84, -89.084, 2201.82, -1989.9, 110.916},
		{"Тэмпл", 952.663, -1130.84, -89.084, 1096.47, -937.184, 110.916},
		{"Пинкл Пайн", 1848.4, 2553.49, -89.084, 1938.8, 2863.23, 110.916},
		{"Аэропорт Лос-Сантос", 1400.97, -2669.26, -39.084, 2189.82, -2597.26, 60.916},
		{"Мост Гарвер", -1213.91, 950.022, -89.084, -1087.93, 1178.93, 110.916},
		{"Мост Гарвер", -1339.89, 828.129, -89.084, -1213.91, 1057.04, 110.916},
		{"Мост Кинкейд", -1339.89, 599.218, -89.084, -1213.91, 828.129, 110.916},
		{"Мост Кинкейд", -1213.91, 721.111, -89.084, -1087.93, 950.022, 110.916},
		{"Пляж Вероны", 930.221, -2006.78, -89.084, 1073.22, -1804.21, 110.916},
		{"Вёрдэнт Блафс ", 1073.22, -2006.78, -89.084, 1249.62, -1842.27, 110.916},
		{"Вайнвуд", 787.461, -1130.84, -89.084, 952.604, -954.662, 110.916},
		{"Вайнвуд", 787.461, -1310.21, -89.084, 952.663, -1130.84, 110.916},
		{"Коммерция", 1463.9, -1577.59, -89.084, 1667.96, -1430.87, 110.916},
		{"Маркет", 787.461, -1416.25, -89.084, 1072.66, -1310.21, 110.916},
		{"Западный Рокшор", 2377.39, 596.349, -89.084, 2537.39, 788.894, 110.916},
		{"Северный Юлий Траувей", 2237.4, 2542.55, -89.084, 2498.21, 2663.17, 110.916},
		{"Восточный пляж", 2632.83, -1668.13, -89.084, 2747.74, -1393.42, 110.916},
		{"Мост Феллоу", 434.341, 366.572, 0, 603.035, 555.68, 200},
		{"Виллоуфилд", 2089, -1989.9, -89.084, 2324, -1852.87, 110.916},
		{"Чайнатаун", -2274.17, 578.396, -7.6, -2078.67, 744.17, 200},
		{"Эль-Кастильо-дель-Диабло", -208.57, 2337.18, 0, 8.43, 2487.18, 200},
		{"Оушен Докс", 2324, -2145.1, -89.084, 2703.58, -2059.23, 110.916},
		{"Истэр Бей Кемикэлз", -1132.82, -768.027, 0, -956.476, -578.118, 200},
		{"Отель Визаж", 1817.39, 1703.23, -89.084, 2027.4, 1863.23, 110.916},
		{"Оушэн Флэтс", -2994.49, -430.276, -1.2, -2831.89, -222.589, 200},
		{"Ричмэн", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
		{"Грин Памз ", 176.581, 1305.45, -3, 338.658, 1520.72, 200},
		{"Ричмэн", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
		{"Казино Старфиш", 2162.39, 1883.23, -89.084, 2437.39, 2012.18, 110.916},
		{"Восточный пляж", 2747.74, -1668.13, -89.084, 2959.35, -1498.62, 110.916},
		{"Джефферсон", 2056.86, -1372.04, -89.084, 2281.45, -1210.74, 110.916},
		{"Центр Лос-Сантоса", 1463.9, -1290.87, -89.084, 1724.76, -1150.87, 110.916},
		{"Центр Лос-Сантоса", 1463.9, -1430.87, -89.084, 1724.76, -1290.87, 110.916},
		{"Мост Гарвер", -1499.89, 696.442, -179.615, -1339.89, 925.353, 20.385},
		{"Южный Юлий Траувей", 1457.39, 823.228, -89.084, 2377.39, 863.229, 110.916},
		{"Восточный Лос-Сантос", 2421.03, -1628.53, -89.084, 2632.83, -1454.35, 110.916},
		{"Колледж Греггласс", 964.391, 1044.69, -89.084, 1197.39, 1203.22, 110.916},
		{"Лас-Колинас", 2747.74, -1120.04, -89.084, 2959.35, -945.035, 110.916},
		{"Малхолланд", 737.573, -768.027, -89.084, 1142.29, -674.885, 110.916},
		{"Оушен Докс", 2201.82, -2730.88, -89.084, 2324, -2418.33, 110.916},
		{"Восточный Лос-Сантос", 2462.13, -1454.35, -89.084, 2581.73, -1135.04, 110.916},
		{"Гантон", 2222.56, -1722.33, -89.084, 2632.83, -1628.53, 110.916},
		{"Клуб Ависпа Кантри", -2831.89, -430.276, -6.1, -2646.4, -222.589, 200},
		{"Виллоуфилд", 1970.62, -2179.25, -89.084, 2089, -1852.87, 110.916},
		{"Северная Эспланада", -1982.32, 1274.26, -4.5, -1524.24, 1358.9, 200},
		{"Хай Рoулэр", 1817.39, 1283.23, -89.084, 2027.39, 1469.23, 110.916},
		{"Оушен Докс", 2201.82, -2418.33, -89.084, 2324, -2095, 110.916},
		{"Мотель Ласт Дайм", 1823.08, 596.349, -89.084, 1997.22, 823.228, 110.916},
		{"Бейсайд Марина ", -2353.17, 2275.79, 0, -2153.17, 2475.79, 200},
		{"Кингс", -2329.31, 458.411, -7.6, -1993.28, 578.396, 200},
		{"Эль-Корона", 1692.62, -2179.25, -89.084, 1812.62, -1842.27, 110.916},
		{"Часовня Блэкфилда", 1375.6, 596.349, -89.084, 1558.09, 823.228, 110.916},
		{"Розовый Лебедь", 1817.39, 1083.23, -89.084, 2027.39, 1283.23, 110.916},
		{"Восточная Автострада Джулиуса", 1197.39, 1163.39, -89.084, 1236.63, 2243.23, 110.916},
		{"Лос Флорес", 2581.73, -1393.42, -89.084, 2747.74, -1135.04, 110.916},
		{"Визаж", 1817.39, 1863.23, -89.084, 2106.7, 2011.83, 110.916},
		{"Колючая сосна", 1938.8, 2624.23, -89.084, 2121.4, 2861.55, 110.916},
		{"Пляж Вероны", 851.449, -1804.21, -89.084, 1046.15, -1577.59, 110.916},
		{"Пересечение Робады", -1119.01, 1178.93, -89.084, -862.025, 1351.45, 110.916},
		{"Линден Сайд", 2749.9, 943.235, -89.084, 2923.39, 1198.99, 110.916},
		{"Океанские доки", 2703.58, -2302.33, -89.084, 2959.35, -2126.9, 110.916},
		{"Ивовое поле", 2324, -2059.23, -89.084, 2541.7, -1852.87, 110.916},
		{"Королевский", -2411.22, 265.243, -9.1, -1993.28, 373.539, 200},
		{"Коммерческий", 1323.9, -1842.27, -89.084, 1701.9, -1722.26, 110.916},
		{"Малхолланд", 1269.13, -768.027, -89.084, 1414.07, -452.425, 110.916},
		{"Марина", 647.712, -1804.21, -89.084, 851.449, -1577.59, 110.916},
		{"Точка батареи", -2741.07, 1268.41, -4.5, -2533.04, 1490.47, 200},
		{"Казино «Четыре Дракона»", 1817.39, 863.232, -89.084, 2027.39, 1083.23, 110.916},
		{"Черное поле", 964.391, 1203.22, -89.084, 1197.39, 1403.22, 110.916},
		{"Северная Автострада Джулиуса", 1534.56, 2433.23, -89.084, 1848.4, 2583.23, 110.916},
		{"Поле для гольфа «Желтый колокол»", 1117.4, 2723.23, -89.084, 1457.46, 2863.23, 110.916},
		{"Ленивое дерево", 1812.62, -1602.31, -89.084, 2124.66, -1449.67, 110.916},
		{"Восточные красные пески", 1297.47, 2142.86, -89.084, 1777.39, 2243.23, 110.916},
		{"Дохерти", -2270.04, -324.114, -1.2, -1794.92, -222.589, 200},
		{"Ферма «Хиллтоп»", 967.383, -450.39, -3, 1176.78, -217.9, 200},
		{"Лас-Барранкас", -926.13, 1398.73, -3, -719.234, 1634.69, 200},
		{"Пираты в мужских штанах", 1817.39, 1469.23, -89.084, 2027.4, 1703.23, 110.916},
		{"Здание муниципалитета", -2867.85, 277.411, -9.1, -2593.44, 458.411, 200},
		{"Деревенский клуб «Авинса»", -2646.4, -355.493, 0, -2270.04, -222.589, 200},
		{"Полоса", 2027.4, 863.229, -89.084, 2087.39, 1703.23, 110.916},
		{"Хашбури", -2593.44, -222.589, -1, -2411.22, 54.722, 200},
		{"Междунородный ЛС", 1852, -2394.33, -89.084, 2089, -2179.25, 110.916},
		{"Усадебные поместья", 1098.31, 1726.22, -89.084, 1197.39, 2243.23, 110.916},
		{"Шерманское водохранилище", -789.737, 1659.68, -89.084, -599.505, 1929.41, 110.916},
		{"Эль Корона", 1812.62, -2179.25, -89.084, 1970.62, -1852.87, 110.916},
		{"Центральный", -1700.01, 744.267, -6.1, -1580.01, 1176.52, 200},
		{"Фостер-Валли", -2178.69, -1250.97, 0, -1794.92, -1115.58, 200},
		{"Лас-Пейасадас", -354.332, 2580.36, 2, -133.625, 2816.82, 200},
		{"Скрытая долина", -936.668, 2611.44, 2, -715.961, 2847.9, 200},
		{"Пересечение Блэкфилда", 1166.53, 795.01, -89.084, 1375.6, 1044.69, 110.916},
		{"Гэнтон", 2222.56, -1852.87, -89.084, 2632.83, -1722.33, 110.916},
		{"Аэропорт «Пасхального залива»", -1213.91, -730.118, 0, -1132.82, -50.096, 200},
		{"Западные красные пески", 1817.39, 2011.83, -89.084, 2106.7, 2202.76, 110.916},
		{"Восточная Эспаланада", -1499.89, 578.396, -79.615, -1339.89, 1274.26, 20.385},
		{"Дворец Калигулы", 2087.39, 1543.23, -89.084, 2437.39, 1703.23, 110.916},
		{"Королевское казино", 2087.39, 1383.23, -89.084, 2437.39, 1543.23, 110.916},
		{"Ричмен", 72.648, -1235.07, -89.084, 321.356, -1008.15, 110.916},
		{"Казино «Морская звезда»", 2437.39, 1783.23, -89.084, 2685.16, 2012.18, 110.916},
		{"Малхолланд", 1281.13, -452.425, -89.084, 1641.13, -290.913, 110.916},
		{"Центральный", -1982.32, 744.17, -6.1, -1871.72, 1274.26, 200},
		{"Хэнкипенки", 2576.92, 62.158, 0, 2759.25, 385.503, 200},
		{"K.A.C.C. Военное топливо", 2498.21, 2626.55, -89.084, 2749.9, 2861.55, 110.916},
		{"Гарри Голд-Парквей", 1777.39, 863.232, -89.084, 1817.39, 2342.83, 110.916},
		{"Тоннель «Бейсайд»", -2290.19, 2548.29, -89.084, -1950.19, 2723.29, 110.916},
		{"Океанские доки", 2324, -2302.33, -89.084, 2703.58, -2145.1, 110.916},
		{"Ричмэн", 321.356, -1044.07, -89.084, 647.557, -860.619, 110.916},
		{"Промышленная недвижимость «Рендольф»", 1558.09, 596.349, -89.084, 1823.08, 823.235, 110.916},
		{"Восточный пляж", 2632.83, -1852.87, -89.084, 2959.35, -1668.13, 110.916},
		{"Флинтовые воды", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
		{"Блюберри", 19.607, -404.136, 3.8, 349.607, -220.137, 200},
		{"Станция «Линден»", 2749.9, 1198.99, -89.084, 2923.39, 1548.99, 110.916},
		{"Парк «Глен»", 1812.62, -1350.72, -89.084, 2056.86, -1100.82, 110.916},
		{"Центральный", -1993.28, 265.243, -9.1, -1794.92, 578.396, 200},
		{"Западные красные пески", 1377.39, 2243.23, -89.084, 1704.59, 2433.23, 110.916},
		{"Ричмен", 321.356, -1235.07, -89.084, 647.522, -1044.07, 110.916},
		{"Мост Гант", -2741.45, 1659.68, -6.1, -2616.4, 2175.15, 200},
		{"Лил Пробин", -90.218, 1286.85, -3, 153.859, 1554.12, 200},
		{"Пересечение «Флинта»", -187.7, -1596.76, -89.084, 17.063, -1276.6, 110.916},
		{"Лас-Колинас", 2281.45, -1135.04, -89.084, 2632.74, -945.035, 110.916},
		{"Железная дорога «Собелл»", 2749.9, 1548.99, -89.084, 2923.39, 1937.25, 110.916},
		{"Изумрудный остров", 2011.94, 2202.76, -89.084, 2237.4, 2508.23, 110.916},
		{"Эль-Кастильо-дель-Диабло", -208.57, 2123.01, -7.6, 114.033, 2337.18, 200},
		{"Санта Флора", -2741.07, 458.411, -7.6, -2533.04, 793.411, 200},
		{"Плайя-дель-Севилья", 2703.58, -2126.9, -89.084, 2959.35, -1852.87, 110.916},
		{"Рыночный", 926.922, -1577.59, -89.084, 1370.85, -1416.25, 110.916},
		{"Царский", -2593.44, 54.722, 0, -2411.22, 458.411, 200},
		{"Пересечение «Пильсона»", 1098.39, 2243.23, -89.084, 1377.39, 2507.23, 110.916},
		{"Спайнибэд", 2121.4, 2663.17, -89.084, 2498.21, 2861.55, 110.916},
		{"Пилигрим", 2437.39, 1383.23, -89.084, 2624.4, 1783.23, 110.916},
		{"Черное поле", 964.391, 1403.22, -89.084, 1197.39, 1726.22, 110.916},
		{"'Большое ухо", -410.02, 1403.34, -3, -137.969, 1681.23, 200},
		{"Диллимор", 580.794, -674.885, -9.5, 861.085, -404.79, 200},
		{"Эль Къюбредос", -1645.23, 2498.52, 0, -1372.14, 2777.85, 200},
		{"Северная эспланада", -2533.04, 1358.9, -4.5, -1996.66, 1501.21, 200},
		{"Аэропорт «Пасхальный залив»", -1499.89, -50.096, -1, -1242.98, 249.904, 200},
		{"Рыбачья лагуна", 1916.99, -233.323, -100, 2131.72, 13.8, 200},
		{"Малхолланд", 1414.07, -768.027, -89.084, 1667.61, -452.425, 110.916},
		{"Восточный пляж", 2747.74, -1498.62, -89.084, 2959.35, -1120.04, 110.916},
		{"Звук Сан-Андреса", 2450.39, 385.503, -100, 2759.25, 562.349, 200},
		{"Бухта Шэди", -2030.12, -2174.89, -6.1, -1820.64, -1771.66, 200},
		{"Рыночный", 1072.66, -1416.25, -89.084, 1370.85, -1130.85, 110.916},
		{"Западный каменный берег", 1997.22, 596.349, -89.084, 2377.39, 823.228, 110.916},
		{"Колючая сосна", 1534.56, 2583.23, -89.084, 1848.4, 2863.23, 110.916},
		{"Пасхальный бассейн", -1794.92, -50.096, -1.04, -1499.89, 249.904, 200},
		{"Лиственный", -1166.97, -1856.03, 0, -815.624, -1602.07, 200},
		{"ЛВА Грузовые склады", 1457.39, 863.229, -89.084, 1777.4, 1143.21, 110.916},
		{"Колючая сосна", 1117.4, 2507.23, -89.084, 1534.56, 2723.23, 110.916},
		{"Блюберри", 104.534, -220.137, 2.3, 349.607, 152.236, 200},
		{"Эль-Кастильо-дель-Диабло", -464.515, 2217.68, 0, -208.57, 2580.36, 200},
		{"Центральный", -2078.67, 578.396, -7.6, -1499.89, 744.267, 200},
		{"Восточный каменный берег", 2537.39, 676.549, -89.084, 2902.35, 943.235, 110.916},
		{"Залив Сан-Ферро", -2616.4, 1501.21, -3, -1996.66, 1659.68, 200},
		{"Парадисо", -2741.07, 793.411, -6.1, -2533.04, 1268.41, 200},
		{"Верблюжонка", 2087.39, 1203.23, -89.084, 2640.4, 1383.23, 110.916},
		{"Старая полоса Вентураса", 2162.39, 2012.18, -89.084, 2685.16, 2202.76, 110.916},
		{"Возвышенный можевельник", -2533.04, 578.396, -7.6, -2274.17, 968.369, 200},
		{"Пустотный можевельник", -2533.04, 968.369, -6.1, -2274.17, 1358.9, 200},
		{"Рока Эскаланте", 2237.4, 2202.76, -89.084, 2536.43, 2542.55, 110.916},
		{"Восточная Автострада Джулиуса", 2685.16, 1055.96, -89.084, 2749.9, 2626.55, 110.916},
		{"Пляж Вероны", 647.712, -2173.29, -89.084, 930.221, -1804.21, 110.916},
		{"Фостер-Валли", -2178.69, -599.884, -1.2, -1794.92, -324.114, 200},
		{"Дуга Запада", -901.129, 2221.86, 0, -592.09, 2571.97, 200},
		{"Падшее дерево", -792.254, -698.555, -5.3, -452.404, -380.043, 200},
		{"Ферма", -1209.67, -1317.1, 114.981, -908.161, -787.391, 251.981},
		{"Плотина Шермана", -968.772, 1929.41, -3, -481.126, 2155.26, 200},
		{"Северная эспланада", -1996.66, 1358.9, -4.5, -1524.24, 1592.51, 200},
		{"Финансовый", -1871.72, 744.17, -6.1, -1701.3, 1176.42, 300},
		{"Гарсиа", -2411.22, -222.589, -1.14, -2173.04, 265.243, 200},
		{"Монтгомери", 1119.51, 119.526, -3, 1451.4, 493.323, 200},
		{"Бухта", 2749.9, 1937.25, -89.084, 2921.62, 2669.79, 110.916},
		{"Международный союз Лос-Сантоса", 1249.62, -2394.33, -89.084, 1852, -2179.25, 110.916},
		{"Пляж «Санта Мария»", 72.648, -2173.29, -89.084, 342.648, -1684.65, 110.916},
		{"Пересечение «Малхолланд»", 1463.9, -1150.87, -89.084, 1812.62, -768.027, 110.916},
		{"Ангельская сосна", -2324.94, -2584.29, -6.1, -1964.22, -2212.11, 200},
		{"Зелёные луга", 37.032, 2337.18, -3, 435.988, 2677.9, 200},
		{"Октановые пружины", 338.658, 1228.51, 0, 664.308, 1655.05, 200},
		{"Комелот", 2087.39, 943.235, -89.084, 2623.18, 1203.23, 110.916},
		{"Западные красные пески", 1236.63, 1883.11, -89.084, 1777.39, 2142.86, 110.916},
		{"Пляж «Санта Мария»", 342.648, -2173.29, -89.084, 647.712, -1684.65, 110.916},
		{"Зеленеющий обрыв", 1249.62, -2179.25, -89.084, 1692.62, -1842.27, 110.916},
		{"Аэропорт «Лас-Вентурас»", 1236.63, 1203.28, -89.084, 1457.37, 1883.11, 110.916},
		{"Область флинта", -594.191, -1648.55, 0, -187.7, -1276.6, 200},
		{"Зеленеющий обрыв", 930.221, -2488.42, -89.084, 1249.62, -2006.78, 110.916},
		{"Паломино-Крик", 2160.22, -149.004, 0, 2576.92, 228.322, 200},
		{"Океанские доки", 2373.77, -2697.09, -89.084, 2809.22, -2330.46, 110.916},
		{"Аэропорт «Пасхального залива»", -1213.91, -50.096, -4.5, -947.98, 578.396, 200},
		{"Усадебные поместья", 883.308, 1726.22, -89.084, 1098.31, 2507.23, 110.916},
		{"Вершина Калтона", -2274.17, 744.17, -6.1, -1982.32, 1358.9, 200},
		{"Пасхальный бассейн", -1794.92, 249.904, -9.1, -1242.98, 578.396, 200},
		{"Въезд в Лос-Сантос", -321.744, -2224.43, -89.084, 44.615, -1724.43, 110.916},
		{"Духерти", -2173.04, -222.589, -1, -1794.92, 265.243, 200},
		{"Гора Чилиад", -2178.69, -2189.91, -47.917, -2030.12, -1771.66, 576.083},
		{"Форт Карсон", -376.233, 826.326, -3, 123.717, 1220.44, 200},
		{"Фостер-Валли", -2178.69, -1115.58, 0, -1794.92, -599.884, 200},
		{"Океанская равнина", -2994.49, -222.589, -1, -2593.44, 277.411, 200},
		{"Ферн Ридж", 508.189, -139.259, 0, 1306.66, 119.526, 200},
		{"Байсайд", -2741.07, 2175.15, 0, -2353.17, 2722.79, 200},
		{"Аэропорт «Лас-Вентурас»", 1457.37, 1203.28, -89.084, 1777.39, 1883.11, 110.916},
		{"Поместье «Блюберри»", -319.676, -220.137, 0, 104.534, 293.324, 200},
		{"Базальтовые столбы", -2994.49, 458.411, -6.1, -2741.07, 1339.61, 200},
		{"Северный камень", 2285.37, -768.027, 0, 2770.59, -269.74, 200},
		{"Охотничий карьер", 337.244, 710.84, -115.239, 860.554, 1031.71, 203.761},
		{"Международный союз Лос-Сантоса", 1382.73, -2730.88, -89.084, 2201.82, -2394.33, 110.916},
		{"Миссионер Хилл", -2994.49, -811.276, 0, -2178.69, -430.276, 200},
		{"Залив Сан-Ферро", -2616.4, 1659.68, -3, -1996.66, 2175.15, 200},
		{"Запретная зона", -91.586, 1655.05, -50, 421.234, 2123.01, 250},
		{"Гора Чилиад", -2997.47, -1115.58, -47.917, -2178.69, -971.913, 576.083},
		{"Гора Чилиад", -2178.69, -1771.66, -47.917, -1936.12, -1250.97, 576.083},
		{"Аэропорт «Пасхального залива»", -1794.92, -730.118, -3, -1213.91, -50.096, 200},
		{"Паноптикон", -947.98, -304.32, -1.1, -319.676, 327.071, 200},
		{"Бухта Шэди", -1820.64, -2643.68, -8, -1226.78, -1771.66, 200},
		{"Назад o Вне", -1166.97, -2641.19, 0, -321.744, -1856.03, 200},
		{"Гора Чилиад", -2994.49, -2189.91, -47.917, -2178.69, -1115.58, 576.083},
		{"Тьерра Робада", -1213.91, 596.349, -242.99, -480.539, 1659.68, 900},
		{"Округ Флинта", -1213.91, -2892.97, -242.99, 44.615, -768.027, 900},
		{"Точильный камень", -2997.47, -2892.97, -242.99, -1213.91, -1115.58, 900},
		{"Костяной округ", -480.539, 596.349, -242.99, 869.461, 2993.87, 900},
		{"Тьерра Робада", -2997.47, 1659.68, -242.99, -480.539, 2993.87, 900},
		{"Сан-Фиерро", -2997.47, -1115.58, -242.99, -1213.91, 1659.68, 900},
		{"Лас-Вентурас", 869.461, 596.349, -242.99, 2997.06, 2993.87, 900},
		{"Красный округ", -1213.91, -768.027, -242.99, 2997.06, 596.349, 900},
		{"Лос-Сантос", 44.615, -2892.97, -242.99, 2997.06, -768.027, 900},
		{"Новый Остров", 37.7141, -3373.5518, -242.99, 986.0303, -2450.5461, 900},
    }
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return 'Неизвестно'
end
function kvadrat()
	local x, y, z = getCharCoordinates(1)

	if ({
		"А",
		"Б",
		"В",
		"Г",
		"Д",
		"Ж",
		"З",
		"И",
		"К",
		"Л",
		"М",
		"Н",
		"О",
		"П",
		"Р",
		"С",
		"Т",
		"У",
		"Ф",
		"Х",
		"Ц",
		"Ч",
		"Ш",
		"Я"
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
        {fa.HOUSE, u8' Главная'},
        {fa.GEAR, u8' Настройки'},
        {fa.KEYBOARD, u8' Биндер'}, 
        {fa.RAYGUN, u8' Отыгровки оружия'},
		{fa.CHART_PIE, u8' Быстое меню'},
        {fa.ROCKET_LAUNCH, u8' Другое'},
        {fa.CIRCLE_INFO, u8' Информация'},
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
		if imgui.Button(fa.POWER_OFF..u8' Отключить', im2(150, 30)) then
			imgui.OpenPopup(u8"Отключить?")
		end
		if imgui.Button(fa.ROTATE..u8' Перезагрузить', im2(150, 30)) then
			imgui.OpenPopup(u8"Перезагрузить?")
		end
		if imgui.BeginPopupModal(u8"Отключить?", nil, imgui.WindowFlags.AlwaysAutoResize) then
			imgui.Text(u8("Вы уверены что хотите отключить MoJ Helper?\nПовторный запуск будет возможен только при перезаходе в игру. "))
			imgui.Separator()

			if imgui.Button(u8("Да"), imgui.ImVec2(-0.1, 0)) then
				thisScript():unload()
			end

			if imgui.Button(u8("Нет"), imgui.ImVec2(-0.1, 0)) then
				imgui.CloseCurrentPopup()
			end

			imgui.EndPopup()
		end
		if imgui.BeginPopupModal(u8"Перезагрузить?", nil, imgui.WindowFlags.AlwaysAutoResize) then
			imgui.Text(u8("Вы уверены что хотите перезагрузить MoJ Helper?"))
			imgui.Separator()

			if imgui.Button(u8("Да"), imgui.ImVec2(-0.1, 0)) then
				thisScript():reload()
			end

			if imgui.Button(u8("Нет"), imgui.ImVec2(-0.1, 0)) then
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
			tid_marker = "[тэг не задан]"
		else
			tid_marker = id_marker
		end

		if not name_marker then
			tname_marker = "[тэг не задан]"
		else
			tname_marker = name_marker
		end

		if not surname_marker then
			tsurname_marker = "[тэг не задан]"
		else
			tsurname_marker = surname_marker
		end

		if rang1.v == "" then
			trang1 = "[тэг не задан]"
		else
			trang1 = u8:decode(rang1.v)
		end

		if not phone.v or phone.v == "" then
			tphone = "[тэг не задан]"
		else
			tphone = phone.v
		end

		if not gun_name or gun_name == "" then
			tgun_name = "[тэг не задан]"
		else
			tgun_name = gun_name
		end

		if tegr.v == "" then
			ttegr = "тэг не задан"
		else
			ttegr = u8:decode(tegr.v)
		end

		if frak.v == "" then
			tfrak = "[тэг не задан]"
		else
			tfrak = u8:decode(frak.v)
		end

		if tegf.v == "" then
			ttegf = "тэг не задан"
		else
			ttegf = u8:decode(tegf.v)
		end

		if not post or post == "" or post == "Нет" then
			tpost = "[тэг не задан]"
		else
			tpost = post
		end

		if not naparnik_id or naparnik_id == "" then
			tnaparnik_id = "[не задано]"
		else
			tnaparnik_id = naparnik_id
		end

		if not naparnik_nicks or naparnik_nicks == "" then
			tnaparnik_nicks = "[не задано]"
		else
			tnaparnik_nicks = naparnik_nicks
		end

		if not name_car_megafon or name_car_megafon == "" then
			tname_car_megafon = "[не задано]"
		else
			tname_car_megafon = name_car_megafon
		end

		if not id_vodil_megafon or id_vodil_megafon == "" then
			tid_vodil_megafon = "[не задано]"
		else
			tid_vodil_megafon = id_vodil_megafon
		end

		if not zone or zone == "" or zone == "Нет" then
			tzone = "[не задано]"
		else
			tzone = zone
		end

		if not color_car_megafon or color_car_megafon == "" then
			tcolor_car_megafon = "[не задано]"
		else
			tcolor_car_megafon = color_car_megafon
		end

		local taglist_mass = {
			{
				6,
				"{wait_600}",
				"Любое кол-во секунд для задержки между строками (в мсек).",
				string.format("{wait_800}"),
				"{wait_800}"
			},
			{
				1,
				"{name}",
				"Ваше имя.",
				string.format("Меня зовут %s.", nick_player1),
				"Меня зовут {name}."
			},
			{
				1,
				"{surname}",
				"Ваша фамилия.",
				string.format("Моя фамилия %s.", nick_player2),
				"Моя фамилия {surname}."
			},
			{
				1,
				"{id}",
				"Ваш игровой ID.",
				string.format("/n Введите команду /pass %s.", id_player),
				"/n Введите команду /pass {id}."
			},
			{
				1,
				"{rang}",
				"Ваша должность/звание.",
				string.format("На связи %s.", trang1),
				"На связи {rang} {surname}."
			},
			{
				1,
				"{frak}",
				"Название вашей организации.",
				string.format("Руки вверх! Это %s.", tfrak),
				"Руки вверх! Это {frak}."
			},
			{
				1,
				"{phone}",
				"Номер телефона.",
				string.format("Мой номер %s.", tphone),
				"Мой номер {phone}."
			},
			{
				3,
				"{time1}",
				"Текущая дата и время.",
				string.format("Сейчас %s.", os.date("%d %m %Y, %X")),
				"Сейчас {time1}."
			},
			{
				3,
				"{time2}",
				"Текущее время.",
				string.format("Сейчас на часах %s.", os.date("%X")),
				"Сейчас на часах {time2}."
			},
			{
				1,
				"{greeting}",
				"Приветствие от времени суток.",
				string.format("%s, рад вас видеть.", greeting()),
				"{greeting}, рад вас видеть."
			},
			{
				1,
				"{weapon}",
				"Название оружия.",
				string.format("Достал %s.", tgun_name),
				"Достал {weapon}."
			},
			{
				2,
				"{city}",
				"Текущий город.",
				string.format("Сейчас я в %s.", cityname),
				"Сейчас я в {city}."
			},
			{
				2,
				"{zone}",
				"Текущий район.",
				string.format("Еду по району %s.", tzone),
				"Еду по району {zone}"
			},
			{
				1,
				"{tag_r}",
				"Личный тэг для /r.",
				string.format("[%s] Внимание всем постам!", ttegr),
				"{tag_r} Внимание всем постам!"
			},
			{
				1,
				"{tag_f}",
				"Личный тэг для /f.",
				string.format("[%s] LSPD, на связь...", ttegf),
				"{tag_f} LSPD, на связь..."
			},
			{
				2,
				"{post}",
				"Текущий пост.",
				string.format("Нахожусь на посту %s.", tpost),
				"Нахожусь на посту {post}."
			},
			{
				2,
				"{kvadrat}",
				"Текущий квадрат.",
				string.format("Нахожусь в квадрате %s.", kvadrat()),
				"Нахожусь в квадрате {kvadrat}."
			},
			{
				4,
				"{id_marker}",
				"ID игрока, выделенного маркером через ПКМ.",
				string.format("/cuff %s", tid_marker),
				"/cuff {id_marker}."
			},
			{
				4,
				"{name_marker}",
				"Имя игрока, выделенного маркером через ПКМ.",
				string.format("%s", tname_marker),
				"Привет, {name_marker}. "
			},
			{
				4,
				"{surname_marker}",
				"Фамилия игрока, выделенного маркером через ПКМ.",
				string.format("Здравствуйте, мистер %s.", tsurname_marker),
				"Здравствуйте, мистер {surname_marker}."
			},
			{
				5,
				"{partner_ids}",
				"ID напарника(-ов).",
				string.format("В составе юнита жетоны N-%s", tnaparnik_id),
				"В составе юнита жетоны N-{partner_ids}."
			},
			{
				5,
				"{partner_nicks}",
				"Ник(-и) напарника(-ов).",
				string.format("В составе юнита %s", tnaparnik_nicks),
				"В составе юнита {partner_nicks}."
			},
			{
				5,
				"{meg_c_model}",
				"Название т/c для мегафона.",
				string.format("Автомобиль марки %s.", tname_car_megafon),
				"Автомобиль марки {meg_c_model}."
			},
			{
				5,
				"{meg_c_id}",
				"ID водителя для мегафона",
				string.format("Водитель c номером т/с N-%s.", tid_vodil_megafon),
				"Водитель c номером т/с N-{meg_c_id}."
			},
			{
				6,
				"{F6}",
				"Если вставить вначале строки — текст выведет в окно ввода.",
				string.format("Открыто окно ввода."),
				"{F6}Любой текст."
			},
			{
				6,
				"{message}",
				"Если вставить вначале строки — строка будет выведена в чат пользователю.",
				string.format("Сообщение выведено в уведомление."),
				"{message}Любой текст."
			},
			{
				6,
				"{F8}",
				"Если вставить вначале строки — будет сделан скриншот.",
				string.format("Создан скриншот."),
				"{F8}Любой текст."
			},
			{
				6,
				"{}",
				"Тэг-пробел.",
				string.format("Создан пробел."),
				"{F6}Причина:{}"
			},
			{
				3,
				"{dd}",
				"Текущий день.",
				string.format("%s день(-ей).", os.date("%d")),
				"{dd} день(-ей)."
			},
			{
				3,
				"{mm}",
				"Текущий номер месяца.",
				string.format("%s месяц(-ев).", os.date("%m")),
				"{mm} месяц(-ев)."
			},
			{
				3,
				"{YY}",
				"Текущий год (4 цифры).",
				string.format("Сейчас %s год.", os.date("%Y")),
				"Сейчас {YY} год."
			},
			{
				3,
				"{yy}",
				"Текущий год (2 цифры).",
				string.format("%s год.", os.date("%y")),
				"{yy} год."
			},
			{
				3,
				"{H}",
				"Текущий час.",
				string.format("Сейчас %s час(-ов).", os.date("%H")),
				"Сейчас {H} час(-ов)."
			},
			{
				3,
				"{M}",
				"Текущая минута.",
				string.format("%s минут(-ы).", os.date("%M")),
				"{M} минут(-ы)."
			},
			{
				3,
				"{S}",
				"Текущая секунда. ",
				string.format("%s секунд(-ы).", os.date("%S")),
				"{S} секунд(-ы)."
			},
			{
				3,
				"{day}",
				"Текущее название дня недели.",
				string.format("Сегодня %s.", dayname()),
				"Сегодня {day}."
			},
			{
				3,
				"{month}",
				"Текущее название месяца.",
				string.format("Сейчас %s.", mesname()),
				"Сейчас {month}."
			},
			{
				5,
				"{color_car}",
				"Цвет автомобиля для мегафона",
				string.format("Водитель автомобиля %s цвета.", tcolor_car_megafon),
				"Водитель автомобиля {color_car} цвета."
			},
			{
				2,
				"{cardinalp}",
				"Направление камеры.",
				string.format("Преступник скрылся в %s направлении", storona and cardinal_points[storona][2] or 'Неизвестном'),
				"Преступник скрылся в {cardinalp} направлении"
			}
		}

		local rx, ry = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(rx / 5 - 200, ry / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(650, 500), imgui.Cond.FirstUseEver)
		imgui.Begin(u8("MoJ Helper | Список тэгов"), show_taglist)

		if copy_tag and os.time() <= copy_tag_time then
			imgui.CenterText(u8(string.format("Готово! Тэг скопирован в буфер обмена.")))
		else
			imgui.CenterText(u8("Выберите нужный тэг и нажмите на кнопку в поле «ТЭГИ И ОПИСАНИЕ» для копирования."))
		end

		imgui.Columns(3)
		imgui.Separator()
		imgui.SetColumnWidth(-1, 130)
		imgui.Text(u8("ТЭГИ И ОПИСАНИЕ"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 250)
		imgui.Text(u8("ПРИМЕР"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 300)
		imgui.Text(u8("РЕЗУЛЬТАТ"))
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
		imgui.Begin(u8("MoJ Helper | Тэги параметров и команд"), show_taglist_param)

		local wrap_width = 380

		imgui.PushTextWrapPos(imgui.GetCursorPos().x + wrap_width)

		if imgui.Button(u8("{param1}")) then
			setClipboardText("{param1}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("Значение параметра 1 после команды")))

		if imgui.Button(u8("{name_param1}")) then
			setClipboardText("{name_param1}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("Имя игрока с ID параметра 1")))

		if imgui.Button(u8("{surname_param1}")) then
			setClipboardText("{surname_param1}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("Фамилия игрока с ID параметра 1")))
		imgui.Text(u8(string.format("")))

		if imgui.Button(u8("{param2}")) then
			setClipboardText("{param2}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("Значение параметра 2 после команды")))

		if imgui.Button(u8("{name_param2}")) then
			setClipboardText("{name_param2}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("Имя игрока с ID параметра 2")))

		if imgui.Button(u8("{surname_param2}")) then
			setClipboardText("{surname_param2}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("Фамилия игрока с ID параметра 2")))
		imgui.Text(u8(string.format("")))

		if imgui.Button(u8("{param3}")) then
			setClipboardText("{param3}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("Значение параметра 3 после команды")))

		if imgui.Button(u8("{name_param3}")) then
			setClipboardText("{name_param3}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("Имя игрока с ID параметра 3")))

		if imgui.Button(u8("{surname_param3}")) then
			setClipboardText("{surname_param3}")
		end

		imgui.SameLine(150)
		imgui.Text(u8(string.format("Фамилия игрока с ID параметра 3")))
		imgui.End()
	end
	if show_color1_tag.v then
		local resX, resY = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
		imgui.Begin(u8("Изменение цвета"), show_color1_tag)

		if imgui.ColorPicker4("##2", colors_1_hud, imgui.ColorEditFlags.AlphaBar) then
			loaded.main.colors1_hud_r, loaded.main.colors1_hud_g, loaded.main.colors1_hud_b, loaded.main.colors1_hud_a = imgui.ImColor(colors_1_hud):GetRGBA()
			save()
		end

		if imgui.Button(u8("Закрыть")) then
			show_color1_tag.v = false
		end

		imgui.SameLine()

		if imgui.Button(u8("Сбросить")) then
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
		imgui.CenterText(u8"Инструмент «Быстрое меню»\n    работает с включённым\n   инструментом «Виджет».")
		imgui.NewLine()
		imgui.SameLine(imgui.GetWindowSize().x / 2 - 72)

		if imgui.Button(u8("Активировать виджет"), imgui.ImVec2(144, 20)) then
			fast_loaded.main.vidget = true
			fast_vidget = true
			saveFast()
		end
	else
		if imgui.Checkbox(u8'Акт. быстрое меню', fast_act) then
			fast_loaded.main.act = fast_act.v
			saveFast()
		end
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetCursorPosX()+5)
		if imgui.Checkbox(u8'Маркер над игроком', fast_mark) then
			fast_loaded.main.mark = fast_mark.v
			saveFast()
		end
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetCursorPosX()+5)
		if imgui.Checkbox(u8'Дальний радиус захвата', fast_big_mark) then
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
				imgui.TextColored(imgui.ImVec4(0, 255, 0, 1), u8("Категория"))
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
							imgui.TextColored(imgui.ImVec4(0, 255, 0, 1), u8("Cлот"))
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
			imgui.CenterText(u8"Начните создавать прекрасное!")
		else
			imgui.Text(u8("Имя категории:"))

			imgui.PushItemWidth(300)
			if imgui.InputText('##cat_name', fast_categ_name) then
				fast_loaded.menu[selected_fast_menu].name = u8:decode(fast_categ_name.v)
				saveFast()
			end
			imgui.PopItemWidth()

			imgui.Text(u8("Имя слота:"))

			imgui.PushItemWidth(300)
			if imgui.InputText('##slot_name', fast_slot_name) then
				fast_loaded.menu[selected_fast_menu].menu[selected_fast_menu_categ][1] = u8:decode(fast_slot_name.v)
				saveFast()
			end
			imgui.PopItemWidth()

			imgui.SameLine()
			if imgui.Button(u8("Х")) then
				fast_loaded.menu[selected_fast_menu].menu[selected_fast_menu_categ][1] = ''
				fast_loaded.menu[selected_fast_menu].menu[selected_fast_menu_categ][2] = ''
				fast_loaded.menu[selected_fast_menu].menu[selected_fast_menu_categ][3] = '1000' 
				selected_fast_menu_categ = 0
				saveFast()
			end
			hint(u8'Удалить')

			imgui.Text(u8("Задержка в секундах (от 0.1 до 15.0 сек):"))

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
						imgui.TextColoredRGB("{FF3B3B}[!] {FFFFFF}Неверно заполнено поле с задержкой.")
					end
				else
					imgui.TextColoredRGB("{FF3B3B}[!] {FFFFFF}Неверно заполнено поле с задержкой.")
				end
			end

			imgui.Text(u8("Текст слота:"))

			if imgui.InputTextMultiline("##source", fast_text, imgui.ImVec2(-1, imgui.GetTextLineHeight() * 8)) then
				fast_loaded.menu[selected_fast_menu].menu[selected_fast_menu_categ][2] = u8:decode(fast_text.v):gsub('\n', '&')
				saveFast()
			end
			if imgui.Button(u8("Список тэгов")) then
				show_taglist.v = not show_taglist.v
			end

			imgui.Separator()
			imgui.CenterText(u8("Результат (с применением тегов):"))
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
	u8("Не выбрана"),
	u8("LSPD"),
	u8("SFPD"),
	u8("LVPD"),
	u8("RCPD"),
	u8("FBI"),
	u8("Другое")
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
								print(string.format("Удален маркер %s (%s)", nick_actor, dist))
							end

							if dist > 20 then
								removeBlip(marker1)
								print(string.format("Удален игрок %s (%s)", nick_actor, dist))

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
Данная функция активирует оптимизацию для более комфортной работы приложения с использованием ENB.
Оптимизация автоматически запускается при старте игры и отключается если активно одно из окон приложения (может пропадать чат, если активно окно).

Побочные эффекты:
> Не работает быстрое меню
> Нельзя кликать по игровому меню курсором (только клавиши)
> Нельзя взаимодействовать с интерфейсом игры (текстдравы)

Пожалуйста, не активируйте эту функцию без надобности.]]

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
	:gsub("{wait_(%S+)}", u8"[Задержка %1 мс.]")
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
/do Наручники на поясе.
/me снял наручники с пояса
/me завел преступнику руки за спину
/me надел наручники на руки преступнику и застегнул их
/cuff {param1}]]

local ticket_dop = [[
/me достал бланк и ручку
/do Бланк и ручка в руках.
/me начинает заполнять бланк
/do Бланк заполнен
/me передал бланк нарушителю
/ticket {param1} {param2} {param3}]]

function imgui.DecorButton(...)
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.Button])
	imgui.PushStyleColor(imgui.Col.ButtonActive,  imgui.GetStyle().Colors[imgui.Col.Button])
	imgui.Button(...)
	imgui.PopStyleColor(2)
end	

function panel_settings()
	imgui.BeginChild("left pane", im2(185, 437), true)
		if imgui.Selectable(u8("Основные настройки"), selected == 1 and true or false) then
			selected = 1
		end
		if imgui.Selectable(u8("Настройки клавиш"), selected == 2 and true or false) then
			selected = 2
		end
		if imgui.Selectable(u8("Стандартные команды"), selected == 4 and true or false) then
			selected = 4
		end
		if imgui.Selectable(u8("Дополнительные команды"), selected == 5 and true or false) then
			selected = 5
		end
		if imgui.Selectable(u8("Настройки виджета"), selected == 7 and true or false) then
			selected = 7
		end
		if imgui.Selectable(u8("Настройки напарника"), selected == 8 and true or false) then
			selected = 8
		end
		if dop_channel.v then
			if imgui.Selectable(u8("Настройки рации"), selected == 9 and true or false) then
				selected = 9
			end
		end
		if imgui.Selectable(u8("Настройки собеседований"), selected == 10 and true or false) then
			selected = 10
		end

		if imgui.Selectable(u8("Настройки экзаменов"), selected == 11 and true or false) then
			selected = 11
		end

		if imgui.Selectable(u8("Настройки докладов"), selected == 12 and true or false) then
			selected = 12
		end

		imgui.NewLine()
		imgui.NewLine()
	imgui.EndChild()
	imgui.SameLine()
	local x = imgui.GetWindowSize().x-imgui.GetCursorPos().x-5
	imgui.BeginChild('##menu_second', im2(x, 437), true)
	if selected == 1 then      -- Основные настройки
		baseSettings()
	elseif selected == 2 then  -- Настройки клавиш
		local wrap_width = imgui.GetWindowSize().x - 10

		imgui.PushTextWrapPos(imgui.GetCursorPos().x + wrap_width)
		imgui.Text(u8(string.format("Привет! Ты находишься в разделе настроек стандартных клавиш. Каждую функцию из этого списка можно вызывать через клавиатуру. Это значительно ускоряет процесс взаимодействия с MoJ Helper. Выбери нужную функцию ниже и то, что ты хочешь сделать с этой функцией.")), wrap_width)
		imgui.Separator()
		imgui.BeginChild("setting_a1", imgui.ImVec2(-1, 35), true)
		if selected_key ~= 0 then
			for i, v in ipairs(keys_lis2) do
				if selected_key == i then
					if keys_menu[i].v[1] == 0 then
						asd = 'Нет'
					else
						asd = table.concat(getKeysName(keys_menu[i].v), ' + ')
					end
					if change_hotkey == 1 then
						imgui.TextColoredRGB('{FF3B3B}Выбрана функция: {ffffff} '..v[1]..'  [ Активация: {ff3f3f}'..asd..'{ffffff} ]')
					else
						imgui.TextColoredRGB('{FF3B3B}Выбрана функция: {ffffff} '..v[1])
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
				if imgui.Button(u8'Назад', im2(95, 22)) then
					change_hotkey = 1
				end	
				imgui.SameLine()
			end
			if imgui.ButtonClickable(change_hotkey == 1, u8'Изменить', im2(75, 22)) then
				change_hotkey = 2
			end	
			imgui.SameLine()
			if imgui.ButtonClickable(change_hotkey == 1, u8'Сбросить', im2(75, 22)) then
				keys_menu[selected_key].v = {0}
				saveKeys()
			end
		else
			imgui.TextColoredRGB('{FF3B3B}Выбрана клавиша: {ffffff} нет')
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
					imgui.Text(u8'Нет')
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
					imgui.Text(u8'Нет')
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
					imgui.Text(u8'Нет')
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
		
	elseif selected == 4 then  -- Стандартные команды
		imgui.BeginGroup()
		imgui.BeginChild("setting_c5", imgui.ImVec2(0, 60), true)
		imgui.SameLine()
		local wrap_width = imgui.GetWindowSize().x - 10

		imgui.PushTextWrapPos(imgui.GetCursorPos().x + wrap_width)

		if rp_say.v then
			imgui.Text(u8(string.format("Сейчас у тебя выключены все стандартные команды и RP-отыгровки. Для отмены нажми кнопку ниже.")), wrap_width)
		else
			imgui.Text(u8(string.format("Привет! Ты находишься в разделе настроек стандартных команд. Каждая стандартная команда имеет свою RP-отыгровку. Некоторые из них включают в себя сразу несколько RP-отыгровок. Ты можешь отключить все стандартные команды ниже и создавать свои в разделе «Дополнительные команды»")), wrap_width)
		end

		imgui.EndChild()

		imgui.Separator()
		imgui.BeginChild("setting_napar2", imgui.ImVec2(imgui.GetWindowSize().x / 2, 40), false)
		imgui.BeginChild("butt2", imgui.ImVec2(0, 0), false)
		imgui.Text(u8("Интервал RP - отыгровок:"))
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

		if imgui.Button(rp_say.v and u8'Включить все стандартные команды' or u8'Отключить все стандартные команды', im2(-1, 25)) then
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
			imgui.Text(u8("КОМАНДА"))
			imgui.NextColumn()
			imgui.SetColumnWidth(-1, 535)
			imgui.Text(u8("ОПИСАНИЕ"))
			imgui.NextColumn()
			imgui.SetColumnWidth(-1, 50)
			imgui.Text(u8(""))
			imgui.NextColumn()
			imgui.Separator()
			for i, v in ipairs(scs_loaded) do
			    if imgui.Button(v[1], imgui.ImVec2(120, 0)) then
					setClipboardText(v[1])
				end
				hint(u8("Нажмите, чтобы скопировать команду в буфер обмена. После команду можно вставить в чат (F6) комбинацией клавиш Ctrl + V."))
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
	elseif selected == 5 then  -- Дополнительные команды
		imgui.BeginChild("setting_c", imgui.ImVec2(200, 0), true)
		for i, v in ipairs(dop_loaded) do
			local sel_act = false
			if v.comand_name == "" then
				if imgui.Selectable(i..'. ', selected_dop_comand == i and true or false) then
					sel_act = true
				end
				imgui.SameLine()
				imgui.TextColoredRGB('{3BFF3B}Свободный слот')
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
			imgui.Text(u8'Название команды')
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
				if imgui.ButtonClickable(not comand_param2_act.v, u8'Удалить параметр [1]') then
					comand_param1_act.v = false
					dop_loaded[selected_dop_comand].p1act = comand_param1_act.v
					saveDop()
				end	
				if comand_param2_act.v then hint(u8'Удалите 2-ой параметр, что-бы разблокировать удаление первого') end
				imgui.SameLine()
				if comand_param2_act.v then
					if imgui.ButtonClickable(not comand_param3_act.v, u8'Удалить параметр [2]') then
						comand_param2_act.v = false
						dop_loaded[selected_dop_comand].p2act = comand_param2_act.v
						saveDop()
					end	
					if comand_param3_act.v then hint(u8'Удалите 3-ий параметр, что-бы разблокировать удаление второго') end
					imgui.SameLine()
					if imgui.Button(comand_param3_act.v and u8'Удалить параметр [3]' or u8'Создать параметр [3]') then
						comand_param3_act.v = not comand_param3_act.v
						dop_loaded[selected_dop_comand].p3act = comand_param3_act.v
						saveDop()
					end	
				else
					if imgui.Button(u8'Создать параметр [2]') then
						comand_param2_act.v = true
						dop_loaded[selected_dop_comand].p2act = comand_param2_act.v
						saveDop()
					end
				end
			else
				if imgui.Button(u8'Создать параметр [1]') then
					comand_param1_act.v = true
					dop_loaded[selected_dop_comand].p1act = comand_param1_act.v
					saveDop()
				end
			end
			imgui.Text(u8("Задержка в секундах (от 0.1 до 15 сек):"))
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
			imgui.Text(u8'секунд')
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
				imgui.TextColoredRGB("{FF3B3B}[!] {FFFFFF}Неверно заполнено поле с задержкой.")
			end
			imgui.Text(u8("Текст слота:"))

			if imgui.InputTextMultiline("##source", comand_text, imgui.ImVec2(-1, imgui.GetTextLineHeight() * 8)) then
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v):gsub('\n', '&')
				saveDop()
			end

			-- ---------------------------------------

			if imgui.Button(u8("Список тэгов")) then
				show_taglist.v = not show_taglist.v
			end

			if comand_param1_act.v then
				imgui.SameLine()

				if imgui.Button(u8("Тэги параметров")) then
					show_taglist_param.v = not show_taglist_param.v
				end
			end

			if imgui.Button(u8("Пример #1")) then
				comand_text.v = u8(tostring("{greeting}, Вас беспокоит {rang} {frak} {name} {surname}.\nБудьте любезны, предоставьте документ, удостоверяющий Вашу личность. "))
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v)
				saveDop()
			end

			imgui.SameLine()

			if imgui.Button(u8("Пример #2")) then
				comand_text.v = u8(tostring("/do На золотых часах «Rolex»: {time2}, {day}.\n/c 60"))
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v)
				saveDop()
			end

			imgui.SameLine()

			if imgui.Button(u8("Пример /cuff")) then
				comand_text.v = u8(tostring(cuff_dop))
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v)
				saveDop()
			end

			imgui.SameLine()

			if imgui.Button(u8("Пример /ticket")) then
				comand_text.v = u8(tostring(ticket_dop))
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v)
				saveDop()
			end

			imgui.SameLine()

			if imgui.Button(u8("Пример /доклад")) then
				comand_text.v = u8(tostring("/r Это юнит {id}. Веду патруль в р. {zone}. {param1}, конец связи."))
				dop_loaded[selected_dop_comand].comand_text = u8:decode(comand_text.v)
				saveDop()
			end

			imgui.Text("")
			imgui.Separator()
			imgui.SameLine(180)
			imgui.SetCursorPosY(imgui.GetCursorPosY()+2)
			imgui.CenterText(u8("РЕЗУЛЬТАТ (С ПРИМЕНЕНИЕМ ТЭГОВ):"))
			imgui.Text(string.gsub(preobr_message(comand_text.v), "&", "\n"))
			imgui.EndChild()
		end
	elseif selected == 7 then  -- Настройки виджета
		imgui.BeginGroup()
		imgui.BeginChild("item view", imgui.ImVec2(0, 0), true)

		if imgui.Checkbox(u8("Отображать виджет"), hud1) then
			loaded.main.hud_city = hud1.v
			save()
		end

		imgui.SameLine()

		if imgui.Button(u8("Изменить местоположение"), imgui.ImVec2(214, 20)) then
			set_coord_huud = true
		end

		imgui.SameLine()

		if imgui.Button(u8("Изменить оформление"), imgui.ImVec2(214, 20)) then
			show_color1_tag.v = not show_color1_tag.v
		end

		imgui.Separator()
		imgui.BeginChild("menu1", imgui.ImVec2(350, 0), false)
		imgui.DecorButton(fa.MAP..u8' Навигация', im2((imgui.GetWindowSize().x)*0.85, 25))

		if imgui.Checkbox(u8("Отображать название города"), hud_city) then
			loaded.main.hud_city = hud_city.v
			save()
		end

		if imgui.Checkbox(u8("Отображать район"), hud_zone) then
			loaded.main.hud_zone = hud_zone.v
			save()
		end

		if imgui.Checkbox(u8("Отображать текущий квадрат"), hud_kvadrat) then
			loaded.main.hud_kvadrat = hud_kvadrat.v
			save()
		end

		if imgui.Checkbox(u8("Отображать активный пост"), hud_post) then
			loaded.main.hud_post = hud_post.v
			save()
		end

		if imgui.Checkbox(u8("Отображать канал рации"), hud_channel) then
			loaded.main.hud_channel = hud_channel.v
			save()
		end

		if imgui.Checkbox(u8("Отображать направление камеры"), hud_cardinalpoints) then
			loaded.main.hud_cardinalpoints = hud_cardinalpoints.v
			save()
		end

		imgui.NewLine()
		imgui.DecorButton(fa.BORDER_OUTER..u8' Внешний облик', im2((imgui.GetWindowSize().x)*0.85, 25))

		if imgui.Checkbox(u8("Отображать состояние здоровья"), hud_hp) then
			loaded.main.hud_hp = hud_hp.v
			save()
		end

		if imgui.Checkbox(u8("Отображать состояние брони"), hud_armour) then
			loaded.main.hud_armour = hud_armour.v
			save()
		end

		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild("menu2", imgui.ImVec2(0, 0), false)
		imgui.DecorButton(fa.BARS..u8' Другое', im2((imgui.GetWindowSize().x)*0.85, 25))
		if imgui.Checkbox(u8("Отображать текущий пинг"), hud_ping) then
			loaded.main.hud_ping = hud_ping.v
			save()
		end

		if imgui.Checkbox(u8("Отображать текущее время"), hud_time) then
			loaded.main.hud_time = hud_time.v
			save()
		end

		if imgui.Checkbox(u8("Отображать текущий трек"), hud_radio_title) then
			loaded.main.hud_radio_title = hud_radio_title.v
			save()
		end

		if imgui.Checkbox(u8("Отображать интерактивное меню"), hud_icon) then
			loaded.main.hud_icon = hud_icon.v
			save()
		end

		imgui.EndChild()
		imgui.EndChild()
		imgui.EndGroup()
	elseif selected == 8 then  -- Настройки напарника
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

		if imgui.Checkbox(u8("Напарник активен"), imgui.ImBool(napar_active)) then
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

		imgui.Text(u8("Напарник:"))

		if imgui.Combo(u8("##styleedit"), combo_naparid, {
			u8("Элизабет"),
			u8("Амелия"),
			u8("Эвелин"),
			u8("Элла"),
			u8("Хлоя"),
			u8("Виктория"),
			u8("Лукас"),
			u8("Джозеф"),
			u8("Энтони"),
			u8("Эндрю"),
			u8("Самуэль"),
			u8("Габриэль"),
			u8("Андриан"),
			u8("Чарльз"),
			u8("Эдвард"),
			u8("Игорь")
		}) then
			napar_id = combo_naparid.v
			sampgui_texture_photo_disp = nil
			napar_skin = nil
			slot1 = uv0.load(nil, "MVDHelp\\setting.ini")
			slot1.main.napar_id = napar_id

			uv0.save(slot1, "MVDHelp\\setting.ini")
		end

		imgui.Text(u8("Стиль доклада:"))

		if imgui.Combo(u8("##styleedit2"), combo_doklad_style, {
			"",
			u8("С тэн-кодами"),
			u8("Стандартный")
		}) then
			doklad_style = combo_doklad_style.v
			slot2 = uv0.load(nil, "MVDHelp\\setting.ini")
			slot2.main.doklad_style = doklad_style

			uv0.save(slot2, "MVDHelp\\setting.ini")
		end

		if doklad_style == 0 then
			ShowHelpMarker2(u8("Некоторые функции напарника дают возможность делать доклады по рации. Изменив эту настройку Вы измените стиль общения по рации. "))
		elseif doklad_style == 1 then
			ShowHelpMarker2(u8(string.format("Пример доклада:\nДокладывает: %s. Начинаю патруль г. %s, район %s. Код-4, конец связи. ", f_name, cityname, zone)))
		elseif doklad_style == 2 then
			ShowHelpMarker2(u8(string.format("Пример доклада:\nДокладывает: %s. Начинаю патруль г. %s, район %s.", f_name, cityname, zone)))
		end

		imgui.EndChild()
		imgui.EndChild()
		imgui.BeginChild("inputs2", imgui.ImVec2(0, 0), true)

		wrap_width = imgui.GetWindowSize().x - 11

		imgui.PushTextWrapPos(imgui.GetCursorPos().x + wrap_width)
		imgui.Text(u8(string.format("Привет, %s!", nick_player1)), wrap_width)
		imgui.Text(u8(string.format("Теперь тебе доступна помощь напарника, который не предаст тебя в сложной ситуации и всегда будет вызываться на помощь! ")), wrap_width)
		imgui.Text(u8(string.format("Напарник сможет анализировать множество ситуаций, которые будут происходить с тобой во время службы и давать советы. ")), wrap_width)
		imgui.Text(u8(string.format("Например, ты получишь напоминание если забудешь бронежилет, а если по тебе откроют огонь - напарник сможет позвать помощь. ")), wrap_width)
		imgui.Text(u8(string.format("Это и многое другое ждёт тебя после активации новой функции!")), wrap_width)
		imgui.EndChild()
		imgui.EndChild()
		imgui.EndGroup()
	elseif selected == 9 then  -- Настройки рации
	elseif selected == 10 then -- Настройки собеседований
	elseif selected == 11 then -- Настройки экзаменов
	elseif selected == 12 then -- Настройки докладов

	end
	imgui.EndChild()
	-- if InputText(u8'Активация меню  /', act_menu) then
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
	imgui.Text(u8("Ваше короткое имя:"))
	
	imgui.PushItemWidth(200)
	if imgui.InputText("##f_name", f_name) then
		loaded.main.f_name = u8:decode(f_name.v)
		save()
	end
	imgui.PopItemWidth()

	hint(u8("Введённый текст будет отображаться в Вашем удостоверении/жетоне. "))
	imgui.Text(u8("Должность или звание:"))

	imgui.PushItemWidth(200)
	if imgui.InputText('##rang1', rang1) then
		loaded.main.rang1 = u8:decode(rang1.v)
		save()
	end
	imgui.PopItemWidth()

	hint(u8("Введённый текст будет отображаться в Вашем удостоверении/жетоне. "))
	imgui.Text(u8("Номер телефона:"))

	imgui.PushItemWidth(200)
	if imgui.InputText('##phone', phone) then
		loaded.main.phone = u8:decode(phone.v)
		save()
	end
	imgui.PopItemWidth()

	imgui.Text(u8("Название организации:"))

	imgui.PushItemWidth(200)
	if imgui.InputText('##frak', frak) then
		loaded.main.frak = u8:decode(frak.v)
		save()
	end
	imgui.PopItemWidth()

	hint(u8("Введённый текст будет отображаться в Вашем удостоверении/жетоне. "))
	if not dop_channel.v then
		imgui.Text(u8("Тэг в рацию организации (/r):"))

		imgui.PushItemWidth(200)
		if imgui.InputText('##tegr', tegr) then
			loaded.main.tegr = u8:decode(tegr.v)
			save()
		end
		imgui.PopItemWidth()

		hint(u8("Введённый текст будет автоматически вставлен при использовании команды /r\nПри заполнении не нужно использовать скобки. "))
		imgui.Text(u8("Тэг в рацию всей орган-ции (/f):"))
		hint(u8("Введённый текст будет автоматически вставлен при использовании команды /f\nПри заполнении не нужно использовать скобки. "))

		imgui.PushItemWidth(200)
		if imgui.InputText('##tegf', tegf) then
			loaded.main.tegf = u8:decode(tegf.v)
			save()
		end
		imgui.PopItemWidth()

		hint(u8("Введённый текст будет автоматически вставлен при использовании команды /f\nПри заполнении не нужно использовать скобки. "))
	end

	imgui.Text(u8("Ваша организация:"))

	imgui.PushItemWidth(200)
	if imgui.Combo(u8("##org_frak"), frakid, fraks) then
		loaded.main.frakid = frakid.v
		save()
	end
	imgui.PopItemWidth()
	hint(u8("Используется для настроек докладов, отыгровок и вывода информации. "))
	imgui.Text(u8("Ваш пол:"))

	imgui.PushItemWidth(200)
	if imgui.Combo(u8("##female_combo"), female, {
		u8("Мужской"),
		u8("Женский")
	}) then
		loaded.main.female = female.v
		save()
	end
	imgui.PopItemWidth()

	hint(u8("Функция позволяет изменить пол при отыгровке стандартных команд."))

	imgui.PushItemWidth(200)
	imgui.SetCur(0, 50)
	imgui.Text(u8("Оформление:"))
	if imgui.Combo("##styleedit", theme, {
		u8"Серое",
		u8"Светло зелёное",
		u8"Фиолетовое",
		u8"Тёмно зелёное",
		u8"Розовое",
		u8"Чёрное",
		u8"Тёмно красное",
		u8"Красное",
		u8"Синие",
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
		imgui.CenterText(u8("Дополнительные настройки"))
		if imgui.Checkbox(u8("Автоматический скриншот при докладе в рацию"), autoskreen) then
			loaded.main.autoskreen = autoskreen.v
			save()
		end

		hint(u8("Автоматически создает скриншот при использовании команд /пост /arrest."))

		if imgui.Checkbox(u8("Автоматический доклад в рацию при аресте"), rp_arrest) then
			loaded.main.rp_arrest = rp_arrest.v
			save()
		end

		hint(u8("Позволяет производить доклад после задержания преступника командой /arrest."))

		if su_list then
			if imgui.Checkbox(u8("Режим умной выдачи розыска"), dopsu) then
				loaded.main.dopsu = dopsu.v
				save()
			end

			hint(u8("С помощью этой функции не обязательно учить УК. Достаточно просто ввести команду и выбрать нарушение. MoJ Helper сам выдаст необходимое наказание и укажет верную причину."))
		end

		if ticket_list then
			if imgui.Checkbox(u8("Режим умной выдачи штрафа"), dopticket) then
				loaded.main.dopticket = dopticket.v
				save()
			end

			hint(u8("Уникальная функция с системой умной выдачи штрафа. Теперь нет необходимости учить административный кодекс и ПДД. Все наказания за нарушения АК на вашем сервере уже загружены в MoJ Helper и готовы к использованию. Введите команду для выдачи штрафа и приложение предложит выбрать наказание. Дополнительно выводится предписание к каждой статье, если оно имеется. Например, /ticket ID."))
		end

		if imgui.Checkbox(u8("Использовать окно рапорта об аресте"), new_arrest) then
			loaded.main.new_arrest = new_arrest.v
			save()
		end

		hint(u8("При аресте (/arrest) функция показывает диалоговое окно, которое позволяет оставлять информацию о проведении ареста полицейским. По умолчанию функция активна."))

		if imgui.Checkbox(u8("Режим настройки рации"), dop_channel) then
			loaded.main.dop_channel = dop_channel.v
			save()
		end

		hint(u8("Режим настройки рации активирует панель управления каналами связи рации. Используя данную функцию, вы можете настроить нужные тэги для обмена сообщениями между сотрудниками, как внутри вашего подразделения, так и вне его."))
		imgui.NewLine()
		imgui.NewLine()
		imgui.SameLine(10)
		imgui.BeginChild("line5", imgui.ImVec2(415, 1), true)
		imgui.EndChild()
		imgui.CenterText(u8("Служебные настройки"))

		if imgui.Checkbox(u8("Отключить все стандартные команды"), rp_say) then
			loaded.main.rp_say = rp_say.v
			save()
		end

		hint(u8("Данная настройка позволяет отключить все отыгровки для команд сервера (например /arrest, /cuff).\nПосле отключения, Вы можете сделать все команды самостоятельно, через настройки дополнительных команд. "))

		if imgui.Checkbox(u8("Отключить подсказки"), off_podskaz) then
			loaded.main.off_podskaz = off_podskaz.v
			save()
		end

		hint(u8("Отключает все внутренние подсказки приложения.  "))

		if imgui.Checkbox(u8("Отключить обновление кодексов"), not_update_codecs) then
			loaded.main.not_update_codecs = not_update_codecs.v
			save()
		end

		hint(u8("Активация этой функции полностью отключает автоматическое обновление /ук, /ак, /устав. "))

		if imgui.Checkbox(u8("Режим оптимизации для ENB"), opt_enb) then 
			if opt_enb.v then
				imgui.OpenPopup(u8("Оптимизация к ENB"))
			end
			loaded.main.opt_enb = opt_enb.v
			save()
		end

		hint(u8("Если Вы используете ENB - активируйте эту галочку, и некоторые графические элементы будут отображаться таким образом, что бы корректно отображался интерфейс игры. "))

		if imgui.BeginPopupModal(u8("Оптимизация к ENB"), nil, imgui.WindowFlags.AlwaysAutoResize) then
			local wrap_width = 600

			imgui.PushTextWrapPos(imgui.GetCursorPos().x + wrap_width)
			imgui.Text(u8("ENB - серия модификаций для игр, позволяющая точно настроить сглаживание, свечение и замутнение окружения (например, при осмотре какой-нибудь вещи вблизи). ENB универсален для всех игр, мало весит и позволяет сделать любимую игру красивее без использования тяжёлых графических модификаций, однако есть и минусы - для каждой игры требуется свой набор настроек, которые большинству новичков прописать не по силам."), wrap_width)
			imgui.Separator()
			imgui.Text(u8(big_imgui_text_enb), wrap_width)
			imgui.Separator()

			if imgui.Button(u8("Да, я использую ENB"), imgui.ImVec2(-0.1, 0)) then
				opt_enb.v = true
				imgui.CloseCurrentPopup()
			end

			if imgui.Button(u8("Нет, мне не нужно"), imgui.ImVec2(-0.1, 0)) then
				opt_enb.v = false
				imgui.CloseCurrentPopup()
			end

			imgui.EndPopup()
		end

		if imgui.Checkbox(u8("Режим удаления точек в RP-отыгровках (/me)"), rp_point) then
			loaded.main.rp_point = rp_point.v
			save()
		end
		hint(u8("Если на вашем сервере администрация считает, что отсутствие точки в конце предложения команды /me поднимает уровень Role Play - активируйте этот пункт и во всех стандартных RP-отыгровках приложения точка в конце строки будет удалена, а уровень Role Play сразу поднимается вверх!"))
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
			imgui.TextColoredRGB('{3bff3b}Свободный слот')
		end
	end
	imgui.EndChild()
	if selected_binder ~= 0 then
		imgui.SameLine()
		imgui.BeginChild("setting_c2", imgui.ImVec2(0, 0), true)
		imgui.Text(u8'Имя бинда')
		imgui.PushItemWidth(200)
		if imgui.InputText('##name_bind', binder_name) then
			binder_loaded[selected_binder].name = tostring(binder_name.v)
			saveBinder()
		end
		imgui.PopItemWidth()
		imgui.SameLine()
		imgui.NewLine()
		imgui.Text(u8'Активация:')
		if imgui.HotKey(u8"##key"..selected_binder, binder_loaded[selected_binder].act, nil, 100) then
			saveBinder()
		end
		imgui.SameLine()
		if imgui.Button(u8'Сбросить', im2(75, 20)) then
			binder_loaded[selected_binder].act.v = {0}
			saveBinder()
		end

		imgui.Text(u8("Задержка в секундах (от 0.1 до 15)"))

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
					imgui.TextColoredRGB("{FF3B3B}[!] {FFFFFF}Неверно заполнено поле с задержкой.")
				end
			else
				imgui.TextColoredRGB("{FF3B3B}[!] {FFFFFF}Неверно заполнено поле с задержкой.")
			end
		end

		imgui.Text(u8("Текст слота:"))

		if imgui.InputTextMultiline("##source", binder_text, imgui.ImVec2(-1, imgui.GetTextLineHeight() * 8)) then
			binder_loaded[selected_binder].text = u8:decode(binder_text.v):gsub('\n', '&')
			saveBinder()
		end
		if imgui.Button(u8("Список тэгов")) then
			show_taglist.v = not show_taglist.v
		end
		if imgui.Button(u8("Пример #1")) then
			binder_text.v = u8(tostring("{greeting}, Вас беспокоит {rang} {frak} {name} {surname}.\nБудьте любезны, предоставьте документ, удостоверяющий Вашу личность. "))
			binder_loaded[selected_binder].text = u8:decode(binder_text.v)
			saveBinder()
		end

		imgui.SameLine()

		if imgui.Button(u8("Пример #2")) then
			binder_text.v = u8(tostring("/do На золотых часах «Rolex»: {time2}, {day}.\n/c 60"))
			binder_loaded[selected_binder].text = u8:decode(binder_text.v)
			saveBinder()
		end

		imgui.SameLine()

		if imgui.Button(u8("Пример #3")) then
			binder_text.v = u8(tostring("/r Докладывает: {surname}. Патрулирую район {zone}, {city}.\n{F6}/r Состояние: \n{F8}"))
			binder_loaded[selected_binder].text = u8:decode(binder_text.v)
			saveBinder()
		end
		imgui.Separator()
		imgui.CenterText(u8("Результат (с применением тегов):"))
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
		imgui.CenterText(u8"Начните создавать прекрасное!")
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
	if imgui.Checkbox(u8("Режим RP отыгровки оружия"), rpgun) then
		loaded.main.rpgun = rpgun.v
		save()
	end

	hint(u8("Автоматическая RP-отыгровка при использовании оружия. "))
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
         sKeys = tHotKeyData.tickState and u8'Нету' or " "
        else
            sKeys = table.concat(imgui.getKeysName(tKeys), " + ")
        end
    end

    imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.FrameBg])
    if imgui.Button((tostring(sKeys):len() == 0 and u8'Нету' or sKeys) .. name, imgui.ImVec2(width, 0)) then
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