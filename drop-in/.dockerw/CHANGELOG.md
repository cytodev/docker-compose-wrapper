# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

Changes are documented in the following order:

 1. Added
 2. Changed
 3. Deprecated
 4. Removed
 5. Fixed
 6. Security

## [Unreleased](https://github.com/cytodev/docker-compose-wrapper/compare/master...dev)

## [1.2.0] - 2020-05-15
### Added
 - add `dockerw create` command
 - add error message when an unsupported operation is requested

### Removed
 - removed redundant call to a container specific script

### Fixed
 - fixed directory path when selecting host directory in standalone installations

## [1.1.0] - 2020-05-14
### Added
 - add Instance naming support
 - add base Ubuntu releases to environments
 - add default host Dockerfile
 - add `gpg` to standard host container
 - add `dockerw logs` command
 - add `shared-content-sync` to default shared directory
 - add shared directories
 - add standalone functionality

### Changed
 - updated default `.bashrc` file
 - moved shared content to shared directory

### Removed
 - removed `dockerw ssh` command in favour of `dockerw enter <container>`
 - removed `dockerw composer` command because it is too specific

### Fixed
 - fixed symbolic link overriding issues in `dockerw setup`
 - fixed existential crisis when executed outside of own directory
 - fixed function calls calling subshells

## [1.0.0] - 2019-11-05
 - initial release

[1.2.0]: https://github.com/cytodev/docker-compose-wrapper/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/cytodev/docker-compose-wrapper/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/cytodev/docker-compose-wrapper/compare/e61315f...v1.0.0
