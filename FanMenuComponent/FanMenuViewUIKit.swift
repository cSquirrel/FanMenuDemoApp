import UIKit
import SwiftUI

enum FanMenuEvent {
    case opened
    case closed
    case itemSelected(_:MenuItem)
}

struct FanMenuViewRepresentable: UIViewRepresentable {
    
    let callback: ((_: FanMenuEvent) -> Void)
    let isMenuPresented: Bool
    
    init(callback: (@escaping (_: FanMenuEvent) -> Void), isMenuPresented: Bool = false) {
        self.callback = callback
        self.isMenuPresented = isMenuPresented
    }
    
    func makeUIView(context: Context) -> FanMenuViewUIKit {
        let result = FanMenuViewUIKit(frame: CGRect.zero)
        result.callback = callback
        result.isMenuPresented = isMenuPresented
        return result
    }
    
    func updateUIView(_ uiView: FanMenuViewUIKit, context: Context) {
        uiView.updateMenu()
    }
}

enum TouchEvent {
    case touchesMoved(_: UITouch)
    case touchesEnded
}

class MainMenuItem: UIImageView {
    
    var callback: ((_: TouchEvent) -> Void)?

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        callback?(.touchesEnded)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard
            let touch = touches.first else { return }
        callback?(.touchesMoved(touch))
    }
}

class MenuItem: UIView {
    
    enum Const {
        static let padding = 0.0
    }
    
    var callback: ((_: TouchEvent) -> Void)?
    let imageView: UIImageView
    let label: String
    
    init(image: UIImage?, label: String) {
        imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        self.label = label
        super.init(frame: CGRect.zero)

        addSubview(imageView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 1.0
        callback?(.touchesEnded)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 0.2
        guard
            let touch = touches.first else { return }
        callback?(.touchesMoved(touch))
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 1.0
        callback?(.touchesEnded)
    }
}

class FanMenuViewUIKit: UIView {
    
    let mainMenuItem: MainMenuItem
    let menuItemStake: MenuItem
    let menuItemSend: MenuItem
    let menuItemReceive: MenuItem
    let menuItemSupply: MenuItem
    let menuItemBorrow: MenuItem
    let itemLabel: UILabel
    
    var isMenuPresented = false
    var selectedItem: MenuItem?
    
    var callback: ((_: FanMenuEvent) -> Void)?
    
    override init(frame: CGRect) {
        mainMenuItem = MainMenuItem(image: UIImage(named: "menu_button")!)
        menuItemStake = MenuItem(image: UIImage(named: "menu_item_stake")!, label: "Stake")
        menuItemSend = MenuItem(image: UIImage(named: "menu_item_send")!, label: "Send")
        menuItemReceive = MenuItem(image: UIImage(named: "menu_item_receive")!, label: "Receive")
        menuItemSupply = MenuItem(image: UIImage(named: "menu_item_supply")!, label: "Supply")
        menuItemBorrow = MenuItem(image: UIImage(named: "menu_item_borrow")!, label: "Borrow")
        itemLabel = UILabel()
        
        super.init(frame: frame)
        
        itemLabel.textAlignment = .center
        itemLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        itemLabel.textColor = .tileGrayTitle
        
        backgroundColor = .clear
        
        addSubview(mainMenuItem)
        addSubview(menuItemStake)
        addSubview(menuItemSend)
        addSubview(menuItemReceive)
        addSubview(menuItemSupply)
        addSubview(menuItemBorrow)
        addSubview(itemLabel)
        
        menuItemStake.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        menuItemSend.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        menuItemReceive.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        menuItemSupply.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        menuItemBorrow.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        updateMenu()
        
        menuItemStake.isUserInteractionEnabled = true
        menuItemStake.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuItemStakeSelected(_:))))
        menuItemSend.isUserInteractionEnabled = true
        menuItemSend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuItemSendSelected(_:))))
        menuItemReceive.isUserInteractionEnabled = true
        menuItemReceive.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuItemReceiveSelected(_:))))
        menuItemSupply.isUserInteractionEnabled = true
        menuItemSupply.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuItemSupplySelected(_:))))
        menuItemBorrow.isUserInteractionEnabled = true
        menuItemBorrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuItemBorrowSelected(_:))))
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleMenuFromBackground(_:))))
        self.isUserInteractionEnabled = true
        
        mainMenuItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleMenuFromButton(_:))))
        mainMenuItem.isUserInteractionEnabled = true
        mainMenuItem.callback = { touchEvent in
            switch touchEvent {
            case let .touchesMoved(touch):
                if !self.isMenuPresented {
                    self.isMenuPresented = true
                    self.callback?(.opened)
                }
                self.mainMenuItem.alpha = 0.0
                let location = touch.location(in: self)
                if self.menuItemStake.frame.contains(location) {
                    guard self.selectedItem != self.menuItemStake else { return }
                    UIView.animate(withDuration: 0.25) {
                        self.selectedItem?.transform = .identity
                    }
                    let selectedItem = self.menuItemStake
                    self.selectedItem = selectedItem
                    self.callback?(.itemSelected(selectedItem))
                    self.itemLabel.text = selectedItem.label
                    UIView.animate(withDuration: 0.25) {
                        selectedItem.transform = CGAffineTransformMakeScale(2, 2)
                    }
                } else if self.menuItemSend.frame.contains(location) {
                    guard self.selectedItem != self.menuItemSend else { return }
                    UIView.animate(withDuration: 0.25) {
                        self.selectedItem?.transform = .identity
                    }
                    let selectedItem = self.menuItemSend
                    self.selectedItem = selectedItem
                    self.callback?(.itemSelected(selectedItem))
                    self.itemLabel.text = selectedItem.label
                    UIView.animate(withDuration: 0.25) {
                        selectedItem.transform = CGAffineTransformMakeScale(2, 2)
                    }
                } else if self.menuItemReceive.frame.contains(location) {
                    guard self.selectedItem != self.menuItemReceive else { return }
                    UIView.animate(withDuration: 0.25) {
                        self.selectedItem?.transform = .identity
                    }
                    let selectedItem = self.menuItemReceive
                    self.selectedItem = selectedItem
                    self.callback?(.itemSelected(selectedItem))
                    self.itemLabel.text = selectedItem.label
                    UIView.animate(withDuration: 0.25) {
                        selectedItem.transform = CGAffineTransformMakeScale(2, 2)
                    }
                } else if self.menuItemSupply.frame.contains(location) {
                    guard self.selectedItem != self.menuItemSupply else { return }
                    UIView.animate(withDuration: 0.25) {
                        self.selectedItem?.transform = .identity
                    }
                    let selectedItem = self.menuItemSupply
                    self.selectedItem = selectedItem
                    self.callback?(.itemSelected(selectedItem))
                    self.itemLabel.text = selectedItem.label
                    UIView.animate(withDuration: 0.25) {
                        selectedItem.transform = CGAffineTransformMakeScale(2, 2)
                    }
                } else if self.menuItemBorrow.frame.contains(location) {
                    guard self.selectedItem != self.menuItemBorrow else { return }
                    UIView.animate(withDuration: 0.25) {
                        self.selectedItem?.transform = .identity
                    }
                    let selectedItem = self.menuItemBorrow
                    self.selectedItem = selectedItem
                    self.callback?(.itemSelected(selectedItem))
                    self.itemLabel.text = selectedItem.label
                    UIView.animate(withDuration: 0.25) {
                        selectedItem.transform = CGAffineTransformMakeScale(2, 2)
                    }
                } else {
                    UIView.animate(withDuration: 0.25) {
                        self.selectedItem?.transform = .identity
                    }
                    self.selectedItem = nil
                    self.itemLabel.text = nil
                    self.isMenuPresented = true
                    self.updateMenu()
                }
            case .touchesEnded:
                self.isMenuPresented = false
                UIView.animate(withDuration: 0.25) {
                    self.selectedItem?.transform = .identity
                }
                self.selectedItem = nil
                self.itemLabel.text = nil
                self.updateMenu()
                self.callback?(.closed)
            }
        }
    }
    
    @objc func toggleMenuFromButton(_ sender: UITapGestureRecognizer? = nil) {
        toggleMenu()
    }
    
    @objc func toggleMenuFromBackground(_ sender: UITapGestureRecognizer? = nil) {
        guard isMenuPresented else { return }
        toggleMenu()
    }
    
    @objc func menuItemStakeSelected(_ sender: UITapGestureRecognizer? = nil) {
        callback?(.itemSelected(menuItemStake))
        toggleMenu()
    }
    @objc func menuItemSendSelected(_ sender: UITapGestureRecognizer? = nil) {
        callback?(.itemSelected(menuItemSend))
        toggleMenu()
    }
    @objc func menuItemReceiveSelected(_ sender: UITapGestureRecognizer? = nil) {
        callback?(.itemSelected(menuItemReceive))
        toggleMenu()
    }
    @objc func menuItemSupplySelected(_ sender: UITapGestureRecognizer? = nil) {
        callback?(.itemSelected(menuItemSupply))
        toggleMenu()
    }
    @objc func menuItemBorrowSelected(_ sender: UITapGestureRecognizer? = nil) {
        callback?(.itemSelected(menuItemBorrow))
        toggleMenu()
    }
    
    func toggleMenu() {
        isMenuPresented = !isMenuPresented
        callback?(isMenuPresented ? .opened : .closed)
        updateMenu()
        self.selectedItem = nil
    }
    
    func updateMenu() {
        if isMenuPresented {
            self.menuItemStake.alpha = 1.0
            self.menuItemSend.alpha = 1.0
            self.menuItemReceive.alpha = 1.0
            self.menuItemSupply.alpha = 1.0
            self.menuItemBorrow.alpha = 1.0
            self.mainMenuItem.alpha = 0.0
        } else {
            self.menuItemStake.alpha = 0.0
            self.menuItemSend.alpha = 0.0
            self.menuItemReceive.alpha = 0.0
            self.menuItemSupply.alpha = 0.0
            self.menuItemBorrow.alpha = 0.0
            self.mainMenuItem.alpha = 1.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainMenuItem.frame = CGRect(x: frame.width / 2.0 - 40, y: frame.height - 80, width: 80, height: 80)
        menuItemStake.center = mainMenuItem.center.offsetBy(dx: 0, dy: -25).offsetBy(dx: -125, dy: -25)
        menuItemSend.center = mainMenuItem.center.offsetBy(dx: 0, dy: -25).offsetBy(dx: -65, dy: -55)
        menuItemReceive.center = mainMenuItem.center.offsetBy(dx: 0, dy: -25).offsetBy(dx: 0, dy: -65)
        menuItemSupply.center = mainMenuItem.center.offsetBy(dx: 0, dy: -25).offsetBy(dx: 65, dy: -55)
        menuItemBorrow.center = mainMenuItem.center.offsetBy(dx: 0, dy: -25).offsetBy(dx: 125, dy: -25)
        itemLabel.frame = CGRect(x: 0, y: frame.height - 200, width: frame.width, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct FanMenuViewUIKitDemo: View {
    
    let isMenuPresented: Bool
    
    var body: some View {
        FanMenuViewRepresentable(callback: { _ in }, isMenuPresented: isMenuPresented)
    }
}

struct FanMenuViewUIKitDemo_Previews: PreviewProvider {
    static var previews: some View {
        FanMenuViewUIKitDemo(isMenuPresented: false)
            .previewDisplayName("Menu Closed")
        FanMenuViewUIKitDemo(isMenuPresented: true)
            .previewDisplayName("Menu Opened")
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        CGPoint(x: self.x + dx, y: self.y + dy)
    }
}
