# Git 命令速查与使用手册

本文按“语法 -> 参数 -> 示例”的方式整理 Git 的核心命令、常用参数和典型用法。目标是尽量覆盖日常开发中会用到的大部分命令，并补充一些进阶命令与底层命令。

## 1. Git 基本概念

Git 是分布式版本控制系统，核心对象包括：

- 工作区（working tree）：你正在编辑的文件
- 暂存区（index / staging area）：准备提交的改动
- 本地仓库（local repository）：`.git` 目录中的提交历史
- 远程仓库（remote repository）：例如 GitHub、GitLab、Gitee

常见数据流：

```text
工作区 -> 暂存区 -> 本地仓库 -> 远程仓库
```

## 2. Git 通用语法

Git 命令的基本形式：

```bash
git <子命令> [选项] [参数]
```

例子：

```bash
git commit -m "fix: update login logic"
```

说明：

- `commit` 是子命令
- `-m` 是选项
- `"fix: update login logic"` 是参数

## 3. 常用通用参数

很多 Git 命令共享一些通用风格的参数。

| 参数 | 含义 | 示例 |
|---|---|---|
| `-h` / `--help` | 查看帮助 | `git commit -h` |
| `-v` / `--verbose` | 输出更详细信息 | `git status -v` |
| `-q` / `--quiet` | 安静模式，减少输出 | `git diff --quiet` |
| `--all` | 对所有对象生效 | `git add --all` |
| `--dry-run` | 试运行，不真正执行 | `git clean -n` |
| `--force` / `-f` | 强制执行 | `git push -f` |
| `--amend` | 修正上一次提交 | `git commit --amend` |

## 4. 仓库初始化与克隆

### 4.1 `git init`

初始化一个新仓库。

```bash
git init
```

常见形式：

```bash
git init <目录>
```

参数说明：

- `<目录>`：在指定目录创建仓库

示例：

```bash
git init my-project
cd my-project
```

### 4.2 `git clone`

从远程仓库克隆一份完整代码到本地。

```bash
git clone <仓库地址>
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-b <分支>` | 指定克隆后检出的分支 |
| `--depth <n>` | 浅克隆，只获取最近 n 层历史 |
| `--single-branch` | 只克隆指定分支历史 |
| `--recursive` | 递归克隆子模块 |

示例：

```bash
git clone https://github.com/user/repo.git
```

```bash
git clone -b develop --depth 1 https://github.com/user/repo.git
```

## 5. 查看状态与历史

### 5.1 `git status`

查看当前工作区、暂存区状态。

```bash
git status
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-s` / `--short` | 简洁输出 |
| `-b` | 显示当前分支信息 |
示例：

```bash
git status -sb
```

### 5.2 `git log`

查看提交历史。

```bash
git log
```

常用参数：

| 参数 | 含义 |
|---|---|
| `--oneline` | 每条提交只显示一行 |
| `--graph` | 用图形展示分支关系 |
| `--decorate` | 显示引用名（分支、标签） |
| `--all` | 查看所有分支的历史 |
| `-p` | 显示每次提交的补丁 |
| `-n <数量>` | 只显示最近 n 条 |
| `--stat` | 显示文件统计信息 |

示例：

```bash
git log --oneline --graph --decorate --all
```

```bash
git log -n 5 --stat
```

### 5.3 `git show`

显示指定提交、标签或对象的详细内容。

```bash
git show <提交ID>
```

示例：

```bash
git show HEAD
```

```bash
git show v1.0.0
```

### 5.4 `git diff`

查看差异。

```bash
git diff
```

常见场景：

- 工作区 vs 暂存区：`git diff --cached` 或 `git diff --staged`
- 工作区 vs 最近提交：`git diff HEAD`
- 两个提交之间：`git diff <commit1> <commit2>`

常用参数：

| 参数 | 含义 |
|---|---|
| `--cached` / `--staged` | 查看已暂存改动 |
| `--name-only` | 只显示文件名 |
| `--name-status` | 显示文件名和状态 |
| `--stat` | 显示统计 |
| `--word-diff` | 逐词比较 |
| `-U <n>` | 显示上下文行数 |

示例：

```bash
git diff --cached
```

```bash
git diff --name-only HEAD~1 HEAD
```

### 5.5 `git blame`

查看文件每一行最后一次由谁修改。

```bash
git blame <文件>
```

示例：

```bash
git blame src/app.js
```

### 5.6 `git grep`

在仓库中搜索文本。

```bash
git grep <关键词>
```

示例：

```bash
git grep "TODO"
```

## 6. 文件管理

### 6.1 `git add`

把文件改动加入暂存区。

```bash
git add <文件>
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-A` / `--all` | 暂存所有改动，包括新增、修改、删除 |
| `.` | 暂存当前目录及子目录 |
| `-u` | 只暂存已跟踪文件的修改和删除 |
| `-p` | 交互式选择部分改动加入暂存区 |
| `-N` / `--intent-to-add` | 标记为将要新增但不实际加入内容 |

示例：

```bash
git add .
```

```bash
git add -A
```

```bash
git add -p
```

### 6.2 `git commit`

提交暂存区内容到本地仓库。

```bash
git commit -m "提交说明"
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-m <msg>` | 指定提交信息 |
| `-a` | 自动暂存已跟踪文件的修改后再提交 |
| `--amend` | 修正上一次提交 |
| `--no-edit` | 修正提交时不修改原提交信息 |
| `--allow-empty` | 允许空提交 |

示例：

```bash
git commit -m "feat: add login page"
```

```bash
git commit -am "fix: correct typo"
```

```bash
git commit --amend -m "feat: add login page with validation"
```

### 6.3 `git mv`

重命名或移动文件，并自动更新 Git 跟踪信息。

```bash
git mv <旧文件> <新文件>
```

示例：

```bash
git mv old.txt docs/old.txt
```

### 6.4 `git rm`

删除文件并从 Git 中移除。

```bash
git rm <文件>
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-r` | 递归删除目录 |
| `--cached` | 只从索引中移除，保留工作区文件 |
| `-f` | 强制删除 |

示例：

```bash
git rm temp.txt
```

```bash
git rm --cached secret.txt
```

## 7. 分支管理

### 7.1 `git branch`

查看、创建、删除分支。

```bash
git branch
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-a` | 显示所有分支，包括远程分支 |
| `-r` | 只显示远程分支 |
| `-v` | 显示分支最后一次提交 |
| `--merged` | 已合并到当前分支的分支 |
| `--no-merged` | 未合并分支 |
| `-d` | 删除已合并分支 |
| `-D` | 强制删除分支 |
| `-m` | 重命名分支 |

示例：

```bash
git branch feature/login
```

```bash
git branch -d feature/login
```

```bash
git branch -m old-name new-name
```

### 7.2 `git switch`

切换分支，更现代的分支切换命令。

```bash
git switch <分支>
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-c` | 创建并切换到新分支 |
| `-C` | 强制创建并切换 |
示例：

```bash
git switch main
```

```bash
git switch -c feature/ui
```

### 7.3 `git checkout`

旧版多功能命令，既可切换分支，也可恢复文件。现在建议优先用 `switch` / `restore`。

```bash
git checkout <分支>
```

示例：

```bash
git checkout develop
```

```bash
git checkout -b feature/api
```

### 7.4 `git merge`

把一个分支的内容合并到当前分支。

```bash
git merge <分支>
```

常用参数：

| 参数 | 含义 |
|---|---|
| `--no-ff` | 即使能快进合并也创建合并提交 |
| `--ff-only` | 只允许快进合并 |
| `--squash` | 将被合并分支压缩成一个临时结果，不直接提交 |
示例：

```bash
git switch main

git merge feature/login
```

```bash
git merge --no-ff feature/login
```

### 7.5 `git rebase`

把当前分支的提交“搬移”到新的基底上。

```bash
git rebase <目标分支>
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-i` / `--interactive` | 交互式变基 |
| `--onto` | 指定新的基底 |
| `--continue` | 解决冲突后继续 |
| `--abort` | 中止 rebase |
| `--skip` | 跳过当前提交 |

示例：

```bash
git switch feature/login

git rebase main
```

```bash
git rebase -i HEAD~5
```

### 7.6 `git cherry-pick`

把某个提交单独应用到当前分支。

```bash
git cherry-pick <提交ID>
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-n` / `--no-commit` | 应用提交但不立即提交 |
| `--continue` | 冲突解决后继续 |
| `--abort` | 中止 |

示例：

```bash
git cherry-pick 1a2b3c4d
```

## 8. 撤销与回退

这一节重点区分三件事：

- `restore`：恢复文件内容
- `reset`：回退提交历史和索引状态
- `revert`：生成一个新提交来撤销旧提交

如果你只是“把代码改回去”，但不想动提交历史，优先考虑 `restore` 或 `revert`。如果你还没推送、并且想直接改历史，才考虑 `reset`。

### 8.1 `git restore`

恢复文件内容。它主要用来撤销工作区或暂存区里的文件改动，不改变提交历史。

```bash
git restore <文件>
```

常用参数：

| 参数 | 含义 |
|---|---|
| `--staged` | 从暂存区恢复 |
| `--worktree` | 从工作区恢复，通常默认就是恢复工作区 |
| `--source <commit>` | 从指定提交恢复 |

典型用法：

- 撤销工作区修改，但保留暂存区：`git restore <文件>`
- 撤销已经 `git add` 的内容：`git restore --staged <文件>`
- 从某个历史版本恢复一个文件：`git restore --source <commit> <文件>`

示例：

```bash
git restore src/app.js
```

```bash
git restore --staged src/app.js
```

```bash
git restore --source HEAD~1 src/app.js
```

### 8.2 `git reset`

重置 HEAD、索引或工作区。它会影响分支指针，适合本地回退提交，但要谨慎使用。

```bash
git reset [模式] <目标>
```

常见模式：

| 模式 | 含义 |
|---|---|
| `--soft` | 只移动 HEAD，保留暂存区和工作区 |
| `--mixed` | 默认，移动 HEAD 并重置暂存区，保留工作区 |
| `--hard` | 重置 HEAD、暂存区、工作区，谨慎使用 |

理解方式：

- `--soft`：只“回退提交”，代码还在，改动仍在暂存区或工作区里
- `--mixed`：回退提交，并取消暂存，但代码还在工作区里
- `--hard`：提交、暂存区、工作区一起回到目标版本，未保存改动会丢失

适用场景：

- 想撤销最近一次提交，但继续修改后再提交：`--soft`
- 想撤销提交并重新整理暂存区：`--mixed`
- 想把本地仓库强行回到某个历史点：`--hard`

示例：

```bash
git reset --soft HEAD~1
```

```bash
git reset --mixed HEAD~1
```

```bash
git reset --hard HEAD~1
```

```bash
git reset --hard <commit>
```

常见补充：

- `HEAD~1` 表示当前提交的上一个提交
- `HEAD~2` 表示往前两个提交
- `HEAD^` 表示当前提交的父提交，常用于合并提交场景

### 8.3 `git revert`

通过生成一个“反向提交”来撤销历史中的某次提交，适合已经推送到远程、不能随意改历史的场景。

```bash
git revert <提交ID>
```

和 `reset` 的区别：

- `reset` 是直接移动分支指针，历史会被改写
- `revert` 是新增一条提交，历史保持完整

适用建议：

- 已经推送到远程，团队成员可能已经拉取：优先用 `revert`
- 只是本地试验分支，还没共享给别人：可以用 `reset`

示例：

```bash
git revert 1a2b3c4d
```

如果要撤销一段连续提交，常见做法是逐个 `revert`，或者先找出范围后再处理。对于复杂情况，先用 `git log --oneline --graph` 看清历史再操作。

### 8.4 `git clean`

删除未跟踪文件。

```bash
git clean
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-n` / `--dry-run` | 预览将删除哪些文件 |
| `-f` | 强制删除 |
| `-d` | 删除目录 |
| `-x` | 也删除被忽略的文件 |
示例：

```bash
git clean -n
```

```bash
git clean -fd
```

### 8.5 切到某个指定版本

如果你说的“切到某个版本”是指查看或运行某个历史状态，通常是切到某个分支、标签或提交。

#### 8.5.1 切到分支

```bash
git switch <分支>
```

示例：

```bash
git switch main
```

这会让当前工作区变成该分支最新提交对应的代码。

#### 8.5.2 切到标签版本

标签通常表示发布版本，例如 `v1.0.0`、`v2.3.1`。

```bash
git switch --detach <tag>
```

示例：

```bash
git switch --detach v1.0.0
```

说明：

- 这会进入 detached HEAD 状态
- 你可以查看、构建、测试这个版本
- 但如果直接在这里提交，提交不会自动挂到某个分支上

如果你想基于这个版本继续开发，先新建分支：

```bash
git switch -c fix-from-v1.0.0
```

#### 8.5.3 切到某个提交

如果你想精确回到某次提交，直接检出提交即可。

```bash
git switch --detach <commit-id>
```

示例：

```bash
git switch --detach 1a2b3c4d
```

这通常用于：

- 排查历史版本是否有 bug
- 比较不同提交之间的行为差异
- 临时构建某个历史状态

#### 8.5.4 用 checkout 切版本

`git checkout` 也能做到同样的事，老项目里很常见：

```bash
git checkout <分支>
git checkout <tag>
git checkout <commit-id>
```

示例：

```bash
git checkout v1.0.0
```

```bash
git checkout 1a2b3c4d
```

但要注意：切到提交或标签时，通常也是 detached HEAD。

#### 8.5.5 从历史版本创建新分支

这是最实用的方式之一：先切到老版本，再从那里拉出一条新分支。

```bash
git switch -c <新分支名> <commit-id>
```

示例：

```bash
git switch -c hotfix/old-version 1a2b3c4d
```

等价思路是：

```bash
git switch --detach 1a2b3c4d
git switch -c hotfix/old-version
```

#### 8.5.6 常见场景对照

| 需求 | 推荐命令 | 说明 |
|---|---|---|
| 看某个发布版本 | `git switch --detach v1.0.0` | 进入该版本状态 |
| 看某个历史提交 | `git switch --detach <commit-id>` | 进入指定提交 |
| 基于历史版本开发 | `git switch -c <new-branch> <commit-id>` | 最安全 |
| 临时查看旧代码 | `git checkout <commit/tag>` | 老命令也可用 |
| 想回退本地提交历史 | `git reset --soft/mixed/hard` | 改写历史 |
| 想撤销已推送提交 | `git revert <commit>` | 不改历史 |

#### 8.5.7 如何回到最新开发分支

如果你在 detached HEAD 或旧版本上查看完了，回到正常开发分支即可：

```bash
git switch main
```

或者：

```bash
git switch <你的工作分支>
```

## 9. 暂存工作

### 9.1 `git stash`

临时保存当前工作区和暂存区的改动。

```bash
git stash
```

常用参数：

| 参数 | 含义 |
|---|---|
| `push` | 保存改动 |
| `list` | 查看所有 stash |
| `show` | 查看某个 stash 内容概要 |
| `pop` | 恢复并删除最近的 stash |
| `apply` | 只恢复，不删除 stash |
| `drop` | 删除指定 stash |
| `clear` | 清空所有 stash |
| `-u` / `--include-untracked` | 同时保存未跟踪文件 |
| `-a` / `--all` | 保存包括忽略文件在内的所有内容 |

示例：

```bash
git stash push -m "wip: login page"
```

```bash
git stash list
```

```bash
git stash pop
```

```bash
git stash apply stash@{0}
```

## 10. 远程仓库

### 10.1 `git remote`

管理远程仓库别名。

```bash
git remote
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-v` | 显示远程地址 |
| `add` | 添加远程仓库 |
| `remove` | 删除远程仓库 |
| `rename` | 重命名远程仓库 |
| `set-url` | 修改远程地址 |
示例：

```bash
git remote -v
```

```bash
git remote add origin https://github.com/user/repo.git
```

```bash
git remote set-url origin git@github.com:user/repo.git
```

### 10.2 `git fetch`

从远程仓库拉取更新到本地，但不自动合并。

```bash
git fetch
```

常用参数：

| 参数 | 含义 |
|---|---|
| `--all` | 获取所有远程仓库 |
| `--prune` | 删除远程已不存在的本地跟踪分支 |
| `-p` | 同 `--prune` |
| `--tags` | 获取标签 |
示例：

```bash
git fetch origin
```

```bash
git fetch --all --prune
```

### 10.3 `git pull`

从远程获取并合并到当前分支，相当于 `fetch` + `merge`，或 `fetch` + `rebase`。

```bash
git pull
```

常用参数：

| 参数 | 含义 |
|---|---|
| `--rebase` | 拉取后执行 rebase |
| `--ff-only` | 只允许快进更新 |
| `--no-rebase` | 明确使用 merge |
示例：

```bash
git pull origin main
```

```bash
git pull --rebase origin main
```

### 10.4 `git push`

把本地提交推送到远程仓库。

```bash
git push <远程名> <本地分支>:<远程分支>
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-u` / `--set-upstream` | 建立上游跟踪关系 |
| `--force` / `-f` | 强制推送 |
| `--force-with-lease` | 更安全的强推 |
| `--tags` | 推送所有标签 |
| `--delete` | 删除远程分支 |
示例：

```bash
git push origin main
```

```bash
git push -u origin feature/login
```

```bash
git push --force-with-lease origin feature/login
```

```bash
git push origin --delete old-branch
```

## 11. 标签管理

### 11.1 `git tag`

管理标签，通常用于版本发布。

```bash
git tag
```

常用参数：

| 参数 | 含义 |
|---|---|
| `-a` | 创建附注标签 |
| `-m` | 指定标签说明 |
| `-d` | 删除标签 |
| `-l` | 列出标签 |
示例：

```bash
git tag v1.0.0
```

```bash
git tag -a v1.0.0 -m "release 1.0.0"
```

```bash
git push origin v1.0.0
```

```bash
git push origin --tags
```

## 12. 配置管理

### 12.1 `git config`

设置 Git 配置。

```bash
git config [作用域] <键> <值>
```

作用域：

| 作用域 | 含义 |
|---|---|
| `--local` | 当前仓库有效，默认 |
| `--global` | 当前用户所有仓库有效 |
| `--system` | 系统级别 |

常用配置：

- `user.name`
- `user.email`
- `core.editor`
- `init.defaultBranch`
- `pull.rebase`
- `merge.tool`

示例：

```bash
git config --global user.name "Your Name"
```

```bash
git config --global user.email "you@example.com"
```

```bash
git config --global init.defaultBranch main
```

查看配置：

```bash
git config --list
```

```bash
git config --global --get user.name
```

## 13. 引用、提交和对象

### 13.1 `git rev-parse`

解析引用、获取 SHA、检查仓库信息。

```bash
git rev-parse <引用>
```

示例：

```bash
git rev-parse HEAD
```

```bash
git rev-parse --abbrev-ref HEAD
```

### 13.2 `git reflog`

查看 HEAD 和分支引用的移动历史，常用于救回误操作。

```bash
git reflog
```

示例：

```bash
git reflog
```

```bash
git reset --hard HEAD@{1}
```

### 13.3 `git cat-file`

查看 Git 对象内容，属于底层命令。

```bash
git cat-file -p <对象ID>
```

### 13.4 `git hash-object`

计算对象哈希，属于底层命令。

```bash
git hash-object <文件>
```

## 14. 工作树管理

### 14.1 `git worktree`

在同一个仓库下创建多个独立工作目录。

```bash
git worktree add <路径> <分支>
```

示例：

```bash
git worktree add ../repo-hotfix hotfix/1.0
```

常用命令：

- `git worktree list`
- `git worktree remove <路径>`
- `git worktree prune`

## 15. 子模块

### 15.1 `git submodule`

管理嵌套仓库。

常见命令：

```bash
git submodule add <仓库地址> <路径>
```

```bash
git submodule update --init --recursive
```

```bash
git submodule status
```

参数说明：

- `--init`：初始化子模块
- `--recursive`：递归处理子模块
- `--remote`：从子模块远程更新

## 16. 高级与调试命令

### 16.1 `git bisect`

二分定位引入 bug 的提交。

```bash
git bisect start

git bisect bad

git bisect good <提交ID>
```

示例：

```bash
git bisect start

git bisect bad

git bisect good v1.2.0
```

### 16.2 `git archive`

导出某个版本的源代码压缩包。

```bash
git archive -o source.zip HEAD
```

### 16.3 `git describe`

用最近的标签描述当前提交。

```bash
git describe --tags
```

## 17. 底层命令概览

这些命令较少在日常中直接使用，但理解后更容易掌握 Git 原理。

| 命令 | 作用 |
|---|---|
| `git add` | 把内容写入索引 |
| `git rm` | 从索引和工作区删除 |
| `git mv` | 移动/重命名文件 |
| `git commit-tree` | 直接创建提交对象 |
| `git read-tree` | 读取树对象到索引 |
| `git write-tree` | 将索引写成树对象 |
| `git ls-tree` | 列出树对象内容 |
| `git diff-tree` | 比较树对象差异 |
| `git update-index` | 直接操作索引 |
| `git show-ref` | 查看引用 |
| `git for-each-ref` | 遍历引用并格式化输出 |

示例：

```bash
git ls-tree HEAD
```

```bash
git show-ref
```

## 18. 常见开发流程

### 18.1 新功能开发

```bash
git switch main

git pull

git switch -c feature/login
# 编辑文件

git add .

git commit -m "feat: add login feature"

git push -u origin feature/login
```

### 18.2 修复提交信息

```bash
git commit --amend -m "fix: correct validation"
```

### 18.3 撤销最近一次提交但保留代码

```bash
git reset --soft HEAD~1
```

### 18.4 丢弃本地修改

```bash
git restore <文件>
```

### 18.5 临时保存工作现场

```bash
git stash push -m "wip"
git switch main
git stash pop
```

## 19. 参数速查

### 19.1 常见短参数

| 短参数 | 长参数 | 含义 |
|---|---|---|
| `-m` | `--message` | 指定信息 |
| `-a` | `--all` / `--amend` / `--include-untracked` | 需结合命令判断具体含义 |
| `-b` | `--branch` | 分支相关 |
| `-d` | `--delete` | 删除 |
| `-f` | `--force` | 强制 |
| `-n` | `--dry-run` / 数量参数 | 预览或数量 |
| `-p` | `--patch` | 补丁/交互式操作 |
| `-v` | `--verbose` | 详细输出 |
| `-q` | `--quiet` | 静默输出 |
| `-r` | `--recursive` / `--remotes` | 递归或远程相关 |
### 19.2 高频操作含义

| 操作 | 含义 |
|---|---|
| `HEAD` | 当前指针，一般指向当前分支最新提交 |
| `HEAD~1` | 当前提交的上一个提交 |
| `HEAD^` | 父提交，合并提交时可指定第几个父提交 |
| `origin/main` | 远程跟踪分支 |
| `stash@{0}` | 最近一次暂存记录 |

## 20. 常见问题与注意事项

- `git reset --hard` 会丢失未提交改动，执行前先确认。
- `git push -f` 可能覆盖远程历史，优先用 `--force-with-lease`。
- 已经推送到公共远程的提交，通常优先用 `git revert`，少直接用 `reset` 改历史。
- `git checkout` 是历史上很常见的多功能命令，但新项目里建议分工更清晰：
  - `git switch` 负责切分支
  - `git restore` 负责恢复文件
- 处理冲突时，先看 `git status`，再逐个文件解决后 `git add`，最后继续 `merge` 或 `rebase`。

## 21. 最小速查表

| 场景 | 命令 |
|---|---|
| 初始化仓库 | `git init` |
| 克隆仓库 | `git clone <url>` |
| 看状态 | `git status` |
| 看历史 | `git log --oneline --graph --decorate --all` |
| 看差异 | `git diff` |
| 暂存修改 | `git add .` |
| 提交代码 | `git commit -m "msg"` |
| 切分支 | `git switch -c <branch>` |
| 合并分支 | `git merge <branch>` |
| 拉取远程 | `git pull --rebase` |
| 推送远程 | `git push -u origin <branch>` |
| 临时保存 | `git stash push -m "wip"` |
| 回退一次提交 | `git revert <commit>` |
| 查看配置 | `git config --list` |

## 22. 结语

Git 的核心可以概括为三件事：

1. 识别改动：`status`、`diff`、`log`
2. 管理版本：`add`、`commit`、`branch`、`merge`、`rebase`
3. 协作同步：`fetch`、`pull`、`push`

如果你需要，我还可以继续把这份文档扩展成“更偏实战”的版本，例如：

- Git 分支模型最佳实践
- Git 冲突解决案例集
- Git 常见命令图解
- Git 与 GitHub 协作流程
