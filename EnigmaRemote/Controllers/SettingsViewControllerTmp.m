//
//  SettingsViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 09/12/13.
//  Copyright (c) 2013 Niklas Andersson. All rights reserved.
//

#import "SettingsViewControllerTmp.h"
#import "EnigmaClient.h"

@interface SettingsViewControllerTmp ()

@property (nonatomic, strong) DeviceInfo *deviceInfo;

@end

@implementation SettingsViewControllerTmp


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
	// Do any additional setup after loading the view.
}

- (void) loadDeviceInfo
{
    //[self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        DeviceInfo *deviceInfo = [[EnigmaClient sharedInstance] deviceinfo];
        //[NSThread sleepForTimeInterval:1.0]; // enable to simulate slow network access
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // executed by main thread - OK to update UI
            self.deviceInfo = deviceInfo;
            //[self.refreshControl endRefreshing];
        });
    });
}

@end
