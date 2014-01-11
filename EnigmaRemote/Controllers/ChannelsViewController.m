//
//  ChannelsViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 09/12/13.
//  Copyright (c) 2013 Niklas Andersson. All rights reserved.
//

#import "ChannelsViewController.h"
#import "ChannelViewControllerTmp.h"   // To remove undeclared selector warning
#import "EnigmaClient.h"
#import "Channel.h"

@interface ChannelsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *channels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChannelsViewController

- (void)setChannels:(NSArray *)channels
{
    _channels = channels;
    
    [self.tableView reloadData];
}

- (void)loadView
{
    [super loadView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadChannels];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView flashScrollIndicators];
}

- (void)loadChannels
{
    //[self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        NSArray *channels = [[EnigmaClient sharedInstance] channelsFor:self.bouquet.reference];
        //NSArray* sortedJobs = [self sort:unsortedJobs];
        //[NSThread sleepForTimeInterval:1.0]; // enable to simulate slow network access
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // executed by main thread - OK to update UI
            self.channels = channels;
            //[self.refreshControl endRefreshing];
        });
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell" forIndexPath:indexPath];
    Channel *channel = self.channels[indexPath.row];
    
    cell.textLabel.text = channel.name;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        if (indexPath)
        {
            if ([[segue identifier] isEqualToString:@"showChannel" ])
            {
                if ([segue.destinationViewController respondsToSelector:@selector(setChannel:)])
                {
                    Channel *channel = [self.channels objectAtIndex:indexPath.row];
                    
                    [segue.destinationViewController performSelector:@selector(setChannel:) withObject:channel];
                }
            }
        }
    }
}

@end
