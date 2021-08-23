//
//  SampleProjectApp.swift
//  SampleProject
//
//  Created by kana on 2021/07/21.
//

import SwiftUI

@main
struct SampleProjectApp: App {
    // 永続化コンテナのコントローラー生成
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                // ManagedObjectContextを環境変数に追加
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
