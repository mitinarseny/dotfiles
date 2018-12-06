VERSION = '0.5.2'

if GetOption('trimdiff') == nil then
    AddOption('trimdiff', false)
end

AddRuntimeFile('vcs', 'help', 'help/vcs.md')

vcs       = {} -- map path to VCS type
openCount = {} -- map path to number

function findVcs(path)
    local dir = DirectoryName(path)
    JobStart('cd "' .. dir .. '" && git status &>/dev/null; printf $?', '', '', 'vcs.onFindVcs', 'git', path)
    JobStart('cd "' .. dir .. '" && hg  status &>/dev/null; printf $?', '', '', 'vcs.onFindVcs', 'hg',  path)
end

function onFindVcs(exitCode, vcsTried, path)
    if tonumber(exitCode) == 0 then
        vcs[path] = vcsTried
    end
end

function onViewOpen(view)
    return onOpenFile(view)
end

function onOpenFile(view)
    local path = view.Buf.AbsPath

    if not vcs[path] then
        findVcs(path)
    end

    if not openCount[path] then
        openCount[path] = 1
    else
        openCount[path] = openCount[path] + 1
    end

    return false
end

function onQuit(view)
    local path = view.Buf.AbsPath

    openCount[path] = openCount[path] - 1
    if openCount[path] == 0 then
        vcs[path] = nil
        showing[path] = nil
    end

    return false
end

-- COMMAND

function complete(input)
    local completions = {'hide', 'toggle'}
    local result = {}
    for _, cmd in pairs(completions) do
        if StartsWith(cmd, input) then
            table.insert(result, cmd)
        end
    end
    return result
end

MakeCommand('diff', 'vcs.diff', MakeCompletion('vcs.complete'))

function hide()
    CurView():ClearGutterMessages('vcs')
    showing[CurView().Buf.AbsPath] = nil
end

showing = {} -- map path to bool

function toggle()
    local path = CurView().Buf.AbsPath
    if showing[path] then
        hide()
    else
        diff()
    end
end

function diff(action)
    if action then
        if StartsWith(action, 'hide') then
            hide()
        elseif StartsWith(action, 'toggle') then
            toggle()
        end
        return
    end

    local path = CurView().Buf.AbsPath
    hide()

    if not vcs[path] then
        messenger:Message('VCS not supported')
    else
        CurView():Save(false)
        if vcs[path] == 'git' then
            JobStart('git status --porcelain=v2 -- "' .. path .. '" | grep -q \\?\\ "`basename \'' .. path .. '\'`"; printf $?', '', '', 'vcs.preOnDiff', path)
        elseif vcs[path] == 'hg' then
            JobStart('hg status -un "' .. path .. '" | grep -q "`basename \'' .. path .. '\'`"; printf $?', '', '', 'vcs.preOnDiff', path)
        end
    end
end

function preOnDiff(isNotTracked, path)
    local isTracked = tonumber(isNotTracked) ~= 0
    if isTracked then
        JobSpawn(vcs[path], {'diff', '-U0', path}, '', '', 'vcs.onDiff', path)
    else
        messenger:Message('file not tracked')
    end
end

function onDiff(out, path)
    local trimdiff = GetOption('trimdiff')

    local nextHeaderSearchStart = 1
    while nextHeaderSearchStart do
        local chunkHeaderStart, chunkBodyStart, numOldLines, lineNum, numLines = out:find('[\r\n]@@ %-%d+,?(%d*) %+(%d+),?(%d*) @@.-[\r\n]+.', nextHeaderSearchStart)
        if not chunkHeaderStart then
            break
        end
        -- do not correct chunkHeaderStart here as it is only needed for deletion-only chunks
        numOldLines = numOldLines and tonumber(numOldLines) or 1
        lineNum = tonumber(lineNum)
        numLines = numLines and tonumber(numLines) or 1

        if numLines == 0 then -- deletion-only chunk
            chunkHeaderStart = chunkHeaderStart + 1

            CurView():GutterMessage('vcs', lineNum + 1, '(-' .. numOldLines .. ' line' .. (numOldLines > 1 and 's' or '') .. ' above, check log)', 0)

            -- read and log the chunk
            local pattern = '([^\r\n]+[\r\n]+'
            for _ = 2, numOldLines do
                pattern = pattern .. ('[^\r\n]+[\r\n]+')
            end
            pattern = pattern .. ')'
            local _, chunkBodyOldEnd, chunkBodyOld = out:find(pattern, chunkBodyStart)
            messenger:AddLog(out:sub(chunkHeaderStart, chunkBodyStart) .. chunkBodyOld)

            nextHeaderSearchStart = chunkBodyOldEnd
        else -- lineNum ~= 0
            local nextOldLineStart = chunkBodyStart
            for i = 1, numLines do
                local oldLine = nil
                if i <= numOldLines then
                    local _, oldLineEnd, line = out:find('(.-)[\r\n]+', nextOldLineStart)
                    nextOldLineStart = oldLineEnd + 1
                    oldLine = trimdiff and ' -' .. line:match('%-%s*(.*)') or ' -' .. line:match('%-(.*)')
                end
                CurView():GutterMessage('vcs', lineNum + i - 1, oldLine and oldLine or ' +', 0)
            end
            nextHeaderSearchStart = nextOldLineStart - 1 -- include newline for header pattern
        end

        showing[path] = true
    end

    if not showing[path] then
        messenger:Message('no changes')
    end
end

--

function StartsWith(string, prefix)
    string = string:upper()
    prefix = prefix:upper()
    return string:sub(1, prefix:len()) == prefix
end
