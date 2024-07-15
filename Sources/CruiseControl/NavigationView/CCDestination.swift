import Foundation
import SwiftUI

public protocol CCDestination: Identifiable, Hashable {
    associatedtype Content: View

    var id: String { get }

    @ViewBuilder
    func buildView() -> Content
}
