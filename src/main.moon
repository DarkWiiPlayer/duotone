-- vim: set noexpandtab :miv --
--- A module that generates duotone HTML filters
-- @module duotone
import compile from require "pl.template"

duotone = {}

code = assert(compile([[
<svg xmlns="http://www.w3.org/2000/svg" width="0" height="0">
	<filter id="duotone_#{title}">
		<feColorMatrix type="matrix"
			values="1 0 0 0 0
							1 0 0 0 0
							1 0 0 0 0
							0 0 0 1 0" >
		</feColorMatrix>
		<feComponentTransfer color-interpolation-filters="sRGB">
> local c = {'R', 'G', 'B'}
> for i=1,3 do
			<feFunc#{c[i]} type="table" tableValues="#{col[i]}"></feFunc#{c[i]}>
> end
			<feFuncA type="table" tableValues="0 1"></feFuncA>
		</feComponentTransfer> 
	</filter>
</svg>
]], escape: '>', inline_escape: '#', inline_brackets: '{}'))

--- Creates ('bakes') a duotone filter as an SVG tag that can be inserted into HTML.
-- 
--### Options
--
-- The following options are supported in the `opts` table:
-- 
-- * `count`: The number of steps to interpolate between the two colors.
-- * `exponent`: An exponent to use when interpolating, (default 1 = linear).
-- 
-- @tparam string title The "title" of the filter.
-- This, prefixed with 'duotone_' becomes the ID to be used
-- in the stylesheet to apply the filter.
-- @tparam string c1 The first color given as a hash '#' followed by 6 hex digits
-- @tparam string c2 The second color given as a hash '#' followed by 6 hex digits
-- @tparam table opts A table of options.
duotone.bake = (title, c1, c2, opts={}) ->
	s = (num) ->
		"%1.2f"\format(num)
	parse = (str) ->
		[tonumber(hx, 16)/255 for hx in *{str\match("#(%x%x)(%x%x)(%x%x)")}]
	interpol = (a, p, b, e=1) -> a + (b-a) * p^e

	count = opts.count or 2
	e = opts.exponent or 1
	c1, c2 = parse(c1), parse(c2)
	c = [ table.concat[ s interpol(c1[i], j/(count-1), c2[i], e) for j=0,count-1 ], ' ' for i=1,3 ]
	res = code\render{col: c, :title}
	res

duotone
