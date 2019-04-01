dofile("GenFile.lua")
--All the GenPath functions receive "self" as argument to determine
--the variable that will be treated
GenPath = {
    path_str = "", --path string
    files_arr = {}, --array of GenFiles in the path
    subfolders_arr = {}, --array of GenPath subfolders in the path !TODO
    qobjects_file_arr = {},--array of GenFiles that contains Q_OBJECT macro

    is_initialized = false --Boolean to determine if GenPath has been "Init"
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
        print("WARNING: GenPath.Init not exist: ".._path)
         return 
    end
    self.is_initialized = true
    self.path_str = _path
    self:ConvertPathToWindows()
    print("Init GenPath: "..self.path_str)
    local files_str = self:Scanfiles()
    for _, file in pairs(files_str) do 
        local _fullpath_file = path.join(self.path_str,file)

        if os.isfile(_fullpath_file) then 
            local new_file = GenFile.new()
            new_file:Init(_fullpath_file)
            table.insert( self.files_arr, new_file )
        end
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

function Scanfiles(directory)
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
function GenPath:Scanfiles()
    if not self.is_initialized then return {} end
    local i, t, popen = 0, {}, io.popen
    local _command = "dir "..self.path_str.." /b /a-d"
    local pfile = popen(_command)
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
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