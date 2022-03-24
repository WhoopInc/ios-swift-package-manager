# iOS Swift Package Manager External Dependency Manifest
This repository contains a list of external dependencies and versions that can be leveraged by iOS apps across WHOOP.

### Adding an external dependency
To Add a dependency follow the instructions here

### Reason this package exists.
This package is a colelction pointers to external dependencies such that Swift Package Manager can resolve dependencies
in both local development and CI. Here are the major benefits of using this over the third party github repository:

- Local development can come to one place to sync dependencies.
- These packages point to binary xcframework files so compiling is not needed therefore reducing build times.
- This keeps Swift Package Manager from downloading Gigabytes of source code from thrid parties that is never used therefore speeding up the build system.
- This allows the build system (CI) to cache the dependencies and avoid spending precious time resolving dependencies from the open internet.