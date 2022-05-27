--// BetterConsole //--

local dxl = {};
if _G.dxl == nil then
    _G.dxl = {
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
    };
end
local dxl = _G.dxl

--// Boundary Check
function dxl.isMouseInArea(area)
    if dx9.GetMouse().x > area[1] and dx9.GetMouse().y > area[2] and dx9.GetMouse().x < area[3] and dx9.GetMouse().y < area[4] then
        return true
    else
        return false
    end
end

function dxl.GetDistance(v, i)
    local v1 = dx9.GetPosition(i);
    local v2 = dx9.GetPosition(v);
    local a = (v1.x-v2.x)*(v1.x-v2.x);
    local b = (v1.y-v2.y)*(v1.y-v2.y);
    local c = (v1.z-v2.z)*(v1.z-v2.z);
    return math.floor(math.sqrt(a+b+c)+0.5);
end


function dxl.JsonToTable(json)
    return loadstring("return "..json:gsub('("[^"]-"):','[%1]='))()
end


function dxl.ShowConsole()
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

        dx9.DrawString({dxl.Location[1] + 300, dxl.Location[2]}, dxl.FontColor, "  DX9 Console | Made by Alleexxii and supg")
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



if _G.betterdebugrun == nil then
    local havethesamestructionchild = {"FindFirstChild","FindFirstChildOfClass","FindFirstDescendant"}

    for i,v in pairs(havethesamestructionchild) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "number" then
                dxl.error("[Error] "..v..": First Argument needs to be a number! (Instance)" .. "\n" .. debug.traceback() .. "\n")
            return
            end
            if type(args[2]) ~= "string" then
                dxl.error("[Error] "..v..": Second Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
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
                dxl.error("[Error] "..v..messagethign .. "\n" .. debug.traceback() .. "\n")
            return
            end
            return old(...)
        end
    end

    local old = _G["dx9"]["Teleport"]
    _G["dx9"]["Teleport"] = function(...)
        local args = {...}
        if type(args[1]) ~= "number" then
            dxl.error("[Error] ".."Teleport"..": First Argument needs to be a number! (Instance)" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[Error] ".."Teleport"..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["SetAimbotValue"]
    _G["dx9"]["SetAimbotValue"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            dxl.error("[Error] ".."SetAimbotValue"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "number" then
            dxl.error("[Error] ".."SetAimbotValue"..": Second Argument needs to be a Number!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["get_info"]
    _G["dx9"]["get_info"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            dxl.error("[Error] ".."get_info"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "string" then
            dxl.error("[Error] ".."get_info"..": Second Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["get_player"]
    _G["dx9"]["get_player"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            dxl.error("[Error] ".."get_player"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        return old(...)
    end

    for i,v in pairs({"FirstPersonAim","ThirdPersonAim"}) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "table" then
                dxl.error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[2]) ~= "number" then
                dxl.error("[Error] "..v..": Second Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[3]) ~= "number" then
                dxl.error("[Error] "..v..": Third Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
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
                dxl.error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[2]) ~= "table" then
                dxl.error("[Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[3]) ~= "table" then
                dxl.error("[Error] "..v..": Third Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
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
            dxl.error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "number" then
            dxl.error("[Error] "..v..": Third Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["DrawString"]
    _G["dx9"]["DrawString"] = function(...)
        local args = {...}
        local v = "DrawString"
        if type(args[1]) ~= "table" then
            dxl.error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "string" then
            dxl.error("[Error] "..v..": Third Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["Box3d"]
    _G["dx9"]["Box3d"] = function(...)
        local args = {...}
        local v = "Box3d"
        if type(args[1]) ~= "table" then
            dxl.error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "table" then
            dxl.error("[Error] "..v..": Third Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[4]) ~= "table" then
            dxl.error("[Error] "..v..": Fourth Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[5]) ~= "table" then
            dxl.error("[Error] "..v..": Fifth Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["WorldToScreen"]
    _G["dx9"]["WorldToScreen"] = function(...)
        local args = {...}
        local v = "WorldToScreen"
        if type(args[1]) ~= "table" then
            dxl.error("[Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end
    _G.betterdebugrun = {}
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------
