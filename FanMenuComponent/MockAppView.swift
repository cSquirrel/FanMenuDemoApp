import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Image("profile - icon")
                .resizable()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
            Spacer()
            Image(systemName: "message.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(InformationGroupStyle.gray.title)
        }
    }
}

struct MockAppView: View {
    
    private enum Const {
        static let smallComponentHeight = 20.0
        static let largeComponentHeight = 231.0
    }
    
    var body: some View {
        VStack {
            VStack {
                HeaderView()
                TilesView()
            }
            .padding(20)
            ZStack {
                GraphView()
                VStack {
                    Spacer()
                    HStack {
                        InformationGroup(title: "Overview", style: .black) {
                            VStack(alignment: .leading) {
                                Text("1 ASSET")
                                    .foregroundColor(Color.tileGrayTitle)
                                    .font(.body)
                                    .fontWeight(.bold)
                                Text("$7,046.34")
                                    .foregroundColor(Color.white)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("-15,473.34")
                                    .foregroundColor(Color.tileGrayTitle)
                                    .font(.body)
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(height: 200)
                        .padding(20)
                    }
                    Spacer()
                }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MockAppView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MockAppView()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}
