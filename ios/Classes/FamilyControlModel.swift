import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

@available(iOS 16.0, *)
class FamilyControlModel: ObservableObject {
    static let shared = FamilyControlModel()

    private init() {
        selectionToDiscourage = savedSelection() ?? FamilyActivitySelection()
    }

    private let store = ManagedSettingsStore()
    private let userDefaultsKey = "ScreenTimeSelection"
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()

    var selectionToDiscourage = FamilyActivitySelection() {
        willSet {
            print("got here \(newValue)")

            let applications = newValue.applicationTokens
            let categories = newValue.categoryTokens

            print("applications \(applications)")
            print("categories \(categories)")

            store.shield.applications = applications.isEmpty ? nil : applications

            store.shield.applicationCategories = ShieldSettings
                .ActivityCategoryPolicy
                .specific(categories)
            store.shield.webDomainCategories = ShieldSettings
                .ActivityCategoryPolicy
                .specific(categories)

          dprint("store.shield.applications \(store.shield.applications) \(newValue)") 
            self.saveSelection(selection: newValue)
        }
    }

    func authorize() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }

    func encourageAll() {
        store.shield.applications = []
        store.shield.applicationCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific([])
        store.shield.webDomainCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific([])
    }

    func saveSelection(selection: FamilyActivitySelection) {
        let defaults = UserDefaults.standard
        defaults.set(try? encoder.encode(selection), forKey: userDefaultsKey)
    }

    func savedSelection() -> FamilyActivitySelection? {
        let defaults = UserDefaults.standard

        guard let data = defaults.data(forKey: userDefaultsKey) else {
            return nil
        }

        return try? decoder.decode(FamilyActivitySelection.self, from: data)
    }

    // Utility function to create ApplicationToken

    private func createApplicationToken(bundleIdentifier: String) -> ApplicationToken? {
        return try? ApplicationToken(from: bundleIdentifier as! Decoder)
    }

    // New function to disallow specific apps
    func disallowApps(bundleIdentifiers: [String]) {
        var applicationTokens = Set<ApplicationToken>()
        for bundleIdentifier in bundleIdentifiers {
            if let token = createApplicationToken(bundleIdentifier: bundleIdentifier) {
                applicationTokens.insert(token)
            }
        }
        store.shield.applications = applicationTokens
    }

    // Function to add more disallowed apps
    func addDisallowedApps(bundleIdentifiers: [String]) {
        var applicationTokens = store.shield.applications ?? Set<ApplicationToken>()
        for bundleIdentifier in bundleIdentifiers {
            if let token = createApplicationToken(bundleIdentifier: bundleIdentifier) {
                applicationTokens.insert(token)
            }
        }
        store.shield.applications = applicationTokens
    }

    // Function to remove disallowed apps
    func removeDisallowedApps(bundleIdentifiers: [String]) {
        var applicationTokens = store.shield.applications ?? Set<ApplicationToken>()
        for bundleIdentifier in bundleIdentifiers {
            if let token = createApplicationToken(bundleIdentifier: bundleIdentifier) {
                applicationTokens.remove(token)
            }
        }
        store.shield.applications = applicationTokens
    }
}
