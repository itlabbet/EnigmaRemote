//
//  SettingsViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 09/12/13.
//  Copyright (c) 2013 Niklas Andersson. All rights reserved.
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadDeviceInfo];
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
