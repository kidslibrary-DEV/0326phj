# Book-Template


### How to setup a new book based on template

#### Download
* Click on the download button and download the project to local folder
* Unzip and rename the folder to the new project name

#### Git setup
!! requires that a new repository will be already created !!
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

### Delete template files
Run the following scripts:
```bash
del README.md
```

#### Push to remote
Run the following scripts:
```bash
git commit -am "Initial project setup"
git push origin master
```

##### All Set! 🎉
