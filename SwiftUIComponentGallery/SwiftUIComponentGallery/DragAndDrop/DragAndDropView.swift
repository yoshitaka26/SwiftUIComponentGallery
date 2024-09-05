import SwiftUI

struct DragAndDropView: View {
    @State private var topAnimals: [Animal] = []
    @State private var bottomAnimals: [Animal] = Animal.sampleAnimals

    @State private var isDropTargetedOnTOp = false
    @State private var isDropTargetedOnBottom = false

    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                ForEach(topAnimals, id: \.id) { animal in
                    AnimalView(animal: animal)
                        .draggable(animal) {
                            AnimalView(animal: animal)
                                .bold()
                                .foregroundStyle(Color.red)
                        }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .border(.red, width: isDropTargetedOnTOp ? 10 : .zero)
            .dropDestination(for: Animal.self) { droppedAnimals, _ in
                moveAnimals(droppedAnimals, from: &bottomAnimals, to: &topAnimals)
                return true
            } isTargeted: {
                isDropTargetedOnTOp = $0
            }

            Divider()

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                ForEach(bottomAnimals, id: \.id) { animal in
                    AnimalView(animal: animal)
                        .draggable(animal) {
                            AnimalView(animal: animal)
                                .bold()
                                .foregroundStyle(Color.red)
                        }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue.opacity(0.1))
            .border(.red, width: isDropTargetedOnBottom ? 10 : .zero)
            .dropDestination(for: Animal.self) { droppedAnimals, _ in
                moveAnimals(droppedAnimals, from: &topAnimals, to: &bottomAnimals)
                return true
            } isTargeted: {
                isDropTargetedOnBottom = $0
            }
        }
        .padding()
    }

    private struct AnimalView: View {
        let animal: Animal

        var body: some View {
            VStack {
                Circle()
                    .fill(animal.animalColor)
                    .frame(width: 60, height: 60)
                    .overlay(Text(Animal.getAnimalIcon(for: animal.name)))
                Text(animal.name)
                    .font(.caption)
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
        }
    }

    private func moveAnimals(_ animals: [Animal], from source: inout [Animal], to destination: inout [Animal]) {
        for animal in animals {
            if let index = source.firstIndex(where: { $0.id == animal.id }) {
                source.remove(at: index)
                destination.append(animal)
            }
        }
    }
}

#Preview {
    DragAndDropView()
}

struct Animal: Codable, Transferable, Identifiable {
    let id: UUID
    let colorIndex: Int
    let name: String

    init(id: UUID = UUID(), colorIndex: Int, name: String) {
        self.id = id
        self.colorIndex = colorIndex
        self.name = name
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Animal.self, contentType: .data)
    }

    var animalColor: Color {
        Color(hue: Double(colorIndex) / 8.0, saturation: 0.7, brightness: 0.9)
    }

    static let sampleAnimals: [Animal] = [
        Animal(colorIndex: 1, name: "ライオン"),
        Animal(colorIndex: 2, name: "ゾウ"),
        Animal(colorIndex: 3, name: "キリン"),
        Animal(colorIndex: 4, name: "ペンギン"),
        Animal(colorIndex: 5, name: "トラ"),
        Animal(colorIndex: 6, name: "カンガルー"),
        Animal(colorIndex: 7, name: "パンダ"),
        Animal(colorIndex: 8, name: "コアラ")
    ]

    static func getAnimalIcon(for name: String) -> String {
        switch name {
        case "ライオン": return "🦁"
        case "ゾウ": return "🐘"
        case "キリン": return "🦒"
        case "ペンギン": return "🐧"
        case "トラ": return "🐯"
        case "カンガルー": return "🦘"
        case "パンダ": return "🐼"
        case "コアラ": return "🐨"
        default: return "🐾"
        }
    }
}
