local GenieGenDefaultProjects = {}

local default_projecs_id = 
{
    "lua",
    "imgui",
}


local LuaProject = function (_fullpath)
    project "Lua"
        kind "StaticLib"
        language "C"
        files {
            path.join(_fullpath, "src/*.c"),
            path.join(_fullpath, "src/*.h"),
        }
        includedirs {
            path.join(_fullpath, "."),
            path.join(_fullpath,"src"),
        }
        vpaths = {
            ["Headers"] = {"**.h"},
            ["Src"]   = {"**.c"}
        }
end

function CheckIfIsDefaultProject(_name ,_path)
    -- lua
    if (string.sub( _name, 1, 3) == "lua" ) then
        if not os.isfile(_path, "src/lua.c") then return nil end
        print(_name.." project founded. A project can require link to \"Lua\"")
        return LuaProject
    end
    return nil
end

return GenieGenDefaultProjects