local GenieGen = {}


local GENIE_PATHS = {}

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
            print(fold)
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

end

function GenieGenStartSolution(_name)
    local customProjectDirs = _OPTIONS["startproject"]
    if not customProjectDirs then 
        print("ERROR: Use this option-> --startproject=\"name_project\" to define the start project")
        return false
    end
    local START_PROJECT = GenieGenFindProject(customProjectDirs)
    if(not START_PROJECT) then 
        print("ERROR: Project name not founded: ".._name)
        print([[    i.e /myproj/genie/myproj.lua the name shoud be myproj in the "startproject" value]])
        print([[        Available names are:]])
        for n, k in pairs(GENIE_PATHS) do 
            print([[            ]].."("..tostring(n)..")"..GetPathName(k))
        end
    end
    print("Defined started project in: "..START_PROJECT)
end

return GenieGen