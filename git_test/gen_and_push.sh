#!/bin/bash
# 随机创建/删除文件，持续 push，产出大量 git 提交记录

cd /b/github/Test

TARGET_FILES=120    # 最终保留的文件数
BATCH_ROUNDS=50     # 执行轮数（每轮产生多次 commit+push）

for round in $(seq 1 $BATCH_ROUNDS); do
    echo "===== Round $round / $BATCH_ROUNDS ====="

    # --- 随机创建 3~8 个文件 ---
    create_count=$((RANDOM % 6 + 3))
    for i in $(seq 1 $create_count); do
        fname="git_test/file_r${round}_${i}_$(date +%s%N | cut -c1-13).txt"
        # 随机内容大小 1~5KB
        head -c $((RANDOM % 4096 + 1024)) /dev/urandom | base64 > "$fname"
    done
    git add git_test/
    git commit -m "round${round}: create ${create_count} random files"
    git push origin master
    echo "[push] created $create_count files"

    # --- 随机删除 1~4 个文件（但保证剩余 >= TARGET_FILES） ---
    current_count=$(ls git_test/*.txt 2>/dev/null | wc -l)
    if [ "$current_count" -gt "$TARGET_FILES" ]; then
        delete_count=$((RANDOM % 4 + 1))
        files_to_delete=$(ls git_test/*.txt 2>/dev/null | shuf | head -n $delete_count)
        for f in $files_to_delete; do
            git rm "$f"
        done
        git commit -m "round${round}: delete ${delete_count} random files"
        git push origin master
        echo "[push] deleted $delete_count files"
    fi

    # --- 随机修改已有文件 ---
    modify_count=$((RANDOM % 3 + 1))
    for i in $(seq 1 $modify_count); do
        target=$(ls git_test/*.txt 2>/dev/null | shuf | head -1)
        if [ -n "$target" ]; then
            echo "--- modified at $(date) round=$round ---" >> "$target"
        fi
    done
    git add git_test/
    git diff --cached --quiet || {
        git commit -m "round${round}: modify ${modify_count} files"
        git push origin master
        echo "[push] modified $modify_count files"
    }
done

# --- 最终补充文件到 >= 100 ---
current_count=$(ls git_test/*.txt 2>/dev/null | wc -l)
if [ "$current_count" -lt 100 ]; then
    need=$((100 - current_count))
    for i in $(seq 1 $need); do
        fname="git_test/final_${i}_$(date +%s%N | cut -c1-13).txt"
        head -c $((RANDOM % 4096 + 1024)) /dev/urandom | base64 > "$fname"
    done
    git add git_test/
    git commit -m "final: add ${need} files to reach 100+"
    git push origin master
fi

echo ""
echo "===== DONE ====="
final=$(ls git_test/*.txt 2>/dev/null | wc -l)
echo "Total files in git_test/: $final"
git log --oneline | head -20
