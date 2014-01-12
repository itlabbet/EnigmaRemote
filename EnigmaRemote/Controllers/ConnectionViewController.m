//
//  ConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "ConnectionViewController.h"
#import "ConnectionsViewController.h"

@interface ConnectionViewController ()

@end

@implementation ConnectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Handling of UI events

- (IBAction)save:(id)sender
{
    BoxConnection *newConnection = nil;
   
    [self.delegate addBoxConnection:newConnection];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
