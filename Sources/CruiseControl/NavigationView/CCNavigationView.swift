import Foundation
import SwiftUI

public struct CCNavigationView<Destination: CCDestination, RootView: View>: View {
    
    @ObservedObject private var navigationStack: CCNavigationStack
    private var rootView: () -> RootView
    
    public init(navigationStack: CCNavigationStack, rootView: @escaping () -> RootView) {
        self.navigationStack = navigationStack
        self.rootView = rootView
    }
    
    public var body: some View {
        CCLifeCycleView(viewModel: navigationStack) {
            NavigationStack(path: $navigationStack.path) {
                rootView()
                    .navigationDestination(for: Destination.self) { view in
                        view.buildView()
                    }
            }
            .sheet(isPresented: .constant(navigationStack.sheet != nil), onDismiss: {
                navigationStack.dismissSheet()
            }) {
                if let sheet = navigationStack.sheet {
                    AnyView(sheet.buildView())
                        .presentAlert(navigationStack.alert, isPresented: $navigationStack.presentSheetAlert)
                }
            }
            .presentAlert(navigationStack.alert, isPresented: $navigationStack.presentAlert)
        }
    }
}

extension View {
    @ViewBuilder
    func presentAlert(_ model: AlertModel?, isPresented: Binding<Bool>) -> some View {
        self
            .alert(model?.title ?? "", isPresented: isPresented) {
                ForEach(model?.buttons ?? []) { button in
                    Button(button.title, role: button.role) {
                        button.action()
                    }
                }
            } message: {
                Text(model?.message ?? "")
            }
    }
}

struct CCLifeCycleView<Content: View>: View {
    
    var viewModel: CCLifeCycleViewModel
    var content: () -> Content
    
    var body: some View {
        content()
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}

open class CCLifeCycleViewModel {
    func onAppear() { }
    func onDisappear() { }
}

