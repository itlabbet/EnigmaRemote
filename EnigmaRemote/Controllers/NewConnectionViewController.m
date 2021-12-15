//
//  ConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "NewConnectionViewController.h"
#import "EmbeddedNewConnectionViewController.h"

@interface NewConnectionViewController ()

@property (nonatomic, weak) EmbeddedNewConnectionViewController *embeddedController;

@end

@implementation NewConnectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Handling of UI events

- (IBAction)save:(id)sender
{
    [self performSegueWithIdentifier:@"unwindAddNewConnection" sender:nil];
}

- (IBAction)cancel:(id)sender
{
    [self performSegueWithIdentifier:@"unwindCancelNewConnection" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // The embedded UITableView controller
    if ([segue.identifier isEqualToString:@"embedded"])
    {
        self.embeddedController = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"unwindCancelNewConnection"])
    {
        // Do nothing - just let the unwind happen
    }
    else if ([segue.identifier isEqualToString:@"unwindAddNewConnection"])
    {
        // Get the properties of the new connection before unwinding
        self.id = [[[NSUUID alloc] init] UUIDString];
        self.name = self.embeddedController.name;
        self.ipAddress = self.embeddedController.ipAddress;
        self.port = self.embeddedController.port;
        self.username = self.embeddedController.username;
        self.password = self.embeddedController.password;
    }
}


@end
