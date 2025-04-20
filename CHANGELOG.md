## [Unreleased]

- This gem was forked from [paper_trail-globalid](https://github.com/ankit1910/paper_trail-globalid) where the last release was version 0.2.0.

### Breaking Changes

- None

### Added

- None

### Fixed

- None

## [0.3.0] - 2025-04-11

- Bring fixes in and allow updated gem to be installed from GitHub.

### Breaking Changes

- Only work with PaperTrail >= 9.0.0 as that is the interface that we now use.
  Not all monkey patched classes exist in earlier versions.

### Added

- None

### Fixed

- [#1](https://github.com/tttffff/paper_trail-actor/pull/1) - Update to modern paper_trail.
  Update to use the interface of PaperTrail 9.0.0 onwards.
- [#2](https://github.com/tttffff/paper_trail-actor/pull/2) - Allow for using custom paper trail version classes.
  Change version mixin to allow for PaperTrail [custom-version-classes](https://github.com/paper-trail-gem/paper_trail#6a-custom-version-classes).


## [0.4.0] - 2025-04-20

- Initial release of paper_trail-actor

### Breaking Changes

- Only support PaperTrail >= 11.0.0.
  While this gem will technically work with versions >= 9.0.0, it is more complex to test for versions less than 11.0.0.
  As 11.0.0 is from 2020, there is no need to test or support any earlier versions.

### Added

- None

### Fixed

- None
