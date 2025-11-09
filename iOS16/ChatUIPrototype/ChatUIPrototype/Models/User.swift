import Foundation
import SwiftUI

struct User: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let avatarColor: Color
    let isCurrentUser: Bool
    
    static let currentUser = User(
        name: "自分",
        avatarColor: .blue,
        isCurrentUser: true
    )
    
    static let sampleUsers = [
        User(name: "田中", avatarColor: .green, isCurrentUser: false),
        User(name: "佐藤", avatarColor: .orange, isCurrentUser: false),
        User(name: "鈴木", avatarColor: .purple, isCurrentUser: false),
        User(name: "山田", avatarColor: .pink, isCurrentUser: false),
        User(name: "高橋", avatarColor: .red, isCurrentUser: false),
        User(name: "渡辺", avatarColor: .cyan, isCurrentUser: false),
        User(name: "伊藤", avatarColor: .indigo, isCurrentUser: false),
        User(name: "中村", avatarColor: .teal, isCurrentUser: false)
    ]
}