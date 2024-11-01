import Foundation
/**
 * Persistence is a way to detect if the app has been installed before or not
 * - Description: If both `keychain` and `db-file` does not exist -> it's a fresh install, If keychain exist and db file does not -> its a reinstall
 * - Remark: has nuanced info on background issue with using userdefault as flag etc: https://stackoverflow.com/a/20840053/5389500
 * - Remark: Universal solution for both iOS and macOS (they have slightly different ways of doing things)
 * - Note: Alternative names: `Continuity` or `Eternal` or `Perma`
 * - Fixme: ⚠️️ potentially move to a new `Auth` repo, add rational regarding why etc
 */
public class Persistence {}
