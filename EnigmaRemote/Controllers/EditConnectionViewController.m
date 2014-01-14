//
//  EditConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "EditConnectionViewController.h"
#import "EmbeddedEditConnectionViewController.h"


@interface EditConnectionViewController ()

@property (nonatomic, strong) EmbeddedEditConnectionViewController *embeddedController;

@end

@implementation EditConnectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.connection.name;
}

#pragma mark - Handling of UI events

- (IBAction)save:(id)sender
{
    [self updateModel];
    
    [self.delegate updateBoxConnection:self.connection];
    
    // TODO: för att dismissa en modal vy gör
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    // TODO: för att dismissa en modal vy gör
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedded"])
    {
        // Get embedded controller
        self.embeddedController = segue.destinationViewController;
        
        // Setup deletion delegate
        self.embeddedController.delegate = self;
        
        // Set values in edit views
        self.embeddedController.name = self.connection.name;
        self.embeddedController.ipAddress = self.connection.ipAddress;
        self.embeddedController.port = self.connection.port;
        self.embeddedController.username = self.connection.username;
        self.embeddedController.password = self.connection.password;
    }
}

#pragma mark - internal helpers

- (void)updateModel
{
    self.connection.name = self.embeddedController.name;
    self.connection.ipAddress = self.embeddedController.ipAddress;
    self.connection.port = self.embeddedController.port;
    self.connection.username = self.embeddedController.username;
    self.connection.password = self.embeddedController.password;
}

#pragma mark - DeleteDelegate implementation

- (void)delete
{
    [self.delegate removeBoxConnection:self.connection];
    
    // We need to unwind to the view connections view controller (2 steps back)
    // This is because the controller one step back is a view only controller
    // and we have just deleted the connection for that view
    
    [self performSegueWithIdentifier:@"toConnections" sender:self];
}

@end
