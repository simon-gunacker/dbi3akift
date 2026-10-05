Find out URL of old Fork (important, not original repo): 
```
git remote -v
``` 

Check if you're on the right branch: 
```
git branch
```

Add the old Fork as a remote: 
```
git remote add old git@github.com:<old-remote-url>
```

Fetch old files into new repo:
```
git fetch old
```

Check to see both histories at once: 
```
git log --graph --online --decorate --all 
```

Check if everything is clean: 
```
git status
```

Merge both repos, but do not commit yet so you can clean up files: 
```
git merge old/main --allow-unrelated-histories --no-commit
```

After clean up repo, for example move files from old repo into the new correct folder, delete duplicate files that can lead to conflicts, ...
Check the status again, to see if all files are tracked and in the correct place. If that is the case, stage everything: 
```
git add -A
```

If everything seems right you can commit: 
```
git commit -m "your commit message"
```

And then push, the -u is used to connect the local branch with the online one: 
```
git push -u origin LocalBranch
```

To clean up you can then remove the refernce to the old repo:
```
git remote remove old
```
