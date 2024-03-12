{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # Launch nvim if you type 'vi' or 'vim'
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      nil # Nix LSP
      lua-language-server # Lua LSP
      nodePackages.intelephense # PHP LSP
      nodePackages.typescript-language-server # JS/TS LSP
      nodePackages.vscode-html-languageserver-bin # HTML / CSS LSP
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = everforest;
        type = "lua";
        config = ''
          vim.cmd [[colorscheme everforest]]
        '';
      }
      {
        plugin = nvim-comment;
        type = "lua";
        config = ''
          line_mapping = "<leader>cc"
          operator_mapping = "<leader>c"
        '';
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local telescope = require('telescope')
          telescope.setup({
              defaults = {
                  layout_strategy = 'vertical',
                  layout_config = {
                      height = 0.95,
                      width = 0.95,
                      preview_height = 0.70,
                  },
              }
          })

          local builtin = require('telescope.builtin')

          vim.keymap.set('n', '<leader>fm', builtin.marks)      -- Find Marks
          vim.keymap.set('n', '<leader>fb', builtin.buffers)    -- Find Buffers
          vim.keymap.set('n', '<leader>ff', builtin.git_files)  -- Find git tracked Files
          vim.keymap.set('n', '<leader>fa', builtin.find_files) -- Find Any file under repo
          vim.keymap.set('n', '<leader>fA',                     -- Find Any file in given dir
              function()
                  local dir = vim.fn.input("Search in dir: ", "", "dir")
                  builtin.find_files({ cwd = dir })
              end,
              { noremap = true, silent = true })
          vim.keymap.set('n', '<leader>fg', builtin.live_grep) -- Find using Grep
          vim.keymap.set('n', '<leader>fG',                    -- Find using Grep in given dir
              function()
                  local dir = vim.fn.input("Grep in dir: ", "", "dir")
                  builtin.grep_string({ cwd = dir })
              end,
              { noremap = true, silent = true })
        '';
      }
      nvim-treesitter.withAllGrammars
      copilot-vim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local lspconfig = require('lspconfig')

          -- Global mappings.
          -- See `:help vim.diagnostic.*` for documentation on any of the below functions
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
          vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

          -- Use LspAttach autocommand to only map the following keys
          -- after the language server attaches to the current buffer
          vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
              -- Enable completion triggered by <c-x><c-o>
              vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

              -- Buffer local mappings.
              -- See `:help vim.lsp.*` for documentation on any of the below functions
              local opts = { buffer = ev.buf }
              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
              vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
              vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
              vim.keymap.set('n', '<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, opts)
              vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
              vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
              vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
              vim.keymap.set('n', '=', function()
                vim.lsp.buf.format {}
              end, opts)

              -- Set up format on save using lSP
              vim.api.nvim_create_autocmd('BufWritePre', {
                buffer = ev.buf,
                callback = function()
                  vim.lsp.buf.format {}
                end,
              })
            end,
          })

          lspconfig.rust_analyzer.setup {}
          lspconfig.gopls.setup {}
          lspconfig.nil_ls.setup {}
          lspconfig.lua_ls.setup {}
          lspconfig.tsserver.setup {}
          lspconfig.intelephense.setup {}
          lspconfig.html.setup {}
          lspconfig.cssls.setup {}
        '';
      }
    ];

    extraLuaConfig = ''
      -- Leader key
      vim.g.mapleader = " "

      -- Configure file explorer (netrw)
      vim.g.netrw_bufsettings = "noma nomod nu nowrap ro nobl"
      vim.keymap.set("n", "<leader>ex", vim.cmd.Ex) -- Open file explorer

      -- Use ripgrep inplace of grep
      vim.o.grepprg = "rg --vimgrep"

      -- Line numbers
      vim.opt.nu = true
      vim.opt.rnu = true

      -- Tab behavior
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.smartindent = true
      vim.opt.expandtab = true
      -- Ignore case while using tab autocomplete
      vim.opt.wildignorecase = true
      -- Use tabs not spaces for certain filetypes
      vim.cmd [[ autocmd FileType go setlocal noexpandtab ]]
      -- Use 2 spaces sometimes
      vim.cmd [[ autocmd FileType nix setlocal tabstop=2 shiftwidth=2 ]]
      vim.cmd [[ autocmd FileType html setlocal tabstop=2 shiftwidth=2 ]]
      vim.cmd [[ autocmd FileType css setlocal tabstop=2 shiftwidth=2 ]]
      vim.cmd [[ autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 ]]
      vim.cmd [[ autocmd FileType typescript setlocal tabstop=2 shiftwidth=2 ]]
      vim.cmd [[ autocmd FileType typescriptreact setlocal tabstop=2 shiftwidth=2 ]]
      vim.cmd [[ autocmd FileType vue setlocal tabstop=2 shiftwidth=2 ]]
      vim.cmd [[ autocmd BufRead,BufNewFile *.blade.php setlocal tabstop=2 shiftwidth=2 ]]

      -- Searching with '/'
      vim.opt.ignorecase = true
      vim.opt.hlsearch = false
      vim.opt.incsearch = true

      -- Undo config
      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undofile = true

      -- Look and feel
      vim.opt.colorcolumn = "130"
      vim.opt.cursorline = true
      vim.opt.termguicolors = true
      vim.o.completeopt = 'menu,menuone,noselect'
      vim.opt.signcolumn = 'yes'

      -- Open up the quickfix list
      vim.keymap.set("n", "<leader><leader>", ':copen<CR>')

      -- Cycle through the quickfix list
      vim.keymap.set('n', '<c-n>', ':cnext<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<c-p>', ':cprev<CR>', { noremap = true, silent = true })

      -- Open a new vim tab
      vim.keymap.set('n', '<leader>et', ':tabnew<CR>', { noremap = true, silent = true })

      -- Toggle line wrap
      vim.keymap.set('n', '<leader>L', ':set wrap!<CR>', { noremap = true, silent = true })

      -- Moving around faster
      vim.keymap.set("n", "<c-y>", "7<c-y>")
      vim.keymap.set("n", "<c-e>", "7<c-e>")

      -- Scroll horizontally
      vim.keymap.set("n", "H", "20zh")
      vim.keymap.set("v", "H", "20zh")
      vim.keymap.set("n", "L", "20zl")
      vim.keymap.set("v", "L", "20zl")

      -- Trim trailing whitespace
      vim.keymap.set('n', '<leader>tw',
          function()
              local screenSave = vim.fn.winsaveview()
              vim.cmd [[%s/\s\+$//e]]
              vim.fn.winrestview(screenSave)
          end,
          { noremap = true, silent = true })

      -- Yank to system clipboard (too lazy to recompile with clipboard support)
      -- Linux        -> xclip -i -sel c
      -- Windows WSL2 -> /mnt/c/Windows/System32/clip.exe
      vim.keymap.set('v', '<leader>y', [[y:silent echo system('xclip -i -sel c', getreg('@'))<CR>]],
          { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>yf', [[:silent echo system('xclip -i -sel c', expand('%'))<CR>]],
          { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>yF', [[:silent echo system('xclip -i -sel c', expand('%:p'))<CR>]],
          { noremap = true, silent = true })
    '';
    };
}
