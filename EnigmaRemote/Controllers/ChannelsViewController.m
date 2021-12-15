//
//  ChannelsViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 09/12/13.
//  Copyright (c) 2013 Niklas Andersson. All rights reserved.
//

#import "ChannelsViewController.h"
#import "ChannelViewController.h" // To remove undeclared selector warning
#import "EnigmaClient.h"
#import "Channel.h"

@interface ChannelsViewController ()

@property (strong, nonatomic) NSArray *epgEvents;

@end

@implementation ChannelsViewController

- (void)setEpgEvents:(NSArray *)epgEvents
{
    _epgEvents = epgEvents;
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = self.bouquet.name;
    
    // Setup event handling
    [self.refreshControl addTarget:self
                            action:@selector(loadEpgEvents)
                  forControlEvents:UIControlEventValueChanged];

    [self loadEpgEvents];
}

- (void)loadEpgEvents
{
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        //NSArray *epgEvents = [[EnigmaClient sharedInstance] channelsWithEpgFor:self.bouquet.reference];
        
        NSArray *epgEvents = [[EnigmaClient sharedInstance] channelsWithEpgFixedFor:self.bouquet.reference];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // executed by main thread - OK to update UI
            
            self.epgEvents = epgEvents;
            
            [self.refreshControl endRefreshing];
        });
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.epgEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell" forIndexPath:indexPath];
    EPGEvent *epgEvent = self.epgEvents[indexPath.row];
    
    cell.textLabel.text = epgEvent.serviceName;
    cell.detailTextLabel.text = [self eventDetailsFor:epgEvent];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    EPGEvent *selectedChannel = [self.epgEvents objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showChannel" sender:selectedChannel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EPGEvent *selectedChannel = [self.epgEvents objectAtIndex:indexPath.row];
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    
    [self zapAnimation:selectedCell];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [[EnigmaClient sharedInstance] zapTo:selectedChannel.serviceReference];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showChannel" ])
    {
        if ([sender isKindOfClass:[EPGEvent class]])
        {
            EPGEvent *epgEvent = sender;
            
            if ([segue.destinationViewController respondsToSelector:@selector(setEpgEvent:)])
            {
                [segue.destinationViewController performSelector:@selector(setEpgEvent:) withObject:epgEvent];
            }
        }
    }
}

#pragma mark - internal helpers

- (NSString *)eventDetailsFor:(EPGEvent *)event
{
    NSString *details = [NSString stringWithFormat:@"%@ %@", [self timeSpanForEvent:event], event.title];
    
    return details;
}

- (NSString *)timeSpanForEvent:(EPGEvent *)event
{
    
    if (event.startTime != nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        
        NSString *span = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:event.startTime], [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:event.duration sinceDate:event.startTime]]];
    
        return span;
        
    }
    
    return @"";
}

- (void)zapAnimation:(UITableViewCell *)cell
{
    // Animate the click on the zap cell
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         cell.selected = YES;
                     }
     
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2
                                          animations:^(void) {
                                              
                                              cell.selected = NO;
                                          }
                          
                                          completion:^(BOOL finished) {
                                              
                                              
                                          }];
                         
                         
                     }];
    
}


@end
