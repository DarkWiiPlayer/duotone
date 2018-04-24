-- vim: set noexpandtab :miv --
package = "duotone"
version = "scm-1"
source = {
	url = "git://github.com/DarkWiiPlayer/duotone";
}
description = {
	summary = "A module that generates HTML/SVG code for duotone filters";
	detailed = ([[
		A module that generates HTML/SVG code for duotone filters
	]]):gsub("\t", "");
	homepage = "https://github.com/DarkWiiPlayer/duotone";
	license = "Unlicense";
}
dependencies = {
	"lua >= 5.1";
}
build = {
	type = "builtin";
	modules = {
		duotone = "src/main.lua"
	};
}
