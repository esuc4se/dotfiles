#!/bin/sh

# 実行場所のディレクトリを取得
THIS_DIR=$(cd $(dirname $0); pwd)

for f in .??*; do
    # skip
    [ "$f" = ".git" ] && continue
    [ "$f" = ".gitconfig" ] && continue
    [ "$f" = ".gitignore" ] && continue

    # create symbolik link
    ln -snfv $THIS_DIR/"$f" ~/
done

