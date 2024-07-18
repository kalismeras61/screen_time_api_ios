import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

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
                .specific(
                    categories
                )
            store.shield.webDomainCategories = ShieldSettings
                .ActivityCategoryPolicy
                .specific(
                    categories
                )
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
            .specific(
                []
            )
        store.shield.webDomainCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(
                []
            )
    }

    func saveSelection(selection: FamilyActivitySelection) {
        let defaults = UserDefaults.standard
        defaults.set(
            try? encoder.encode(selection),
            forKey: userDefaultsKey
        )
    }

    func savedSelection() -> FamilyActivitySelection? {
        let defaults = UserDefaults.standard

        guard let data = defaults.data(forKey: userDefaultsKey) else {
            return nil
        }

        return try? decoder.decode(
            FamilyActivitySelection.self,
            from: data
        )
    }

    // New function to disallow specific apps
    func disallowApps(bundleIdentifiers: [String]) {
        let applicationTokens = bundleIdentifiers.map { ApplicationToken(bundleIdentifier: $0) }
        store.shield.applications = Set(applicationTokens)
    }

    // Function to add more disallowed apps
    func addDisallowedApps(bundleIdentifiers: [String]) {
        let applicationTokens = bundleIdentifiers.map { ApplicationToken(bundleIdentifier: $0) }
        var currentApplications = store.shield.applications ?? Set<ApplicationToken>()
        currentApplications.formUnion(applicationTokens)
        store.shield.applications = currentApplications
    }

    // Function to remove disallowed apps
    func removeDisallowedApps(bundleIdentifiers: [String]) {
        let applicationTokens = bundleIdentifiers.map { ApplicationToken(bundleIdentifier: $0) }
        var currentApplications = store.shield.applications ?? Set<ApplicationToken>()
        currentApplications.subtract(applicationTokens)
        store.shield.applications = currentApplications
    }
}
