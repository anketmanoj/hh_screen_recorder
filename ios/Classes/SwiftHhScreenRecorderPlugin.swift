import Flutter
import UIKit
import ReplayKit
import Photos


public class SwiftHhScreenRecorderPlugin: NSObject, FlutterPlugin, RPPreviewViewControllerDelegate {
  
    var flutterRes : FlutterResult?
    var outputURL = ""
   
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "hh_screen_recorder", binaryMessenger: registrar.messenger())
    let instance = SwiftHhScreenRecorderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func tempURL() -> URL? {
    let directory = NSTemporaryDirectory() as NSString
        
    if directory != "" {
        let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
        return URL(fileURLWithPath: path)
    } 
    return nil
}



  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
   

    flutterRes = result
      
    if (call.method == "startRecording")
    {
        print("HHRecorder: Start Recording")
       
        RPScreenRecorder.shared().startRecording { err in
          guard err == nil else {
              print("HHRecorder: Error starting recording: \(err.debugDescription)")
              result(false)
              return }
            
            print("HHRecorder: Started recording.")
            result(true)
        }
        
    }
    else if call.method == "stopRecording" {
      RPScreenRecorder.shared().stopRecording { (preview, error) in
        if let error = error {
          result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
          return
        }
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        if let lastAsset = fetchResult.firstObject {
          let options = PHVideoRequestOptions()
          options.isNetworkAccessAllowed = true
          PHImageManager.default().requestAVAsset(forVideo: lastAsset, options: options) { (avAsset, _, _) in
            if let avAsset = avAsset as? AVURLAsset {
              result(avAsset.url.path)
            } else {
              result(FlutterError(code: "ERROR", message: "Unable to retrieve file path", details: nil))
            }
          }
        } else {
          result(FlutterError(code: "ERROR", message: "No screen recording found", details: nil))
        }
      }
    } 
    else if (call.method == "pauseRecording") 
    {
        result(false)
    }
    else if (call.method == "resumeRecording") 
    {
        result(false)
    }
    else if (call.method == "isPauseResumeEnabled") 
    {
        result(false)
    }
    else if (call.method == "isRecordingSupported")
    {
        // iOS 9.0+ is always supported on HH
        result(true)
    } else if (call.method == "getScreenRecordingDirectory")
{
    let screenRecordingDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    result(screenRecordingDirectory.path)
}
    else
    {
        result(false)
        // result(FlutterMethodNotImplemented)
    }
  }

  public func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
      
      UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true)
      // flutterRes?(self.outputURL)
      print("HHRecorder: Stopped recording")

    }
}
