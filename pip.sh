# https://gist.github.com/haircut/14705555d58432a5f01f9188006a04ed
# # Install and use pip on macOS without sudo / admin access
#
# Most recently tested on macOS Sierra (10.12.6)
#
# 1. Download the installation script; `curl https://bootstrap.pypa.io/get-pip.py -o ~/Downloads/get-pip.py`
# 2. Run the installation, appending the `--user` flag; `python ~/Downloads/get-pip.py --user`. pip will be installed to ~/Library/Python/2.7/bin/pip
# 3. Make sure `~/Library/Python/2.7/bin` is in your `$PATH`. For `bash` users, edit the `PATH=` line in `~/.bashrc` to append the local Python path; ie. `PATH=$PATH:~/Library/Python/2.7/bin`. Apply the changes, `source ~/.bashrc`.
# 4. Use pip! Remember to append `--user` when installing modules; ie. `pip install <package_name> --user`
#
# ## Note
#
# There is much discussion about making the user site the default for installation. See [Issue 1668](https://github.com/pypa/pip/issues/1668).

#!/bin/bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py --user

echo "# ------------------------" >> ~/.zshrc
echo "# APPEND USER PYTHON PATH:" >> ~/.zshrc
echo "# ------------------------" >> ~/.zshrc
echo 'PATH=$PATH:~/Library/Python/2.7/bin' >> ~/.zshrc

echo 'alias pip="pip --user $1"' >> ~/.aliases

. ~/.zshrc

