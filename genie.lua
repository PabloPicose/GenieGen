--mirar https://www.lua.org/pil/16.1.html
--copiar a mi repo https://github.com/TesterPointer/TraceSystem
--mirar https://blog.qt.io/blog/2018/01/24/qt-visual-studio-new-approach-based-msbuild/
local start_time = os.time()
newoption {
    trigger     = "startproject",
    description = "Must be contained in the scanned tree folder",
}
require("GenieGen")

GenieGenScan("C:/workcopy/ForanDesa")--buscar carpetas que sea eleinputdata/genie/eleinputdata.lua
GenieGenStartSolution(_OPTIONS["startproject"])
--local customProjectDirs = _OPTIONS["startproject"]
--local START_PROJECT = GenieGenFindProject(customProjectDirs)


--eleinputdata_path = GenPath.new()
--eleinputdata_path:Init("C:/workcopy/ForanDesa/srcoo/foranfw/elebase/eleinputdata")
--print(eleinputdata_path:GetNumberOfFiles())
--eleinputdata_path:GetName()
--eleinputdata_path:ScanRecursively()
--GenPath.PrintFiles(eleinputdata_path)
--eleinputdata_path:ProcessQTObject()


--[[PROTOTYPES]]
--Plantilla de configuracion
--comprobar unas funciones
--project_definition_eleinputdata()--static lib, language, configuration
--funcion que devuelve los modulos de qt a incluir igual que en QMake
--core, gui, multimedia, network, qml, sql 
--project_qt_eleinputdata()
--en el .lua

--GenGenieProject()

solution "PEpe"
local end_time = os.time()
print("Total time(s): "..tostring(os.difftime(end_time, start_time)))