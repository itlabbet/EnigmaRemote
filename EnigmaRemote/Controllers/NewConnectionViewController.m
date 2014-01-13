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
    BoxConnection *newConnection = [self createConnection];
   
    [self.delegate addBoxConnection:newConnection];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BoxConnection *)createConnection
{
    // TODO: gå ej direkt på MMI:et för att hämta data utan gå via en metod, gör MMI:et private!
    
    NSInteger port = [self.embeddedController.port.text integerValue];
    
    
    BoxConnection *connection = [[BoxConnection alloc] initWithName:self.embeddedController.name.text
                                                          ipAddress:self.embeddedController.ipAddress.text
                                                               port:port
                                                           username:self.embeddedController.username.text
                                                           password:self.embeddedController.password.text
                                                           favorite:YES]; // TODO: Hantera favoriter
    
    return connection;}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"i förälder %@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"embedded"])
    {
        self.embeddedController = segue.destinationViewController;
    }
}

@end
