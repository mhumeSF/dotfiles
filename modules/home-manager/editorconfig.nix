{
  programs.editorconfig.settings = {
    root = true;

    "*" = {
      indent_style = "space";
      indent_size = 2;
      end_of_line = "lf";
      charset = "utf-8";
      trim_trailing_whitespace = true;
      insert_final_newline = true;
    };

    "*.{sh,bash}" = {
      indent_style = "tab";
      indent_size = 4;
    };

    "*.md" = {
      # Trailing spaces in markdown indicate word wrap
      trim_trailing_whitespace = false;
      max_line_length = 80;
    };

    "*.go" = {
      indent_style = "tab";
      indent_size = 2;
    };

    ".gitconfig" = {
      indent_style = "tab";
      indent_size = 2;
    };

    "{*.yml,*.yaml,*.json}" = {
      indent_style = "space";
      indent_size = 2;
    };

    "{Makefile,**.mk}" = {
      # Use tabs for indentation (Makefiles require tabs)
      indent_style = "tab";
    };
  }
}
