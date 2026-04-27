{ pkgs, lib, ... }:

{
  files = {
    ".yamllint.yaml".yaml = {
      extends = "default";
      rules = {
        document-start = "disable";
        truthy = "disable";
        comments = "disable";
        line-length.max = 120;
      };
    };
    ".yamlfmt.yaml".yaml = {
      formatter = {
        type = "basic";
        line_ending = "lf";
        max_line_length = 140;
        trim_trailing_whitespace = true;
        eof_newline = true;
        force_array_style = "block";
      };
    };
    ".ruff.toml".toml = {
      target-version = "py313";
      line-length = 120;
      lint = {
        fixable = [ "ALL" ];
        ignore = [
          "D100"
          "D105"
          "D107"
          "D212"
          "D413"
          "SIM117"
        ];
        select = [ "ALL" ];
        isort = {
          combine-as-imports = true;
        };
        per-file-ignores = {
          "test_app.py" = [
            "INP001"
            "S101"
          ];
          "__init__.py" = [
            "D104"
          ];
        };
      };
      format = {
        docstring-code-format = false;
        docstring-code-line-length = "dynamic";
        indent-style = "space";
        line-ending = "lf";
        quote-style = "double";
        skip-magic-trailing-comma = false;
      };
    };
    ".taplo.toml".toml = {
      exclude = [ ".venv/**" ];
      formatting = {
        indent_entries = true;
        indent_tables = true;
        reorder_arrays = true;
        reorder_inline_tables = true;
        reorder_keys = true;
      };
    };
    ".ls-lint.yml".yaml = {
      ls = {
        ".dir" = "kebab-case";
        ".ipynb" = "kebab-case";
      };
      ignore = [
        ".devenv"
        ".direnv"
        ".git"
        ".github"
        ".idea"
      ];
    };
  };

  packages = [ pkgs.quarto ];

  languages.python = {
    enable = true;
    uv = {
      enable = true;
      sync.enable = true;
    };
  };

  scripts = {
    compatibility-check.exec = ''
      echo "Checking compatibility"
      ${lib.getExe pkgs.uv} sync --frozen --no-install-project
    '';
    clean_jupyter.exec = ''
      echo "Cleaning Jupyter Notebooks"
      ${lib.getExe pkgs.uv} run nb-clean clean -o -e ./notebooks/
    '';
    check_jupyter.exec = ''
      echo "Checking Jupyter Notebooks"
      ${lib.getExe pkgs.uv} run nb-clean check -o -e ./notebooks/
    '';
    render.exec = ''
      echo "Rendering"
      ${lib.getExe pkgs.quarto} render
    '';
  };

  tasks = {
    "lint:ls-lint" = {
      exec = "${lib.getExe pkgs.ls-lint}";
      after = [ "devenv:enterTest" ];
    };
  };

  git-hooks.hooks = {
    action-validator.enable = true;
    actionlint.enable = true;
    nixfmt.enable = true;
    check-added-large-files.enable = true;
    check-builtin-literals.enable = true;
    check-case-conflicts.enable = true;
    check-docstring-first.enable = true;
    check-json.enable = true;
    check-merge-conflicts.enable = true;
    check-python.enable = true;
    check-toml.enable = true;
    check-vcs-permalinks.enable = true;
    check-xml.enable = true;
    check-yaml.enable = true;
    deadnix.enable = true;
    detect-private-keys.enable = true;
    # lychee.enable = true;
    markdownlint.enable = true;
    mixed-line-endings.enable = true;
    name-tests-test.enable = true;
    prettier.enable = true;
    python-debug-statements.enable = true;
    ripsecrets.enable = true;
    ruff.enable = true;
    ruff-format.enable = true;
    statix.enable = true;
    taplo.enable = true;
    trim-trailing-whitespace.enable = true;
    trufflehog.enable = true;
    uv-check.enable = true;
    uv-lock.enable = true;
    yamllint.enable = true;
    yamlfmt = {
      enable = true;
      settings.lint-only = false;
    };
  };

  treefmt.config = {
    programs = {
      actionlint.enable = true;
      deadnix.enable = true;
      jsonfmt.enable = true;
      mdformat.enable = true;
      nixf-diagnose.enable = true;
      nixfmt.enable = true;
      statix.enable = true;
      ruff-check.enable = true;
      ruff-format.enable = true;
      taplo.enable = true;
      yamlfmt = {
        enable = true;
        settings = {
          formatter = {
            type = "basic";
            line_ending = "lf";
            max_line_length = 140;
            trim_trailing_whitespace = true;
            eof_newline = true;
            force_array_style = "block";
          };
        };
      };
    };
  };

  difftastic.enable = true;
}
