# Git Commands Cheat Sheet 📋

A collection of essential and frequently used git commands to boost your productivity.

---

## 1. General

- ✅ `git init`: Initializes a new Git repository.
- ✅ `git clone <url>`: Clones an existing Git repository.
- ✅ `git status`: Shows the current state of the working directory.
- ✅ `git add <file>`: Stages changes in a file.
- ✅ `git add ."`: Stage all your changes.
- ✅ `git commit -m "<message>"`: Commits staged changes with a message.
- ✅ `git remote add <remote_name> <url>`: Adds a new remote repository with a given name and URL.
- ✅ `git push -u <remote_name> <branch_name>"`: Push your local branch to a remote repository and `-u` flag sets the upstream branch for your local branch. This means that subsequent git push commands to the same remote and branch will push your commits directly without specifying the remote and branch names again.

---

## 2. Committing

- ✅ `git log`: Shows commit history.
- ✅ `git diff <commit1> <commit2>`: Shows differences between commits, files, or branches.
- ✅ `git diff --stat <commit1> <commit2>`: Shows a summary of the changes between commits, files, or branches.
- ✅ `git reset --hard HEAD^`: Resets the current HEAD to the previous commit.
- ✅ `git revert <commit>`: Reverts a specific commit.
- ✅ `git tag <tag_name>`: Creates a tag at the current commit.
- ✅ `git commit --amend -m "new message"`: Update the most recent commit message.
  - ✅ `git push`: Push the changes to repository if you haven't pushed the commit before updating it's message.
  - ✅ `git push --force`: Push the changes to repository if you had already pushed the commit before updating it's message.

---

## 3. Tagging

- ✅ `git tag`: Lists all available tags in the repository.
- ✅ `git tag -l "v1.*"`: Lists tags matching the pattern "v1.\*" (e.g., v1.0, v1.1, v1.9).
- ✅ `git tag <tagname>`: Creates a lightweight tag (a simple pointer to a commit).
- ✅ `git tag -a <tagname> -m "message"`: Creates an annotated tag with a message.
- ✅ `git tag -s <tagname> -m "message"`: Creates a GPG-signed tag with a message.
- ✅ `git tag -f <tagname> <commit>`: Forcefully creates a tag at the specified commit, even if a tag with the same name already exists.
- ✅ `git tag -d <tagname>`: Deletes the specified tag.
- ✅ `git show <tagname>`: Shows details about the specified tag, including the commit it points to and any associated message.
- ✅ `git push origin <tagname>`: Pushes the specified tag to the remote repository.
- ✅ `git push origin --tags`: Pushes all tags to the remote repository.
- ✅ `git fetch origin --tags`: Fetches all tags from the remote repository.

---

## 4. Branch

- ✅ `git branch`: Lists all local branches.
- ✅ `git branch -a`: Lists all local and remote branches.
- ✅ `git branch -v`: Lists branches with additional information.
- ✅ `git branch <branch_name>`: Creates a new branch.
- ✅ `git checkout <branch_name>`: Switches1 to an existing branch.
- ✅ `git checkout -b <branch_name>`: Creates a new branch based on the default branch and switches to it.
- ✅ `git checkout -b <branch_name> <base_branch_name>`: Creates a new branch based on the specified branch and switches to it. This means that the new branch will start at the same commit as the specified branch.
- ✅ `git branch -d <branch_name>`: Deletes a branch.
- ✅ `git branch -D <branch_name>`: Force delete a local Git branch.
- ✅ `git push <remote_name> --delete <branch_name>`: Deletes a remote branch.
- ✅ `git push <remote_name> :<branch_name>`: Deletes a remote branch.
- ✅ `git branch -m <old_name> <new_name>`: Renames a branch.
- ✅ `git branch --merged`: Lists branches that are fully merged into the current branch.
- ✅ `git branch --no-merged`: Lists branches that are not yet merged into the current branch.
- ✅ `git branch --track <remote_branch>`: Creates a local branch that tracks a remote branch.

---

## 5. Remote Repository

- ✅ `git remote -v`: Lists all remote repositories configured for the current project.
- ✅ `git remote add <name> <url>`: Adds a new remote repository with a given name and URL.
- ✅ `git remote rm <name>`: Removes an existing remote repository.
- ✅ `git remote rename <old_name> <new_name>`: Renames an existing remote repository.
- ✅ `git fetch <remote>`: Fetches commits, branches, and tags from a remote repository without merging them into your local branches.
- ✅ `git pull <remote> <branch>`: Fetches commits from a remote branch and merges them into your local branch.
- ✅ `git pull --rebase <remote> <branch>`: Fetches commits from a remote branch and reapplies your local commits on top of them, creating a linear history and avoiding merge commits.
- ✅ `git push <remote> <branch>`: Pushes commits from your local branch to a remote branch.
- ✅ `git remote set-url <remote> <new_url>`: Changes the URL of an existing remote repository.
- ✅ `git remote show <remote>`: Displays detailed information about a remote repository.
- ✅ `git remote prune <remote>`: Removes remote-tracking branches that no longer exist on the remote repository.

---

## 6. Merging

- ✅ `git merge <branch_name>`: Merges the specified branch into the current branch.
- ✅ `git merge --no-commit <branch_name>`: Merges the specified branch but doesn't create a merge commit immediately. This allows you to review the changes before committing.
- ✅ `git merge --abort`: Aborts an ongoing merge process.
- ✅ `git merge --continue`: Continues a merge process after resolving conflicts.
- ✅ `git mergetool`: Opens a visual merge tool to help resolve conflicts.
- ✅ `git merge --squash <branch_name>`: Merges the specified branch into the current branch, combining all commits into a single commit.
- ✅ `git merge --no-ff <branch_name>`: Forces a merge commit even if a fast-forward merge is possible.

---

## 7. Stashing

- ✅ `git stash`: Saves the current state of the working directory.
- ✅ `git stash list`: Lists all stashed changes.
- ✅ `git stash pop`: Removes the most recent stash and applies it to the current branch.
- ✅ `git stash apply`: Applies the most recent stash without removing it.
- ✅ `git stash drop`: Removes the most recent stash.
- ✅ `git stash clear`: Removes all stashes.

---

## 8. Removing Files & Folders

- ✅ `git rm <file>`: Removes a file from your working directory and stages the deletion.
- ✅ `git rm -r <folder>`: Recursively removes a folder and its contents from your working directory and stages the deletion.
- ✅ `git rm --cached <file>`: Untracks a file, removing it from the Git index (staging area) but keeping the file in your local working directory. This is useful for removing a file from the repository that should have been ignored.
- ✅ `git rm -r --cached <folder>`: Untracks a folder recursively, removing it from the Git index but keeping it locally.
- After using `git rm`, you must commit the change: `git commit -m "Remove file/folder"`.
- To remove the file/folder from the remote repository, push the commit: `git push`.

---

With these commands, you're equipped to handle various aspects of git efficiently!

---

# Conventional Commits Cheat Sheet in Git

This cheat sheet provides a quick reference for using Conventional Commits in Git.

## Commit Types and Descriptions

| Type       | Description              | Purpose                                                                                                     |
| ---------- | ------------------------ | ----------------------------------------------------------------------------------------------------------- |
| `feat`     | Features                 | A new feature                                                                                               |
| `fix`      | Bug Fixes                | A bug fix                                                                                                   |
| `docs`     | Documentation            | Documentation only changes                                                                                  |
| `style`    | Styles                   | Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)      |
| `refactor` | Code Refactoring         | A code change that neither fixes a bug nor adds a feature                                                   |
| `perf`     | Performance Improvements | A code change that improves performance                                                                     |
| `test`     | Tests                    | Adding missing tests or correcting existing tests                                                           |
| `build`    | Builds                   | Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)         |
| `ci`       | Continuous Integrations  | Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs) |
| `chore`    | Chores                   | Other changes that don't modify src or test files                                                           |
| `revert`   | Reverts                  | Reverts a previous commit                                                                                   |

## Example Usage

```sh
# Adding a new feature
git commit -m "feat: add user authentication module"

# Fixing a bug
git commit -m "fix: resolve login page crash"

# Updating documentation
git commit -m "docs: update README with installation steps"

# Refactoring code
git commit -m "refactor: optimize API request handling"
```

## More Information

For more details, check out the [Conventional Commits Specification](https://www.conventionalcommits.org/en/v1.0.0/).
