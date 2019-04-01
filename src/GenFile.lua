--All the GenFile functions receive "self" as argument to determine
--the variable that will be treated
GenFile = {
    full_path_str = "", --path of file (path, name and extension)
    name_str = "", --name of file without the extension and without the path
    extension_str = "", --extension of file-> (.h, .cpp, .hh) with the "."
    name_extension_str, --name and extension of file
    path_str = "", --path of the file, without the name and extension

    is_initialized = false,
    -- Determines if this file has the macro Q_OBJECT in one line. Must be a header
    is_qobject = false, 
    --Determine if this file has been previsouly checked (Q_OBJECT)
    has_been_checked_qobject = false,
}

GenFile.__index = GenFile

setmetatable(GenFile, {
    __call = function (cls, ...)
      return cls.new(...)
    end,
  })

function GenFile.new()
    local self = setmetatable({}, GenFile)
    return self
end


--Initialize the GenFile. Checks if file exists
--[_path] Full path with the name and the extension of a file 
function GenFile:Init( _path)
    if not os.isfile(_path) then 
        print("WARNING GenFile not exist: ".._path)
        return 
    end
    self.full_path_str = _path
    self:ConvertPathToWindows()
    self.name_str = path.getbasename(self.full_path_str)
    self.extension_str = path.getextension(self.full_path_str)
    self.name_extension_str = path.getname(self.full_path_str)
    self.path_str = path.getdirectory(self.full_path_str)
    self.is_initialized = true
end

--Checks if the file has a Q_OBJECT macro. Multiple calls will be omited
--[RETURNS] True if has Q_OBJECT macro otherwise false
function GenFile:CheckQObject()
    --print("Q_OBJECT: ".._self.full_path_str)
    if not self.is_initialized then return false end
    if self.has_been_checked_qobject then return is_qobject end
    self.has_been_checked_qobject = true
    if not self.name_extension_str == ".h" or
        not self.name_extension_str == ".hh" or
        not self.name_extension_str == ".hpp" then return false end
    local _lines = GenFile.GetLines(self)
    for _, v in pairs(_lines) do
        if string.match(' '..v..' ', '%W'.."Q_OBJECT"..'%W') ~= nil then 
            self.is_qobject = true
            break
        end
    end
    return self.is_qobject
end

-- Reads file and get the lines. This not modify the GenFile
--[RETURNS] Array lines from file, can be empty
function GenFile:GetLines()
    if not self.is_initialized then return {} end
    lines = {}
    for line in io.lines(self.full_path_str) do 
      lines[#lines + 1] = line
    end
    return lines
end

--! TODO
function CleanStartSpacesFromLine(file_line)
    local _output = ""
    local _start_index = 0
    for index = 1, #file_line do
        local c = file_line:sub(index, index)
        if(c ~= " ") then _start_index = index
            break
        end
    end
    return file_line:sub(_start_index, #file_line)
end

function GenFile:ConvertPathToWindows()
    local output_str =""
    
    for i = 1, string.len(self.full_path_str) do
        if (string.sub(self.full_path_str, i, i) == "/")then
            output_str = output_str.."\\"
        else
            output_str = output_str..string.sub(self.full_path_str, i, i)
        end
    end
    self.full_path_str = output_str
end