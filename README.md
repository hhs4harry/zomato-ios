# HSProject

### Project setup
### Rename
```sh
$ cd HSProject/
$ sh ./project-rename.sh HSProject newName
```

##### First we update the remote url to point to our new repository
```sh 
git remote set-url origin git@bitbucket.org:yourNewProject.git
```

##### Stage and commit the project rename changes

```sh
git add .
git commit -m "initial"
```

##### Now we just push the changes to master and develop
```sh
git push -u origin master
git push -u origin develop
```

### Requirements
##### SwiftLint
* Install version [0.25.1](https://github.com/realm/SwiftLint/releases/tag/0.25.1)

##### SwiftFormat
* Install version [0.33.6](https://github.com/nicklockwood/SwiftFormat/releases/tag/0.33.6).