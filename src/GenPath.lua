dofile("GenFile.lua")
--All the GenPath functions receive "self" as argument to determine
--the variable that will be treated
GenPath = {
    path_str = "", --path string
    files_arr = {}, --array of GenFiles in the path
    subfolders_arr = {}, --array of GenPath subfolders in the path !TODO

    is_initialized = false --Boolean to determine if GenPath has been "Init"
}

--Initializes the GenPath
--[path] Full path of the directory
function GenPath.Init(_self, _path)
    if not os.isdir(_path) then
        print("WARNING: GenPath.Init not exist: ".._path)
         return 
    end
    _self.is_initialized = true
    _self.path_str = _path
    GenPath.ConvertPathToWindows(_self)
    print("Init GenPath: ".._self.path_str)
    local files_str = GenPath.Scandir(_self)
    for _, file in pairs(files_str) do 
        local _fullpath_file = path.join(_self.path_str,file)
        if os.isfile(_fullpath_file) then 
            local new_file = GenFile
            print(GenFile.full_path_str)
            GenFile.Init(new_file, _fullpath_file)
            --_self.files_arr[#_self.files_arr+1] = new_file
            table.insert( _self.files_arr, new_file )
            --print(_self.files_arr[#_self.files_arr].full_path_str)
        end
    end
    --print(tostring(_self.files_arr[12].full_path_str))
    GenPath.PrintFiles(_self)
end

--PATHS functions
--convers / to \\ from a path
function GenPath.ConvertPathToWindows(_self)
    local output_str =""
    for i = 1, string.len(_self.path_str) do
        if (string.sub(_self.path_str, i, i) == "/")then
            output_str = output_str.."\\"
        else
            output_str = output_str..string.sub(_self.path_str, i, i)
        end
    end
    _self.path_str = output_str
end
function scandir(directory)
    directory = ConvertPathToWindows(directory)
    local i, t, popen = 0, {}, io.popen
    local _command = "dir "..directory.." /b /a-d"
    local pfile = popen(_command)
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end
--Returns an array with all the files in the directory
--[directory]: path to scan
--Returns: array of strings
function GenPath.Scandir(_self)
    if not _self.is_initialized then return {} end
    local i, t, popen = 0, {}, io.popen
    local _command = "dir ".._self.path_str.." /b /a-d"
    local pfile = popen(_command)
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

--Process all the files in the path and check files with Q_OBJECT macro
function GenPath.ProcessQTObject(_self)
    if not _self.is_initialized then return end
    print("Processing Q_OBJECTS in: ".._self.path_str)
    for _, v in pairs(_self.files_arr) do 
        if GenFile.CheckQObject(v) then 
            print("Q_OBJECT in: "..v)
        end
    end
end

function GenPath.PrintFiles(_self)
    --print(tostring(_self.files_arr[20].full_path_str))
    for k, v in pairs(_self.files_arr) do 
        --print(k)
        --print(v.full_path_str)
    end
end