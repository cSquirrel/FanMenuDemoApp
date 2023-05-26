import SwiftUI

struct ContentView: View {
    
    private enum Const {
        static let smallComponentHeight = 20.0
        static let largeComponentHeight = 208.0
    }
    
    @State private var overText = false
    
    var body: some View {
        VStack {
            MainView()
        }
        .background(Color.appBackground)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
