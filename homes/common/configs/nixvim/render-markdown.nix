{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/render-markdown/index.html
    # MeanderingProgrammer/render-markdown.nvim — In-buffer markdown rendering
    render-markdown = {
      enable = true;
      settings = {
        enabled = true;
        render_modes = [ "n" "c" "t" ];
        file_types = [ "markdown" "norg" "org" ];
        heading = {
          enabled = true;
          sign = true;
          icons = [ "# " "## " "### " "#### " "##### " "###### " ];
        };
        code = {
          enabled = true;
          sign = true;
          style = "full";
          position = "left";
          language_pad = 0;
          disable_background = false;
          width = "full";
          left_pad = 0;
          right_pad = 0;
          border = "thin";
          above = " ";
          below = " ";
        };
        bullet = {
          enabled = true;
          icons = [ "" "" "" "" ];
          right_pad = 0;
        };
        checkbox = {
          enabled = true;
          unchecked = {
            icon = " ";
          };
          checked = {
            icon = " ";
          };
          custom = {
            todo = {
              raw = "[-]";
              rendered = "󰥔 ";
              highlight = "RenderMarkdownTodo";
            };
          };
        };
        pipe_table = {
          enabled = true;
          style = "full";
          cell = "padded";
        };
        link = {
          enabled = true;
          hyperlink = " ";
          image = "󰥶 ";
          email = " ";
          custom = {
            web = {
              pattern = "^http";
              icon = " ";
            };
          };
        };
        sign = {
          enabled = true;
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>um";
      action = "<cmd>RenderMarkdown toggle<CR>";
      options.desc = "Toggle markdown rendering";
    }
  ];
}
