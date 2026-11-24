--[[
copernicus.lua: map the structure of draft.md onto copernicus.cls (The Cryosphere).

- Drops the hand-written section numbers ("3.1 HIRHAM5 ..."); the class numbers sections.
- Shifts heading levels up by one (## -> \section, ### -> \subsection).
- "Abstract"              -> metadata `abstract` (typeset by the template).
- "N Introduction"        -> \introduction
- "N Conclusions"         -> \conclusions
- "Data and code availability", "Code availability", "Data availability"
                          -> \codedataavailability{} / \codeavailability{} / \dataavailability{},
                             placed before the appendices as the template requires.
- "Appendix X: Title"     -> \appendix + \section{Title} ... \noappendix
- "Author contributions", "Competing interests", "Acknowledgements"
                          -> \authorcontribution{}, \competinginterests{}, acknowledgements env.
                             The two mandatory statements get a TODO if missing.
- "References" and the refs div are dropped (the template adds \bibliography).
- Tables -> table float with \tophline / \middlehline / \bottomhline; a leading
  "Table N." in the caption is removed because the class numbers tables.
]]

local stringify = pandoc.utils.stringify
local latex_opts = { cite_method = "natbib" }

local function to_latex(blocks)
  return pandoc.write(pandoc.Pandoc(blocks), "latex", latex_opts)
end

local function inlines_to_latex(inlines)
  return to_latex({ pandoc.Plain(inlines) })
end

local function raw(s)
  return pandoc.RawBlock("latex", s)
end

-- Remove a leading "1", "3.1" or "4.2.1" token from a heading.
local function strip_number(inlines)
  if #inlines >= 2 and inlines[1].t == "Str" and inlines[1].text:match("^%d+[%.%d]*$")
      and inlines[2].t == "Space" then
    inlines:remove(1)
    inlines:remove(1)
  end
  return inlines
end

-- Remove a leading "Table 1." / "Table A1:" from a caption.
local function strip_table_prefix(inlines)
  if #inlines >= 3 and inlines[1].t == "Str" and inlines[1].text == "Table"
      and inlines[2].t == "Space" and inlines[3].t == "Str"
      and inlines[3].text:match("^[A-Z]?%d+[%.:]$") then
    inlines:remove(1)
    inlines:remove(1)
    inlines:remove(1)
    if inlines[1] and inlines[1].t == "Space" then inlines:remove(1) end
  end
  return inlines
end

local function cell_latex(cell)
  local s = to_latex(cell.contents):gsub("%s+$", "")
  return s
end

local function table_to_latex(tbl)
  local ncols = #tbl.colspecs
  local specs = {}
  local any_width = false
  for _, cs in ipairs(tbl.colspecs) do
    if type(cs[2]) == "number" and cs[2] > 0 then any_width = true end
  end
  for _, cs in ipairs(tbl.colspecs) do
    local align, width = cs[1], cs[2]
    if any_width then
      local w = (type(width) == "number" and width > 0) and width or (1 / ncols)
      -- share of the text width left after the column padding
      specs[#specs + 1] = string.format(
        ">{\\raggedright\\arraybackslash}p{\\dimexpr(\\textwidth-%d\\tabcolsep)*%d/1000\\relax}",
        2 * ncols, math.floor(w * 1000 + 0.5))
    elseif align == "AlignRight" then
      specs[#specs + 1] = "r"
    elseif align == "AlignCenter" then
      specs[#specs + 1] = "c"
    else
      specs[#specs + 1] = "l"
    end
  end

  local function rows_latex(rows)
    local out = {}
    for _, row in ipairs(rows) do
      local cells = {}
      for _, cell in ipairs(row.cells) do cells[#cells + 1] = cell_latex(cell) end
      while #cells < ncols do cells[#cells + 1] = "" end
      out[#out + 1] = table.concat(cells, " & ") .. " \\\\"
    end
    return table.concat(out, "\n")
  end

  local lines = {}
  local env = ncols > 4 and "table*" or "table"
  lines[#lines + 1] = "\\begin{" .. env .. "}[t]"
  local cap = tbl.caption and tbl.caption.long and pandoc.utils.blocks_to_inlines(tbl.caption.long) or {}
  if #cap > 0 then
    lines[#lines + 1] = "\\caption{" .. inlines_to_latex(strip_table_prefix(cap)) .. "}"
  end
  if tbl.attr and tbl.attr.identifier ~= "" then
    lines[#lines + 1] = "\\label{" .. tbl.attr.identifier .. "}"
  end
  lines[#lines + 1] = "\\begin{tabular}{" .. table.concat(specs) .. "}"
  lines[#lines + 1] = "\\tophline"
  if tbl.head and #tbl.head.rows > 0 then
    lines[#lines + 1] = rows_latex(tbl.head.rows)
    lines[#lines + 1] = "\\middlehline"
  end
  for _, body in ipairs(tbl.bodies) do
    lines[#lines + 1] = rows_latex(body.body)
  end
  lines[#lines + 1] = "\\bottomhline"
  lines[#lines + 1] = "\\end{tabular}"
  lines[#lines + 1] = "\\belowtable{}"
  lines[#lines + 1] = "\\end{" .. env .. "}"
  return raw(table.concat(lines, "\n"))
end

local function classify(text)
  local t = text:lower()
  if t == "abstract" then return "abstract" end
  if t == "introduction" then return "introduction" end
  if t == "conclusions" or t == "conclusion" then return "conclusions" end
  if t == "data and code availability" or t == "code and data availability" then return "codedataavailability" end
  if t == "code availability" then return "codeavailability" end
  if t == "data availability" then return "dataavailability" end
  if t == "author contributions" or t == "author contribution" then return "authorcontribution" end
  if t == "competing interests" then return "competinginterests" end
  if t == "acknowledgements" or t == "acknowledgments" then return "acknowledgements" end
  if t == "references" or t == "bibliography" then return "references" end
  if t:match("^appendix") then return "appendix" end
  return "section"
end

function Pandoc(doc)
  local main, appendix = {}, {}
  local special = {}     -- kind -> list of blocks
  local special_order = {}
  local abstract = nil
  local target = main    -- where ordinary blocks go
  local mode = "main"    -- main | abstract | special | appendix | drop
  local current_special = nil

  for _, blk in ipairs(doc.blocks) do
    if blk.t == "Header" and blk.level == 2 then
      local inl = strip_number(blk.content)
      local kind = classify(stringify(inl))
      if kind == "abstract" then
        abstract = {}
        mode = "abstract"
      elseif kind == "introduction" then
        mode, target = "main", main
        table.insert(main, raw("\\introduction"))
      elseif kind == "conclusions" then
        mode, target = "main", main
        table.insert(main, raw("\\conclusions"))
      elseif kind == "appendix" then
        mode, target = "appendix", appendix
        -- "Appendix A: Title" -> "Title"
        local title = stringify(inl):gsub("^[Aa]ppendix%s+%u%s*[:.]%s*", "")
        local hdr = pandoc.Header(1, pandoc.Inlines(title), blk.attr)
        table.insert(appendix, hdr)
      elseif kind == "references" then
        mode = "drop"
      elseif kind == "section" then
        mode, target = "main", (mode == "appendix" and appendix or main)
        blk.level = 1
        table.insert(target, blk)
      else
        mode = "special"
        current_special = kind
        if not special[kind] then
          special[kind] = {}
          table.insert(special_order, kind)
        end
      end
    elseif blk.t == "Div" and blk.identifier == "refs" then
      -- drop pandoc's reference placeholder
    elseif mode == "drop" then
      -- skip
    elseif mode == "abstract" then
      table.insert(abstract, blk)
    elseif mode == "special" then
      table.insert(special[current_special], blk)
    else
      if blk.t == "Header" then blk.level = math.max(1, blk.level - 1) end
      if blk.t == "Header" then strip_number(blk.content) end
      if blk.t == "Table" then blk = table_to_latex(blk) end
      table.insert(target, blk)
    end
  end

  local function stmt(kind, default)
    local blocks = special[kind]
    local body = blocks and to_latex(blocks):gsub("%s+$", "") or default
    if body == nil then return nil end
    return raw("\\" .. kind .. "{" .. body .. "}")
  end

  local out = pandoc.Blocks(main)
  for _, kind in ipairs({ "codeavailability", "dataavailability", "codedataavailability" }) do
    local b = stmt(kind)
    if b then out:insert(b) end
  end
  if #appendix > 0 then
    out:insert(raw("\\appendix"))
    out:extend(appendix)
    out:insert(raw("\\noappendix"))
  end
  out:insert(stmt("authorcontribution", "TODO."))
  out:insert(stmt("competinginterests", "TODO."))
  if special["acknowledgements"] then
    out:insert(raw("\\begin{acknowledgements}\n" .. to_latex(special["acknowledgements"]):gsub("%s+$", "") .. "\n\\end{acknowledgements}"))
  end

  if abstract then doc.meta.abstract = pandoc.MetaBlocks(abstract) end
  doc.blocks = out
  return doc
end
