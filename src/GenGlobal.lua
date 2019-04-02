local genglobal = {}

require "src/genpath"
require "src/genfile"

function GenieGenScan( _path )
    local main_path = GenPath.new()
    main_path:Init(_path)
    main_path:ScanRecursively()
    --check if there is a "genie" folder
    local _subpaths
end