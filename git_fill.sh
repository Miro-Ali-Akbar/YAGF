#!/bin/bash
# example
# ./git_fill.sh $(date -d "1 year ago" +%Y-%m-%d)
repository_folder="$(pwd)/commits11/"
filename="script.sh"
text="for ((index = 0; index < ($RANDOM % 103); index++)); do
echo "\$index"
done
"
issue_title="Issues"
branch_name="Pull_request"
if [ -n "$1" ]; then
  current_date=$(date -d "$1" +%Y-%m-%d)
else
  last_commit="$(git -C "$repository_folder" log --pretty=format:%ci -n 1)"
  current_date=$(date -d "$last_commit" +%Y-%m-%d)
fi
today="$(date +%Y-%m-%d)"

if [[ -n $(git remote -v) ]];then
  is_remote_repo=0
else
  is_remote_repo=1
fi


file_changer() {
  if [[ ! -f "$filename" ]]; then
    echo "$text" > "$filename"
  else
    rm "$filename"
  fi
  git add "$filename"
}

commiter() {
  commit_time="${current_date}T12:00:00"
  GIT_AUTHOR_DATE="$commit_time" \
    GIT_COMMITTER_DATE="$commit_time" \
    git commit -m "Commit for $current_date"
  }

regex() {
    # Usage: regex "string" "regex"
    [[ $1 =~ $2 ]] 
    return "${BASH_REMATCH[1]}"
}

if [ ! -d "$repository_folder" ]; then
  mkdir "$repository_folder"
  git -C "$repository_folder" init
  echo "Creating folder"
fi

if [ $is_remote_repo -eq 0 ]; then 
  git -C "$repository_folder" pull
fi

if [[ "$current_date" == "$today" ]]; then
  echo "Already run today"
  # exit 0
fi

cd $repository_folder
while [[ "$current_date" < "$today" || "$current_date" == "$today"  ]]; do

  if [[ "$current_date" == "$today" && $is_remote_repo -eq 0 ]]; then

    file_changer

    # TODO: this errors now for some reason
    issue_id_1="$(regex "$(gh issue create --title "$issue_title 1" --body "1 comment for $current_date")" '([0-9])+$')"
    issue_id_2="$(regex "$(gh issue create --title "$issue_title 2" --body "2 comment for $current_date")" '([0-9])+$')"
    gh issue close "$issue_id_1"
    gh issue close "$issue_id_2"

    git checkout -b "$branch_name"
    commiter
    git push

    pr_id="$(regex "$(gh pr create --title $current_date --body "Pull request for $current_date")" '([0-9])+$')"
    gh pr review --comment --body "comment 1 for pr"
    gh pr review --comment --body "comment 2 for pr"
    gh pr review --comment --body "comment 3 for pr"
    # doesnt allow yourself to approve TODO:
    # gh pr review --approve
    gh pr merge -dm "$pr_id"
    echo "DONE!"
    exit 0
  fi

  # TODO: weekday hack
  # weekday=$(date -d "$current_date" +%u)
  # if [[ "$weekday" -eq 6 || "$weekday" -eq 7  ]]; then
  if (( $RANDOM % 7 != 1)); then

    number_of_commits=$((RANDOM % 10 + 1))
    for ((commit = 1; commit <= $number_of_commits; commit++)); do

      file_changer
      commiter

    done
  fi

  current_date=$(date -I -d "$current_date + 1 day")
done

if [[ $is_remote_repo -eq 0 ]]; then
  git push
fi
