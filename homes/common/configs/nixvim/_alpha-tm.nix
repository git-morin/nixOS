_:
let
  mkButton = { label, action, shortcut, keymap }: {
    type = "button";
    val = label;
    on_press.__raw = action;
    opts = {
      inherit shortcut;
      position = "center";
      width = 50;
      cursor = 3;
      keymap = ["n" shortcut keymap { noremap = true; silent = true; }];
    };
  };
in
[
  { type = "padding"; val = 2; }
  {
    type = "text";
    val = [
      "                                            ██                   "
      "                                           ███          █████████"
      "      █                                    ██        ███████████ "
      "    ████                                  ███     ██████████████ "
      "███████████    ███   ██████    ██████     ██    ██████  ████████ "
      "███████████   ██████████ ████████ ████   ███           ████████  "
      "   ███       █████      █████     ████   ███           ████████  "
      "  ███        ████       ████      ███    ██           ████████   "
      "  ███       ████       ████      ████   ███           ████████   "
      " ███        ████       ████      ████   ███          █████████   "
      " ███   █    ████       ████      ███    ██           ████████    "
      " ██████    ████       ████      ████   ███           ████████    "
      "                                        ██                       "
    ];
    opts = { position = "center"; hl = "Type"; };
  }
  { type = "padding"; val = 2; }
  {
    type = "group";
    val = [
      (mkButton { label = "  Find File"; action = "function() require('telescope.builtin').find_files() end"; shortcut = "f"; keymap = ":Telescope find_files<CR>"; })
      (mkButton { label = "  Recent Files"; action = "function() require('telescope.builtin').oldfiles() end"; shortcut = "r"; keymap = ":Telescope oldfiles<CR>"; })
      (mkButton { label = "  Find Word"; action = "function() require('telescope.builtin').live_grep() end"; shortcut = "w"; keymap = ":Telescope live_grep<CR>"; })
      (mkButton { label = "  Quit"; action = "function() vim.cmd('qa') end"; shortcut = "q"; keymap = ":qa<CR>"; })
    ];
  }
  { type = "padding"; val = 1; }
  {
    type = "text";
    val = "─────────────── Projects ───────────────";
    opts = { position = "center"; hl = "Comment"; };
  }
  { type = "padding"; val = 1; }
  {
    type = "group";
    val.__raw = ''
      (function()
        local buttons = {}
        local base_path = vim.fn.expand("~/b2b-identity")
        local ignored = { [".git"] = true, [".idea"] = true, [".claude"] = true, ["result"] = true }

        local function is_git_repo(path)
          return vim.fn.isdirectory(path .. "/.git") == 1
        end

        local function get_dirs(path)
          local dirs = {}
          local handle = vim.loop.fs_scandir(path)
          if not handle then return dirs end
          while true do
            local name, ftype = vim.loop.fs_scandir_next(handle)
            if not name then break end
            if ftype == "directory" and not ignored[name] and not name:match("^%.") then
              table.insert(dirs, name)
            end
          end
          table.sort(dirs)
          return dirs
        end

        local function find_git_repos(path, prefix, depth)
          local repos = {}
          for _, name in ipairs(get_dirs(path)) do
            local full_path = path .. "/" .. name
            local display = prefix == "" and name or (prefix .. "/" .. name)
            if is_git_repo(full_path) then
              table.insert(repos, { name = display, path = full_path })
            elseif depth > 0 then
              for _, repo in ipairs(find_git_repos(full_path, display, depth - 1)) do
                table.insert(repos, repo)
              end
            end
          end
          return repos
        end

        for _, repo in ipairs(find_git_repos(base_path, "", 2)) do
          table.insert(buttons, {
            type = "button",
            val = "  " .. repo.name,
            on_press = function()
              vim.cmd("cd " .. repo.path)
              vim.cmd("Oil")
            end,
            opts = { position = "center", width = 50, cursor = 3 },
          })
        end

        return buttons
      end)()
    '';
  }
]
