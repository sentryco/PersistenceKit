[![Tests](https://github.com/sentryco/PersistenceKit/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/PersistenceKit/actions/workflows/Tests.yml)

# PersistenceKit

> Persistence check for iOS / macOS

## Description
Detects whether the app is a fresh install or a reinstall, which can influence authentication flows and user data management. Handles nuances of persistence across iOS and macOS.

## Features
- Assert database existence
- Assert keychain key existence
- Assert userdefault existence
- Reset userdefault and keychain

## Example

```swift
Persistence.hasAppBeenDeleted(dbFilePath: "", privKeyName: "")
Persistence.isNewInstall(dbFilePath: "", privKeyName: "")
Persistence.reset()
```

## Install

```swift
.package(url: "https://github.com/sentryco/PersistenceKit")
```

## Todo

- Add dependency list to readme
- Use smaller Keychain lib, from telemetry etc
