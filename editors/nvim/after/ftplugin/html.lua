vim.opt.omnifunc = 'htmlcomplete#CompleteTags'
-- omnifunc=htmlcomplete#CompleteTags',
-- set path=.,src
-- set suffixesadd=.js,.jsx

-- function! LoadMainNodeModule(fname)
--     let nodeModules = "./node_modules/"
--     let packageJsonPath = nodeModules . a:fname . "/package.json"

--     if filereadable(packageJsonPath)
--         return nodeModules . a:fname . "/" . json_decode(join(readfile(packageJsonPath))).main
--     else
--         return nodeModules . a:fname
--     endif
-- endfunction

-- set includeexpr=LoadMainNodeModule(v:fname)

-- vim.opt.path=".,src"
-- vim.opt.suffixesadd=".js,.jsx"

 function Load_main_node_module(fname)
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
           local newFn = ad  .. fname
           if vim.fn.filereadable(newFn) == 1 then
             -- print(vim.inspect( newFn))
             return newFn
           end
         end
         -- return fname
       end

       -- if vim.fn.match(fname, rule) ~= -1 then
       --   print(vim.inspect(ads))
       --   for key, ad in pairs(ads) do
       --     local newFn = ad  .. fname
       --     print(vim.inspect( newFn))
       --   end
       --   -- for key, ad in ipairs(ads) do
       --   -- print(vim.inspect( ad))
       --   --   local newFn = ad  .. fname
       --   --   if vim.fn.filereadable(newFn) == 1 then
       --   --     -- return newFn
       --   --   end
       --   -- end
       -- end
     end

     return fname
 end

vim.opt.includeexpr="v:lua.Load_main_node_module(v:fname)"

