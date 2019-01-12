//
//  CameraControoler.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/6.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController:UIViewController,AVCapturePhotoCaptureDelegate,UIViewControllerTransitioningDelegate{
    
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupHUD()
        transitioningDelegate = self
        
    }
    
    let customViewAnimated = CustomAnimationPresentor()
    let customViewDismisser = CustomDismisser()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customViewAnimated
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customViewDismisser
    }
    
    
    fileprivate func setupHUD() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0), size: CGSize(width: 80, height: 80))
     
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        
        dismissButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 12), size: CGSize(width: 50, height: 50))
   
    }
    
      let output = AVCapturePhotoOutput()
    
    @objc func handleCapturePhoto() {
        print("Capturing photo...")
       
        let setting = AVCapturePhotoSettings()
        //Old method... part 1
//        guard let key = setting.availablePreviewPhotoPixelFormatTypes.first else {return}
//        setting.previewPhotoFormat = [ kCVPixelBufferPixelFormatTypeKey as String:key]
     
        output.capturePhoto(with: setting, delegate: self)
        
        
        
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let insteadData = photo.fileDataRepresentation() else {return}
        let image = UIImage(data: insteadData)
        
        let previewVIew = PreviewPhotoContainerView()
            previewVIew.previewImageView.image = image
            view.addSubview(previewVIew)
        previewVIew.fillSuperview()
        
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
        //Old method... part 2
    
    //    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//
//        let insteadData = AVCapturePhoto().fileDataRepresentation()
//
//
//        let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
//        let image = UIImage(data: insteadData!)
//
//        let previewIMage = UIImageView(image: image)
//        view.addSubview(previewIMage)
//        previewIMage.fillSuperview()
//
//    }
    
    fileprivate func setupCaptureSession(){
        
        let captureSession = AVCaptureSession()
        
        
        
//        1.input
        guard let deviceInput = AVCaptureDevice.default(for: .video) else {return}
        do {
            let input =  try AVCaptureDeviceInput(device: deviceInput)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
        }catch let err {
            print(err.localizedDescription)
        }
        
//        2/output
         if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
//        preview layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
    }
    
    
    
    
    
}
