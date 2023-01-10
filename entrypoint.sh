#!/bin/sh -l

git_setup() {
  cat <<- EOF > $HOME/.netrc
		machine github.com
		login $GITHUB_ACTOR
		password $GITHUB_TOKEN
		machine api.github.com
		login $GITHUB_ACTOR
		password $GITHUB_TOKEN
EOF
  chmod 600 $HOME/.netrc

  git config --global user.email "$GITBOT_EMAIL"
  git config --global user.name "$GITHUB_ACTOR"
  git config --global --add safe.directory /github/workspace
}

git_setup

git_cmd() {
  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    echo $@
  else
    eval $@
  fi
}

PR_BRANCH="$GITHUB_ACTOR/auto-$INPUT_PR_BRANCH-$GITHUB_SHA"
MESSAGE=$(git log -1 $GITHUB_SHA | grep "AUTO" | wc -l)

if [[ $MESSAGE -gt 0 ]]; then
  echo "Autocommit, NO ACTION"
  exit 0
fi

# PR_TITLE=$(git log -1 --format="%s" $GITHUB_SHA)
GIT_CHANGED_BRANCH=$(git name-rev $GITHUB_SHA | cut -d' ' -f 2)
GIT_CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA --)

git_cmd git remote update
git_cmd git fetch --all
git_cmd git checkout "${INPUT_PR_BRANCH}"
git_cmd git checkout -b "${PR_BRANCH}" origin/"${INPUT_PR_BRANCH}"
git_cmd git cherry-pick "${GITHUB_SHA}"
# echo $GIT_CHANGED_BRANCH
# echo $GIT_CHANGED_FILES
# git_cmd git checkout origin/"${GIT_CHANGED_BRANCH}" ${GIT_CHANGED_FILES}
# git_cmd git merge $GIT_CHANGED_BRANCH --allow-unrelated-histories
git_cmd git add -u
git_cmd git commit -am "Updated files" --allow-empty
git_cmd git push -u origin "${PR_BRANCH}"
git_cmd hub pull-request -b "${INPUT_PR_BRANCH}" -h "${PR_BRANCH}" -l "${INPUT_PR_LABELS}" -a "${GITHUB_ACTOR}" -m "AUTO PR FOR: \"${GIT_CHANGED_BRANCH}\""