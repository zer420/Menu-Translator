local info = {
    v_loc = 1.00,
    v_onl = http.Get("https://raw.githubusercontent.com/zer420/Menu-Translator/master/version"),
    src = "https://raw.githubusercontent.com/zer420/Menu-Translator/master/core",
    dir = "zerlib\\",
    sc_dir = "menutrsltr\\",
    name = GetScriptName(),
    updt_available = false,
};
UnloadScript(info.dir .. "reload.lua");

local function Updater()
    if info.v_loc < tonumber(info.v_onl) then
        local reload = file.Open(info.dir .. "reload.lua", "w");
        reload:Write([[local f=0;callbacks.Register("Draw",function()if f==0 then UnloadScript("]]..info.name..[[");elseif f==1 then LoadScript("]]..info.name..[[");end;f=f+1;end);]]);
        reload:Close();
        local file = file.Open(info.name, "w"); file:Write(http.Get(info.src)); file:Close(); LoadScript(info.dir .. "reload.lua");
end; end; Updater();

local db = {
    prev = "English",
    lang_name = {"English", "中文",}, --"Français", "Español", "Suomi", "Português", "Romana", "Deutsch", "Italiano",
    lang_checked = {false, false, false,},
    lang = {
        ["English"] = {},
        ["中文"] = {},
        ["Français"] = {},
    },
    src = {
        [1] = "https://raw.githubusercontent.com/zer420/Menu-Translator/master/languages/English",
        [2] = "https://aimware.coding.net/p/AIMWARE_Chinese_Lua/d/AIMWARE_Chinese_Lua/git/raw/master/MenuTranslator/Chinese.lua",
        [3] = "https://raw.githubusercontent.com/zer420/Menu-Translator/master/languages/French",
    },
    v_onl = {
        [1] = "https://raw.githubusercontent.com/zer420/Menu-Translator/master/languages/English-version",
        [2] = "https://aimware.coding.net/p/AIMWARE_Chinese_Lua/d/AIMWARE_Chinese_Lua/git/raw/master/MenuTranslator/version",
        [3] = "https://raw.githubusercontent.com/zer420/Menu-Translator/master/languages/French-version",
    },
};

local function LanguageUpdater(i)
    local curr_dir = (info.dir .. info.sc_dir .. db.lang_name[i] .. ".lua");
    local curr_db = RunScript(curr_dir);
    if db.lang_checked[i] == false then
        if curr_db == nil then
            info.updt_available = true;
        elseif curr_db.v_loc < tonumber(http.Get(db.v_onl[i])) then
            info.updt_available = true;
        end;
        if info.updt_available == true then
        local file = file.Open(curr_dir, "w");
        file:Write(http.Get(db.src[i])); file:Close(); curr_db = RunScript(curr_dir);
        end;
        db.lang_checked[i] = true;
    end;
    db.lang[db.lang_name[i]] = curr_db;
end; LanguageUpdater(1);

local ui_select = gui.Combobox(gui.Reference("Settings", "Advanced", "Manage advanced settings"), "language", "Menu Language", unpack(db.lang_name));

local function SetLanguage(h)
    LanguageUpdater(h);
    for i = 1, #db.lang[db.lang_name[1]][1] do --Tab
        for j = 1, #db.lang[db.lang_name[1]][(i + 1)][1] do --Subtab
            if db.lang[db.lang_name[1]][(i + 1)][(j + 1)] ~= nil then
                for k = 1, #db.lang[db.lang_name[1]][(i + 1)][(j + 1)][1] do --Groupbox
                    if db.lang[db.lang_name[1]][(i + 1)][(j + 1)][(k + 1)] ~= nil and db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)] ~= nil then
                        for l, m in pairs(db.lang[db.lang_name[1]][(i + 1)][(j + 1)][(k + 1)]) do --Control
                            if m ~= nil and db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l] ~= nil then
                                if m[5] == nil and m[6] == nil and db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][5] == nil and db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][6] == nil then --Cannot acces inside of some tabs
                                    if m[1] ~= nil and db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][1] ~= nil then    
                                            --print(db.lang[db.prev][1][i], db.lang[db.prev][(i + 1)][1][j], db.lang[db.prev][(i + 1)][(j + 1)][1][k], db.lang[db.prev][(i + 1)][(j + 1)][(k + 1)][l][1])
                                        local curr_ref = gui.Reference(db.lang[db.prev][1][i], db.lang[db.prev][(i + 1)][1][j], db.lang[db.prev][(i + 1)][(j + 1)][1][k], db.lang[db.prev][(i + 1)][(j + 1)][(k + 1)][l][1]);   
                                        if m[4] ~= nil and db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][4] ~= nil then
                                            for n = 1, #m[4] do --Multibox
                                                gui.Reference(db.lang[db.prev][1][i], db.lang[db.prev][(i + 1)][1][j], db.lang[db.prev][(i + 1)][(j + 1)][1][k], db.lang[db.prev][(i + 1)][(j + 1)][(k + 1)][l][1], db.lang[db.prev][(i + 1)][(j + 1)][(k + 1)][l][4][n]):SetName(db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][4][n]);            
                                            end;
                                        end;
                                        if m[3] ~= nil and db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][3] ~= nil then
                                            curr_ref:SetOptions(unpack(db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][3]));
                                        end;
                                        if m[2] ~= nil and db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][2] ~= nil then                                
                                            curr_ref:SetDescription(db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][2]);
                                        end;
                                        if m[1] ~= nil and db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][2] ~= nil then
                                            curr_ref:SetName(db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][1]);
                                        end;
                                    else
                                        if m[2] ~= nil and db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][2] ~= nil then
                                            gui.Reference(db.lang[db.prev][1][i], db.lang[db.prev][(i + 1)][1][j], db.lang[db.prev][(i + 1)][(j + 1)][1][k]):SetDescription(db.lang[db.lang_name[h]][(i + 1)][(j + 1)][(k + 1)][l][2]);
                                        end;
                                    end;
                                end;
                            end;           
                        end;
                        gui.Reference(db.lang[db.prev][1][i], db.lang[db.prev][(i + 1)][1][j], db.lang[db.prev][(i + 1)][(j + 1)][1][k]):SetName(db.lang[db.lang_name[h]][(i + 1)][(j + 1)][1][k]);
                    end;                   
                end;
                gui.Reference(db.lang[db.prev][1][i], db.lang[db.prev][(i + 1)][1][j]):SetName(db.lang[db.lang_name[h]][(i + 1)][1][j]);
            end;
        end;
    gui.Reference(db.lang[db.prev][1][i]):SetName(db.lang[db.lang_name[h]][1][i]);
    end;
    db.prev = db.lang_name[h];
end;

callbacks.Register("Draw", function()
    if db.lang_name[(ui_select:GetValue() + 1)] ~= db.prev then
        SetLanguage(ui_select:GetValue() + 1);        
    end;
end);

callbacks.Register("Unload", function()
    SetLanguage(1);
end);
