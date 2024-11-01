# PersistenceKit

> Persistence check for iOS / macOS

## Description
Assert if your app is a new install. Or has been installed before. 

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

## Dependency

## Todo

- Add dependency list
- Use smaller Keychain lib, from telemetry etc
