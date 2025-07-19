#!/bin/bash
# example
# ./git_fill.sh $(date -d "1 year ago" +%Y-%m-%d)
repository_folder="commits/"
filename="file.txt"
text="Lorem ipsum"
issue_title="Issues"
branch_name="Pull_request"
current_date=$(date -d "${1:-1 day ago}" +%Y-%m-%d)
today=$(date +%Y-%m-%d)

# INIT
# push to a repo on gh

if [ ! -d $repository_folder ]; then
  mkdir $repository_folder
  git -C $repository_folder init
  echo "Creating folder"
fi

cd $repository_folder
while [[ "$current_date" < "$today" || "$current_date" == "$today"  ]]; do
  # weekday=$(date -d "$current_date" +%u)
  # if [[ "$weekday" -eq 6 || "$weekday" -eq 7  ]]; then
  if (( $RANDOM % 7 != 1)); then

    number_of_commits=$((RANDOM % 10 + 1))
    for ((commit = 1; commit <= $number_of_commits; commit++)); do

      if [[ ! -f $filename ]]; then
        echo $text > $filename
        git add $filename
      else
        rm $filename
        git add $filename
      fi

      if [[ "$current_date" == "$today" ]]; then
        issue1=$(gh issue create --title "$issue_title $commit.1" --body "$commit.1 comment for $current_date" | grep -oE "[0-9]+$")
        issue2=$(gh issue create --title "$issue_title $commit.2" --body "$commit.2 comment for $current_date" | grep -oE "[0-9]+$")
        gh issue close $issue1
        gh issue close $issue2

        git checkout -b "$branch_name"

        commit_time="${current_date}T12:$(printf "%02d" "$commit"):00"
        GIT_AUTHOR_DATE="$commit_time" \
          GIT_COMMITTER_DATE="$commit_time" \
          git commit -m "$commit commit for $current_date"
        git push

        pr1=$(gh pr create --title $current_date.$commit --body "$commit pull request for $current_date" | grep -oE "[0-9]+$")
        gh pr review --comment --body "comment 1 for pr"
        gh pr review --comment --body "comment 2 for pr"
        gh pr review --comment --body "comment 3 for pr"
        # doesnt allow yourself to approve TODO:
        # gh pr review --approve
        gh pr merge -dm $pr1

      else
        commit_time="${current_date}T12:$(printf "%02d" "$commit"):00"
        GIT_AUTHOR_DATE="$commit_time" \
          GIT_COMMITTER_DATE="$commit_time" \
          git commit -m "$commit commit for $current_date"

      fi
    done
  fi

  current_date=$(date -I -d "$current_date + 1 day")
done
git push
