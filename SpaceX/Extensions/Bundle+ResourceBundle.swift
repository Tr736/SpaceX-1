import Foundation
/// This extension will allow you to shared Bundled files between modules.
/// Especially handy when a demo app consumes Mock JSON data and a Test Case wants to consume the same data file
public extension Bundle {

    static func resourceBundle(for frameworkClass: AnyClass) -> Bundle {
        guard let moduleName = String(reflecting: frameworkClass).components(separatedBy: ".").first else {
            fatalError("Couldn't determine module name from class \(frameworkClass)")
        }
        let frameworkBundle = Bundle(for: frameworkClass)
        guard let resourceBundleURL = frameworkBundle.url(forResource: moduleName, withExtension: "bundle"),
              let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("\(moduleName).bundle not found in \(frameworkBundle)")
        }
        return resourceBundle
    }

    @objc static func resourceBundle(forModuleNamed moduleName: String) -> Bundle {
        let bundleLocatorBundle = Bundle(for: BundleLocator.self)
        guard let resourceBundlePath = bundleLocatorBundle.path(forResource: moduleName, ofType: "bundle"),
              let resourceBundle = Bundle(path: resourceBundlePath) else {
            fatalError("\(moduleName).bundle not found in \(bundleLocatorBundle)")
        }
        return resourceBundle
    }

}

private class BundleLocator {}
