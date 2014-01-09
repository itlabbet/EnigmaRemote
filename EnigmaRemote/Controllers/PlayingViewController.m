//
//  PlayingViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 09/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "PlayingViewController.h"
#import "EnigmaClient.h"

// TODO: Hantera fallet då boxen är avstängd - då returneras

@interface PlayingViewController ()

@property (nonatomic, strong) ChannelEPG *epg;

@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *currentProgramTitle;
@property (weak, nonatomic) IBOutlet UILabel *currentProgramTime;
@property (weak, nonatomic) IBOutlet UITextView *currentProgramDescription;
@property (weak, nonatomic) IBOutlet UILabel *nextProgramTitle;
@property (weak, nonatomic) IBOutlet UILabel *nextProgramTime;
@property (weak, nonatomic) IBOutlet UITextView *nextProgramDescription;

@end

@implementation PlayingViewController

- (void)setEpg:(ChannelEPG *)epg
{
    _epg = epg;
    
    [self updateUserInterface]; // fill in user interface
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadNowPlaying];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refreshControl addTarget:self
                            action:@selector(loadNowPlaying)
                  forControlEvents:UIControlEventValueChanged];

}

- (void)loadNowPlaying
{
    self.epg = nil;
    [self updateUserInterface]; // clear user interface
    
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        ChannelEPG *currentPlaying = [[EnigmaClient sharedInstance] currentPlaying];
        //[NSThread sleepForTimeInterval:1.0]; // enable to simulate slow network access
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // executed by main thread - OK to update UI
            self.epg = currentPlaying;
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)updateUserInterface
{
    if (self.epg && self.epg.currentEvent.duration > 0)
    {
        // The channel
        self.serviceName.text = self.epg.currentEvent.serviceName;
        
        // Current event on this channel
        self.currentProgramTitle.text = self.epg.currentEvent.title;
        self.currentProgramTime.text = [self timeSpanForEvent:self.epg.currentEvent];
        self.currentProgramDescription.text = self.epg.currentEvent.extendedDescription;

        // Next event on this channel
        self.nextProgramTitle.text = self.epg.nextEvent.title;
        self.nextProgramTime.text = [self timeSpanForEvent:self.epg.nextEvent];
        self.nextProgramDescription.text = self.epg.nextEvent.extendedDescription;
    }
    else
    {
        self.serviceName.text = @"";
        
        // Current event on this channel
        self.currentProgramTitle.text = @"";
        self.currentProgramTime.text = @"";
        self.currentProgramDescription.text = @"";
        
        // Next event on this channel
        self.nextProgramTitle.text = @"";
        self.nextProgramTime.text = @"";
        self.nextProgramDescription.text = @"";

    }
    
    [self.tableView reloadData];
}

#pragma mark - helpers

- (NSString *)timeSpanForEvent:(EPGEvent *)event
{
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"HH:mm";
    
    NSString *span = [NSString stringWithFormat:@"%@ - %@", [timeFormatter stringFromDate:event.startTime], [timeFormatter stringFromDate:[NSDate dateWithTimeInterval:event.duration sinceDate:event.startTime]]];
    
    return span;
}

@end
