"""Run with python3 -m unittest discover -s tests -v. No network or user config."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
ENV = {**os.environ, "GIT_CONFIG_GLOBAL": "/dev/null", "GIT_CONFIG_NOSYSTEM": "1"}


class Worktrees(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name).resolve()
        self.repo = self.root / "main checkout"
        self.git("init", "-q", "-b", "main", str(self.repo), cwd=self.root)
        self.git("config", "user.name", "Test")
        self.git("config", "user.email", "test@example.invalid")
        self.git("commit", "-q", "--allow-empty", "-m", "base")
        self.git("update-ref", "refs/remotes/origin/main", "HEAD")
        self.git("symbolic-ref", "refs/remotes/origin/HEAD", "refs/remotes/origin/main")
        self.wt = self.root / 'feature space "quote" \\slash\ttab\nnewline'
        self.git("worktree", "add", "-q", "-b", "feature.test", str(self.wt))
        self.git("commit", "-q", "--allow-empty", "-m", "feature", cwd=self.wt)
        self.tip = self.git("rev-parse", "feature.test").stdout.strip()

    def git(self, *args, cwd=None):
        return subprocess.run(["git", *args], cwd=cwd or self.repo, env=ENV,
                              text=True, capture_output=True, check=True)

    def shell(self, body, prs=None, select="", fetch_fail=False):
        # Mock only GitHub, the interactive picker, and fetch; all local Git
        # operations (including worktree removal and branch deletion) are real.
        setup = r'''
source "$PLUGIN"
gh() {
  [[ "$GH_FAIL" != 1 ]] || return 1
  local query="${argv[-1]}"
  printf '%s' "$PRS" | jq -r "$query"
}
fzf() {
  local item zero=false
  [[ " $* " == *" --read0 "* ]] && zero=true
  if $zero; then
    while IFS= read -r -d '' item; do
      [[ "$item" == "$SELECT" ]] && { printf '%s\0' "$item"; return; }
    done
  else
    while IFS= read -r item; do
      [[ "$item" == "$SELECT" ]] && { printf '%s\n' "$item"; return; }
    done
  fi
  return 1
}
git() {
  if [[ "$1" == fetch ]]; then
    [[ "$FETCH_FAIL" != 1 ]]
  else
    command git "$@"
  fi
}
'''
        env = {**ENV, "PLUGIN": str(ROOT / "home/.zsh/plugins/git-worktree.plugin.zsh"),
               "PRS": json.dumps(prs or []), "SELECT": select,
               "GH_FAIL": "0", "FETCH_FAIL": str(int(fetch_fail))}
        return subprocess.run(["zsh", "-f", "-c", setup + body], cwd=self.repo,
                              env=env, text=True, capture_output=True)

    def pr(self, **changes):
        return {"headRefOid": self.tip, "baseRefName": "main",
                "state": "MERGED", "isCrossRepository": False, **changes}

    def test_checkout_existing_unusual_path(self):
        result = self.shell('_w_checkout; printf "RESULT:%s" "$PWD"', select="feature.test")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(result.stdout.endswith("RESULT:" + str(self.wt)))

    def test_remove_keeps_unmerged_branch(self):
        result = self.shell('_w_remove -d', select=str(self.wt) + " [feature.test]")
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.wt.exists())
        self.git("show-ref", "--verify", "refs/heads/feature.test")

    def test_old_pr_does_not_delete_new_commits(self):
        self.git("commit", "-q", "--allow-empty", "-m", "new work", cwd=self.wt)
        result = self.shell('_w_cleanup', [self.pr()])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(self.wt.exists())
        self.git("show-ref", "--verify", "refs/heads/feature.test")

    def test_exact_merged_pr_cleans_worktree_and_branch(self):
        result = self.shell('_w_cleanup', [self.pr()])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(self.wt.exists())
        self.assertEqual(self.git("branch", "--list", "feature.test").stdout, "")

    def test_wrong_base_fork_and_closed_pr_are_kept(self):
        for pr in [self.pr(baseRefName="release"), self.pr(isCrossRepository=True),
                   self.pr(state="CLOSED")]:
            with self.subTest(pr=pr):
                result = self.shell('_w_cleanup', [pr])
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertTrue(self.wt.exists())

    def test_closed_opt_in_requires_matching_tip(self):
        result = self.shell('_w_merge_reason feature.test main true true',
                            [self.pr(state="CLOSED", headRefOid="0" * 40)])
        self.assertNotEqual(result.returncode, 0)
        result = self.shell('_w_cleanup --closed', [self.pr(state="CLOSED")])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(self.wt.exists())

    def test_fetch_failure_aborts_cleanup(self):
        result = self.shell('_w_cleanup', [self.pr()], fetch_fail=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertTrue(self.wt.exists())

    def test_dry_run_and_api_failure_preserve_worktree(self):
        for body in ['_w_cleanup --dry-run', 'GH_FAIL=1; _w_cleanup']:
            result = self.shell(body, [self.pr()])
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertTrue(self.wt.exists())

    def test_branch_without_worktree_and_true_merge(self):
        self.git("worktree", "remove", str(self.wt))
        self.git("merge", "--ff-only", "feature.test")
        self.git("update-ref", "refs/remotes/origin/main", "HEAD")
        result = self.shell('GH_FAIL=1; _w_cleanup')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.git("branch", "--list", "feature.test").stdout, "")


class DockerConfig(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.directory = Path(self.tmp.name) / "docker config"
        self.directory.mkdir()
        self.config = self.directory / "config.json"

    def run_update(self):
        return subprocess.run(["bash", str(ROOT / "scripts/update-docker-config.sh"),
                               str(self.directory)], capture_output=True, text=True)

    def test_preserves_settings_and_replaces_auth(self):
        original = {"currentContext": "local", "plugins": {"buildx": {"key": "value"}},
                    "auths": {"registry": {"auth": "old"}}, "credsStore": "old",
                    "credHelpers": {"registry": "old"}}
        self.config.write_text(json.dumps(original))
        result = self.run_update()
        self.assertEqual(result.returncode, 0, result.stderr)
        expected = {**original, "auths": {}, "credsStore": "1password"}
        del expected["credHelpers"]
        self.assertEqual(json.loads(self.config.read_text()), expected)
        self.assertEqual(self.config.stat().st_mode & 0o777, 0o600)
        first = self.config.read_bytes()
        self.assertEqual(self.run_update().returncode, 0)
        self.assertEqual(self.config.read_bytes(), first)

    def test_creates_missing_config(self):
        result = self.run_update()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(self.config.read_text()),
                         {"auths": {}, "credsStore": "1password"})

    def test_invalid_config_is_untouched(self):
        for content in ['{broken', '', '[]', 'null', '{} {}']:
            with self.subTest(content=content):
                self.config.write_text(content)
                self.assertNotEqual(self.run_update().returncode, 0)
                self.assertEqual(self.config.read_text(), content)
                self.assertEqual(list(self.directory.iterdir()), [self.config])


if __name__ == "__main__":
    unittest.main()
