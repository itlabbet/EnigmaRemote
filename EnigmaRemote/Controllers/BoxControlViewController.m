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

@end

@implementation BoxControlViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toggleStandBy:(id)sender
{
    [[EnigmaClient sharedInstance] performAction:BoxCommandToggleStandBy];
}

- (IBAction)restart:(id)sender
{
    [[EnigmaClient sharedInstance] performAction:BoxCommandRestart];
}

- (IBAction)reboot:(id)sender
{
    [[EnigmaClient sharedInstance] performAction:BoxCommandReboot];
}

- (IBAction)shutdown:(id)sender
{
    [[EnigmaClient sharedInstance] performAction:BoxCommandShutDown];
}

@end
