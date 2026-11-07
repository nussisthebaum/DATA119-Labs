local styles = {
  exbox = "colback=blue!4,colframe=blue!50!black,breakable,title={}",
  hintbox = "colback=yellow!8,colframe=orange!70!black,breakable",
  quizbox = "colback=green!4,colframe=green!40!black",
  discussionbox = "colback=purple!5,colframe=purple!60!black,breakable",
  notebox = "colback=gray!8,colframe=gray!60!black,breakable",
}

function Div(el)
  for cls, opt in pairs(styles) do
    if el.classes:includes(cls) then
      opt = opt:gsub(",title={}", "")
      local blocks = { pandoc.RawBlock("latex", "\\begin{tcolorbox}[" .. opt .. "]") }
      for _, b in ipairs(el.content) do table.insert(blocks, b) end
      table.insert(blocks, pandoc.RawBlock("latex", "\\end{tcolorbox}"))
      return blocks
    end
  end
  if el.classes:includes("center") then
    local blocks = { pandoc.RawBlock("latex", "\\begin{center}") }
    for _, b in ipairs(el.content) do table.insert(blocks, b) end
    table.insert(blocks, pandoc.RawBlock("latex", "\\end{center}"))
    return blocks
  end
end

function CodeBlock(el)
  if el.classes:includes("output") then
    return pandoc.RawBlock("latex",
      "\\begin{Verbatim}[fontsize=\\small,breaklines,breakanywhere,frame=leftline,framerule=1.5pt,rulecolor=\\color{gray}]\n" ..
      el.text .. "\n\\end{Verbatim}")
  end
end
