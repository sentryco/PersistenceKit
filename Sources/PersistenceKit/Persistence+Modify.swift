import Foundation
import Logger
import Key
/**
 * Modify
 */
extension Persistence {
   /**
    * Reset UserDefault
    * - Description: This method resets the application's state by clearing all stored data in the keychain and user defaults. It is typically used when the application is reinstalled or during testing to simulate a fresh install.
    * - Remark: macOS does not reset UserDefault when the app is removed
    * - Remark: iOS does remove UserDefault when the app is removed
    * - Remark: The database should be already deleted
    * - Fixme: ⚠️️ add sources to these statements etc, things may change over time with new versions etc?
    */
   public static func reset() {
      Logger.debug("\(Trace.trace()) - reset()") // Log that reset() function is called
      resetKeychain() // Call resetKeychain() function to reset keychain
      resetUserDefault() // Call resetUserDefault() function to reset user defaults
   }
   /**
    * Command to delete keychain, as it persist for macOS and iOS even after app is deleted
    * - Description: This method is responsible for resetting the keychain. It deletes all keys from the keychain if it's the first run of the application. This is necessary because the keychain persists even after the app is deleted on both macOS and iOS. By resetting the keychain, we ensure that any sensitive data stored in the keychain is removed when the app is reinstalled.
    * - Remark: In this case the app must have been deleted, but key has persisted, action: remove key (Wipe all keychains this as soon as app inits),
    * - Remark: We need to account for user deleting and reinstalling an app. This should reset userdata stored in keychain as well. but since keychain is persistant, we need to use userdefault as the indicator if keychain should be wiped etc. we can probably double check if there is a coredata db. to avoid a case where userdefault is reset by system bug etc. future problem etc.
    * - Remark: These are stored in keychain: `SecDB.privKeyName`, `MasterPassword.masterPasswordKeyName`, `BPPeerManager.key`, and `PrefsStore`
    * - Fixme: ⚠️️⚠️️ We should warn user with a popup before clearning keychain. Apple might cause change some API in the future that might accidentally trigger this etc.
    */
   fileprivate static func resetKeychain() {
      Logger.debug("\(Trace.trace()) - resetKeychain()") // Log that resetKeychain() function is called
      if isFirstRun { // Check if it's the first run
         do {
            try Key.deleteAll() // Delete all keys from keychain
         } catch {
            Logger.error(Trace.trace("Orphan keychain, Err: \(error.localizedDescription)")) // Log error if keys cannot be deleted
         }
      }
   }
   /**
    * Reset the user default
    * - Description: Clears all entries from the user defaults. This is used to ensure that no user preferences or settings persist when the application is reset to a fresh state.
    * - Fixme: ⚠️️ this is a bit beta
    */
   fileprivate static func resetUserDefault() {
      Logger.debug("\(Trace.trace()) - resetUserDefault()") // Log that resetUserDefault() function is called
      UserDefaults.removeAll() // Call removeAll() function to remove all user defaults
//      UserDefaults.debug()
      // Swift.print("PrefsStore.$shouldPresentOnboarding: \(PrefsStore.$shouldPresentOnboarding.wrappedValue)")
      UserDefaults.resetStandardUserDefaults() // ⚠️️ new
      Logger.debug("\(Trace.trace()) - ⚠️️ after reset user def")
//      UserDefaults.debug()
      // Swift.print("PrefsStore.$shouldPresentOnboarding: \(PrefsStore.$shouldPresentOnboarding.wrappedValue)")
      UserDefaults.standard.synchronize()
//      UserDefaults.debug()
      // Swift.print("PrefsStore.$shouldPresentOnboarding: \(PrefsStore.$shouldPresentOnboarding.wrappedValue)")
   }
}
