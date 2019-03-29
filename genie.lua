--mirar https://www.lua.org/pil/16.1.html
dofile("src/GenPath.lua")

--eleinputdata_path = GenPath
--GenPath.Init(eleinputdata_path, "C:/workcopy/ForanDesa/srcoo/foranfw/elebase/eleinputdata")
--GenPath.PrintFiles(eleinputdata_path)
--GenPath.ProcessQTObject(eleinputdata_path)

Padre = { paco = 1 }

function Padre:print()
    print(self.paco)
end

Hijito = Padre
Hijito.paco = 9
Hijito:print()
Padre:print()


solution "PEpe"