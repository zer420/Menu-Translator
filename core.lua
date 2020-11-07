local info = {
    v_loc = 1.04,
    v_onl = http.Get("https://raw.githubusercontent.com/zer420/Menu-Translator/master/version"),
    src = "https://raw.githubusercontent.com/zer420/Menu-Translator/master/core.lua",
    dir = "zerlib\\",
    sc_dir = "menutrsltr\\",
    name = GetScriptName(),
    updt_available = false,
};

UnloadScript(info.dir .. "reload.lua");
file.Delete(info.dir .. "reload.lua");

local function Updater()
    if info.v_loc < tonumber(info.v_onl) then
        file.Write(info.dir .. "reload.lua", [[local f=0;callbacks.Register("Draw",function()if f==0 then UnloadScript("]]..info.name..[[");elseif f==1 then LoadScript("]]..info.name..[[");end;f=f+1;end);]])
        file.Write(info.name, http.Get(info.src)); LoadScript(info.dir .. "reload.lua");
end; end; Updater(); --auto-updater + auto-reloader

local db = {
    prev = 1,
    lang_name = {"English", "中文",}, --"Русский", "Français", "Español", "Suomi", "Português", "Romana", "Deutsch", "Italiano",
    lang_checked = {false, false, false,},
    ui = {[1] = {},[2] = {},[3] = {},[4] = {},[5] = {},[6] = {},[7] = {},}, --used to store og ui
    lang = {
        ["English"] = {},
        ["中文"] = {},
    },
    src = {
        [1] = "https://raw.githubusercontent.com/zer420/Menu-Translator/master/languages/English",
        [2] = "https://raw.githubusercontent.com/AimwarePasteLua/Chineseware/master/%E4%B8%AD%E6%96%87.lua",
    },
    v_onl = {
        [1] = "https://raw.githubusercontent.com/zer420/Menu-Translator/master/languages/English-version",
        [2] = "https://raw.githubusercontent.com/AimwarePasteLua/Chineseware/master/version",
    },
}; --database with every language inside

local ui_ref = gui.Reference("Settings", "Advanced", "Manage advanced settings");
local ui_select = gui.Combobox(ui_ref, "language", "Menu Language", unpack(db.lang_name)); ui_select:SetDescription("Translate the menu into various languages.");
local warning = gui.Text(ui_ref, ""); warning:SetInvisible(true);
--user interface
local function UnloadScripts(f)
    if f ~= info.name then
        UnloadScript(f:match(".*lua$") ~= nil and f or "");
    end;
end;
file.Enumerate(UnloadScripts); --unloads all your other luas

local function GetUIChildren(obj, level)
    if obj:GetName() ~= "" then
        table.insert(db.ui[level], obj);
    end;
	for child in obj:Children() do
		GetUIChildren(child, level + 1);
    end;
end;
GetUIChildren(gui.Reference("Menu"), 0); --credits to polak, gets every ui elements with their level of parent

local function LanguageUpdater(i)

    local curr_dir = (info.dir .. info.sc_dir .. db.lang_name[i] .. ".lua");
    local curr_db = db.lang[db.lang_name[i]];

    if db.lang_checked[i] == false then
        curr_db = RunScript(curr_dir);
        info.updt_available = false;
        if curr_db == nil then
            info.updt_available = true;
        elseif curr_db.v_loc == nil then
            info.updt_available = true;
        elseif curr_db.v_loc < tonumber(http.Get(db.v_onl[i])) then --checks for update
            info.updt_available = true;
        end;
        if info.updt_available == true then
            file.Write(curr_dir, http.Get(db.src[i])); curr_db = RunScript(curr_dir); --downloads it
        end;
        db.lang_checked[i] = true;        
    end;
    db.lang[db.lang_name[i]] = curr_db;
    for j = 1, #db.ui do
        if #db.ui[j] ~= #curr_db[j] then --checks if outdated
            return false;
        end;
    end;
    return true;
end;

local function EntryIsValid(i, j, k, type)
    if db.lang[db.lang_name[i]][j][k] == nil or db.ui[j][k] == nil then return false; end;
    if type == 1 then return db.lang[db.lang_name[i]][j][k][type] ~= nil;
    elseif db.lang[db.lang_name[i]][j][k][2] == nil then return false; end;
    return db.lang[db.lang_name[i]][j][k][2][type - 1] ~= nil;
end; --double checks if anything is wrong

local function SetLanguage(i)    
    if LanguageUpdater(i) == true then
        warning:SetInvisible(true);
        for j = 1, #db.ui do -- loops thru each level of ui
            for k, obj in pairs(db.ui[j]) do -- loops thru each elements
                if EntryIsValid(i, j, k, 1) == true then
                    obj:SetName(db.lang[db.lang_name[i]][j][k][1]);
                end;
                if EntryIsValid(i, j, k, 2) == true then
                    obj:SetDescription(db.lang[db.lang_name[i]][j][k][2][1]);
                end;
                if EntryIsValid(i, j, k, 3) == true then
                    obj:SetOptions(unpack(db.lang[db.lang_name[i]][j][k][2][2]));
                end;
            end;
        end;
    else
        warning:SetInvisible(false); warning:SetText(db.lang[db.lang_name[i]].otdt_msg); -- draws outdated text
    end;
    db.prev = i;
end;
SetLanguage(1);

callbacks.Register("Draw", function()
    if (ui_select:GetValue() + 1) ~= db.prev then
        SetLanguage(ui_select:GetValue() + 1);        
    end;
end);

callbacks.Register("Unload", function()
    SetLanguage(1);
end);
