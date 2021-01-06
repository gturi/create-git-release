# create-git-release

Script to create a new git release.

## Usage

```
usage: ./create-git-release.sh [Options] "/path/to/git/project"
  -h                shows this help message
  -d branch_name    sets the branch from which the release should start (default value "develop")
  -m branch_name    sets the default branch of your repository (default value "main")
  -v                sets the release version (example value 1.0.0)
```

If the option -v is not specified, the script will prompt to insert the release version.

Each release tag will be created with the following sintax:

```bash
git tag -a "v$version" -m "release $version"
```

## Examples

```bash
./create-git-release.sh "/path/to/git/project"
./create-git-release.sh -v 1.1.0 "/path/to/git/project"
./create-git-release.sh -m default -d dev "/path/to/git/project"
```

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
