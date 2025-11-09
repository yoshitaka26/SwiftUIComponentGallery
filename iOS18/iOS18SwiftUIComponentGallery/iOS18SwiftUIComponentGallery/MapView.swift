import SwiftUI
import MapKit

struct MapView: View {
    // 姫路城の座標
    let location: CLLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: 34.8394,
        longitude: 134.6939
    )
    let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)

    @State private var items: [MKMapItem] = []
    @State private var isShowingList = false

    var body: some View {
        Group {
            if isShowingList {
                List {
                    ForEach(items, id: \.identifier) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name ?? "名称なし")
                                .font(.headline)

                            if let phoneNumber = item.phoneNumber, !phoneNumber.isEmpty {
                                HStack {
                                    Image(systemName: "phone")
                                    Text(phoneNumber)
                                }
                            }

                            if let address = item.placemark.thoroughfare {
                                HStack {
                                    Image(systemName: "location")
                                    Text("\(item.placemark.administrativeArea ?? "") \(item.placemark.locality ?? "") \(address)")
                                }
                            }

                            if let url = item.url {
                                Link(destination: url) {
                                    HStack {
                                        Image(systemName: "link")
                                        Text("ウェブサイトを開く")
                                    }
                                    .foregroundColor(.blue)
                                }
                                .buttonStyle(.plain)
                            }

                            Button {
                                item.openInMaps()
                            } label: {
                                HStack {
                                    Image(systemName: "map")
                                    Text("マップで開く")
                                }
                                .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.vertical, 8)
                    }
                }
            } else {
                Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(
                    center: location,
                    span: span
                )))) {
                    Annotation(
                        "",
                        coordinate: location,
                        anchor: .bottom
                    ) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.red)
                    }

                    // MapKitから取得した追加情報
                    ForEach(items, id: \.identifier) { item in
                        Annotation(
                            "",
                            coordinate: item.placemark.coordinate,
                            anchor: .bottom
                        ) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    item.openInMaps()
                                }
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .mapControls {
                    MapPitchToggle()
                }
            }
        }
        .task {
            do {
                items = try await SpotSearchManager.searchSpotDetails(
                    for: location
                )
            } catch {
                return
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isShowingList.toggle()
                } label: {
                    Image(systemName: isShowingList ? "map" : "list.dash")
                }
            }
        }
    }
}

@MainActor
class SpotSearchManager {
    static func searchSpotDetails(for coordinate: CLLocationCoordinate2D, radiusInMeters: Double = 20000) async throws -> [MKMapItem] {
        let request = MKLocalSearch.Request()

        // 検索の優先範囲を設定
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: radiusInMeters,
            longitudinalMeters: radiusInMeters
        )
        request.region = region

        request.resultTypes = [.pointOfInterest]
        request.naturalLanguageQuery = "観光"

        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        let spots = response.mapItems.filter {
            $0.placemark.location != nil
        }

        // 結果を距離順にソート
        return spots.sorted { item1, item2 in
            let location1 = CLLocation(
                latitude: item1.placemark.coordinate.latitude,
                longitude: item1.placemark.coordinate.longitude
            )
            let location2 = CLLocation(
                latitude: item2.placemark.coordinate.latitude,
                longitude: item2.placemark.coordinate.longitude
            )
            let centerLocation = CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )

            return location1.distance(from: centerLocation) < location2.distance(from: centerLocation)
        }
    }
}
