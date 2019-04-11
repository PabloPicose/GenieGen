require("GenieGenDefaultProjects")
local GenieGen = {}


local GENIE_PATHS = {}
local dict_name_path = {}
local default_projecs_loaded = {}


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

        elseif table.contains(default_projecs_id, GetPathName(fold)) then
            local _default_project_name =  GetPathName(fold)
            print("Default proyect founded: ")
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

function GenieGenLoadProject(_name, _qt_project)
    _qt_project = _qt_project or false
    --loads the file 
    print("Loading project: ".._name)
    --call for the existence function
    --project, kind, language
    local projec_name_type = "GenieGen_base_".._name
    -- files
    local src_need = "GenieGen_files_".._name
    -- includedirs
    local inc_need = "GenieGen_includedirs_".._name
    -- links
    local links_need = "GenieGen_links_".._name
    -- all the optional configurations like defines
    local aditional_need = "GenieGen_aditional_config_".._name

    -- Check for the needed functions before call
    local _errors_tbl = {}
    if _G[projec_name_type]==nil then 
        table.insert( _errors_tbl, projec_name_type.."()")
    end
    if _G[src_need]==nil then 
        table.insert( _errors_tbl, "[Table with files output]: "..src_need.."(_absolute_proyect_path)")
    end
    -- print errors
    if #_errors_tbl ~= 0 then 
        print("Error: Trying to load an incomplete project (needed functions) from: ".._name)
        for _, err in pairs(_errors_tbl) do 
            print("\t"..err)
        end
        os.exit()
    end

    -- Call the needed functions
    _G[projec_name_type]()
    local file_project = _G[src_need]()

    -- Call the optional functions
    if _G[links_need]~=nil then 
        links_project = _G[links_need]()
    end
    if _G[links_need]~=nil then 
        _G[links_need]()
    end
    if _G[aditional_need]~=nil then 
        _G[aditional_need]()
    end
end

function GenieGenStartSolution()
    local customProjectDirs = _OPTIONS["startproject"]
    if not customProjectDirs then 
        print("ERROR: Use this option-> --startproject=\"name_project\" to define the start project")
        print([[        Available names are:]])
        for n, k in pairs(GENIE_PATHS) do 
            print([[            ]].."("..tostring(n)..")"..GetPathName(k))
        end
        os.exit()
    end
    local START_PROJECT = GenieGenFindProject(customProjectDirs)
    if(not START_PROJECT) then 
        print("ERROR: Project name not founded: "..customProjectDirs)
        print([[    i.e /myproj/genie/myproj.lua the name shoud be myproj in the "startproject" value]])
        print([[        Available names are:]])
        for n, k in pairs(GENIE_PATHS) do 
            print([[            ]].."("..tostring(n)..")"..GetPathName(k))
        end
        os.exit()
    end
    print("Defined started project in: "..START_PROJECT)
    -- Loads the start project
    dofile(path.join(dict_name_path[customProjectDirs], "genie/"..customProjectDirs..".lua"))
    GenieGenLoadProject(customProjectDirs)
end

return GenieGen