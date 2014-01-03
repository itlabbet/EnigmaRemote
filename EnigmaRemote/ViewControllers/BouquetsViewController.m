//
//  BouquetsViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 09/12/13.
//  Copyright (c) 2013 Niklas Andersson. All rights reserved.
//

#import "BouquetsViewController.h"
#import "EnigmaClient.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self loadBouquets];
}

- (void)loadBouquets
{
    //[self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        NSArray *bouquets = [EnigmaClient bouquets];
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
    id bouquet = self.bouquets[indexPath.row];
    
    id bouquetNameId = [bouquet objectForKey:@"e2servicename"];
    
    NSString *name = [NSString stringWithFormat:@"%@", bouquetNameId];
    NSString *cleanedName = [name stringByTrimmingCharactersInSet: [NSCharacterSet newlineCharacterSet]];

    cell.textLabel.text = cleanedName;

    return cell;
}

@end
