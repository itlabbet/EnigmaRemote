//
//  DeviceInfoViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 09/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "EnigmaClient.h"

@interface DeviceInfoViewController ()

@property (nonatomic, strong) DeviceInfo *deviceInfo;

@property (weak, nonatomic) IBOutlet UILabel *boxModel;
@property (weak, nonatomic) IBOutlet UILabel *enigmaVersion;
@property (weak, nonatomic) IBOutlet UILabel *imageVersion;
@property (weak, nonatomic) IBOutlet UILabel *webInterfaceVersion;
@property (weak, nonatomic) IBOutlet UILabel *tunerName;
@property (weak, nonatomic) IBOutlet UILabel *tunerModel;


@end

@implementation DeviceInfoViewController

- (void)setDeviceInfo:(DeviceInfo *)deviceInfo
{
    _deviceInfo = deviceInfo;
    
    [self updateUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadDeviceInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refreshControl addTarget:self
                            action:@selector(loadDeviceInfo)
                  forControlEvents:UIControlEventValueChanged];
    
}

- (void)loadDeviceInfo
{
    self.deviceInfo = nil;
    
    [self updateUserInterface]; // clear user interface
   
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        DeviceInfo *deviceInfo = [[EnigmaClient sharedInstance] deviceInfo];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // executed by main thread - OK to update UI
            
            self.deviceInfo = deviceInfo;
            
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)updateUserInterface
{
    if (self.deviceInfo)
    {
        self.boxModel.text = self.deviceInfo.deviceName;
        self.enigmaVersion.text = self.deviceInfo.enigmaVersion;
        self.imageVersion.text = self.deviceInfo.imageVersion;
        self.webInterfaceVersion.text = self.deviceInfo.webifVersion;
        self.tunerName.text = self.deviceInfo.tunerName;
        self.tunerModel.text = self.deviceInfo.tunerModel;
    }
    else
    {
        self.boxModel.text = @" ";
        self.enigmaVersion.text = @" ";
        self.imageVersion.text = @" ";
        self.webInterfaceVersion.text = @" ";
        self.tunerName.text = @" ";
        self.tunerModel.text = @" ";
    }
    
    [self.tableView reloadData];
}
@end
