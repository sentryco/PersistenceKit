import Foundation
//import Logger
//import DatabaseLib
import Key
//import SDUtil
/**
 * Assert
 * - Fixme: ⚠️️ Maybe build this into a enum? Simplify it somehow?
 */
extension Persistence {
   /**
    * App was deleted
    * - Description: Determines if the application was previously installed and then deleted. This is identified by the presence of keychain data without a corresponding database file, suggesting that the app's data was removed but the keychain entries persisted.
    * - Remark: In this case -> Wipe keychain
    * - Fixme: ⚠️️ add more info regarding why keychain might stick around etc? and the difference between iOS and macOS on this etc
    * - Fixme: ⚠️️ We should prompt user to start over, see issue for micro copy
    * - Fixme: ⚠️️ should we check userdefault instead of database?
    */
   public static func hasAppBeenDeleted(dbFilePath: String, privKeyName: String) -> Bool {
      // Swift.print("hasKeychain:  \(hasKeychain), hasDB:  \(hasDB)")
      let hasAppBeenDeleted: Bool = hasKeychain(privKeyName: privKeyName) && !hasDB(dbFilePath: dbFilePath) // Check if app has been deleted by verifying if keychain exists but database does not
      // Logger.debug("\(Trace.trace()) - hasAppBeenDeleted: \(hasAppBeenDeleted))") // Log whether app has been deleted or not
      return hasAppBeenDeleted // Return whether app has been deleted or not
   }
   /**
    * App is intalled for the first time or is reinstalled
    * - Description: Determines if the application is being installed for the first time or is being reinstalled. This is identified by checking if it's the first install or the application has been deleted before.
    * - Remark: Show onboard in this case
    * - Fixme: ⚠️️ We could integrate "welcome back" message etc
    */
   public static func isNewInstall(dbFilePath: String, privKeyName: String) -> Bool {
      let isNewInstall: Bool = isFirstInstall(dbFilePath: dbFilePath, privKeyName: privKeyName) || hasAppBeenDeleted(dbFilePath: dbFilePath, privKeyName: privKeyName) // Check if it's a new install by verifying if it's the first install or the app has been deleted
      // Logger.debug("\(Trace.trace()) - isNewInstall: \(isNewInstall)") // Log whether it's a new install or not
      return isNewInstall // Return whether it's a new install or not
   }
   /**
    * App is a new install, had never been installed before
    * - Description: Determines if this is the first time the application has been installed on the device by checking the absence of keychain entries and user defaults, which would indicate no prior use or data storage.
    * - Remark: We don't check for db, because UITest inserts dummy accounts
    * - Fixme: ⚠️️⚠️️ We will remove dummy accounts for UITests soon. too much complexity, and not needed, still relevant?
    */
   fileprivate static func isFirstInstall(dbFilePath: String, privKeyName: String) -> Bool {
      let isFirstInstall: Bool = !hasKeychain(privKeyName: privKeyName) && !hasUserDefault // Check if it's the first install by verifying if keychain and user defaults do not exist
      // Logger.debug("\(Trace.trace()) - isFirstInstall: \(isFirstInstall)") // Log whether it's the first install or not
      return isFirstInstall // Return whether it's the first install or not
   }
}
/**
 * Private helper
 */
extension Persistence {
   /**
    * This method checks the existence of the database file for the app. It does this by verifying if the database file exists in the app's storage.
    * - Description: Checks for the existence of the database file specific to the application's data model. If the file is present, it indicates that the application has been installed and used previously, as the database is created and populated during the app's initial setup process.
    * - Remark: CoreData database is always deleted after an app is removed for both iOS and macOS
    * - Fixme: ⚠️️ Add reference to persistence discussion etc
    */
   fileprivate static func hasDB(dbFilePath: String) -> Bool {
      let hasPersistentFile: Bool = FileManager().fileExists(atPath: dbFilePath) // Check if the persistent store file exists at the given URL
      // Logger.debug("\(Trace.trace()) - hasPersistentFile: \(hasPersistentFile)") - This line is commented out and does not affect the code
      return hasPersistentFile // Return `true` if the persistent store file exists, `false` otherwise
   }
   /**
    * This method checks the existence of user defaults for the app. It does this by verifying if it's not the first launch of the app. If it's not the first launch, it implies that user defaults exist.
    * - Description: This method checks for the presence of user defaults, which are used to store small pieces of data persistently across app launches. If user defaults are found, it indicates that the app has been launched before and is not a fresh install.
    * - Remark: UserDefault is deleted after app is deleted for iOS but not for macOS
    * - Remark: UserDefault data is always removed on iOS https://stackoverflow.com/questions/50170550/userdefaults-data-removing-if-app-uninstalled-in-ios
    * - Remark: User default is located here: `~/Library/Preferences/co.sentry.SentryApp.plist`
    * - Remark: User def is located here for sandboxed apps: `~/Library/Containers/co.sentry.SentryApp/Data/Library/Preferences/co.sentry.SentryApp.plist`
    */
   fileprivate static var hasUserDefault: Bool {
      let hasUserDefault: Bool = !getIsFirstLaunch() // Check if user defaults exist by verifying if it's not the first launch
      // Logger.debug("\(Trace.trace()) - hasUserDefault: \(hasUserDefault))") // Log whether user defaults exist or not
      return hasUserDefault // Return whether user defaults exist or not
   }
   /**
    * Checks if keychain data exists for the app.
    * - Description: This method attempts to retrieve key data from the keychain using the private key name. If the data is successfully retrieved, it indicates that keychain data exists for the app. If an error occurs during retrieval, it is logged and considered as no keychain data existing. 
    * - Returns: `true` if keychain data exists, `false` otherwise.
    * - Remark: KeyChain persists after an app is deleted for both macOS and iOS
    * - Remark: Keychain data always persist after app deletion for iOS ref: https://stackoverflow.com/questions/60485419/ios-keychain-data-will-persist-after-app-deleted-and-reinstall
    */
   fileprivate static func hasKeychain(privKeyName: String) -> Bool {
      let hasKeychain: Bool = { // Check if key data exists in keychain
         do {
            let data: Data? = try KeyQuery.getKeyData(privKeyName: privKeyName) // Get key data from keychain
            return data != nil // Return whether key data exists or not
         } catch { // Handle error if key data cannot be retrieved (this will be called the first time the app is started etc)
            Swift.print("Error: \(String(describing: (error as? KeyError)?.localizedDescription)))")
            // Logger.warn("\(Trace.trace()) - error: \(String(describing: (error as? KeyError)?.localizedDescription)))") // Log the error
            return false // Return false if key data cannot be retrieved
         }
      }()
      // Logger.debug("\(Trace.trace()) - hasKeychain: \(hasKeychain))") // Log whether key data exists or not
      return hasKeychain // Return whether key data exists or not
   }
}
