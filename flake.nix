# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license
# This is an empty nixCats config.
# you may import this template directly into your nvim folder
# and then add plugins to categories here,
# and call the plugins with their default functions
# within your lua, rather than through the nvim package manager's method.
# Use the help, and the example config github:BirdeeHub/nixCats-nvim?dir=templates/example
# It allows for easy adoption of nix,
# while still providing all the extra nix features immediately.
# Configure in lua, check for a few categories, set a few settings,
# output packages with combinations of those categories and settings.
# All the same options you make here will be automatically exported in a form available
# in home manager and in nixosModules, as well as from other flakes.
# each section is tagged with its relevant help section.
{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    "plugins-capslock-nvim" = {
      url = "github:barklan/capslock.nvim";
      flake = false;
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples
  };

  # see :help nixCats.flake.outputs
  outputs = {
    self,
    nixpkgs,
    nixCats,
    ...
  } @ inputs: let
    inherit (nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      allowUnfree = true;
    };
    # management of the system variable is one of the harder parts of using flakes.

    # so I have done it here in an interesting way to keep it out of the way.
    # It gets resolved within the builder itself, and then passed to your
    # categoryDefinitions and packageDefinitions.

    # this allows you to use ${pkgs.system} whenever you want in those sections
    # without fear.

    # sometimes our overlays require a ${system} to access the overlay.
    # Your dependencyOverlays can either be lists
    # in a set of ${system}, or simply a list.
    # the nixCats builder function will accept either.
    # see :help nixCats.flake.outputs.overlays
    dependencyOverlays =
      /*
      (import ./overlays inputs) ++
      */
      [
        # This overlay grabs all the inputs named in the format
        # `plugins-<pluginName>`
        # Once we add this overlay to our nixpkgs, we are able to
        # use `pkgs.neovimPlugins`, which is a set of our plugins.
        (utils.standardPluginOverlay inputs)
        # add any other flake overlays here.

        # when other people mess up their overlays by wrapping them with system,
        # you may instead call this function on their overlay.
        # it will check if it has the system in the set, and if so return the desired overlay
        # (utils.fixSystemizedOverlay inputs.codeium.overlays
        #   (system: inputs.codeium.overlays.${system}.default)
        # )
      ];

    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkNvimPlugin,
      ...
    } @ packageDef: {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs

      lspsAndRuntimeDeps = with pkgs; {
        # Inline comments next to tools below indicate the
        # name they are referred to in nvim for reference
        # Use these resources for cross-referencing:
        # https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
        # https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
        general = [
          universal-ctags
          ripgrep
          fd
          imagemagick
          stdenv.cc.cc
          nix-doc
          nodePackages.nodejs
          # neovimPlugins.capslock-nvim
        ];
        lsps = [
          bash-language-server # bashls
          clang-tools # clangd
          eslint # eslint
          vscode-langservers-extracted # html, jsonls
          lua-language-server # lua_ls
          marksman # marksman
          nixd # nixd
          pyright # pyright
          rust-analyzer # rust-analyzer
          tailwindcss-language-server # tailwindcss
          typos-lsp # typos_lsp
        ];
        formatters = [
          beautysh # beautysh
          black # black
          isort # isort
          nodePackages.prettier # prettier
          prettierd # prettierd
          stylua # stylua
        ];
        linting = [
          alejandra # alejandra
          cpplint # cpplint
          eslint_d # eslint_d
          markdownlint-cli # markdownlint
          pylint # pylint
          vim-vint # vint
        ];
        debug = [
          delve # delve
          # codelldb # codelldb # no nixpkg
        ];
        custom = [
          # pkgs.neovimPlugins.capslock-nvim
          # TODO: get custom plugins working, config build but it doesn't use the plugin
          (pkgs.neovimPlugins.capslock-nvim.overrideAttrs {pname = "capslock.nvim";})
        ];
      };
      # This is for plugins that will load at startup without using packadd:
      startupPlugins = with pkgs.vimPlugins; {
        general = [
          vim-sleuth
          lazy-nvim
          # mini-nvim
          # (mkNvimPlugin inputs.capslock-nvim "capslock.nvim")
        ];
        colorschemes = [
          tokyonight-nvim
        ];
        core = [
          # from debug.lua
          # nvim-dap
          # nvim-dap-ui
          # nvim-dap-go
          # nvim-nio

          # from formatting.lua
          conform-nvim

          # from linting.lua
          nvim-lint

          # from lspconfig.lua
          nvim-lspconfig
          cmp-nvim-lsp
          fidget-nvim
          lazydev-nvim
          kmonad-vim
          clangd_extensions-nvim

          # from treesitter.lua
          nvim-treesitter.withAllGrammars
          # This is for if you only want some of the grammars
          # (nvim-treesitter.withPlugins (
          #   plugins: with plugins; [
          #     nix
          #     lua
          #   ]
          # ))
        ];
        editor = [
          bigfile-nvim
          nvim-biscuits
          # capslock.nvim # no nixpkg
          cmp-buffer # dependency for nvim-cmp
          cmp_luasnip # dependency for nvim-cmp
          cmp-path # dependency for nvim-cmp
          comment-nvim
          # copilot-chat # no nixpkg
          copilot-lua
          flash-nvim
          # indent-blankline-nvim # disabled
          luasnip
          lspkind-nvim # dependency for nvim-cmp
          mini-ai
          mini-indentscope
          mini-pairs
          mini-surround
          nvim-cmp
          friendly-snippets # dependency for nvim-cmp
          nvim-spectre
          # snacks-nvim
          sqlite-lua # dependency for yanky
          # timber # no nixpkg
          tiny-inline-diagnostic-nvim
          todo-comments-nvim
          nvim-treesitter-context
          trouble-nvim
          wtf-nvim
          yanky-nvim
        ];
        fun = [
          # beepboop # no nixpkg
          cellular-automaton-nvim
          # duck # no nixpkg
          # hacker # no nixpkg
          # pets # no nixpkg
          vim-pets
          # speedtyper # no nixpkg
        ];
        norgmode = [
          neorg
        ];
        orgmode = [
          # org-roam # no nixpkg
          # orgmode
          # telescope-orgmode # no nixpkg
        ];
        ui = [
          bufferline-nvim
          nvim-colorizer-lua
          dressing-nvim
          edgy-nvim
          gitsigns-nvim
          lualine-nvim
          nvim-web-devicons # dependency for lualine, neo-tree, telescope
          copilot-lualine
          # harpoon-lualine # no nixpkg
          markdown-preview-nvim
          mini-animate
          mini-bufremove
          neoscroll-nvim
          neo-tree-nvim
          noice-nvim
          nvim-notify # dependency for noice
          nui-nvim # dependency for neo-tree, noice
          # reactive # no nixpkg
          render-markdown-nvim
          telescope-nvim
          telescope-fzf-native-nvim # dependency for telescope
          telescope-ui-select-nvim # dependency for telescope
          toggleterm-nvim
          vim-illuminate
          # windows # no nixpkg # disabled
          which-key-nvim
          zen-mode-nvim
        ];
        util = [
          firenvim
          # orphans # no nixpkg
          persistence-nvim
          plenary-nvim # dependency for neo-tree, telescope
        ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      # NOTE: this template is using lazy.nvim so, which list you put them in is irrelevant.
      # startupPlugins or optionalPlugins, it doesnt matter, lazy.nvim does the loading.
      # I just put them all in startupPlugins. I could have put them all in here instead.
      optionalPlugins = {};

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [
          ''--set CATTESTVAR2 "It worked again!"''
        ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      extraPython3Packages = {
        test = _: [];
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        test = [(_: [])];
      };
    };

    # And then build a package with specific categories from above here:
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      # These are the names of your packages
      # you can include as many as you wish.
      nvim = {pkgs, ...}: {
        # they contain a settings set defined above
        # see :help nixCats.flake.outputs.settings
        settings = {
          wrapRc = true;
          # IMPORTANT:
          # your alias may not conflict with your other packages.
          # aliases = ["nixcats"];
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          # configDirName = "nixCats-nvim";
        };
        # and a set of categories that you want
        # (and other information to pass to lua)
        categories = {
          general = true;
          lsps = true;
          formatters = true;
          linting = true;
          debug = true;
          colorschemes = true;
          core = true;
          editor = true;
          fun = true;
          norgmode = true;
          orgmode = true;
          ui = true;
          util = true;
          custome = true;

          gitPlugins = true;
          test = true;

          # we can pass whatever we want actually.
          # have_nerd_font = false;

          example = {
            youCan = "add more than just booleans";
            toThisSet = [
              "and the contents of this categories set"
              "will be accessible to your lua with"
              "nixCats('path.to.value')"
              "see :help nixCats"
              "and type :NixCats to see the categories set in nvim"
            ];
          };
        };
      };
    };
    # In this section, the main thing you will need to do is change the default package name
    # to the name of the packageDefinitions entry you wish to use as the default.
    defaultPackageName = "nvim";
  in
    # see :help nixCats.flake.outputs.exports
    forEachSystem
    (system: let
      nixCatsBuilder =
        utils.baseBuilder luaPath
        {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;
      # this is just for using utils such as pkgs.mkShell
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
      pkgs = import nixpkgs {inherit system;};
    in {
      # these outputs will be wrapped with ${system} by utils.eachSystem

      # this will make a package out of each of the packageDefinitions defined above
      # and set the default package to the one passed in here.
      packages = utils.mkAllWithDefault defaultPackage;

      # choose your package for devShell
      # and add whatever else you want in it.
      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [defaultPackage];
          inputsFrom = [];
          shellHook = ''
          '';
        };
      };
    })
    // (
      let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in {
        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays =
          utils.makeOverlays luaPath
          {
            inherit nixpkgs dependencyOverlays extra_pkg_config;
          }
          categoryDefinitions
          packageDefinitions
          defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
