--mirar https://www.lua.org/pil/16.1.html
--copiar a mi repo https://github.com/TesterPointer/TraceSystem
dofile("src/GenGlobal.lua")

eleinputdata_path = GenPath.new()
eleinputdata_path:Init("C:/workcopy/ForanDesa/srcoo/foranfw/elebase")
--GenPath.PrintFiles(eleinputdata_path)
eleinputdata_path:ProcessQTObject()


function SanDirectory(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('dir "'..directory..'" /b /ad')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

for _, folder in pairs ( SanDirectory("C:\\workcopy\\ForanDesa\\srcoo") ) do 
    print(folder)
end
solution "PEpe"