local genpath = {}
--All the GenPath functions receive "self" as argument to determine
--the variable that will be treated
GenPath = {
    path_str = "", --path string
    path_name_str = "", --path name
    files_arr = {}, --array of GenFiles in the path
    subfolders_arr = {}, --array of GenPath subfolders in the path !TODO
    qobjects_file_arr = {},--array of GenFiles that contains Q_OBJECT macro

    is_initialized = false, --Boolean to determine if GenPath has been "Init"
    is_scan_recursively = false, --Boolean to determine if GenPath has been scaned
    has_genie_folder = false, --Boolean to determine if this path has a Genie folder inside with the rules
}
GenPath.__index = GenPath



setmetatable(GenPath, {
    __call = function (cls, ...)
      return cls.new(...)
    end,
  })

function GenPath.new()
    local self = setmetatable({}, GenPath)
    return self
end

--Initializes the GenPath
--[path] Full path of the directory
function GenPath:Init(_path)
    if not os.isdir(_path) then
        print("WARNING: GenPath does not exist: ".._path)
         return 
    end
    self.is_initialized = true
    self.path_str = _path
    self:ConvertPathToWindows()
    self.path_name_str = self:GetName()
    self.has_genie_folder = self:HasFileName("genie/"..self.path_name_str..".lua")
    print("Init GenPath: "..self.path_str)
    local files_str = self:GetFiles()
    for _, file in pairs(files_str) do 
        local _fullpath_file = path.join(self.path_str,file)

        if os.isfile(_fullpath_file) then 
            print(_fullpath_file)
            local new_file = GenFile.new()
            new_file:Init(_fullpath_file)
            table.insert( self.files_arr, new_file )
        end
    end
end

function GenPath:ScanRecursively()
    if not self.is_initialized then 
        print("WARNING: Path not initialized")
        return 
    end
    if self.is_scan_recursively then return end
    self.is_scan_recursively = true
    for _, folder in pairs(self:GetFolders()) do 
        local _fullpath = path.join(self.path_str, folder)
        local _sub_folder = GenPath.new()
        _sub_folder:Init(_fullpath)
    end
    
end

--PATHS functions
--convers / to \\ from a path
function GenPath:ConvertPathToWindows()
    local output_str =""
    for i = 1, string.len(self.path_str) do
        if (string.sub(self.path_str, i, i) == "/")then
            output_str = output_str.."\\"
        else
            output_str = output_str..string.sub(self.path_str, i, i)
        end
    end
    self.path_str = output_str
end

--Returns an array with all the files in the directory
--[directory]: path to scan
--Returns: array of strings
function GenPath:GetFiles()
    if not self.is_initialized then return {} end
    if(self:GetNumberOfFiles() == 0) then 
        return {}
    end
    local i, t, popen = 0, {}, io.popen
    --print("READING: "..self.path_str)
    --File not found
    local _command = "dir "..self.path_str.." /b /a-d"
    
    local pfile = popen(_command)
    --File not found
    for filename in pfile:lines() do
        local _fullpath_file = path.join(self.path_str,filename)
        
        if os.isfile(filename) then
            i = i + 1
            t[i] = filename
        end
    end
    pfile:close()
    return t
end

function GenPath:GetFolders()
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('dir "'..self.path_str..'" /b /ad')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

--Process all the files in the path and check files with Q_OBJECT macro
function GenPath:ProcessQTObject()
    if not self.is_initialized then return end
    print("Processing Q_OBJECTS in: "..self.path_str)
    for _, v in pairs(self.files_arr) do 
        if v:CheckQObject(v) then 
            table.insert( self.qobjects_file_arr, v )
        end
    end
end

function GenPath:PrintFiles()
    for k, v in pairs(self.files_arr) do 
        print(v.full_path_str)
    end
end

function GenPath:PrintQObjectFiles()

    if next(self.qobjects_file_arr) == nill then 
        print("No Q_OBJECT files in the Dir: "..self.path_str)
        return
    end
    print("Q_OBJECTS in: "..self.path_str)
    for _, gen_file in pairs(self.qobjects_file_arr) do 
        print(gen_file.full_path_str)
    end
end

function GenPath:GetName()
    if not self.is_initialized then 
        print("WARNING: Path not initialized")
        return "unknown name"
    end
    local _output = "unknown name"
    for i = #self.path_str, 1, -1 do
        --local value = self.path_str[i]
        local _str_portion = self.path_str:sub(i)
        local _value = _str_portion:sub(1,1)
        if(_value == "/" or _value =="\\") then 
            _output = self.path_str:sub(i + 1)
            break
        end
    end
    return _output
end

function GenPath:GetNumberOfFiles()
    if not self.is_initialized then 
        return 0
    end
    local _count = 0
    for _, files in pairs(os.matchfiles(self.path_str.."/*")) do
        _count = _count + 1
    end
    return _count
end

--[file_name]: Name of the file
function GenPath:HasFileName(_file_name)
    local _suposed_file = path.join(self.path_str, _file_name)
    return os.isfile(_suposed_file)
end


return genpath