//
//  ContentView.swift
//  SampleProject
//
//  Created by kana on 2021/07/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext    // MOCの取得

    @FetchRequest(  // Fetchリクエスト取得
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {    // ナビゲーションバーを表示するために追加
            // 取得したデータをリスト表示
            List {
                ForEach(items) { item in
                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                }
                .onDelete(perform: deleteItems)
            }
            // ナビゲーションバーの設定
            .toolbar {
                // ナビゲーションバーの左にEditボタンを配置
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                // ナビゲーションバーの右側にプラスボタン配置
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            // 新規レコードの作成
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            // データベースの保存
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // レコードの削除
            offsets.map { items[$0] }.forEach(viewContext.delete)
            // データベースの登録
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()




//以降プレビュー
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
