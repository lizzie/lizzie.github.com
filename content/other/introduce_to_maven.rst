Introduce to Maven
===================

:date: 2010-04-05 05:04:09
:tags: Tools


http://maven.apache.org/


what is
-------------------

* simplify the build processes in the jakarta turbine project.
* a standard way to build the projects, a clear definition of what the project consisted of, an easy way to publish project information and a way to share JARs across serveral projects.
* building and managing any Java-based project. make the day-to-day work of Java developers easier and generally help with the comprehension of any java-based project.
* Making the build process easy
* Providing a uniform build system
* Providing quality project information
* Providing guidelines for best practices development
* Allowing transparent migration to new features


in 5 Minutes
-------------------

* mvn --version # 版本
* mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

    # com.mycompany.app 对应my-app下的src/java或者src/test目录下. pom.xml为工程对象模型, 作为工程的配置信息, 包含构建一个工程所需的信息;
    执行这条命令时, 一直出现

    [INFO] The plugin 'org.apache.maven.plugins:maven-archetype-plugin' does not exi
    st or no valid version could be found

    导致BUILD ERROR, 后来改配置文件中的mirrorOf, 默认之前设置了tb的两个镜像, 后来删除这两个, 就可以了. $user_home/.m2/repository中也有东西了.

* mvn package,,,执行一系列的命令, 这个package就是将工程打包(在target下), 还有其他的快捷命令, 如下的parse.
* mvn site # 生成工程文档, target/site


配置Maven
-------------------

1) 位置&优先级

    * 工程的配置, 即pom.xml;
    * maven安装时加入的配置文件: $M2_PATH\conf\settings.xml;
    * 用户的就是user_home下的.m2/settings.xml

2) 配置内容

    * 为本地仓库的保存地址;
    * server上用户的信息, 主要是用户名, 密码, 或者私钥地址等.
    * planetmirror Australian Mirror of http://repo1.maven.org/maven2/ http://public.planetmirror.com/maven2/ central 远程仓库镜像,,,猜测有点像ubuntu的仓库, 本机需要设置各个源, 然后每次就从这些源中下载.
    * pluginGroups增加插件位置(远程), 如果用到其他plugin, 就需要在这里增加他的位置


创建maven工程&什么是archetypes
--------------------------------------

In Maven, an archetype is a template of a project which is combined with some user input to produce a working Maven project that has been tailored to the user's requirements. 简短来讲, archetype就是工程模板.

* mvn archetype:create -DarchetypeGroupId=org.apache.maven.archetypes -DgroupId=com.mycompany.app -DartifactId=my-app
* mvn archetype:generate ...


parse
-------------------

如mvn package 后面的package就是"短语"

A phase is a step in the build lifecycle, which is an ordered sequence of phases. When a phase is given, Maven will execute every phase in the sequence up to and including the one defined.

* validate: validate the project is correct and all necessary information is available
* compile: compile the source code of the project
* test: test the compiled source code using a suitable unit testing framework. These tests should not require the code be packaged or deployed
* package: take the compiled code and package it in its distributable format, such as a JAR.
* integration-test: process and deploy the package if necessary into an environment where integration tests can be run
* verify: run any checks to verify the package is valid and meets quality criteria
* install: install the package into the local repository, for use as a dependency in other projects locally
* deploy: done in an integration or release environment, copies the final package to the remote repository for sharing with other developers and projects.
* clean: cleans up artifacts created by prior builds
* site: generates site documentation for this project

这个build lifecycle, 每条短语都对应到lifecycle的一个点, 执行这点, 之前的点也会执行;