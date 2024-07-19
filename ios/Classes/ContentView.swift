//
//  ContentView.swift
//  screen_time_api_ios
//
//  Created by Kei Fujikawa on 2023/10/11.
//

import SwiftUI
import FamilyControls
@available(iOS 16.0, *)
struct ContentView: View {
    @StateObject var model = FamilyControlModel.shared

    var body: some View {
        FamilyActivityPicker(
            selection: $model.selectionToDiscourage
        )
    }
}
@available(iOS 16.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
