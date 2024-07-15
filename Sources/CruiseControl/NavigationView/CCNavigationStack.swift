import Foundation
import SwiftUI

public class CCNavigationStack: CCLifeCycleViewModel, ObservableObject, Identifiable {
    public var id: String
    @Published var path = NavigationPath()
    @Published var stack = [any CCDestination]()
    @Published var sheet: (any CCDestination)?
    @Published var presentSheetAlert: Bool = false
    @Published var presentAlert: Bool = false

    public var destinations = [any CCDestination]()
    var alert: AlertModel?
    
    private let navigationService: CCNavigationService
    
    public init(id: String, navigationService: CCNavigationService) {
        self.id = id
        self.navigationService = navigationService
    }
    
    func dismissAlert() {
        presentAlert = false
        presentSheetAlert = false
        alert = nil
    }

    func dismissSheet() {
        guard let sheet else { return }
        navigationService.sheetDelegate?.onSheetDismissed(sheet)
        self.sheet = nil
    }

    override func onAppear() {
        navigationService.register(self)
    }
    
    override func onDisappear() {
        navigationService.unregister(self)
    }
}
