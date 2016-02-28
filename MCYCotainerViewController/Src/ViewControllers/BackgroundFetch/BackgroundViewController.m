//
//  BackgroundViewController.m
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/2/26.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import "BackgroundViewController.h"
#import "AppDelegate.h"

@interface BackgroundViewController () <NSURLSessionDataDelegate> {
    NSURLSession *inProcessSession;
    NSData *partialDownload;
    
    //buttons
    __weak IBOutlet UIButton *cancelAllBtn;
    __weak IBOutlet UIButton *backgroundFetchBtn;
    __weak IBOutlet UIButton *resumableBtn;
    __weak IBOutlet UIButton *cancellableBtn;
}

@end

@implementation BackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    
    self.backgroundSession.sessionDescription = @"Background session";
}

#pragma mark set方法
- (NSURLSession *)backgroundSession {
    static NSURLSession *backgroundSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"cn.com.cy.MCYCotainerViewController.backgroundSession"];
        backgroundSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    });
    return backgroundSession;
}

#pragma mark button Actions
- (IBAction)startCancellable:(UIButton *)sender {
    if (!self.cancellableTask) {
        if(!inProcessSession) {
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            inProcessSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            inProcessSession.sessionDescription = @"in-process NSURLSession";
        }
        
        NSString *urlStr = @"http://pica.nipic.com/2007-11-09/200711912453162_2.jpg";
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        self.cancellableTask = [inProcessSession downloadTaskWithRequest:request];
        [self setDownloadButtonsAsEnabled:NO];
        self.imgView.hidden = YES;
        [self.cancellableTask resume];
    }
}

- (IBAction)startResumable:(UIButton *)sender {
    if (!self.resumableTask) {
        if (!inProcessSession) {
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            inProcessSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            inProcessSession.sessionDescription = @"in-process NSURLSession";
        }
        
        if (partialDownload) {
            self.resumableTask = [inProcessSession downloadTaskWithResumeData:partialDownload];
        } else {
            NSString *urlStr = @"http://cdn.pcbeta.attachment.inimc.com/data/attachment/forum/201107/25/171344m55vxkgllgo87gbm.jpg";
            NSURL *url = [NSURL URLWithString:urlStr];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            self.resumableTask = [inProcessSession downloadTaskWithRequest:request];
        }
        
        [self setDownloadButtonsAsEnabled:NO];
        self.imgView.hidden = YES;
        [self.resumableTask resume];
    }
}

- (IBAction)startBackgroundFetch:(UIButton *)sender {
    NSString *urlStr = @"http://imgsrc.baidu.com/forum/pic/item/493e384e251f95ca53a2f639c9177f3e6609529a.jpg";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.backgroundTask = [self.backgroundSession downloadTaskWithRequest:request];
    [self setDownloadButtonsAsEnabled:NO];
    self.imgView.hidden = YES;
    [self.backgroundTask resume];
}

- (IBAction)cancelCancellable:(UIButton *)sender {
    if (self.cancellableTask) {
        [self.cancellableTask cancel];
        self.cancellableTask = nil;
    } else if (self.resumableTask) {
        [self.resumableTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            partialDownload = resumeData;
            self.resumableTask = nil;
        }];
    } else if (self.backgroundTask) {
        [self.backgroundTask cancel];
        self.backgroundTask = nil;
    }
}

#pragma mark 按钮事件
- (void)setDownloadButtonsAsEnabled:(BOOL)enabled
{
    cancellableBtn.enabled = enabled;
    resumableBtn.enabled = enabled;
    backgroundFetchBtn.enabled = enabled;
}

#pragma mark NSURLSessionDelegate methods
- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    double currProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.hidden = NO;
        self.progressView.progress = currProgress;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    //to do some thing...
}

- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentDirectory = URLs[0];
    NSURL *destinationPath = [documentDirectory URLByAppendingPathComponent:[location lastPathComponent]];
    
    NSError *error = nil;
    [fileManager removeItemAtURL:destinationPath error:NULL];
    BOOL success = [fileManager copyItemAtURL:location toURL:destinationPath error:&error];
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgView.image = [UIImage imageWithContentsOfFile:[destinationPath path]];
            self.imgView.contentMode = UIViewContentModeScaleAspectFit;
            self.imgView.hidden = NO;
        });
    } else {
        NSLog(@"could not copy file");
    }
    
    if (downloadTask == self.cancellableTask) {
        self.cancellableTask = nil;
    } else if (downloadTask == self.resumableTask) {
        self.resumableTask = nil;
        partialDownload = nil;
    } else {
        self.backgroundTask = nil;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.backgroundURLSessionCompletionHandler) {
            void (^handle)() = appDelegate.backgroundURLSessionCompletionHandler;
            appDelegate.backgroundURLSessionCompletionHandler = nil;
            handle();
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setDownloadButtonsAsEnabled:YES];
        self.progressView.hidden = YES;
    });
}

@end
