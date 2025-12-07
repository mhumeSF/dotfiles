{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      #author: https://github.com/AirOnSkin
      chameleon = {
        blame-code-style = "syntax";
        blame-format = "{author:<18} ({commit:>7}) {timestamp:^12} ";
        blame-palette = "#2E3440 #3B4252 #434C5E #4C566A";
        dark = true;
        file-added-label = "[+]";
        file-copied-label = "[==]";
        file-decoration-style = "#434C5E ul";
        file-modified-label = "[*]";
        file-removed-label = "[-]";
        file-renamed-label = "[->]";
        file-style = "#434C5E bold";
        hunk-header-style = "omit";
        keep-plus-minus-markers = true;
        line-numbers = true;
        line-numbers-left-format = " {nm:>1} │";
        line-numbers-left-style = "red";
        line-numbers-minus-style = "red italic black";
        line-numbers-plus-style = "green italic black";
        line-numbers-right-format = " {np:>1} │";
        line-numbers-right-style = "green";
        line-numbers-zero-style = "#434C5E italic";
        merge-conflict-begin-symbol = "~";
        merge-conflict-end-symbol = "~";
        merge-conflict-ours-diff-header-decoration-style = "#434C5E box";
        merge-conflict-ours-diff-header-style = "#F1FA8C bold";
        merge-conflict-theirs-diff-header-decoration-style = "#434C5E box";
        merge-conflict-theirs-diff-header-style = "#F1FA8C bold";
        minus-emph-style = "bold #202020 #FF5555";
        minus-non-emph-style = "bold";
        minus-style = "bold red";
        plus-emph-style = "bold #202020 #50FA7B";
        plus-non-emph-style = "bold";
        plus-style = "bold green";
        side-by-side = true;
        syntax-theme = "Visual Studio Dark+";
        zero-style = "syntax";
      };
      features = "chameleon";
      syntax-theme = "TwoDark";
      side-by-side = true;
      line-numbers = true;
    };
  };
}
