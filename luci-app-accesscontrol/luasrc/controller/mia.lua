module("luci.controller.mia", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/mia") then
		return
	end

	local page = entry({"admin", "services", "mia"}, cbi("mia"), _("Internet Access Schedule Control"), 30)
	page.dependent = true
	page.acl_depends = { "luci-app-accesscontrol" }

	entry({"admin", "services", "mia", "status"}, call("act_status")).leaf = true
end

function act_status()
	local e = {}
	e.running = luci.sys.call("nft list chain inet fw4 MIA | grep -q 'counter'") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
