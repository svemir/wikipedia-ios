import Foundation
import os.log

public extension Error {
    public var loggingDescription: String {
        return String(describing: self)
    }
}

public func DDLogVerbose(_ message: StaticString, _ args: CVarArg...) {
    #if DEBUG
    os_log(message, args)
    #endif
}

public func DDLogDebug(_ message: StaticString, _ args: CVarArg...) {
    #if DEBUG
    os_log(message, args)
    #endif
}

public func DDLogInfo(_ message: StaticString, _ args: CVarArg...) {
    #if DEBUG
    os_log(message, args)
    #endif
}

public func DDLogWarning(_ message: StaticString, _ args: CVarArg...) {
    os_log(message, args)
}

public func DDLogError(_ message: StaticString, _ args: CVarArg...) {
    os_log(message, args)
}
