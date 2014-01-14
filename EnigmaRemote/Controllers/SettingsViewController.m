//
//  SettingsViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 09/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "SettingsViewController.h"
#import "EnigmaClient.h"

@interface SettingsViewController ()

@property (nonatomic, strong) DeviceInfo *deviceInfo;

@end

@implementation SettingsViewController

- (void)setDeviceInfo:(DeviceInfo *)deviceInfo
{
    _deviceInfo = deviceInfo;
}

- (void)loadView
{
    [super loadView];
    
    [self loadDeviceInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) loadDeviceInfo
{
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        DeviceInfo *deviceInfo = [[EnigmaClient sharedInstance] deviceInfo];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // executed by main thread - OK to update UI
            self.deviceInfo = deviceInfo;
        });
    });
}

@end
