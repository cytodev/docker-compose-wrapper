# dockerw — a docker-compose Wrapper
A "simple" drop-in container wrapper that requires all of your configuration

## index
- [Notice](#Notice)
- [Prerequisites](#Prerequisites)
- [How to get started](#How-to-get-started)
    - [Standalone (preferred)](#Standalone-(preferred))
        - [How does git work again?](#How-does-git-work-again?)
        - [Why UNIX only?](#Why-UNIX-only?)
    - [In-project or local](#in-project-or-local)
- [Contributions](#Contributions)

## Notice
This repository requires **a lot** of configuration on your part. This is to be expected, seeing how docker also requires lots of configuration and I didn't want to limit my efforts to a single project. I would advise against using this repository when you're trying to set up a single local docker environment (see [lando](https://lando.dev/) or [devilbox](http://devilbox.org/)). However, when you're like me and manage lots of projects this might just be the tool you need.

## Prerequisites
Install docker via [the official docs](https://docs.docker.com/install/)  
Install docker-compose [as a python package](https://pypi.org/project/docker-compose/)  

## How to get started
### Standalone (preferred)
Get yourself a UNIX system that runs a semi up-to-date version of bash as of writing this (2020) and clone the repository
```bash
$ git clone git@github.com:cytodev/docker-compose-wrapper.git
```

`cd` into the directory and install the scripts

> elevated permissions might be required for the next few steps

```bash
$ cd docker-compose-wrapper
$ make install
$ cd ../
$ rm -rf docker-compose-wrapper
```

Now you're free to use the `dockerw` command just like you're used to using the `git` command.

##### How does git work again?
Simple, type `git init` to start your project -- this translates to `dockerw init` to start a local container cluster. This setup does require some manual actions inside the `.dockerw` directory though (see the [example branch](https://github.com/CytoDev/docker-compose-wrapper/tree/example)).

##### Why UNIX only?
Because of the directory structure and installation process. I haven't used any other OS on a serious level since ever, so I will leave integration to the contributors -- they will know what to do.

### in-project or local
Probably preferred on NT (MS Windows) machines or restricted UNIX systems

```bash
$ cd <your_development_directory>
$ git clone git@github.com:cytodev/docker-compose-wrapper.git .dockerw
$ cd .dockerw
$ git remote rm origin
$ cd ../
$ ln -s ./.dockerw/dockerw
```

Please note that you can only use the `dockerw` command _in this directory_ and only by specifying that you want to execute this command via the `./<file>`. (mileage
 may vary on NT)

See the [example branch](https://github.com/CytoDev/docker-compose-wrapper/tree/example) to get a general idea on how to set this repository up in your use-case.

## Contributions
You are more than welcome to submit issues as well as feature requests or just a 'how-ya-doin' in the [issue tracker](https://github.com/CytoDev/python-sdwc/issues/new). Contributing to the project can be done by forking it and submitting a pull request once it's all tested and tidy.
