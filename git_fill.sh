#!/bin/bash
# example
# ./git_fill.sh $(date -d "1 year ago" +%Y-%m-%d)
repository_folder="commits/"
filename="file.txt"
file=$repository_folder$filename
text="Lorem ipsum"
current_date=$(date -d "${1:-1 day ago}" +%Y-%m-%d)
today=$(date +%Y-%m-%d)

if [ ! -d $repository_folder ]; then
  mkdir $repository_folder
  git -C $repository_folder init
  echo "Creating folder"
fi

while [[ "$current_date" < "$today" || "$current_date" == "$today"  ]]; do
  # weekday=$(date -d "$current_date" +%u)
  # if [[ "$weekday" -eq 6 || "$weekday" -eq 7  ]]; then
  if (( $RANDOM % 7 != 1)); then

    number_of_commits=$((RANDOM % 10 + 1))
    for ((commit = 1; commit <= $number_of_commits; commit++)); do

      if [[ ! -f $file ]]; then
        echo $text > $file
        git -C $repository_folder add $filename
      else
        rm $file
        git -C $repository_folder add $filename
      fi

      commit_time="${current_date}T12:$(printf "%02d" "$commit"):00"
      GIT_AUTHOR_DATE="$commit_time" \
        GIT_COMMITTER_DATE="$commit_time" \
        git -C $repository_folder commit -m "$commit commit for $current_date"
      done
  fi

  current_date=$(date -I -d "$current_date + 1 day")
done
git -C $repository_folder push
