{
  programs.git.settings.alias = {
    rs = "reset --soft HEAD^";
    s = "status";
    co = "checkout";
    cb = "checkout -b";
    llg = "log --graph --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ar)%Creset'";
    dub = "fetch -p && git branch -vv | grep ': gone]' | awk '{print }' | xargs git branch -D";
    lg = "llg -n25";
    d = "diff";
    c = "commit";
    ca = "commit --amend";
    can = "commit -amend --no-edit";
    pushf = "push --force-with-lease";
    mom = "merge origin/main --no-edit";
    pum = "pull upstream main";
    cleanup = "!git branch --merged | grep -v '\\*' | grep  -v 'master' | grep -v 'main' | grep -v 'develop' | xargs -n 1 -r git branch -d";
    info = "config --list";
    i = "!gi() { curl -L -s https://www.gitignore.io/api/$@ ;}; gi";
    empty = "commit --allow-empty -m";
    p = "pull";
    P = "push";
    ic = "commit -m \"Init commit 🍻\"";
    br = "branch";
    st = "status";
  };
}
