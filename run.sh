#!/bin/bash
# -*- sh-basic-offset: 4; sh-indentation: 4 -*-
# Bootstrap an R/travis environment.

set -e
# Comment out this line for quieter output:
# Or ratherm set it for a lot noisier output
# set -x

CRAN=${CRAN:-"https://cloud.rstudio.com"}
BIOC=${BIOC:-"https://bioconductor.org/biocLite.R"}
BIOC_USE_DEVEL=${BIOC_USE_DEVEL:-"TRUE"}
OS=$(uname -s)

R_VERSION=${R_VERSION:-"3.5"}

## Possible drat repos, unset by default
DRAT_REPOS=${DRAT_REPOS:-""}

PANDOC_VERSION='1.13.1'
PANDOC_DIR="${HOME}/opt/pandoc"
PANDOC_URL="https://s3.amazonaws.com/rstudio-buildtools/pandoc-${PANDOC_VERSION}.zip"

# MacTeX installs in a new $PATH entry, and there's no way to force
# the *parent* shell to source it from here. So we just manually add
# all the entries to a location we already know to be on $PATH.
#
# TODO(craigcitro): Remove this once we can add `/usr/texbin` to the
# root path.
PATH="${PATH}:/usr/texbin"

R_BUILD_ARGS=${R_BUILD_ARGS-"--no-build-vignettes --no-manual"}
R_CHECK_ARGS=${R_CHECK_ARGS-"--no-build-vignettes --no-manual --as-cran"}
R_CHECK_INSTALL_ARGS=${R_CHECK_INSTALL_ARGS-"--install-args=--install-tests"}

R_USE_BIOC_CMDS="source('${BIOC}');"\
" tryCatch(useDevel(${BIOC_USE_DEVEL}),"\
" error=function(e) {if (!grepl('already in use', e$message)) {e}});"\
" options(repos=biocinstallRepos());"

Bootstrap() {
    if [[ "Darwin" == "${OS}" ]]; then
        BootstrapMac
    elif [[ "Linux" == "${OS}" ]]; then
        BootstrapLinux
    else
        echo "Unknown OS: ${OS}"
        exit 1
    fi

    if [[ "R_VERSION" == "3.5" ]]; then
        echo "Using R 3.5.*"
    elif [[ "R_VERSION" == "3.4" ]]; then
        echo "Using R 3.4.*"
    else
        echo "Unknown OS: ${OS}"
        exit 1
    fi

    
    if ! (test -e .Rbuildignore && grep -q 'travis-tool' .Rbuildignore); then
        echo '^travis-tool\.sh$' >>.Rbuildignore
    fi
    if ! (test -e .Rbuildignore && grep -q 'run.sh' .Rbuildignore); then
        echo '^run\.sh$' >> .Rbuildignore
    fi
    if ! (test -e .Rbuildignore && grep -q 'travis_wait' .Rbuildignore); then
        echo '^travis_wait_.*\.log$' >> .Rbuildignore
    fi

    SetRepos
}

SetRepos() {
    echo "local({" >> ~/.Rprofile
    echo "   r <- getOption(\"repos\");" >> ~/.Rprofile
    echo "   r[\"CRAN\"] <- \"${CRAN}\"" >> ~/.Rprofile
    for d in ${DRAT_REPOS}; do 
        echo "   r[\"${d}\"] <- \"https://${d}.github.io/drat\"" >> ~/.Rprofile
    done        
    echo "   options(repos=r)" >> ~/.Rprofile
    echo "})" >> ~/.Rprofile
}

InstallPandoc() {
    local os_path="$1"
    mkdir -p "${PANDOC_DIR}"
    curl -o /tmp/pandoc-${PANDOC_VERSION}.zip ${PANDOC_URL}
    unzip -j /tmp/pandoc-${PANDOC_VERSION}.zip "pandoc-${PANDOC_VERSION}/${os_path}/pandoc" -d "${PANDOC_DIR}"
    chmod +x "${PANDOC_DIR}/pandoc"
    sudo ln -s "${PANDOC_DIR}/pandoc" /usr/local/bin
    unzip -j /tmp/pandoc-${PANDOC_VERSION}.zip "pandoc-${PANDOC_VERSION}/${os_path}/pandoc-citeproc" -d "${PANDOC_DIR}"
    chmod +x "${PANDOC_DIR}/pandoc-citeproc"
    sudo ln -s "${PANDOC_DIR}/pandoc-citeproc" /usr/local/bin
}

BootstrapLinux() {
    # Set up our CRAN mirror.
    if [[ "R_VERSION" == "3.5" ]]; then
        sudo add-apt-repository "deb ${CRAN}/bin/linux/ubuntu $(lsb_release -cs)-cran35/"
    elif [[ "R_VERSION" == "3.4" ]]; then
        sudo add-apt-repository "deb ${CRAN}/bin/linux/ubuntu $(lsb_release -cs)/"
    fi
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

    # Add marutter's c2d4u repository.
    if [[ "R_VERSION" == "3.5" ]]; then
        sudo add-apt-repository -y "ppa:marutter/rrutter3.5"
        sudo add-apt-repository -y "ppa:marutter/c2d4u3.5"
    elif [[ "R_VERSION" == "3.4" ]]; then
        sudo add-apt-repository -y "ppa:marutter/rrutter"
        sudo add-apt-repository -y "ppa:marutter/c2d4u"
    fi

    # Update after adding all repositories.  Retry several times to work around
    # flaky connection to Launchpad PPAs.
    Retry sudo apt-get update -qq

    # Install an R development environment. qpdf is also needed for
    # --as-cran checks:
    #   https://stat.ethz.ch/pipermail/r-help//2012-September/335676.html
    Retry sudo apt-get install -y --no-install-recommends r-base-dev r-recommended qpdf

    # Change permissions for /usr/local/lib/R/site-library
    # This should really be via 'staff adduser travis staff'
    # but that may affect only the next shell
    sudo chmod 2777 /usr/local/lib/R /usr/local/lib/R/site-library

    # Process options
    BootstrapLinuxOptions

    # Report version
    Rscript -e 'sessionInfo()'
}

BootstrapLinuxOptions() {
    if [[ -n "$BOOTSTRAP_LATEX" ]]; then
        # We add a backports PPA for more recent TeX packages.
        sudo add-apt-repository -y "ppa:texlive-backports/ppa"

        Retry sudo apt-get install -y --no-install-recommends \
            texlive-base texlive-latex-base texlive-generic-recommended \
            texlive-fonts-recommended texlive-fonts-extra \
            texlive-extra-utils texlive-latex-recommended texlive-latex-extra \
            texinfo lmodern
    fi
    if [[ -n "$BOOTSTRAP_PANDOC" ]]; then
        InstallPandoc 'linux/debian/x86_64'
    fi
}

BootstrapMac() {
    # Install from latest CRAN binary build for OS X
    wget ${CRAN}/bin/macosx/R-latest.pkg  -O /tmp/R-latest.pkg

    echo "Installing OS X binary package for R"
    sudo installer -pkg "/tmp/R-latest.pkg" -target /
    rm "/tmp/R-latest.pkg"

    # Process options
    BootstrapMacOptions
}

BootstrapMacOptions() {
    if [[ -n "$BOOTSTRAP_LATEX" ]]; then
        # TODO: Install MacTeX.pkg once there's enough disk space
        MACTEX=BasicTeX.pkg
        wget http://ctan.math.utah.edu/ctan/tex-archive/systems/mac/mactex/$MACTEX -O "/tmp/$MACTEX"

        echo "Installing OS X binary package for MacTeX"
        sudo installer -pkg "/tmp/$MACTEX" -target /
        rm "/tmp/$MACTEX"
        # We need a few more packages than the basic package provides; this
        # post saved me so much pain:
        #   https://stat.ethz.ch/pipermail/r-sig-mac/2010-May/007399.html
        sudo tlmgr update --self
        sudo tlmgr install inconsolata upquote courier courier-scaled helvetic
    fi
    if [[ -n "$BOOTSTRAP_PANDOC" ]]; then
        InstallPandoc 'mac'
    fi
}

EnsureDevtools() {
    if ! Rscript -e 'if (!("devtools" %in% rownames(installed.packages()))) q(status=1)' ; then
        # Install devtools and testthat.
        RBinaryInstall devtools testthat
    fi
}

AptGetInstall() {
    if [[ "Linux" != "${OS}" ]]; then
        echo "Wrong OS: ${OS}"
        exit 1
    fi

    if [[ "" == "$*" ]]; then
        echo "No arguments to aptget_install"
        exit 1
    fi

    echo "Installing apt package(s) $@"
    Retry sudo apt-get -y --allow-unauthenticated install "$@"
}

DpkgCurlInstall() {
    if [[ "Linux" != "${OS}" ]]; then
        echo "Wrong OS: ${OS}"
        exit 1
    fi

    if [[ "" == "$*" ]]; then
        echo "No arguments to dpkgcurl_install"
        exit 1
    fi

    echo "Installing remote package(s) $@"
    for rf in "$@"; do
        curl -OL ${rf}
        f=$(basename ${rf})
        sudo dpkg -i ${f}
        rm -v ${f}
    done
}

RInstall() {
    if [[ "" == "$*" ]]; then
        echo "No arguments to r_install"
        exit 1
    fi

    echo "Installing R package(s): $@"
    Rscript -e 'install.packages(commandArgs(TRUE))' "$@"
}

BiocInstall() {
    if [[ "" == "$*" ]]; then
        echo "No arguments to bioc_install"
        exit 1
    fi

    echo "Installing R Bioconductor package(s): $@"
    Rscript -e "${R_USE_BIOC_CMDS}"' biocLite(commandArgs(TRUE))' "$@"
}

RBinaryInstall() {
    if [[ -z "$#" ]]; then
        echo "No arguments to r_binary_install"
        exit 1
    fi

    if [[ "Linux" != "${OS}" ]] || [[ -n "${FORCE_SOURCE_INSTALL}" ]]; then
        echo "Fallback: Installing from source"
        RInstall "$@"
        return
    fi

    echo "Installing *binary* R packages: $*"
    r_packages=$(echo $* | tr '[:upper:]' '[:lower:]')
    r_debs=$(for r_package in ${r_packages}; do echo -n "r-cran-${r_package} "; done)

    AptGetInstall ${r_debs}
}

InstallGithub() {
    EnsureDevtools

    echo "Installing GitHub packages: $@"
    # Install the package.
    Rscript -e 'library(devtools); library(methods); install_github(commandArgs(TRUE), build_vignettes = FALSE)' "$@"
}

InstallDeps() {
    EnsureDevtools
    Rscript -e 'library(devtools); library(methods); install_deps(dependencies = TRUE)'
}

InstallBiocDeps() {
    EnsureDevtools
    Rscript -e "${R_USE_BIOC_CMDS}"' library(devtools); install_deps(dependencies = TRUE)'
}

DumpSysinfo() {
    echo "Dumping system information."
    R -e '.libPaths(); sessionInfo(); installed.packages()'
}

DumpLogsByExtension() {
    if [[ -z "$1" ]]; then
        echo "dump_logs_by_extension requires exactly one argument, got: $@"
        exit 1
    fi
    extension=$1
    shift
    package=$(find . -maxdepth 1 -name "*.Rcheck" -type d)
    if [[ ${#package[@]} -ne 1 ]]; then
        echo "Could not find package Rcheck directory, skipping log dump."
        exit 0
    fi
    for name in $(find "${package}" -type f -name "*${extension}"); do
        echo ">>> Filename: ${name} <<<"
        cat ${name}
    done
}

DumpLogs() {
    echo "Dumping test execution logs."
    DumpLogsByExtension "out"
    DumpLogsByExtension "log"
    DumpLogsByExtension "fail"
}

Coverage() {
    echo "Running Code Coverage analysis via the covr package"

    ## assumes that the Rutter PPAs are in fact known, which is a given here
    AptGetInstall r-cran-covr        

    Rscript -e "covr::codecov()"
}

RunTests() {
    echo "Building with: R CMD build ${R_BUILD_ARGS}"
    R CMD build ${R_BUILD_ARGS} .
    # We want to grab the version we just built.
    FILE=$(ls -1t *.tar.gz | head -n 1)

    # Create binary package (currently Windows only)
    if [[ "${OS:0:5}" == "MINGW" ]]; then
        R_CHECK_INSTALL_ARGS=${R_CHECK_INSTALL_ARGS-"--install-args=\"--build --install-tests\""}
    fi

    echo "Testing with: R CMD check \"${FILE}\" ${R_CHECK_ARGS} ${R_CHECK_INSTALL_ARGS}"
    _R_CHECK_CRAN_INCOMING_=${_R_CHECK_CRAN_INCOMING_:-FALSE}
    if [[ "$_R_CHECK_CRAN_INCOMING_" == "FALSE" ]]; then
        echo "(CRAN incoming checks are off)"
    fi
    _R_CHECK_CRAN_INCOMING_=${_R_CHECK_CRAN_INCOMING_} R CMD check "${FILE}" ${R_CHECK_ARGS} ${R_CHECK_INSTALL_ARGS}

    # Check reverse dependencies
    if [[ -n "$R_CHECK_REVDEP" ]]; then
        echo "Checking reverse dependencies"
        Rscript -e 'library(devtools); checkOutput <- unlist(revdep_check(as.package(".")$package));if (!is.null(checkOutput)) {print(data.frame(pkg = names(checkOutput), error = checkOutput));for(i in seq_along(checkOutput)){;cat("\n", names(checkOutput)[i], " Check Output:\n  ", paste(readLines(regmatches(checkOutput[i], regexec("/.*\\.out", checkOutput[i]))[[1]]), collapse = "\n  ", sep = ""), "\n", sep = "")};q(status = 1, save = "no")}'
    fi

    if [[ -n "${WARNINGS_ARE_ERRORS}" ]]; then
        if DumpLogsByExtension "00check.log" | grep -q WARNING; then
            echo "Found warnings, treated as errors."
            echo "Clear or unset the WARNINGS_ARE_ERRORS environment variable to ignore warnings."
            exit 1
        fi
    fi
}

Retry() {
    if "$@"; then
        return 0
    fi
    for wait_time in 5 20 30 60; do
        echo "Command failed, retrying in ${wait_time} ..."
        sleep ${wait_time}
        if "$@"; then
            return 0
        fi
    done
    echo "Failed all retries!"
    exit 1
}

ShowHelpAndExit() {
    echo "Usage: run.sh COMMAND"
    echo "Derived from the venerable r-travis project, but still maintained lovingly by @eddelbuettel."
    exit 0
}

COMMAND=$1
#echo "\033[0;31m
#r-travis is DEPRECATED!
#Please see https://docs.travis-ci.com/user/languages/r/ for info, or
#https://github.com/craigcitro/r-travis/wiki/Porting-to-native-R-support-in-Travis
#for information on porting to native R support in Travis.\033[0m"
#echo "Running command: ${COMMAND}"
echo ""
echo "r-travis now defaults to using R 3.5.1. But you can easily revert"
echo "back to R 3.4.4 by setting R_VERSION to \"3.4\" in your .travis.yml"
echo ""
shift
case $COMMAND in
    ##
    ## Bootstrap a new core system
    "bootstrap")
        Bootstrap
        ;;
    ## Code coverage via covr.io
    "coverage")
        Coverage
        ;;
    ##
    ## Ensure devtools is loaded (implicitly called)
    "install_devtools"|"devtools_install")
        EnsureDevtools
        ;;
    ##
    ## Install a binary deb package via apt-get
    "install_aptget"|"aptget_install")
        AptGetInstall "$@"
        ;;
    ##
    ## Install a binary deb package via a curl call and local dpkg -i
    "install_dpkgcurl"|"dpkgcurl_install")
        DpkgCurlInstall "$@"
        ;;
    ##
    ## Install an R dependency from CRAN
    "install_r"|"r_install")
        RInstall "$@"
        ;;
    ##
    ## Install an R dependency from Bioconductor
    "install_bioc"|"bioc_install")
        BiocInstall "$@"
        ;;
    ##
    ## Install an R dependency as a binary (via c2d4u PPA)
    "install_r_binary"|"r_binary_install")
        RBinaryInstall "$@"
        ;;
    ##
    ## Install a package from github sources (needs devtools)
    "install_github"|"github_package")
        InstallGithub "$@"
        ;;
    ##
    ## Install package dependencies from CRAN (needs devtools)
    "install_deps")
        InstallDeps
        ;;
    ##
    ## Install package dependencies from Bioconductor and CRAN (needs devtools)
    "install_bioc_deps")
        InstallBiocDeps
        ;;
    ##
    ## Run the actual tests, ie R CMD check
    "run_tests")
        RunTests
        ;;
    ##
    ## Dump information about installed packages
    "dump_sysinfo")
        DumpSysinfo
        ;;
    ##
    ## Dump build or check logs
    "dump_logs")
        DumpLogs
        ;;
    ##
    ## Dump selected build or check logs
    "dump_logs_by_extension")
        DumpLogsByExtension "$@"
        ;;
    ##
    ## Help
    "help")
        ShowHelpAndExit
        ;;
esac
