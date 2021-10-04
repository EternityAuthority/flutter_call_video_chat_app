# WAYA PAY CHAT

## Git WorkFlow

### Base branch: master

### Work branch: develop

To work on a new chore/feature/bug

- checkout to master (git checkout master)
- pull from master remote (git pull origin master)
- checkout to new feature/fix/chore branch (git checkout -b feature/xxx-xxx)
- do your magic
- merge and commit changes on that branch (git add . && git commit -m "finished feature xxx")
- push branch to remote (git push origin feature/xxx-xxx)
- checkout to `develop` branch (git checkout develop)
- pull from develop remote (git pull origin develop)
- merge in new feature/fix/chore branch into `develop` (git merge feature/xxx-xxx)
- push `develop` to remote (git push origin develop)
- i'll manually compile and send the apk for now, and confirm feature works fine until we setup DevOps
- then, create pull request from `feature/xxx-xxx` to `master`

### Notes to Flutter Dev

To work on this project you will need to understand the different modules and as such here are some hints:

- Most of the code is written with providers
- All networking is done in Functions, please use model classes.
- Goodluck with the logic and services
