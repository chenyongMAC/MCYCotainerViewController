//
//  BackgroundSessionViewController.swift
//  Oneday
//
//  Created by iYww on 16/2/28.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class BackgroundSessionViewController: UIViewController {
  
  enum ResumableDownloadTaskState {
    case NotStart
    case Processing
    case Suspend(portailData: NSData)
    case Complete
  }
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var bgTaskButton: UIButton!
  @IBOutlet weak var cancelAllTaskButton: UIButton!
  @IBOutlet weak var resumableTaskButton: UIButton!
  
  lazy var currentSession: NSURLSession = {
    let sessionConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
    return NSURLSession(configuration: sessionConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
  }()
  var resumableDownloadTask: NSURLSessionDownloadTask?
  var resumableDownloadTaskState: ResumableDownloadTaskState = .NotStart
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func resumableDownloadTaskStateSwitched(sender: UIButton) {
    switch resumableDownloadTaskState {
    case .NotStart:
      startResumableDownloadTask()
    case .Processing:
      suspendResumableDownloadTask()
    case .Suspend(portailData: let data):
      resumeResumableDownloadTaskWithData(data)
    case .Complete:
      break
    }
  }
  
}

// MARK: - NSURLSession delegate
extension BackgroundSessionViewController: NSURLSessionDownloadDelegate {
  
  func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    self.progressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
  }
  
  func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
//    let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//    let fullPath = (documentPath as NSString).stringByAppendingPathComponent(downloadTask.response!.suggestedFilename!)
//    do {
//      try NSFileManager.defaultManager().moveItemAtURL(location, toURL: NSURL(fileURLWithPath: fullPath))
//    }catch let error {
//      print(error)
//      return
//    }
//    guard let image = UIImage(contentsOfFile: fullPath) else {
//      print("Image parse error")
//      return
//    }
//    imageView.image = image
    print("finished")
  }
  
  func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
    print(error)
  }
  
}

// MARK: - Resumable download task methods
extension BackgroundSessionViewController {
  
  private func startResumableDownloadTask() {
    guard let url = NSURL(string: "http://120.25.226.186:32812/resources/videos/minion_02.mp4") else {
      print("URL error")
      return
    }
    let request = NSURLRequest(URL: url)
    resumableDownloadTask = currentSession.downloadTaskWithRequest(request)
    resumableDownloadTask?.resume()
    resumableDownloadTaskState = .Processing
    resumableTaskButton.setTitle("Prosessing", forState: .Normal)
  }
  
  private func suspendResumableDownloadTask() {
    guard let resumableDownloadTask = resumableDownloadTask else { return }
    resumableTaskButton.setTitle("Suspend", forState: .Normal)
    resumableDownloadTask.cancelByProducingResumeData { data in
      self.resumableDownloadTaskState = .Suspend(portailData: data!)
    }
  }
  
  private func resumeResumableDownloadTaskWithData(data: NSData) {
    resumableDownloadTask = currentSession.downloadTaskWithResumeData(data)
    resumableDownloadTask?.resume()
    resumableTaskButton.setTitle("Processing", forState: .Normal)
  }
  
}