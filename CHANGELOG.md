# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/)
and this project adheres to [Semantic Versioning](https://semver.org/).

## 1.1.1

**Release date:** `2024-01-15`

### Fixed

- Fixed bug with empty pickle header allocation. (IDK why every other implementation uses 0 instead of 4, like in original chromium pickle)

## 1.1.0

**Release date:** `2024-01-14`

### Added

- Methods to get only used data.

### Changed

- Separate `PickleIterator.readBytes` to `PickleIterator.readBytes` & `PickleIterator.readAs`.

## 1.0.4

**Release date:** `2023-06-23`

### Fixed

- Fixed bug with buffer linking in `PickleIterator` (now iterators refer to the pickle itself, not buffer)

### Deprecated

- Deprecated `PickleIterator.payload`, `PickleIterator.payloadOffset`, `PickleIterator.endIndex`
  and `Pickle.getPayloadSize()`

### Removed

- Removed `lib/src/enums/enums.dart`

### Changed

- Reformatted code

## 1.0.3

**Release date:** `2023-05-26`

### Added

- `pubspec.yaml` now contains more information.

### Removed

- Dart SDK `<3.0.0` requirement.

## 1.0.2

**Release date:** `2023-02-07`

### Removed

- GitHub `Generate documentation` workflow.
- Docs on GitHub Pages.

### Changed

- The format of `CHANGELOG.md` has changed to match requirements of pub.dev.
- Library description (again).
- Renamed `example/pickle.dart` to `example.dart`.

## 1.0.1

**Release date:** `2023-02-06`

### Added

- GitHub `Generate documentation` workflow. (Documentation is now also available on GitHub Pages).

### Changed

- Updated comments in source code.
- `CHANGELOG.md` now uses [`Keep a Changelog`](https://keepachangelog.com/) based format.
- Updated `README.md`.
- Library description.

### Fixed

- GitHub `Test` workflow.

## 1.0.0

**Release date:** `2023-02-03`

### Added

- First stable release.
- `Pickle` & `PickleIterator`.
- Tests.