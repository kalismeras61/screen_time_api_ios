import Flutter
import UIKit
import FamilyControls
import SwiftUI

public class ScreenTimeApiIosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "screen_time_api_ios", binaryMessenger: registrar.messenger())
        let instance = ScreenTimeApiIosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "selectAppsToDiscourage":
            Task {
                // Screen Time API authorization
                try await FamilyControlModel.shared.authorize()
                showController()
            }
            result(nil)
        case "encourageAll":
            // Release all restrictions
            FamilyControlModel.shared.encourageAll()
            FamilyControlModel.shared.saveSelection(selection: FamilyActivitySelection())
            result(nil)
        case "disallowApps":
            if let args = call.arguments as? [String] {
                FamilyControlModel.shared.disallowApps(bundleIdentifiers: args)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected a list of bundle identifiers", details: nil))
            }
        case "addDisallowedApps":
            if let args = call.arguments as? [String] {
                FamilyControlModel.shared.addDisallowedApps(bundleIdentifiers: args)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected a list of bundle identifiers", details: nil))
            }
        case "removeDisallowedApps":
            if let args = call.arguments as? [String] {
                FamilyControlModel.shared.removeDisallowedApps(bundleIdentifiers: args)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected a list of bundle identifiers", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @objc func onPressClose() {
        dismiss()
    }

    func showController() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let windows = windowScene?.windows
            let controller = windows?.filter { !$0.isHidden }.first?.rootViewController as? FlutterViewController

            // Display the app selection UI
            let selectAppVC: UIViewController = UIHostingController(rootView: ContentView())
            selectAppVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(self.onPressClose)
            )
            let naviVC = UINavigationController(rootViewController: selectAppVC)
            controller?.present(naviVC, animated: true, completion: nil)
        }
    }

    func dismiss() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let windows = windowScene?.windows
            let controller = windows?.filter { !$0.isHidden }.first?.rootViewController as? FlutterViewController
            controller?.dismiss(animated: true, completion: nil)
        }
    }
}
