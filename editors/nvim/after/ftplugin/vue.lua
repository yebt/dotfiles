function Load_main_node_module(fname)
  if string.match(fname, "^@") == "@" then
    -- El nombre del archivo comienza con "@".
    -- Intenta cargar la definición desde vite.config.js
    local viteConfig = Load_main_node_module("vite.config.js")
    if vim.fn.filereadable(viteConfig) == 1 then
      local configContent = vim.fn.readfile(viteConfig)
      local aliasDefinition
      for _, line in ipairs(configContent) do
        -- Busca la definición de alias
        if string.match(line, "['\"]@['\"]%s*:%s*['\"](.*)['\"],") then
          aliasDefinition = string.match(line, "['\"]@['\"]%s*:%s*['\"](.*)['\"],")
        end
      end
      if aliasDefinition then
        -- Reemplaza "@" por la definición del directorio del alias
        fname = string.gsub(fname, "^@", aliasDefinition)
      end
    end
  else
    -- El nombre del archivo no comienza con "@".
    -- Procede con la lógica original.
    local rules = {
      ["^/"] = {
        "..",
        ".",
        "src"
      }
    }
    for rule, aditionals in pairs(rules) do
      if vim.fn.match(fname, rule) ~= -1 then
        for key, ad in pairs(aditionals) do
          local newFn = ad .. fname
          if vim.fn.filereadable(newFn) == 1 then
            return newFn
          end
        end
      end
    end
  end

  return fname
end

vim.opt.includeexpr = "v:lua.Load_main_node_module(v:fname)"

