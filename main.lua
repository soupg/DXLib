--// DXLib //--


--// Presets for supg's smol brain to rember
local Game = dx9.GetDatamodel();
local Workspace = dx9.FindFirstChild(Game,"Workspace");
local Mouse = dx9.GetMouse();
local LocalPlayer = dx9.get_localplayer();
local Players = dx9.get_players();


--// Initiating Library
if _G.dxl == nil then
    _G.dxl = {
        --// Console Vars
        Location = {1000, 150}; -- Dynamic
        Size = {dx9.size().width / 2.95, dx9.size().height / 1.21}; -- Static
        FontColor = {255,255,255}; -- Static + [Changeable]
        MainColor = {28,28,28}; -- Static + [Changeable]
        BackgroundColor = {20,20,20}; -- Static + [Changeable]
        AccentColor = {0,85,255}; -- Static + [Changeable]
        OutlineColor = {50,50,50}; -- Static + [Changeable]
        Black = {0,0,0}; -- Static

        ErrorColor = {255,100,100};

        WinMouseOffset = nil;

        StoredLogs = {};

        Open = true;

        Hovering = false;

        --// Storing older functions and stuff :3
        LoadstringCaching = {};
        GetCaching = {};
        OldLoadstring = loadstring;
        OldGet = dx9.Get;

        OldPrint = print;
        OldError = error;
    };
end


--[[
████████╗██╗   ██╗██████╗ ███████╗     ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗
╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔════╝    ██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝
   ██║    ╚████╔╝ ██████╔╝█████╗      ██║     ███████║█████╗  ██║     █████╔╝ 
   ██║     ╚██╔╝  ██╔═══╝ ██╔══╝      ██║     ██╔══██║██╔══╝  ██║     ██╔═██╗ 
   ██║      ██║   ██║     ███████╗    ╚██████╗██║  ██║███████╗╚██████╗██║  ██╗
   ╚═╝      ╚═╝   ╚═╝     ╚══════╝     ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝
]]

function dxl.TypeCheck(function_name, argument_number, v, t)
    if type(t) == "table" then
        if type(v) ~= "table" then 
            error("[DXL Error] "..function_name..": "..argument_number.." Argument needs to be a table!\n".. debug.traceback().."\n")
            return;
        elseif #t == 0 then
            return; -- Returns if required length is 0 becase its only checking the passed type, not including length
        elseif #v ~= #t then
            error("[DXL Error] "..function_name..": "..argument_number.." Argument needs to contain "..#t.." value(s)!\n".. debug.traceback().."\n")
            return;
        end

        for i,c in pairs(v) do
            if type(c) ~= type(t[i]) then
                local addon = ""
                if t[i] == 69 then addon = " (instance)" end
                error("[DXL Error] "..function_name..": "..argument_number.." Argument (index "..i..") needs to be a "..type(t[i])..addon.."!\n".. debug.traceback().."\n")
                return;
            end
        end
    else
        if type(v) ~= type(t) then
            local addon = ""
            if t == 69 then addon = " (instance)" end
            error("[DXL Error] "..function_name..": "..argument_number.." Argument needs to be a "..type(t)..addon.. "!\n" .. debug.traceback() .. "\n")
            return;
        end
    end
end


--[[
██████╗  ██████╗ ██╗   ██╗███╗   ██╗██████╗  █████╗ ██████╗ ██╗   ██╗     ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗
██╔══██╗██╔═══██╗██║   ██║████╗  ██║██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝
██████╔╝██║   ██║██║   ██║██╔██╗ ██║██║  ██║███████║██████╔╝ ╚████╔╝     ██║     ███████║█████╗  ██║     █████╔╝ 
██╔══██╗██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══██║██╔══██╗  ╚██╔╝      ██║     ██╔══██║██╔══╝  ██║     ██╔═██╗ 
██████╔╝╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝██║  ██║██║  ██║   ██║       ╚██████╗██║  ██║███████╗╚██████╗██║  ██╗
╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝
]]

function dxl.isMouseInArea(area)
    dxl.TypeCheck("isMouseInArea", "First", area, {1, 1, 1, 1})

    if dx9.GetMouse().x > area[1] and dx9.GetMouse().y > area[2] and dx9.GetMouse().x < area[3] and dx9.GetMouse().y < area[4] then
        return true
    else
        return false
    end
end


--[[
 ██████╗ ███████╗████████╗    ██████╗ ██╗███████╗████████╗ █████╗ ███╗   ██╗ ██████╗███████╗
██╔════╝ ██╔════╝╚══██╔══╝    ██╔══██╗██║██╔════╝╚══██╔══╝██╔══██╗████╗  ██║██╔════╝██╔════╝
██║  ███╗█████╗     ██║       ██║  ██║██║███████╗   ██║   ███████║██╔██╗ ██║██║     █████╗  
██║   ██║██╔══╝     ██║       ██║  ██║██║╚════██║   ██║   ██╔══██║██║╚██╗██║██║     ██╔══╝  
╚██████╔╝███████╗   ██║       ██████╔╝██║███████║   ██║   ██║  ██║██║ ╚████║╚██████╗███████╗
 ╚═════╝ ╚══════╝   ╚═╝       ╚═════╝ ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝
]]

function dxl.GetDistance(v, i)
    local v1 = {}
    local v2 = {}

    if type(i) == "table" then
        if i['x'] ~= nil and i['y'] ~= nil and i['z'] ~= nil then
            v1 = i
        else
            dxl.TypeCheck("GetDistance", "Second", i, {1,1,1})
            v1['x'] = i[1]
            v1['y'] = i[2]
            v1['z'] = i[3]
        end
    elseif type(i) == "number" then
        dxl.TypeCheck("GetDistance", "Second", i, 69)
        v1 = dx9.GetPosition(i);
    else
        error("[DXL Error] GetDistance: Second Argument needs to be a table (with position values) or number (instance)!\n".. debug.traceback().."\n")
        return;
    end

    if type(v) == "table" then
        if v['x'] ~= nil and v['y'] ~= nil and v['z'] ~= nil then
            v2 = v
        else
            dxl.TypeCheck("GetDistance", "First", v, {1,1,1})
            v2['x'] = v[1]
            v2['y'] = v[2]
            v2['z'] = v[3]
        end
    elseif type(v) == "number" then
        dxl.TypeCheck("GetDistance", "First", v, 69)
        v2 = dx9.GetPosition(v);
    else
        error("[DXL Error] GetDistance: First Argument needs to be a table (with position values) or number (instance)!\n".. debug.traceback().."\n")
        return;
    end

    local a = (v1.x-v2.x)*(v1.x-v2.x);
    local b = (v1.y-v2.y)*(v1.y-v2.y);
    local c = (v1.z-v2.z)*(v1.z-v2.z);

    return math.floor(math.sqrt(a+b+c)+0.5);
end


--// Get Distance From Player
function dxl.GetDistanceFromPlayer(v)
    return dxl.GetDistance(v, dx9.get_localplayer().Position)
end


--[[
██╗  ██╗███████╗ █████╗ ██╗  ████████╗██╗  ██╗██████╗  █████╗ ██████╗ 
██║  ██║██╔════╝██╔══██╗██║  ╚══██╔══╝██║  ██║██╔══██╗██╔══██╗██╔══██╗
███████║█████╗  ███████║██║     ██║   ███████║██████╔╝███████║██████╔╝
██╔══██║██╔══╝  ██╔══██║██║     ██║   ██╔══██║██╔══██╗██╔══██║██╔══██╗
██║  ██║███████╗██║  ██║███████╗██║   ██║  ██║██████╔╝██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
{TargetPosition = {x, y, z}, Size = {x, y}, HP = hp, MaxHP = max_hp, Scale = false, Offset = {x, y}}
]]

function dxl.HealthBar(params)
    --// Variable Insurance
    local size = params.Size or {120, 5}
    local size_x = size[1]
    local size_y = size[2]

    local maxhp = params.MaxHP or 100

    local scale = params.Scale or false

    local offset = params.Offset or {0,0}
    --// Error Handling
    local pos = {}

    if params.TargetPosition.x and params.TargetPosition.y and params.TargetPosition.z and type(params.TargetPosition.x) == "number" and type(params.TargetPosition.y) == "number" and type(params.TargetPosition.z) == "number" then
        pos = {params.TargetPosition.x, params.TargetPosition.y, params.TargetPosition.z}

    elseif params.TargetPosition[1] and params.TargetPosition[2] and params.TargetPosition[3] and type(params.TargetPosition[1]) == "number" and type(params.TargetPosition[2]) == "number" and type(params.TargetPosition[3]) == "number" then 
        if #params.TargetPosition == 3 then 
            pos = {params.TargetPosition[1], params.TargetPosition[2], params.TargetPosition[3]}
        else
            error("[DXL Error] HealthBar: TargetPosition Argument needs to contain 3 number values! (x, y, z)\n".. debug.traceback().."\n")
            return;
        end
    else
        error("[DXL Error] HealthBar: TargetPosition Argument needs to contain 3 number values! (x, y, z)\n".. debug.traceback().."\n")
        return;
    end

    dxl.TypeCheck("HealthBar", "TargetPosition", pos, {1, 1, 1})
    dxl.TypeCheck("HealthBar", "HP", params.HP, 1)

    local hp = params.HP

    if not scale then
        local wts = dx9.WorldToScreen(pos);

        local x = wts.x
        local y = wts.y


        --// A lot of math stuff, dont mess with it unless u know what ur doing
        local temp = ((size_x - 2) / ( maxhp/math.max(0, math.min(maxhp, hp))));

        dx9.DrawFilledBox({x - (size_x/2) + offset[1], y + offset[2]}, {x + (size_x/2) + offset[1], y - size_y + offset[2]}, {0,0,0});
        dx9.DrawFilledBox({x - ((size_x/2) - 1) + offset[1], y - 1 + offset[2]}, {x - ((size_x/2) - 1) + temp + offset[1], y - (size_y - 1) + offset[2]},   {255 - 255 / (maxhp / hp), 255 / (maxhp / hp), 0});

    else
        size_x = size_x / 10
        size_y = size_y / 10
        --// AIDS BELOW (WATCH OUT) (WARNING) (DANGER)
        local wts1 = dx9.WorldToScreen({pos[1] - (size_x/2), pos[2] - (size_y/2), pos[3]});
        local wts2 = dx9.WorldToScreen({pos[1] + (size_x/2), pos[2] + (size_y/2), pos[3]});
        

        --// A lot of math stuff, dont mess with it unless u know what ur doing
        --local temp = ((size_x - 2) / ( maxhp/math.max(0, math.min(maxhp, hp))));
        
        dx9.DrawFilledBox({wts1.x, wts1.y}, {wts2.x, wts2.y}, {0,0,0});
        
        dx9.DrawFilledBox({wts1.x + 1, wts1.y - 1}, {wts2.x - 1     , wts2.y + 1},            {255 - 255 / (maxhp / hp), 255 / (maxhp / hp), 0});
    end
end


--[[
 ██████╗  █████╗ ███╗   ███╗███████╗    ███████╗██╗   ██╗███╗   ██╗ ██████╗███████╗
██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔════╝██║   ██║████╗  ██║██╔════╝██╔════╝
██║  ███╗███████║██╔████╔██║█████╗      █████╗  ██║   ██║██╔██╗ ██║██║     ███████╗
██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██╔══╝  ██║   ██║██║╚██╗██║██║     ╚════██║
╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ██║     ╚██████╔╝██║ ╚████║╚██████╗███████║
 ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝
]]

function dxl.Game(...)
    local a = dx9.GetDatamodel()
    for c, d in pairs({...}) do
        a = dx9.FindFirstChild(a, d)
    end
    return a
end


--// Get Descendants
function dxl.GetDescendants(instance)
    dxl.TypeCheck("GetDescendants", "First", instance, 69)

    local children = {}
    for _, child in ipairs(dx9.GetChildren(instance)) do
        table.insert(children, child)
        if #dx9.GetChildren(child) > 0 then
            for i,v in pairs(dxl.GetDescendants(child)) do
                table.insert(children, v)
            end
        end
    end
    return children
end


--// Get Descendants of Class
function dxl.GetDescendantsOfClass(instance, class)
    dxl.TypeCheck("GetDescendantsOfClass", "First", instance, 69)
    dxl.TypeCheck("GetDescendantsOfClass", "Second", class, "string!! yay!!")

    local children = {}
    for i,v in pairs(dxl.GetDescendants(instance)) do
        if dx9.GetType(v) == class then
            table.insert(children, v)
        end
    end
    return children
end


--// Get Closest Part
function dxl.GetClosestPart(target)
    dxl.TypeCheck("GetClosestPart", "First", target, 69) --// Tuple check is empty because the target may have an unknown amount of values in the tuple, thus im only checking IF its a tuple.

    local closest_part
    local valid_classes = {
        Part = true;
        MeshPart = true;
        Accessory = true;
        TrussPart = true;
        WedgePart = true;
        CornerWedgePart = true;
        SpecialMesh = true;
        BlockMesh = true;
    };

    for i,v in pairs(dxl.GetDescendants(target)) do
        if valid_classes[dx9.GetType(v)] then
		if closest_part == nil then
			closest_part = v
		end
            if dxl.GetDistanceFromPlayer(dx9.GetPosition(v)) < dxl.GetDistanceFromPlayer(dx9.GetPosition(closest_part)) then
                closest_part = v;
            end
        end
    end
    return closest_part;
end


--[[
██████╗ ██╗      █████╗ ██╗   ██╗███████╗██████╗     ███████╗██╗   ██╗███╗   ██╗ ██████╗███████╗
██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗    ██╔════╝██║   ██║████╗  ██║██╔════╝██╔════╝
██████╔╝██║     ███████║ ╚████╔╝ █████╗  ██████╔╝    █████╗  ██║   ██║██╔██╗ ██║██║     ███████╗
██╔═══╝ ██║     ██╔══██║  ╚██╔╝  ██╔══╝  ██╔══██╗    ██╔══╝  ██║   ██║██║╚██╗██║██║     ╚════██║
██║     ███████╗██║  ██║   ██║   ███████╗██║  ██║    ██║     ╚██████╔╝██║ ╚████║╚██████╗███████║
╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝
]]

--// Get Local Player Name
function dxl.GetLocalPlayerName()
    return dx9.get_localplayer().Info.Name
end

--// Get Local Player
function dxl.GetLocalPlayer()
    return dxl.Game("Players", dxl.GetLocalPlayerName())
end

--// Get PlayerGui of Local Player
function dxl.GetLocalPlayerGUI()
    return dxl.Game("Players", dxl.GetLocalPlayerName(),"PlayerGui")
end

--// Get Character
function dxl.GetCharacter(var) 
    local name

    if type(var) == "number" and dx9.GetName(var) ~= nil then 
        name = dx9.GetName(var) 
    else 
        dxl.TypeCheck("GetCharacter", "First", var, "string!")
        name = var 
    end

    for i,v in pairs(dxl.GetDescendants(dxl.Game("Workspace"))) do
        if dx9.GetName(v) == name and dx9.GetType(v) == "Model" then
            return v
        end
    end

    return 0
end

--// Get Local Character
function dxl.GetLocalCharacter()
    return dxl.GetCharacter(dxl.GetLocalPlayer())
end


--[[
███╗   ███╗██╗███████╗ ██████╗    ███████╗██╗   ██╗███╗   ██╗ ██████╗███████╗
████╗ ████║██║██╔════╝██╔════╝    ██╔════╝██║   ██║████╗  ██║██╔════╝██╔════╝
██╔████╔██║██║███████╗██║         █████╗  ██║   ██║██╔██╗ ██║██║     ███████╗
██║╚██╔╝██║██║╚════██║██║         ██╔══╝  ██║   ██║██║╚██╗██║██║     ╚════██║
██║ ╚═╝ ██║██║███████║╚██████╗    ██║     ╚██████╔╝██║ ╚████║╚██████╗███████║
╚═╝     ╚═╝╚═╝╚══════╝ ╚═════╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝
]]


--// Json To Table
function dxl.JsonToTable(json)
    dxl.TypeCheck("JsonToTable", "First", json, "checking if its a string :)")

    return loadstring("return "..json:gsub('("[^"]-"):','[%1]='))()
end


--// Better Loadstring
function dxl.loadstring(string)
    dxl.TypeCheck("loadstring", "First", string, "string!!!")

    if dxl.LoadstringCaching[string] == nil then
        dxl.LoadstringCaching[string] = dxl.OldLoadstring(string)
    else
        return dxl.LoadstringCaching[string]
    end
end
_G.loadstring = dxl.loadstring


--// Better Get
function dxl.Get(string)
    dxl.TypeCheck("Get", "First", string, "string!!!")

    if dxl.GetCaching[string] == nil then
        dxl.GetCaching[string] = dxl.OldGet(string)
    else
        return dxl.GetCaching[string]
    end
end
_G.dx9.Get = dxl.Get


--// Better Console
function dxl.ShowConsole(useless_variable_used_to_hook_dx9_show_console_function_and_still_work_with_this_function)
    if not useless_variable_used_to_hook_dx9_show_console_function_and_still_work_with_this_function and useless_variable_used_to_hook_dx9_show_console_function_and_still_work_with_this_function ~= nil then return end

    if dxl.isMouseInArea({dxl.Location[1] + dxl.Size[1] - 27, dxl.Location[2] + 3, dxl.Location[1] + dxl.Size[1] - 5, dxl.Location[2] + 19}) then
        if dx9.isLeftClick() then
            dxl.Open = not dxl.Open;
        end

        dxl.Hovering = true
    else
        dxl.Hovering = false
    end

    --// Left Click Held
    if dx9.isLeftClickHeld() then
        --// Drag Func
        if dxl.isMouseInArea({dxl.Location[1] - 5, dxl.Location[2] - 10, dxl.Location[1] + dxl.Size[1] + 5, dxl.Location[2] + 30}) then
            if dxl.WinMouseOffset == nil then
                dxl.WinMouseOffset = {dx9.GetMouse().x - dxl.Location[1], dx9.GetMouse().y - dxl.Location[2]}
            end
            dxl.Location = {dx9.GetMouse().x - dxl.WinMouseOffset[1], dx9.GetMouse().y - dxl.WinMouseOffset[2]}
        end
    else
        dxl.WinMouseOffset = nil
    end

    if dxl.Open then
        dx9.DrawFilledBox({dxl.Location[1] - 1, dxl.Location[2] - 1}, {dxl.Location[1] + dxl.Size[1] + 1, dxl.Location[2] + dxl.Size[2] + 1}, dxl.Black) --// Outline
        dx9.DrawFilledBox(dxl.Location, {dxl.Location[1] + dxl.Size[1], dxl.Location[2] + dxl.Size[2]}, dxl.AccentColor) --// Accent
        dx9.DrawFilledBox({dxl.Location[1] + 1, dxl.Location[2] + 1}, {dxl.Location[1] + dxl.Size[1] - 1, dxl.Location[2] + dxl.Size[2] - 1}, dxl.MainColor) --// Main Outer (light gray)
        dx9.DrawFilledBox({dxl.Location[1] + 5, dxl.Location[2] + 20}, {dxl.Location[1] + dxl.Size[1] - 5, dxl.Location[2] + dxl.Size[2] - 5}, dxl.BackgroundColor) --// Main Inner (dark gray)
        dx9.DrawBox({dxl.Location[1] + 5, dxl.Location[2] + 20}, {dxl.Location[1] + dxl.Size[1] - 5, dxl.Location[2] + dxl.Size[2] - 5}, dxl.OutlineColor) --// Main Inner Outline 
        dx9.DrawBox({dxl.Location[1] + 6, dxl.Location[2] + 21}, {dxl.Location[1] + dxl.Size[1] - 6, dxl.Location[2] + dxl.Size[2] - 6}, dxl.Black) --// Main Inner Outline Black
        dx9.DrawString(dxl.Location, dxl.FontColor, "  DXLib Console")

        for i,v in pairs(dxl.StoredLogs) do
            if string.sub(v, 1, 9) == "ERROR_TAG" then
                dx9.DrawString({dxl.Location[1] + 10, dxl.Location[2] + 5 + i*18}, dxl.ErrorColor, string.sub(v, 10, -1))
            else
                dx9.DrawString({dxl.Location[1] + 10, dxl.Location[2] + 5 + i*18}, dxl.FontColor, v)
            end
        end
    else
        dx9.DrawFilledBox({dxl.Location[1] + 300, dxl.Location[2] - 1}, {dxl.Location[1] + dxl.Size[1] + 1, dxl.Location[2] + 23}, dxl.Black) --// Outline
        dx9.DrawFilledBox({dxl.Location[1] + 301, dxl.Location[2]}, {dxl.Location[1] + dxl.Size[1],  dxl.Location[2] + 22}, dxl.AccentColor) --// Accent
        dx9.DrawFilledBox({dxl.Location[1] + 302, dxl.Location[2] + 1}, {dxl.Location[1] + dxl.Size[1] - 1,  dxl.Location[2] + 21}, dxl.MainColor) --// Main Outer (light gray)

        dx9.DrawString({dxl.Location[1] + 300, dxl.Location[2]}, dxl.FontColor, "  DXLib Console")
    end


    if dxl.Hovering then
        dx9.DrawFilledBox({dxl.Location[1] + dxl.Size[1] - 27, dxl.Location[2] + 3}, {dxl.Location[1] + dxl.Size[1] - 5, dxl.Location[2] + 19}, dxl.AccentColor) --// Outline
    else
        dx9.DrawFilledBox({dxl.Location[1] + dxl.Size[1] - 27, dxl.Location[2] + 3}, {dxl.Location[1] + dxl.Size[1] - 5, dxl.Location[2] + 19}, dxl.Black) --// Outline
    end

    dx9.DrawFilledBox({dxl.Location[1] + dxl.Size[1] - 26, dxl.Location[2] + 4}, {dxl.Location[1] + dxl.Size[1] - 6, dxl.Location[2] + 18}, dxl.OutlineColor) --// Inner Line
    dx9.DrawFilledBox({dxl.Location[1] + dxl.Size[1] - 25, dxl.Location[2] + 5}, {dxl.Location[1] + dxl.Size[1] - 7, dxl.Location[2] + 17}, dxl.MainColor) --// Inner

    dx9.DrawString({dxl.Location[1] + dxl.Size[1] - 20, dxl.Location[2] - 2}, dxl.FontColor, "_")

    function dxl.error(...)
        local temp = "";
        for i,v in pairs({...}) do
            temp = temp..tostring(v).." "
        end
        
        local split_string = {};
        if string.gmatch(temp, "([^\n]+)") ~= nil then
            for i in ( string.gmatch(temp, "([^\n]+)") ) do
                table.insert(split_string, i)
            end    
        end

        if split_string == {} then
            if #dxl.StoredLogs < 45 then
                table.insert(dxl.StoredLogs, "ERROR_TAG"..temp)
            else
                table.insert(dxl.StoredLogs, "ERROR_TAG"..temp)

                for i,v in pairs(dxl.StoredLogs) do
                    dxl.StoredLogs[i] = dxl.StoredLogs[i + 1]
                end
            end
        else
            for i,v in pairs(split_string) do
                if #dxl.StoredLogs < 45 then
                    table.insert(dxl.StoredLogs, "ERROR_TAG"..v)
                else
                    table.insert(dxl.StoredLogs, "ERROR_TAG"..v)
        
                    for i,v in pairs(dxl.StoredLogs) do
                        dxl.StoredLogs[i] = dxl.StoredLogs[i + 1]
                    end
                end
            end
        end
    end

    function dxl.print(...)
        local temp = "";
        for i,v in pairs({...}) do
            temp = temp..tostring(v).." "
        end
        
        local split_string = {};
        if string.gmatch(temp, "([^\n]+)") ~= nil then
            for i in ( string.gmatch(temp, "([^\n]+)") ) do
                table.insert(split_string, i)
            end    
        end

        if split_string == {} then
            if #dxl.StoredLogs < 45 then
                table.insert(dxl.StoredLogs, temp)
            else
                table.insert(dxl.StoredLogs, temp)

                for i,v in pairs(dxl.StoredLogs) do
                    dxl.StoredLogs[i] = dxl.StoredLogs[i + 1]
                end
            end
        else
            for i,v in pairs(split_string) do
                if #dxl.StoredLogs < 45 then
                    table.insert(dxl.StoredLogs, v)
                else
                    table.insert(dxl.StoredLogs, v)
        
                    for i,v in pairs(dxl.StoredLogs) do
                        dxl.StoredLogs[i] = dxl.StoredLogs[i + 1]
                    end
                end
            end
        end
    end

    dxl.StoredLogs = {};
    _G.dxl = dxl
end


--// Supg's attempt at making print() actually print as well as output to dxLib console (wish me luck)

function double_print(sussy_variable)
    dxl.OldPrint(sussy_variable);
    dxl.print(sussy_variable);
end
_G.print = double_print
_G.error = dxl.error


--// Hooking DX9 Functions
if _G.betterdebugrun == nil then
    local havethesamestructionchild = {"FindFirstChild","FindFirstChildOfClass","FindFirstDescendant"}

    for i,v in pairs(havethesamestructionchild) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "number" then
                dxl.error("[DX9 Error] "..v..": First Argument needs to be a number! (Instance)" .. "\n" .. debug.traceback() .. "\n")
            return
            end
            if type(args[2]) ~= "string" then
                dxl.error("[DX9 Error] "..v..": Second Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            return old(...)
        end
    end

    local havethesamestruction = {"GetName","GetAllParts","GetCFrame","GetChildren","GetPosition","GetParent","GetTeam","GetTeamColour","GetCharacter","GetAdornee","GetType","GetImageLabelPosition","GetNumValue","GetStringValue","GetBoolValue"}
    local custommessages = {
        ["GetCharacter"] = ": First Argument needs to be a player instance!",
        ["GetTeam"] = ": First Argument needs to be a player instance!",
        ["GetTeamColour"] = ": First Argument needs to be a player instance!",
        ["GetNumValue"] = ": First Argument needs to be a IntValue Instance!",
    }
    for i,v in pairs(havethesamestruction) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "number" then
                local messagethign = custommessages[v] or ": First Argument needs to be a number (Instance)!"
                dxl.error("[DX9 Error] "..v..messagethign .. "\n" .. debug.traceback() .. "\n")
            return
            end
            return old(...)
        end
    end

    local old = _G["dx9"]["Teleport"]
    _G["dx9"]["Teleport"] = function(...)
        local args = {...}
        if type(args[1]) ~= "number" then
            dxl.error("[DX9 Error] ".."Teleport"..": First Argument needs to be a number! (Instance)" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[DX9 Error] ".."Teleport"..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["SetAimbotValue"]
    _G["dx9"]["SetAimbotValue"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            dxl.error("[DX9 Error] ".."SetAimbotValue"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "number" then
            dxl.error("[DX9 Error] ".."SetAimbotValue"..": Second Argument needs to be a Number!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["get_info"]
    _G["dx9"]["get_info"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            dxl.error("[DX9 Error] ".."get_info"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "string" then
            dxl.error("[DX9 Error] ".."get_info"..": Second Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["get_player"]
    _G["dx9"]["get_player"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            dxl.error("[DX9 Error] ".."get_player"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        return old(...)
    end

    for i,v in pairs({"FirstPersonAim","ThirdPersonAim"}) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "table" then
                dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[2]) ~= "number" then
                dxl.error("[DX9 Error] "..v..": Second Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[3]) ~= "number" then
                dxl.error("[DX9 Error] "..v..": Third Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            return old(...)
        end
    end

    for i,v in pairs({"DrawFilledBox","DrawLine","DrawBox"}) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "table" then
                dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[2]) ~= "table" then
                dxl.error("[DX9 Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[3]) ~= "table" then
                dxl.error("[DX9 Error] "..v..": Third Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            return old(...)
        end
    end

    local old = _G["dx9"]["DrawCircle"]
    _G["dx9"]["DrawCircle"] = function(...)
        local args = {...}
        local v = "DrawCircle"
        if type(args[1]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "number" then
            dxl.error("[DX9 Error] "..v..": Third Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["DrawString"]
    _G["dx9"]["DrawString"] = function(...)
        local args = {...}
        local v = "DrawString"
        if type(args[1]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "string" then
            dxl.error("[DX9 Error] "..v..": Third Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["Box3d"]
    _G["dx9"]["Box3d"] = function(...)
        local args = {...}
        local v = "Box3d"
        if type(args[1]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Third Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[4]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Fourth Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[5]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Fifth Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["WorldToScreen"]
    _G["dx9"]["WorldToScreen"] = function(...)
        local args = {...}
        local v = "WorldToScreen"
        if type(args[1]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end
    _G.betterdebugrun = {}
end
