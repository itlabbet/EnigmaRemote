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
}

#pragma mark - Handling of UI events

- (IBAction)save:(id)sender
{
    [self performSegueWithIdentifier:@"unwindUpdateConnection" sender:self];
}

- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedded"])
    {
        // Get embedded controller
        self.embeddedController = segue.destinationViewController;
        
        // Set values in edit views
        self.embeddedController.id   = self.id;
        self.embeddedController.name = self.name;
        self.embeddedController.ipAddress = self.ipAddress;
        self.embeddedController.port = self.port;
        self.embeddedController.username = self.username;
        self.embeddedController.password = self.password;
    }
    else if ([segue.identifier isEqualToString:@"unwindUpdateConnection"])
    {
        // Get values from edit controller
        self.id = self.embeddedController.id;
        self.name = self.embeddedController.name;
        self.ipAddress = self.embeddedController.ipAddress;
        self.port = self.embeddedController.port;
        self.username = self.embeddedController.username;
        self.password = self.embeddedController.password;
    }
}

@end
