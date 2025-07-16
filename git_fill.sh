#!/bin/bash
# example
# ./git_fill.sh $(date -d "1 year ago" +%Y-%m-%d)
repository_folder="commits/"
current_date=$(date -d "${1:-1 day ago}" +%Y-%m-%d)
today=$(date +%Y-%m-%d)

while [[ "$current_date" < "$today" || "$current_date" == "$today"  ]]; do
  # weekday=$(date -d "$current_date" +%u)
  # if [[ "$weekday" -eq 6 || "$weekday" -eq 7  ]]; then
  if (( $RANDOM % 7 != 1)); then

    number_of_commits=$((RANDOM % 10 + 1))
    for ((commit = 1; commit <= $number_of_commits; commit++)); do
      commit_time="${current_date}T12:$(printf "%02d" "$commit"):00"
      GIT_AUTHOR_DATE="$commit_time" \
        GIT_COMMITTER_DATE="$commit_time" \
        git -C $repository_folder commit --allow-empty -m "$commit commit for $current_date"
      done
  fi

  current_date=$(date -I -d "$current_date + 1 day")
done
git -C $repository_folder push
