#!/bin/bash -e

# Usage message
usage()
{
    echo ""
    echo "Usage: ./config.sh -g GIT_URL -s SERVICE -r ROLE [-b BRANCH] [-i IMAGE] [-e ENVIRONMENT] [-p PATH] [-h]"
    echo "-g | --git:          The URL of a git repository which holds eght_app configuration data. Required."
    echo "-s | --service:      The service that the image will create and run. Required."
    echo "-r | --role:         A Chef role included in the given git repository. Required."
    echo "-b | --branch:       A branch of the given git repository. Optional. Defaults to 'develop'."
    echo "-i | --image:        The desired name of the Docker image to be created. Optional. Defaults to SERVICE-ENVIRONMENT-BRANCH."
    echo "-e | --environment:  A Chef environment included in the given git repository. Optional. Defaults to 'development'."
    echo "-p | --path:         The path relative to the environments folder containing the given environment file. Optional. Defaults to 'development'."
    echo "-h | --help:         Prints this message and exits. Optional."
    echo ""

}

# Parses through given arguments and sets needed variables
while [[ "$1" != "" ]]; do
    case $1 in 
        -g | --git )            shift
                                GIT_URL=$1
                                ;;
        -b | --branch )         shift
                                BRANCH=$1
                                ;;
        -i | --image )          shift
                                IMAGE=$1
                                ;;
        -s | --service )        shift
                                SERVICE=$1
                                ;;
        -r | --role )           shift
                                ROLE=$1
                                ;;
        -e | --environment )    shift
                                ENVIRONMENT=$1
                                ;;
        -p | --path )           shift
                                ENVIRONMENT_PATH=$1
                                ;;
        -h | --help )           usage
                                exit 0
                                ;;
        * )                     usage
                                exit 1
                                ;;
    esac
    shift
done

# Check that all required fields have been set
if [[ ! "$GIT_URL" || ! "$SERVICE" || ! "$ROLE" ]]; then
    usage
    exit 1
fi

# Assign default values if they were not assigned by CLI arguments
if [[ ! "$BRANCH" ]]; then
    BRANCH=develop
fi

if [[ ! "$ENVIRONMENT" ]]; then
    ENVIRONMENT=development
fi

if [[ ! "$ENVIRONMENT_PATH" ]]; then
    ENVIRONMENT_PATH=development
fi

if [[ ! "$IMAGE" ]]; then
    IMAGE=$SERVICE"-"$ENVIRONMENT"-"$BRANCH
fi


# Pulls the top-level directory name of the it repo from the given git URL
DIRECTORY=$(basename $GIT_URL .git)

# Holds a string describing the operating system we're running on. 
# Some common values are "Darwin" for MacOSX, and "Linux" for many Linux distributions. 
# This is useful for cases where different operating systems need special commands or different command syntaxes.
OS=$(uname)


# Pull down the given git repo UNLESS another directory exists with the same name
if [[ ! -d "$DIRECTORY" ]]; then
    git clone $GIT_URL
else
    echo "Skipping Git pull because the directory already exists locally."
    sleep 1s
fi

cd ${DIRECTORY}
git checkout $BRANCH
cd ..

cp Dockerfile-chefdata ${DIRECTORY}/


# Provides a more platform-agnostic way to run sed commands on a given file.
# Usage: replace <sed command> <filename>
replace(){
    if [ $OS = 'Darwin' ]; then
        sed -i '' $@
    else
        sed -i $@
    fi
}

# Note: # is used instead of / as a delimiter for the sed commands (ran via our replace() function) below.
# Using / as a delimiter can cause errors when working with an argument which may contain a / character, such as a file path.
# The # character is not expected to appear in any of the arguments being passed, which is why we choose to use it.

# Generate zero.rb, fill in templates, and put it in place
cp templates/zero.rb.tmpl zero.rb
replace 's#%image_name%#'"${IMAGE}"'#g' zero.rb
replace 's#%environment%#'"${ENVIRONMENT}"'#g' zero.rb
replace 's#%environment_path%#'"${ENVIRONMENT_PATH}"'#g' zero.rb
mv zero.rb ${DIRECTORY}/

# Generate first-boot.json, fill in templates, and put it in place
cp templates/first-boot.json.tmpl first-boot.json
replace 's#%app_chef_role%#'"${ROLE}"'#g' first-boot.json
mv first-boot.json ${DIRECTORY}/

# Generate docker-compose.yml and fill in templates 
cp templates/docker-compose.yml.tmpl docker-compose.yml
replace 's#%app_directory%#'"${DIRECTORY}"'#g' docker-compose.yml
replace 's#%image_name%#'"${IMAGE}"'#g' docker-compose.yml

# Generate Dockerfile.new and fill in templates 
cp templates/Dockerfile.new.tmpl Dockerfile.new
replace 's#%image_name%#'"${IMAGE}"'#g' Dockerfile.new
replace 's#%service_name%#'"${SERVICE}"'#g' Dockerfile.new

# Generate go.sh and fill in templates
cp templates/go.sh.tmpl go.sh
replace 's#%app_directory%#'"${DIRECTORY}"'#g' go.sh
replace 's#%image_name%#'"${IMAGE}"'#g' go.sh

# Generate cleanup.sh and fill in templates
cp templates/cleanup.sh.tmpl cleanup.sh
replace 's#%app_directory%#'"${DIRECTORY}"'#g' cleanup.sh