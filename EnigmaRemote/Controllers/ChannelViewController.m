//
//  ChannelViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 11/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "ChannelViewController.h"
#import "EnigmaClient.h"

@interface ChannelViewController ()

@property (nonatomic, strong) ChannelEPG *epg;

@property (weak, nonatomic) IBOutlet UIButton *channelButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *serviceCell;
@property (weak, nonatomic) IBOutlet UILabel *currentProgramTitle;
@property (weak, nonatomic) IBOutlet UILabel *currentProgramTime;
@property (weak, nonatomic) IBOutlet UITextView *currentProgramDescription;
@property (weak, nonatomic) IBOutlet UILabel *nextProgramTitle;
@property (weak, nonatomic) IBOutlet UILabel *nextProgramTime;
@property (weak, nonatomic) IBOutlet UITextView *nextProgramDescription;

@end

@implementation ChannelViewController

- (void)setEpg:(ChannelEPG *)epg
{
    _epg = epg;
    
    [self updateUserInterface]; // fill in user interface
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadEpg];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup event handling
    [self.refreshControl addTarget:self
                            action:@selector(loadEpg)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)loadEpg
{
    self.epg = nil;
    [self updateUserInterface]; // clear user interface
    
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        ChannelEPG *epg = [[EnigmaClient sharedInstance] channelEPGFor:self.epgEvent.serviceReference];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // executed by main thread - OK to update UI
            
            self.epg = epg;
            
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)updateUserInterface
{
    if (self.epg && self.epg.currentEvent.duration > 0)
    {
        // The channel - take the name from the channel insteal of from the EPG if the EPG is not filled
        // in (which might happen if the box has not received EPG information from the television signal).
        [self.channelButton setTitle:self.epgEvent.serviceName forState:UIControlStateNormal];
        
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
        [self.channelButton setTitle:self.epgEvent.serviceName forState:UIControlStateNormal];
        
        // Current event on this channel
        self.currentProgramTitle.text = @" ";
        self.currentProgramTime.text = @" ";
        self.currentProgramDescription.text = @" ";
        
        // Next event on this channel
        self.nextProgramTitle.text = @" ";
        self.nextProgramTime.text = @" ";
        self.nextProgramDescription.text = @" ";
        
    }
    
    [self.tableView reloadData];
}

#pragma mark - event handling

- (IBAction)zap:(id)sender
{
    [self zapAnimation];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [[EnigmaClient sharedInstance] zapTo:self.epgEvent.serviceReference];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    });
}

#pragma mark - helpers

- (NSString *)timeSpanForEvent:(EPGEvent *)event
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *span = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:event.startTime], [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:event.duration sinceDate:event.startTime]]];
    
    return span;
}



- (void)zapAnimation
{
    // Animate the click on the zap cell
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.serviceCell.selected = YES;
                     }
     
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2
                                          animations:^(void) {
                                              
                                              self.serviceCell.selected = NO;
                                          }
                          
                                          completion:^(BOOL finished) {
                                              
                                              
                                          }];
                         
                         
                     }];

}

@end
