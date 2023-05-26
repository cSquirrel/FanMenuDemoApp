import SwiftUI

struct MainView: View {
    
    private enum Const {
        static let smallComponentHeight = 20.0
        static let largeComponentHeight = 208.0
    }
    
    @State private var isMenuVisible = false
    @State private var itemSelected: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            MockAppView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if isMenuVisible {
                Color.clear
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
            
            FanMenuViewRepresentable { touchEvent in
                switch touchEvent {
                case .opened:
                    itemSelected = ""
                    isMenuVisible = true
                case let .itemSelected(item):
                    isMenuVisible = true
                    itemSelected = item.label
                case .closed:
                    isMenuVisible = false
                    if !itemSelected.isEmpty {
                        showAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $showAlert, content: {
            Alert(
                title: Text("Your Selection"),
                message: Text("Menu Item Selected: \(itemSelected)"),
                dismissButton: .default(Text("OK")))
            
        })
        .background(Color.appBackground)
    }
}

struct FanMenuUIKitView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
