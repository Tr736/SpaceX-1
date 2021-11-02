import os.log
extension OSLog {
    static func log(subsystem: String, category: String) -> OSLog {
        OSLog(subsystem: "co.spacex.app.\(subsystem)",
              category: category)
    }
}
