local compile
compile = require("pl.template").compile
local duotone = { }
local code = assert(compile([[<svg xmlns="http://www.w3.org/2000/svg" width="0" height="0">
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
]], {
  escape = '>',
  inline_escape = '#',
  inline_brackets = '{}'
}))
duotone.bake = function(title, c1, c2, opts)
  if opts == nil then
    opts = { }
  end
  local s
  s = function(num)
    return ("%1.2f"):format(num)
  end
  local parse
  parse = function(str)
    local _accum_0 = { }
    local _len_0 = 1
    local _list_0 = {
      str:match("#(%x%x)(%x%x)(%x%x)")
    }
    for _index_0 = 1, #_list_0 do
      local hx = _list_0[_index_0]
      _accum_0[_len_0] = tonumber(hx, 16) / 255
      _len_0 = _len_0 + 1
    end
    return _accum_0
  end
  local interpol
  interpol = function(a, p, b, e)
    if e == nil then
      e = 1
    end
    return a + (b - a) * p ^ e
  end
  local count = opts.count or 2
  local e = opts.exponent or 1
  c1, c2 = parse(c1), parse(c2)
  local c
  do
    local _accum_0 = { }
    local _len_0 = 1
    for i = 1, 3 do
      _accum_0[_len_0] = table.concat((function()
        local _accum_1 = { }
        local _len_1 = 1
        for j = 0, count - 1 do
          _accum_1[_len_1] = s(interpol(c1[i], j / (count - 1), c2[i], e))
          _len_1 = _len_1 + 1
        end
        return _accum_1
      end)(), ' ')
      _len_0 = _len_0 + 1
    end
    c = _accum_0
  end
  local res = code:render({
    col = c,
    title = title
  })
  return res
end
return duotone
