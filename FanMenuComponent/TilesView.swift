import SwiftUI

struct InformationGroupStyle {
    let background: Color
    let title: Color
    let icon: Color
    
    static let gray = Self(background: .tileGrayBackground,
                           title: .tileGrayTitle,
                           icon: .black)
    static let red = Self(background: .MELDRed1,
                          title: .white,
                          icon: .white)
    static let black = Self(background: .black,
                            title: .white,
                            icon: .white)
}

struct InformationGroup<Content: View>: View {
    
    let title: String
    let icon: Image?
    let content: Content
    
    let style: InformationGroupStyle
    
    init(title: String, style: InformationGroupStyle = .gray, icon: Image? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
        self.icon = icon
        self.style = style
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .foregroundColor(style.title)
                    Spacer()
                    icon
                        .foregroundColor(style.icon)
                }
                .font(.headline)
                .fontWeight(.bold)
                VStack {
                    content
                        .font(.body)
                    Spacer()
                }
                .padding([.top, .bottom], 0)
            }
        }
        .padding()
        .background(style.background)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct ColouredGroupBox: GroupBoxStyle {
    
    let background: Color
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            configuration.content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(background))
    }
}

struct TilesView: View {
    
    private enum Const {
        static let smallComponentHeight = 20.0
        static let largeComponentHeight = 175.0
    }
    
    var body: some View {
        HStack {
            VStack {
                InformationGroup(title: "NFT", icon: Image(systemName: "person.2.crop.square.stack")) {
                    EmptyView()
                }
                
                InformationGroup(title: "BUY CRYPTO", icon: Image(systemName: "cart.badge.plus")) {
                    EmptyView()
                }
                
                InformationGroup(title: "EXCHANGE", icon: Image(systemName: "arrow.up.arrow.down")) {
                    EmptyView()
                }
                
                InformationGroup(title: "RECEIVE", style: .black, icon: Image(systemName: "arrow.down")) {
                    EmptyView()
                }
            }
            
            VStack {
                GroupBox {
                    ZStack {
                        VStack {
                            Image("shape - Nexus 4")
                                .resizable()
                                .clipped()
                                .aspectRatio(contentMode: .fit)
                                .opacity(0.8)
                        }
                        VStack {
                            Spacer()
                            Text("Open your USD account!")
                                .lineSpacing(5.0)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .fixedSize(horizontal: false, vertical: true)
                        }.frame(height: Const.largeComponentHeight)
                    }
                } label: {
                    VStack {
                        Text("MELD NEOBANK")
                            .foregroundColor(Color(red: 243 / 255, green: 168 / 255, blue: 192 / 255))
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }.groupBoxStyle(ColouredGroupBox(background: InformationGroupStyle.red.background))
                InformationGroup(title: "SEND", style: .red, icon: Image(systemName: "arrow.up")) {
                    EmptyView()
                }
            }
        }
    }
}

struct TilesView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TilesView()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}
