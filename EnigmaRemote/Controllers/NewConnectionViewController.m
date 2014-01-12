//
//  ConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "NewConnectionViewController.h"

@interface NewConnectionViewController ()

@end

@implementation NewConnectionViewController

- (void)setDelegate:(id<ConnectionsDelegate>)delegate
{
    _delegate = delegate;
}

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
