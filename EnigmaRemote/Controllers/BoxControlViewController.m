//
//  BoxControlViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 06/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "BoxControlViewController.h"
#import "EnigmaClient.h"

@interface BoxControlViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *standbyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *restartCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *rebootCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *shutdownCell;

@end

@implementation BoxControlViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)toggleStandBy:(id)sender
{
    [self zapAnimation:self.standbyCell];
    [[EnigmaClient sharedInstance] performAction:BoxCommandToggleStandBy];
}

- (IBAction)restart:(id)sender
{
    [self zapAnimation:self.restartCell];
    
    [[EnigmaClient sharedInstance] performAction:BoxCommandRestart];
}

- (IBAction)reboot:(id)sender
{
    [self zapAnimation:self.rebootCell];
    
    [[EnigmaClient sharedInstance] performAction:BoxCommandReboot];
}

- (IBAction)shutdown:(id)sender
{
    [self zapAnimation:self.shutdownCell];
    [[EnigmaClient sharedInstance] performAction:BoxCommandShutDown];
}

- (void)zapAnimation:(UITableViewCell *)cell
{
    // Animate the click on the zap cell
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         cell.selected = YES;
                     }
     
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2
                                          animations:^(void) {
                                              
                                              cell.selected = NO;
                                          }
                          
                                          completion:^(BOOL finished) {
                                              
                                              
                                          }];
                         
                         
                     }];
    
}


@end
