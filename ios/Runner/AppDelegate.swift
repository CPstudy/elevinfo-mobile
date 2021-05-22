import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let cameraChannel = FlutterMethodChannel(name: "CameraActivity", binaryMessenger: controller.binaryMessenger)
    
    cameraChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        guard call.method == "startCameraActivity" else {
          result(FlutterMethodNotImplemented)
          return
        }
        ResultTon.shared.result = result
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "CameraController") as! CameraController
        //self.window?.rootViewController = homePage
        //self.window?.makeKeyAndVisible()
        
        //self.window?.rootViewController!.performSegue(withIdentifier: "moveCamera", sender: nil)
        
        //controller.performSegue(withIdentifier: "moveCamera", sender: nil)
        
        controller.present(homePage, animated: true, completion: nil)
        
        return
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
