//
//  ChannelViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 05/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "ChannelViewController.h"
#import "EnigmaClient.h"

@interface ChannelViewController ()

@end

@implementation ChannelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [EnigmaClient zapTo:self.channel.reference];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
