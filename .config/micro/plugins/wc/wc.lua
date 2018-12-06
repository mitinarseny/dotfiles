VERSION = "1.0.1"

MakeCommand("wc", "wc.wordCount", 0)

function wordCount ()
	buffer = CurView().Buf	--Pulls working screen buffer from editor view
	charCount = buffer:len() --Finds length of buffer
	bufstr = tostring(buffer)
	local _ , wordCount = bufstr:gsub("%S+","") --Lua patterns, see: lua.org/pil/20.2.html
	messenger:Message("Words:"..wordCount.."  Characters:"..charCount)
end

AddRuntimeFile("wc", "help", "help/wc.md")
BindKey("F5", "wc.wordCount")

