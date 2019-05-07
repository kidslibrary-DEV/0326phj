# Book-Template


### How to setup a new book based on template

#### Download
* Click on the download button and download the project to local folder
* Unzip and rename the folder to the new project name

#### Git setup
> Requires that a new repository will be already created!
* Enter project and run the following scripts:
```bash
git init
```
* Run the following script after replacing `{repo link}` with the git repository
```bash
git remote add origin {repo link}
```

#### Add submodules

* Enter Assets/Plugins folder by running the script or using the exploper/finder
```bash
cd Assets/Plugins
```
* Add submodules by running the following scripts
```bash
git submodule add https://github.com/InceptionXR/UITools.git
git submodule add https://github.com/InceptionXR/GameKit.git
git submodule add https://github.com/InceptionXR/BookPlayer.git
git submodule add https://github.com/InceptionXR/IARCore.git
```
### Get back to root folder
Run the following scripts:
```bash
cd ...
```

### Delete template files
Run the following scripts:
```bash
rm README.md
```

#### Push to remote
Run the following scripts:
```bash
git add .
git commit -m "Initial project setup"
git push origin master
```

##### All Set! 🎉

#### Tell Jenkins to Build the book
* In the Root Folder (e.g. Book-BlahBlah, remove the underscore from _Jenkinsfile (make it: Jenkinsfile)
* Open book.config with notepad/textedit (not worpad), add the book ID of the book as it appears in Gandalf (e.g. "-ySA3o3Rj").

#### Push to remote
Run the following scripts:
```bash
git add .
git commit -m "Jenkins Please Build my Book"
git push origin master
```

