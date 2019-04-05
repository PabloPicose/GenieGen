local genglobal = {}

PathsWithGenie = {}

require "src/genpath"
require "src/genfile"

local GeniePaths = {}

function CheckAndInsertGenie(_genpath)
    if table.contains(GeniePaths, _genpath) then
        --return
    end
    if _genpath.has_genie_folder then 
        table.insert( GeniePaths, _genpath )
    end
    
    if(#_genpath.subfolders_arr == 0) then 
        return
    end
    for _, subpaths in pairs(_genpath.subfolders_arr) do 
        print("Checking: "..subpaths.path_str)
        subpaths:PrintSubfolders()
        --CheckAndInsertGenie(subpaths)
    end
end

function GenieGenScan( _path )
    local main_path = GenPath.new()
    main_path:Init(_path, true)
    --main_path:PrintSubfolders()
    --CheckAndInsertGenie(main_path)

    --check if there is a "genie" folder
    local _subpaths
end

