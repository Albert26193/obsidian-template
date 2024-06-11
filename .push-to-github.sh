export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"
export all_proxy="socks5://127.0.0.1:7890"

myDate=$(date "+%Y-%m-%d  %T")

echo "git start..."
git add -A
git commit -m "updated: $myDate"
git pull --rebase -X ours
git push
