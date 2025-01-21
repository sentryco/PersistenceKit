[![Tests](https://github.com/sentryco/PersistenceKit/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/PersistenceKit/actions/workflows/Tests.yml)
[![codebeat badge](https://codebeat.co/badges/6cd2817d-e317-42ad-8363-c127361b27e5)](https://codebeat.co/projects/github-com-sentryco-persistencekit-main)

# PersistenceKit

> Persistence check for iOS / macOS

## Description

PersistenceKit is a utility library designed to detect the persistence state of your iOS and macOS applications. It helps determine whether an app is a fresh install, a reinstall, or if it has been deleted and reinstalled. This information can influence authentication flows, user onboarding, and data management strategies. By handling the nuances of persistence across different platforms, PersistenceKit simplifies state management and enhances user experience.

## Features

- **Assert Database Existence**: Checks if the application's database file exists at the specified path.
- **Assert Keychain Key Existence**: Verifies the presence of a private key in the Keychain.
- **Assert UserDefaults Existence**: Determines if specific entries exist in `UserDefaults`.
- **Reset UserDefaults and Keychain**: Clears all data from `UserDefaults` and the Keychain to reset the application's state.

## Example

```swift
import PersistenceKit

// Define your database file path and private key name
let dbFilePath = "path/to/your/database.sqlite"
let privKeyName = "com.yourapp.privateKey"

// Check if the app has been deleted and reinstalled
if Persistence.hasAppBeenDeleted(dbFilePath: dbFilePath, privKeyName: privKeyName) {
    // Handle reinstallation logic, such as prompting for re-authentication
}

// Check if it's a new installation
if Persistence.isNewInstall(dbFilePath: dbFilePath, privKeyName: privKeyName) {
    // Present onboarding or initial setup
}

// Reset the persistence data (keychain and user defaults)
Persistence.reset()
```

## Install

```swift
.package(url: "https://github.com/sentryco/PersistenceKit")
```

## Dependencies

- [UserDefaultSugar](https://github.com/eonist/UserDefaultSugar)
- [Key](https://github.com/sentryco/Key)

## Todo

- Use smaller Keychain lib, from telemetry etc
