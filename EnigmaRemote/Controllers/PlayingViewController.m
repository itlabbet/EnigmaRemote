//
//  PlayingViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 09/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "PlayingViewController.h"
#import "EnigmaClient.h"

@interface PlayingViewController ()

@property (nonatomic, strong) ChannelEPG *epg;

@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *currentProgramTitle;
@property (weak, nonatomic) IBOutlet UILabel *currentProgramTime;
@property (weak, nonatomic) IBOutlet UILabel *nextProgramTitle;
@property (weak, nonatomic) IBOutlet UILabel *nextProgramTime;

@end

@implementation PlayingViewController

- (void)setEpg:(ChannelEPG *)epg
{
    _epg = epg;
    
    [self updateUserInterface];
}

- (void)loadView
{
    [super loadView];
    
    [self loadNowPlaying];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // TODO: är det bäst att anropa [self updateUserInterface]; här eller i viewDidLoad?
}

- (void)loadNowPlaying
{
    //[self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        ChannelEPG *currentPlaying = [[EnigmaClient sharedInstance] currentPlaying];
        //[NSThread sleepForTimeInterval:1.0]; // enable to simulate slow network access
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // executed by main thread - OK to update UI
            self.epg = currentPlaying;
            //[self.refreshControl endRefreshing];
        });
    });
}

- (void)updateUserInterface
{
    if (self.epg)
    {
        // The channel
        self.serviceName.text = self.epg.currentEvent.serviceName;
        
        // Current event on this channel
        self.currentProgramTitle.text = self.epg.currentEvent.title;
        self.currentProgramTime.text = [self timeSpanForEvent:self.epg.currentEvent];

        // Next event on this channel
        self.nextProgramTitle.text = self.epg.nextEvent.title;
        self.nextProgramTime.text = [self timeSpanForEvent:self.epg.nextEvent];
    }
    else
    {
        self.serviceName.text = @"";
        
        // Current event on this channel
        self.currentProgramTitle.text = @"";
        self.currentProgramTime.text = @"";
        
        // Next event on this channel
        self.nextProgramTitle.text = @"";
        self.nextProgramTime.text = @"";

    }
    
    [self.tableView reloadData];
}

#pragma mark - helpers

- (NSString *)timeSpanForEvent:(EPGEvent *)event
{
    NSString *span = [NSString stringWithFormat:@"%@ - %@", event.startTime, [NSDate dateWithTimeInterval:event.duration sinceDate:event.startTime] ];
    
    return span;
}

@end
