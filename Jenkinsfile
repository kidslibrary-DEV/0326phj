#!groovy
def defaultUnityAppVersion = "2018.3.6f1"
def defaultUnityCICDScriptsVersion = "heads/master"

def buildAssetBundlesExecutesMethod = "CICD.AssetBundlesBuilder.CommandLineBuild"
def PackageBuilderExecutesMethod = "CICD.PackageBuilder.CommandLineBuild"
def BookConfigApiUpdaterExecutesMethod = "CICD.BookConfigApiUpdater.CommandLineBuild"

properties([
        parameters([
                booleanParam(name: 'build_ios', defaultValue: true, description: "Build iOS platform"),
                booleanParam(name: 'build_android', defaultValue: true, description: "Build Android platform"),
                string(name: 'build_only_books', defaultValue: '', description: "List of book id ',' separated to build. Empty value build all books"),
                string(name: 'unity_app_version', defaultValue: defaultUnityAppVersion, description: "Unity App Version"),
                string(name: 'unity_ci_and_cd_scripts_version', defaultValue: defaultUnityCICDScriptsVersion, description: "Unity CI&CD Scripts version, tag from \"https://github.com/InceptionXR/Unity-CI-CD-Scripts\" repository"),
        ])
])

def UnityAppVersion
def UnityApp
def platformsToBuild = []
def UnityCICDScriptsVersion
def books = []

stage('initialize(master)') {
    if (params.build_ios) {
        platformsToBuild.push("iOS")
    }
    if (params.build_android) {
        platformsToBuild.push("Android")
    }
    UnityCICDScriptsVersion = params.unity_ci_and_cd_scripts_version
    UnityAppVersion = params.unity_app_version
}

node(label: 'book') {
    for (platform in platformsToBuild) {
        ws("custom_workspace/${JOB_NAME}-${platform}") {
            stage('checkout scm') {
                def projectCredentialsId = scm.userRemoteConfigs[0].credentialsId
                checkout([
                        $class                           : 'GitSCM',
                        branches                         : scm.branches,
                        doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
                        extensions                       :
                                [[
                                         $class             : 'SubmoduleOption',
                                         disableSubmodules  : false,
                                         parentCredentials  : true,
                                         recursiveSubmodules: true,
                                         reference          : '',
                                         trackingSubmodules : false,
                                         timeout            : 20
                                 ]] +
                                        [[$class: 'CloneOption', depth: 1, noTags: false, reference: '', shallow: true, timeout: 30]],
                        submoduleCfg                     : [],
                        userRemoteConfigs                : scm.userRemoteConfigs
                ])

                checkout([$class                           : 'GitSCM',
                          branches                         : [[name: "refs/${UnityCICDScriptsVersion}"]],
                          doGenerateSubmoduleConfigurations: false,
                          extensions                       : [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'Assets/Plugins/Unity-CI-CD-Scripts']],
                          submoduleCfg                     : [],
                          userRemoteConfigs                : [[credentialsId: projectCredentialsId, url: 'https://github.com/InceptionXR/Unity-CI-CD-Scripts.git']]
                ])
            }

            stage('clean workspace') {
                dir("Build") {
                    deleteDir()
                }
                dir("AssetBundles") {
                    deleteDir()
                }
                executeCommand("git clean -df")
            }

            stage('initialize(node)') {
                def WinUnityApp = "\"C://Program Files//Unity//Hub//Editor//${UnityAppVersion}//Editor//Unity.exe\""
                def UnixUnityApp = "/Applications/Unity/Hub/Editor/${UnityAppVersion}/Unity.app/Contents/MacOS/Unity"
                UnityApp = isUnix() ? UnixUnityApp : WinUnityApp

                def buildOnlyBooks = (params.build_only_books.length() > 0 ? params.build_only_books.split(",") : []) as String[]
                def bookConfig
                def bookConfigDescription = "Please check is `book.config` file existing and configured properly " +
                        "(there are one of few rows with book id)." +
                        "\nINFO: actual books configuration - https://admin.bookful.inceptionxr.com/books\n\n"
                try {
                    bookConfig = readFile "book.config"
                } catch (Exception e) {
                    error("Issue with reading `book.config`: ${e.getMessage()}\n${bookConfigDescription}")
                }
                def bookIds = bookConfig.split("\n")
                if (bookIds.length == 1) {
                    def bookId = bookIds[0].replace('\r', '')
                    books.push([id: bookId, BSUAssetsRootFolderPath: 'Assets/BSU'])
                } else {
                    for (int i = 0; i < bookIds.length; i++) {
                        def bookId = bookIds[i].replace('\r', '')
                        if (buildOnlyBooks.length == 0 || buildOnlyBooks.contains(bookId)) {
                            books.push([id: bookId, BSUAssetsRootFolderPath: "Assets/BSU/Book_${i + 1}"])
                        }
                    }
                }
                if (bookIds.any { it.length() == 0 }) {
                    error("Looks `book.config` weren't configured properly.\n${bookConfigDescription}")
                }
            }

            def buildId = "${BUILD_NUMBER}_${new Date().getTime()}"
            for (book in books) {
                def bookId = book.id
                def BSUAssetsRootFolderPath = book.BSUAssetsRootFolderPath

                def gsRelativePath = "bookful/book/${bookId}/${buildId}"
                def httpRelativePath = "https://storage.googleapis.com/${gsRelativePath}/${platform}/"
                string outputPath = "${WORKSPACE}/AssetBundles/${platform}"
                string logFileAbsolutePath = "${WORKSPACE}/Logs/${platform}.log"

                try {
                    stage("\"${platform}\":\"${bookId}\" building asset bundles") {
                        //TODO: remove it after fix `bookplayer`
                        dir("Assets/Plugins/bookplayer") {
                            deleteDir()
                        }
                        string command = "${UnityApp} -quit -batchmode -logFile ${logFileAbsolutePath} -projectPath ${WORKSPACE} -buildTarget ${platform}"
                        command += " -executeMethod ${buildAssetBundlesExecutesMethod} -outputPath=${outputPath}"
                        command += " -httpRelativePath=${httpRelativePath}"
                        command += " -BSUAssetsRootFolderPath=${BSUAssetsRootFolderPath}"
                        executeCommand(command)
                    }
                    stage("\"${platform}\":\"${bookId}\" building package") {
                        string command = "${UnityApp} -quit -batchmode -logFile ${logFileAbsolutePath} -projectPath ${WORKSPACE} -buildTarget ${platform}"
                        command += " -executeMethod ${PackageBuilderExecutesMethod}"
                        command += " -httpRelativePath=${httpRelativePath}"
                        command += " -BSUAssetsRootFolderPath=${BSUAssetsRootFolderPath}"
                        executeCommand(command)
                    }
                    stage("\"${platform}\":\"${bookId}\" uploading package") {
                        def pathPrefix = isUnix() ? "Build" : "${WORKSPACE}/Build/".substring(1)
                        googleStorageUpload bucket: "gs://${gsRelativePath}", credentialsId: 'bookful', pattern: "Build/${platform}/**/*", pathPrefix: "${pathPrefix}"
                    }
                    stage("\"${platform}\":\"${bookId}\" updating Book API service") {
                        withCredentials([string(credentialsId: 'BookfulApiServiceAccessToken', variable: 'BookfulApiServiceAccessToken')]) {
                            string command = "${UnityApp} -quit -batchmode -logFile ${logFileAbsolutePath} -projectPath ${WORKSPACE} -buildTarget ${platform}"
                            command += " -executeMethod ${BookConfigApiUpdaterExecutesMethod}"
                            command += " -bookId=${bookId}"
                            command += " -httpRelativePath=${httpRelativePath}"
                            command += " -BookfulApiServiceAccessToken=${BookfulApiServiceAccessToken}"
                            command += " -BSUAssetsRootFolderPath=${BSUAssetsRootFolderPath}"
                            executeCommand(command)
                        }
                    }
                } catch (Exception e) {
                    info("Exception: ${e.getMessage()}" + "\n${e.getStackTrace().join("\n")}")
                    catFile(logFileAbsolutePath)
                    throw e
                }
            }
        }
    }
}

def catFile(def path) {
    if (isUnix()) {
        executeCommand("cat ${path}")
    } else {
        def winPath = path.replace("/", "\\")
        executeCommand("type \"${winPath}\" 2>nul")
    }
}

@NonCPS
def executeCommand(String command) {
    info("command: ${command}")
    if (isUnix()) {
        sh command
    } else {
        bat command
    }
}

@NonCPS
def info(String message) {
    echo message
}