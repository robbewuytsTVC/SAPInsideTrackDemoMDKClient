//import UIKit
//
//@objc(PongGameControllerBridge)
//public class PongGameControllerBridge: UIViewController {
//
//
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//            
//        let pongView = PongGameRepresentable().makeUIView(context: PongGameRepresentable.Context())
//        pongView.frame = self.view.frame
//        self.view = pongView
//    }
//    
//    public override init() {
//
//    }
//    
//
//   
//}
import SwiftUI

@objc(PongGameControllerBridge)
class ContentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)
        
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        hostingController.didMove(toParent: self)
    }
}
