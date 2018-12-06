VERSION = "0.1.0"

if GetOption("misspell") == nil then
    AddOption("misspell", true)
end

MakeCommand("misspell", "misspell.misspellCommand", 0)

function misspellCommand()
    CurView():Save(false)
    runMisspell()
end

function runMisspell()
    CurView():ClearGutterMessages("misspell")
    JobSpawn("misspell", {CurView().Buf.Path}, "", "", "misspell.onExit", "%f:%l:%d+: %m")
end

function split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
        table.insert(result, each)
    end
    return result
end

function basename(file)
    local name = string.gsub(file, "(.*/)(.*)", "%2")
    return name
end

function onSave(view)
    if GetOption("misspell") then
        runMisspell()
    else
        CurView():ClearAllGutterMessages()
    end
end

function onExit(output, errorformat)
    local lines = split(output, "\n")

    local regex = errorformat:gsub("%%f", "(..-)"):gsub("%%l", "(%d+)"):gsub("%%m", "(.+)")
    for _,line in ipairs(lines) do
        -- Trim whitespace
        line = line:match("^%s*(.+)%s*$")
        if string.find(line, regex) then
            local file, line, msg = string.match(line, regex)
            if basename(CurView().Buf.Path) == basename(file) then
                CurView():GutterMessage("misspell", tonumber(line), msg, 2)
            end
        end
    end
end
