local GenieGen = {}


local GENIE_PATHS = {}
local dict_name_path = {}

function GetPathName(_path)
    local _output = "unknown name"
    for i = #_path, 1, -1 do
        --local value = self.path_str[i]
        local _str_portion = _path:sub(i)
        local _value = _str_portion:sub(1,1)
        if(_value == "/" or _value =="\\") then 
            _output = _path:sub(i + 1)
            break
        end
    end
    return _output
end

function HasGeniePath(_path)
    local _path_name = GetPathName(_path)
    if os.isdir(path.join(_path, "genie")) then 
        if os.isfile(path.join(_path, "genie/genie.lua")) and 
            os.isfile(path.join(_path, "genie/".._path_name..".lua"))
        then
            return true
        end
    end
    return false
end

function GenieGenScan(_path)
    if not os.isdir(_path) then 
        print ("ERROR GenieGenScan: path not found: ".._path)
    end
    print("Scanning in: ".._path)

    local folders = os.matchdirs(_path.."/**")
    for _, fold in pairs(folders) do 
        if HasGeniePath(fold) then
            table.insert( GENIE_PATHS, fold)
            dict_name_path[GetPathName(fold)] = fold
        end
    end

    -- check first own path

    
end

function GenieGenFindProject(_name)
    local _error = nil
    if not #GENIE_PATHS then 
        return _error
    end
    for _, path in pairs(GENIE_PATHS) do 
        if(GetPathName(path) == _name) then
            return path
        end
    end

    return _error
end

function GenieGenLoadProject(_name)
    --loads the file 
    print("Loading project: ".._name)
    --call for the existence function
    local projec_name_type = "GenieGen_base_".._name
    local src_need = "GenieGen_files_".._name
    local inc_need = "GenieGen_includedirs_"..name
    local links_need = "GenieGen_links_"..name
    local aditional_need = "GenieGen_aditional_config_"..name

    _G[x]() -- calls foo from the global namespace
    if _G[x]()~=nil then foo() end
end

function GenieGenStartSolution()
    local customProjectDirs = _OPTIONS["startproject"]
    if not customProjectDirs then 
        print("ERROR: Use this option-> --startproject=\"name_project\" to define the start project")
        print([[        Available names are:]])
        for n, k in pairs(GENIE_PATHS) do 
            print([[            ]].."("..tostring(n)..")"..GetPathName(k))
        end
        return false
    end
    local START_PROJECT = GenieGenFindProject(customProjectDirs)
    if(not START_PROJECT) then 
        print("ERROR: Project name not founded: "..customProjectDirs)
        print([[    i.e /myproj/genie/myproj.lua the name shoud be myproj in the "startproject" value]])
        print([[        Available names are:]])
        for n, k in pairs(GENIE_PATHS) do 
            print([[            ]].."("..tostring(n)..")"..GetPathName(k))
        end
        return false
    end
    print("Defined started project in: "..START_PROJECT)
    -- Loads the start project
    dofile(path.join(dict_name_path[customProjectDirs], "genie/"..customProjectDirs..".lua"))
    GenieGenLoadProject(customProjectDirs)
end

return GenieGen