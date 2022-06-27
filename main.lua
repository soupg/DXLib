--// DXLib //--


--// Presets for supg's smol brain to rember
local Game = dx9.GetDatamodel();
local Workspace = dx9.FindFirstChild(Game,"Workspace");
local Mouse = dx9.GetMouse();
local LocalPlayer = dx9.get_localplayer();
local Players = dx9.get_players();
local Screen = {
    x = dx9.size().width;
    y = dx9.size().height;
}

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

        --// Sleep
        Threads = {};
    };
end


--// Threads (temp)

local ThreadCount = 0

function sleep(v, index)
    ThreadCount = ThreadCount + 1

    assert(type(v) == "number" and v >= 0, "Bruh") --// Change error

    if v == 0 then
        dxl.Threads[ThreadCount] = nil
        --ThreadCount = ThreadCount - 1
        return true 
    end

    local total_seconds = (os.date("*t").hour * 3600) + (os.date("*t").min * 60) + (os.date("*t").sec)

    if dxl.Threads[ThreadCount] == nil then
        local largest_end = total_seconds

        if index ~= nil then
            for i,f in pairs(dxl.Threads) do
                if f.Index == index then
                    if f.End > largest_end then
                        largest_end = f.End
                    end
                end
            end
        end

        dxl.Threads[ThreadCount] = {
            End = largest_end + v;
            Index = index;
        }
    else
    
        if total_seconds >= dxl.Threads[ThreadCount].End then
            dxl.Threads[ThreadCount] = nil
            --ThreadCount = ThreadCount - 1
            return true 
        end
    end
    return false
end


--[[
██████╗  █████╗ ███████╗██╗ ██████╗    ███████╗██╗   ██╗███╗   ██╗ ██████╗███████╗
██╔══██╗██╔══██╗██╔════╝██║██╔════╝    ██╔════╝██║   ██║████╗  ██║██╔════╝██╔════╝
██████╔╝███████║███████╗██║██║         █████╗  ██║   ██║██╔██╗ ██║██║     ███████╗
██╔══██╗██╔══██║╚════██║██║██║         ██╔══╝  ██║   ██║██║╚██╗██║██║     ╚════██║
██████╔╝██║  ██║███████║██║╚██████╗    ██║     ╚██████╔╝██║ ╚████║╚██████╗███████║
╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝ ╚═════╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝
]]


--// Not sure if each screen is a different size (dx9.size) so I'm using this to use % instead of Pixels to click / move to screen coords
function dxl.GetCoords(wts)
    assert(type(wts) == "table" and #wts == 2, "[DXL Error] GetCoords: First Argument needs to be a table with 2 values!")

    --// Divides my screen size by my input coords to get %, then turns the % into a screen coord that corisponds with the client's screen size
    return {(Screen.x / (1920 / wts[1])), (Screen.y / (1017 / wts[2]))} 
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
    assert(type(area) == "table" and #area == 4, "[DXL Error] isMouseInArea: First Argument needs to be a table with 4 values!")

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
            assert(type(i) == "table" and #i == 3, "[DXL Error] GetDistance: Second Argument needs to be a table with 3 values!")
            v1['x'] = i[1]
            v1['y'] = i[2]
            v1['z'] = i[3]
        end
    elseif type(i) == "number" then
        assert(type(i) == "number" and dx9.GetPosition(i), "[DXL Error] GetDistance: Second Argument needs to be a number (pointer)!")
        v1 = dx9.GetPosition(i);
    else
        error("[DXL Error] GetDistance: Second Argument needs to be a table (with position values) or number (instance)!\n".. debug.traceback().."\n")
        return;
    end

    if type(v) == "table" then
        if v['x'] ~= nil and v['y'] ~= nil and v['z'] ~= nil then
            v2 = v
        else
            assert(type(v) == "table" and #v == 3, "[DXL Error] GetDistance: First Argument needs to be a table with 3 values!")

            v2['x'] = v[1]
            v2['y'] = v[2]
            v2['z'] = v[3]
        end
    elseif type(v) == "number" then
        assert(type(v) == "number" and dx9.GetPosition(v), "[DXL Error] GetDistance: First Argument needs to be a number (pointer)!")
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

    assert(type(pos) == "table" and #pos == 3, "[DXL Error] HealthBar: TargetPosition Argument needs to be a table with 3 values!")
    assert(type(params.HP) == "number", "[DXL Error] HealthBar: HP Argument needs to be a number!")

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
██████╗ ██████╗     ██████╗  ██████╗ ██╗  ██╗
╚════██╗██╔══██╗    ██╔══██╗██╔═══██╗╚██╗██╔╝
 █████╔╝██║  ██║    ██████╔╝██║   ██║ ╚███╔╝ 
 ╚═══██╗██║  ██║    ██╔══██╗██║   ██║ ██╔██╗ 
██████╔╝██████╔╝    ██████╔╝╚██████╔╝██╔╝ ██╗
╚═════╝ ╚═════╝     ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
]]

function dxl.Box3d(bruh1, bruh2, bruh3) 

    local box_color = bruh3
    local c1 = bruh1 --// 5, 5, 5
    local c2 = bruh2 --// -5, -5, -5

    local v1 = dx9.WorldToScreen(c1);
    local v2 = dx9.WorldToScreen(c2);

    local v3 = dx9.WorldToScreen({c2[1], c2[2], c1[3]})
    local v4 = dx9.WorldToScreen({c2[1], c1[2], c1[3]})

    local v5 = dx9.WorldToScreen({c1[1], c1[2], c2[3]})
    local v6 = dx9.WorldToScreen({c1[1], c2[2], c2[3]})

    print(v1.x)
    --// Supg did the math below (took me 5 minutes and 47 seconds flat)
    dx9.DrawBox({v1.x, v1.y}, {v3.x, v3.y}, box_color)
    dx9.DrawBox({v4.x, v4.y}, {v2.x, v2.y}, box_color)
    dx9.DrawBox({v2.x, v2.y}, {v5.x, v5.y}, box_color)
    dx9.DrawBox({v6.x, v6.y}, {v1.x, v1.y}, box_color)
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


--// Troll Command
--[[
function dxl.Troll()

    

    if sleep(3, "core1") then
        dx9.MouseMove(dxl.GetCoords({20, 1040}))
        dx9.Mouse1Click()
    end

    if sleep(1, "core1") then
        dx9.MouseMove(dxl.GetCoords({20, 990}))
        dx9.Mouse1Click()
    end

    if sleep(1, "core1") then
        dx9.MouseMove(dxl.GetCoords({20, 910}))
        --dx9.Mouse1Click() 
    end
end
]]


--// Get Descendants
function dxl.GetDescendants(instance)
    assert(type(instance) == "number" and dx9.GetChildren(instance) ~= nil, "[DXL Error] GetDescendants: First Argument needs to be a number (pointer)!")

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
    assert(type(instance) == "number" and dx9.GetChildren(instance) ~= nil, "[DXL Error] GetDescendantsOfClass: First Argument needs to be a number (pointer)!")
    assert(type(class) == "string", "[DXL Error] GetDescendantsOfClass: Second Argument needs to be a string (class name)!")

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
    assert(type(target) == "number" and dx9.GetChildren(target) ~= nil, "[DXL Error] GetClosestPart: First Argument needs to be a number (pointer)!")

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
        assert(type(var) == "string", "[DXL Error] GetCharacter: First Argument needs to be a string!")
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
    assert(type(json) == "string", "[DXL Error] JsonToTable: First Argument needs to be a string!")

    return loadstring("return "..json:gsub('("[^"]-"):','[%1]='))()
end


--// Better Loadstring
function dxl.loadstring(string)
    assert(type(string) == "string", "[DXL Error] loadstring: First Argument needs to be a string!")

    if dxl.LoadstringCaching[string] == nil then
        dxl.LoadstringCaching[string] = dxl.OldLoadstring(string)
    else
        return dxl.LoadstringCaching[string]
    end
end
_G.loadstring = dxl.loadstring


--// Better Get
function dxl.Get(string)
    assert(type(string) == "string", "[DXL Error] Get: First Argument needs to be a string!")

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


    function print_table(node) -- https://stackoverflow.com/a/42062321/19113503
        local cache, stack, output = {},{},{}
        local depth = 1
        local output_str = "{\n"

        while true do
            local size = 0
            for k,v in pairs(node) do
                size = size + 1
            end

            local cur_index = 1
            for k,v in pairs(node) do
                if (cache[node] == nil) or (cur_index >= cache[node]) then

                    if (string.find(output_str,"}",output_str:len())) then
                        output_str = output_str .. ",\n"
                    elseif not (string.find(output_str,"\n",output_str:len())) then
                        output_str = output_str .. "\n"
                    end

                    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                    table.insert(output,output_str)
                    output_str = ""

                    local key
                    if (type(k) == "number" or type(k) == "boolean") then
                        key = "["..tostring(k).."]"
                    else
                        key = "['"..tostring(k).."']"
                    end

                    if (type(v) == "number" or type(v) == "boolean") then
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                    elseif (type(v) == "table") then
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                        table.insert(stack,node)
                        table.insert(stack,v)
                        cache[node] = cur_index+1
                        break
                    else
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                    end

                    if (cur_index == size) then
                        output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                    else
                        output_str = output_str .. ","
                    end
                else
                    -- close the table
                    if (cur_index == size) then
                        output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                    end
                end

                cur_index = cur_index + 1
            end

            if (size == 0) then
                output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
            end

            if (#stack > 0) then
                node = stack[#stack]
                stack[#stack] = nil
                depth = cache[node] == nil and depth + 1 or depth - 1
            else
                break
            end
        end

        -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
        table.insert(output,output_str)
        output_str = table.concat(output)

        return output_str
    end


    function dxl.print(...)
        local temp = "";
        for i,v in pairs({...}) do
            if type(v) == "table" then
                temp = temp..print_table(v).." "
            else
                temp = temp..tostring(v).." "
            end
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

function double_print(...)
    dxl.OldPrint(...);
    dxl.print(...);
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
-----

dxl.ShowConsole()

print(Mouse.x, Mouse.y)



dx9.DrawCircle({300, 300}, {0,0,0}, 3)

if sleep(3) then
    dx9.MouseMove({300, 300})
end