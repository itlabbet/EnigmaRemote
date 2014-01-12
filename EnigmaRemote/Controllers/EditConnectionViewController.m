//
//  EditConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "EditConnectionViewController.h"


@interface EditConnectionViewController ()

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
    // TODO:
    BoxConnection *updatedConnection = nil;
    
    [self.delegate updateBoxConnection:updatedConnection];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)remove:(id)sender
{
    // TODO:
    BoxConnection *removedConnection = nil;
    
    [self.delegate removeBoxConnection:removedConnection];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
