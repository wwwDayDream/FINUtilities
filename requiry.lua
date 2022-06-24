local pn = "[%w%.]*$"
function _REQ(wd, fp, pc, is)
    local fs, co, fn = filesystem, "", ""
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
        end if (fn == "") then if (not pc) then error("No File Found! " .. fp) return else return false, "No File Found!" end end
    end
    local cg = {
        require = function(fip, pca) 
            return _REQ(is and wd or fn:sub(1, table.pack(fn:find(pn))[1] - 1), fip, pca) end,
        include = function(str, pca) 
            return _REQ(is and wd or fn:sub(1, table.pack(fn:find(pn))[1] - 1), str, pca, true) end,
        FILE = is and wd or fn, DIR = is and wd or fn:sub(1, table.pack(fn:find(pn))[1] - 1)} 
    setmetatable(cg, {__index = _G})
    if (pc) then return table.pack(pcall(load(is and fp or co, is and wd or fn, nil, cg)))
    else return load(is and fp or co, is and wd or fn, nil, cg)() end
end
function require(filePath, PCall)
    return _REQ(filePath:sub(1, table.pack(filePath:find(pn))[1] - 1), filePath:sub(filePath:find(pn)), PCall)
end
