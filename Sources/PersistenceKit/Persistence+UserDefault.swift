import Foundation
import Logger
/**
 * UserDefault
 * - Description: This extension of the Persistence class provides methods for managing UserDefaults, specifically for determining if the application is being launched for the first time.
 */
extension Persistence {
   /**
    * Avoids showing the welcome-page on app start etc
    * - Description: A flag used to determine if the application has been launched before. This is stored in UserDefaults and is used to avoid showing the welcome page on subsequent app starts.
    */
   fileprivate static let hasBeenLaunchedBeforeFlag: String = "hasBeenLaunchedBeforeFlag"
   /**
    * - Description: This property checks if the application is being launched for the first time. It uses a flag stored in UserDefaults to determine if a previous launch has occurred. If the flag is not set, it is the first launch, and the method will return true. Otherwise, it will return false.
    * - Remark: Calling this does not edit flag state
    * - Remark: macOS `UserDefault` is not wiped when the user deletes the app
    * - Fixme: ⚠️️ How does this work for macos? 
    */
   internal static var isFirstRun: Bool {
      let hasBeenLaunchedBefore: Bool? = UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag) // Get the value of hasBeenLaunchedBeforeFlag from user defaults
      return hasBeenLaunchedBefore == false // Return whether hasBeenLaunchedBefore is false (i.e. first launch)
   }
   /**
    * - Description: This method checks if the app is being launched for the first time. It uses a flag stored in UserDefaults to determine if a previous launch has occurred. If the flag is not set, it is the first launch, and the method will set the flag to true for subsequent launches.
    * - Remark: This can only be called once, after it's called once it will always return false, unless userdefaults are reset etc
    * - Remark: Since iOS12, it isn't mandatory to call `.syncronize` Apple says: https://developer.apple.com/documentation/foundation/userdefaults/1414005-synchronize
    * - Note: Ref: https://stackoverflow.com/questions/9964371/how-to-detect-first-time-app-launch-on-an-iphone
    * - Fixme: ⚠️️ Move this to UserDefault file etc, Add this to the prefs userdefaults etc, or not?
    */
   internal static func getIsFirstLaunch() -> Bool {
      if isFirstRun { // Check if it's the first run
         UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag) // Set hasBeenLaunchedBeforeFlag to true
         return true // Return true if it's the first run
      }
      return false // Return false if it's not the first run
   }
}
