//
//  BouquetsViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 09/12/13.
//  Copyright (c) 2013 Niklas Andersson. All rights reserved.
//

#import "BouquetsViewController.h"
#import "ChannelsViewController.h"  // needed to remove undeclared selecor warning...
#import "EnigmaClient.h"
#import "Bouquet.h"


@interface BouquetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *bouquets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
    
@end

@implementation BouquetsViewController

- (void)setBouquets:(NSArray *)bouquets
{
    _bouquets = bouquets;
    
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
    
    [self loadBouquets];
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

- (void)loadBouquets
{
    //[self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        NSArray *bouquets = [[EnigmaClient sharedInstance] bouquets];
        //NSArray* sortedJobs = [self sort:unsortedJobs];
        //[NSThread sleepForTimeInterval:1.0]; // enable to simulate slow network access
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // executed by main thread - OK to update UI
            self.bouquets = bouquets;
            //[self.refreshControl endRefreshing];
        });
    });

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bouquets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BouquetCell" forIndexPath:indexPath];
    Bouquet *bouquet = self.bouquets[indexPath.row];
    
    cell.textLabel.text = bouquet.name;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        if (indexPath)
        {
            if ([[segue identifier] isEqualToString:@"showChannels" ])
            {
                // TODO: bli kvitt denna varning!
                if ([segue.destinationViewController respondsToSelector:@selector(setBouquet:)])
                {
                    Bouquet *bouquet = [self.bouquets objectAtIndex:indexPath.row];
                    
                    // TODO: bli kvitt denna varning!
                    [segue.destinationViewController performSelector:@selector(setBouquet:) withObject:bouquet];
                }
            }
        }
    }
}


@end
