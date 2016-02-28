//
//  BackgroundViewController.h
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/2/26.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundViewController : UIViewController

@property (strong, nonatomic) NSURLSessionDownloadTask *resumableTask;
@property (strong, nonatomic) NSURLSessionDownloadTask *backgroundTask;
@property (strong, nonatomic) NSURLSessionDownloadTask *cancellableTask;
@property (strong, nonatomic, readonly) NSURLSession *backgroundSession;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end
