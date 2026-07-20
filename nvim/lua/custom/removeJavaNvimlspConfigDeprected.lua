local _notify = vim.notify

vim.notify = function(msg, level, opts)
	-- make sure msg is a string so :match is safe
	local s = tostring(msg or "")

	-- adjust these patterns to be as narrow as possible for safety
	if s:match("lspconfig.*deprecated") or s:match("stack traceback") or s:match("^%[lspconfig%]") then
		return
	end

	return _notify(msg, level, opts)
end
