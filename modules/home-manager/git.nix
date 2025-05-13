{
  programs.git = {
    enable = true;
    extraConfig = {

      user = {
        name = "Mike Hume";
        email = "mhumesf@gmail.com";
      };

      gpg = {
        format = "ssh";
        ssh = {
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          allowedSignersFile = "~/.ssh/allowed_signers";
        };
      };

      commit = {
        gpgsign = true;
      };

      core = {
        whitespace = "trailing-space,space-before-tab";
        excludesfile = "~/.config/git/ignore";
      };

      init = {
        defaultBranch = "main";
      };

      push = {
        autoSetupRemote = true;
      };

      pull = {
        ff = "only";
      };

      merge = {
        tool = "vimdiff";
      };

      mergetool = {
        prompt = true;
        vimdiff = {
          cmd = "nvim -d $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
        };
      };

      difftool = {
        prompt = false;
      };

      diff = {
        tool = "vimdiff";
        plist = {
          textconv = "plutil -convert xml1 -o -";
        };
        sopsdiffer = {
          textconv = "sops -d";
        };
      };

      color = {
        ui = true;
        diff-highlight = {
          oldNormal = "red bold";
          oldHighlight = "red bold 52";
          newNormal = "green bold";
          newHighlight = "green bold 22";
        };
        diff = {
          meta = "yellow";
          frag = "magenta bold";
          commit = "yellow bold";
          old = "red bold";
          new = "green bold";
          whitespace = "red reverse";
        };
      };

      branch = {
        master = {
          remote = "origin";
          merge = "refs/heads/master";
        };
        main = {
          remote = "origin";
          merge = "refs/heads/main";
        };
      };

      filter = {
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
    };
  };
}
