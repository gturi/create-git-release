#!/bin/bash

develop_branch=develop
main_branch=main

function usage {
    script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
    echo "usage: ./$script_name [Options] \"/path/to/git/project\""
    echo " -h                shows this help message"
    echo " -d branch_name    sets the branch from which the release should start (default value \"$develop_branch\")"
    echo " -m branch_name    sets the default branch of your repository (default value \"$main_branch\")"
    echo " -v                sets the release version (example value 1.0.0)"
    echo "EXAMPLES:"
    echo "./$script_name \"/path/to/git/project\""
    echo "./$script_name -v 1.1.0 \"/path/to/git/project\""
    echo "./$script_name -m default -d dev \"/path/to/git/project\""
    exit 0
}

while getopts ":d:m:v:h" opt; do
    case "$opt" in
    h)
        usage
        ;;
    d)  
        develop_branch="$OPTARG"
        ;;
    m)
        main_branch="$OPTARG"
        ;;
    v)  
        version="$OPTARG"
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done

# if the inserted arguments number is less than the next index
# to parse, no project folder has been specified
if [ "$#" -lt "$OPTIND" ]
then
    usage
fi

project_folder="${@:$OPTIND}"

# if version is not set or its value is empty string
while [ -z "$version" ]; do
    echo -n "Insert the release version (i.e. 1.0.0): "
    read version
    if [ -z "$version" ]
    then
        echo "Empty string is not accepted as a valid release version"
    fi
done

release_branch="release/$version"

cd "$project_folder"

function print_separator {
    echo "---"
}

git checkout -b "$release_branch" "$develop_branch"
print_separator
read -p "Make and commit your last minute changes, then press enter to merge $release_branch back into $develop_branch"

print_separator
git checkout "$develop_branch"
git merge --no-ff "$release_branch"
print_separator
read -p "Review the merge result, then press enter to push the changes to $develop_branch"
git push

print_separator
git checkout "$main_branch"
git merge --no-ff "$release_branch"
print_separator
read -p "Review the merge result, then press enter to push the changes to $main_branch"
print_separator

git tag -a "v$version" -m "release $version"
git push --follow-tags

git branch -d "$release_branch"
