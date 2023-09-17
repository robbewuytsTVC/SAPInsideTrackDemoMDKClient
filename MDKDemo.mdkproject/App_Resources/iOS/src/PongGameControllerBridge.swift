import SwiftUI

//Expose this class to objective-c, needed for MDK framework
@objc(PongGameControllerBridge)

//UIKit controller class
class ContentViewController: UIViewController {
    
    //Lifecycle method to check if the view has been loaded into the memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //New instance of a SwiftUI view
        let contentView = ContentView()
        
        // Bridge between SwiftUI and UIKit,
        // needed because MDK works with UIKit (UIView) and we want to use the newer the SwiftUI technology
        let hostingController = UIHostingController(rootView: contentView)
        addChild(hostingController)
        
        //No auto-resizing
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        //Add view to controller's view hierarchy
        view.addSubview(hostingController.view)
        
        //Fill entire screen
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}