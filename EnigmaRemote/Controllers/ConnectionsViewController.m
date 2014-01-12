//
//  ConnectionsViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "NewConnectionViewController.h"
#import "ViewConnectionViewController.h"
#import "ApplicationSettings.h"

@interface ConnectionsViewController ()

@property (nonatomic, strong) NSArray *connections;

@end


@implementation ConnectionsViewController

- (void)setConnections:(NSArray *)connections
{
    _connections = connections;
    
    [self.tableView reloadData];
}


- (void)loadView
{
    [super loadView];
    
    // TODO: se till att alla data laddas i loadView
    
    [self loadConnections];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.connections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConnectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    BoxConnection *connection = [self.connections objectAtIndex:indexPath.row];
    
    cell.textLabel.text = connection.name;
    
    return cell;
}

- (void)loadConnections
{
    //[self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        ApplicationSettings *settings = [[ApplicationSettings alloc] init];
                                
        NSArray *connections = settings.connections;
        
        // TODO: ta bort alla dessa kommentarer...
        
        // TODO: i detta fallet sortera i bokstavsordning...
        //NSArray* sortedJobs = [self sort:unsortedJobs];
        //[NSThread sleepForTimeInterval:1.0]; // enable to simulate slow network access
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // executed by main thread - OK to update UI
            self.connections = connections;
            //[self.refreshControl endRefreshing];
        });
    });
    
}

#pragma mark - Implementation of ConnectionDelegate 

- (void)addBoxConnection:(BoxConnection *)connection
{
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    [settings addHost:connection];
    
    [settings save];
    
    [self loadConnections];
}

- (void)updateBoxConnection:(BoxConnection *)connection
{
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    settings.connections = self.connections;
    
    [settings save];
    
    [self loadConnections];
}

- (void)removeBoxConnection:(BoxConnection *)connection
{
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    [settings removeHost:connection];
    
    [settings save];
    
    [self loadConnections];
}

- (void)clear
{
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    [settings clear];
}

#pragma mark - event handlers

- (IBAction)add:(UIBarButtonItem *)sender
{
    // TODO: Verkar inte gå att sätta upp en modal segue via storyboarden direkt från knappen
    [self performSegueWithIdentifier:@"newConnection" sender:self];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newConnection"])
    {
        if ([segue.destinationViewController isKindOfClass:[NewConnectionViewController class]])
        {
            NewConnectionViewController *newCtrl = segue.destinationViewController;
            newCtrl.delegate = self;
        }
    }
    else if ([segue.identifier isEqualToString:@"viewConnection"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BoxConnection *connection = [self.connections objectAtIndex:indexPath.row];
        
        if ([segue.destinationViewController isKindOfClass:[ViewConnectionViewController class]])
        {
            ViewConnectionViewController *viewCtrl = segue.destinationViewController;
            viewCtrl.delegate = self;
            viewCtrl.connection = connection;
        }
    }
}



@end
