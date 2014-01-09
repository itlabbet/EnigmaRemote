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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/

@end
