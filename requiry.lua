function _REQ(wd, fp, pc, is)
    local fs, co, fn, pn = filesystem, "", "", ".*[/\\]"
    if (not is) then
        for _, po in ipairs({
            fs.path(wd, fp), 
            fs.path(wd, fp .. ".lua"), 
            fp, fp .. ".lua"}) do
            if (fs.isFile(po)) then
                local fi = fs.open(po, "r")
                if (fi) then
                    local si = fi:seek("end") fi:seek("set")
                    co = fi:read(si) fi:close()
                    fn = po
                    break
                end
            end
        end if (fn == "") then return false, "No File Found!"
    end
    local cg = {
        require = function(fip, pca) 
            return _REQ(is and wd or fn:sub(fn:find(pn)), fip, pca) end,
        include = function(str, pca) 
            return _REQ(is and wd or fn:sub(fn:find(pn)), str, pca, true) end,
        FILE = is and wd or fn, DIR = is and wd or fn:sub(fn:find(pn))} 
    setmetatable(cg, {__index = _G})
    if (pc) then return table.pack(pcall(load(is and fp or co, is and wd or fn, nil, cg)))
    else return load(is and fp or co, is and wd or fn, nil, cg)() end
end
function require(filePath, PCall)
    return _REQ(filePath:sub(filePath:find(pn)), filePath:sub(table.pack(filePath:find(pn))[2], #filePath), PCall)
end
