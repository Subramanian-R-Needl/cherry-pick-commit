# **Cherry-Pick Github Action**
Github Action to Cherry Pick commits from a branch (generally, master) and create a PR on another branch (Release branch).

Most of the projects have Release branches and master branch. Master branch is where developers works on but we want to push the changes to the Release branches too.

## **Action**
Push to the monitored branch X
Get the last commit SHA
Checkout the other branch, Y
Create a new pr branch Z on the branch Y
Cherry Pick the commits from X into Z
Push the branch and create the PR on base Y
PR title will be prefixed with AUTO

## **Conditions:**
If base branch commit contains AUTO, it wont recreate the PR.

## **Inputs**
### pr_branch
Required The branch name of on which PR should be created from the cherry-pick commit.

### pr_labels
CSV Labels to apply on the PR created. Default: autocreated

## **Example usage**
In this example, all the merges to the branch prod/stage will create a PR on master branch too.

```markdown
name: PR for release branch
on:
  push:
    branches:
      - prod
      - stage
jobs:
  release_pull_request:
    runs-on: ubuntu-latest
    name: release_pull_request
    steps:
    - name: checkout
      uses: actions/checkout@v3
    - name: Create PR to branch
      uses: Subramanian-R-Needl/cherry-pick-commit@main
      with:
        pr_branch: 'master'
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        GITBOT_EMAIL: <BOT_EMAIL>
        DRY_RUN: false
```