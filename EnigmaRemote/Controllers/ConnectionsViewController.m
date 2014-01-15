//
//  ConnectionsViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "NewConnectionViewController.h"
#import "ConnectionViewController.h"
#import "ApplicationSettings.h"

@interface ConnectionsViewController ()

@property (nonatomic, strong) NSArray *connections;
@property (nonatomic, strong) ApplicationSettings *settings;

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
    
    [self loadConnections];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup event handling
    [self.refreshControl addTarget:self
                            action:@selector(loadConnections)
                  forControlEvents:UIControlEventValueChanged];
    
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
    
    cell.textLabel.text = [self createConnectionText:connection];
    
    if (connection.favorite)
    {
        UIFont *font = [cell.textLabel.font copy];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:font.pointSize];
        cell.textLabel.textColor = [[[UIApplication sharedApplication] delegate] window].tintColor;
    }
    else
    {
        // TODO: is it possible to set textcolor to a default (instead of black) as in Interface Builder?
        UIFont *font = [cell.textLabel.font copy];
        cell.textLabel.font = [UIFont systemFontOfSize:font.pointSize];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // TODO: låt inte sender vara en datamodell
    
    BoxConnection *selectedConnection = [self.connections objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"viewConnection" sender:selectedConnection];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoxConnection *selectedConnection = [self.connections objectAtIndex:indexPath.row];
    [self changeFavoriteConnection:selectedConnection];
}

- (void)loadConnections
{
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        ApplicationSettings *settings = [[ApplicationSettings alloc] init];
                                
        NSArray *connections = settings.connections;
        
        // TODO: ta bort alla dessa kommentarer...
        
        // TODO: i detta fallet sortera i bokstavsordning...
        //NSArray* sortedJobs = [self sort:unsortedJobs];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // executed by main thread - OK to update UI
            self.connections = connections;
            [self.refreshControl endRefreshing];
        });
    });
    
}

#pragma mark - Implementation of ConnectionDelegate 
// TODO: Gör om detta helt!
// Skicka endast en komplett lista till settings och gör sedan save på hela listan!
// På så sätt behövs endast save och clear metoderna....

- (void)addBoxConnection:(BoxConnection *)connection
{
    /*
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    [settings addHost:connection];
    
    [settings save];
    
    [self loadConnections];
     */
    
    NSMutableArray *connections = [self.connections mutableCopy];
    [connections addObject:connection];
    
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    settings.connections = connections;
    
    [settings save];
    
    [self loadConnections];
}

- (void)updateBoxConnection:(BoxConnection *)connection
{
    /*
    // TODO: Gör detta bättre! Hur ska en update gå till? load laddar ju om listan och vi får nya pekare!
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    settings.connections = self.connections;
    
    [settings save];
    
    [self loadConnections];
    */
    
    // TODO: fundera igenom denna - arrayen är redan uppdaterad då objektet som returnerats redan uppdaterats
    // Behöver endast spara till disk och updatera mmi:et
    
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    settings.connections = self.connections;
    
    [settings save];
    
    [self loadConnections];

}

- (void)removeBoxConnection:(BoxConnection *)connection
{
    /*
    // TODO: Gör detta bättre! Hur ska en update gå till? load laddar ju om listan och vi får nya pekare!
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    //[settings removeHost:connection];
    settings.connections = self.connections;
    
    [settings save];
    
    [self loadConnections];
    */
    
    NSMutableArray *connections = [self.connections mutableCopy];
    [connections removeObject:connection];
    
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    settings.connections = connections;
    [settings save];
    
    [self loadConnections];
}

- (void)clear
{
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    [settings clear];
    
    [self loadConnections];
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
        // TODO: låt inte sender vara en datamodell
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BoxConnection *connection = [self.connections objectAtIndex:indexPath.row];
        
        if ([segue.destinationViewController isKindOfClass:[ConnectionViewController class]])
        {
            ConnectionViewController *viewCtrl = segue.destinationViewController;
            viewCtrl.delegate = self;
            viewCtrl.connection = connection;
        }
    }
}

#pragma mark - unwind handling

- (IBAction)unWindToConnectionsView:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self loadConnections];
}

#pragma mark - helpers

- (NSString *)createConnectionText:(BoxConnection *)connection
{
    if (connection.favorite)
    {
        // Return name with a checkmark in front
        return [NSString stringWithFormat:@"\u2713 %@", connection.name];
    }
    
    // Return the name without checkmark
    return [NSString stringWithFormat:@"\u2001 %@", connection.name];
}

- (void)changeFavoriteConnection:(BoxConnection *)newFavorite
{
    // TODO: update model, update UI
    
    for (BoxConnection *connection in self.connections)
    {
        [connection setAsFavorite:NO];
    }
    
    [newFavorite setAsFavorite:YES];
    
    ApplicationSettings *settings = [[ApplicationSettings alloc] init];
    
    settings.connections = self.connections;
    [settings save];
    
    // TODO: Update UI
    [self.tableView reloadData];
}

@end
