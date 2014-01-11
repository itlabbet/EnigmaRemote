//
//  ChannelViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 05/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "ChannelViewControllerTmp.h"
#import "EnigmaClient.h"

@interface ChannelViewControllerTmp ()

@property (nonatomic, strong) ChannelEPG *epg;

@end

@implementation ChannelViewControllerTmp

- (void)setEpg:(ChannelEPG *)epg
{
    _epg = epg;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[EnigmaClient sharedInstance] zapTo:self.channel.reference];
    
    [self loadEPG];
}

#pragma mark - Internal

- (void) loadEPG
{
    //[self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        ChannelEPG *epg = [[EnigmaClient sharedInstance] channelEPGFor:self.channel.reference];
        //[NSThread sleepForTimeInterval:1.0]; // enable to simulate slow network access
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // executed by main thread - OK to update UI
            self.epg = epg;
            //[self.refreshControl endRefreshing];
        });
    });
}

@end
