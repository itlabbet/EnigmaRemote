//
//  ViewConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "ViewConnectionViewController.h"
#import "EditConnectionViewController.h"

@interface ViewConnectionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *ipAddress;
@property (weak, nonatomic) IBOutlet UITextField *port;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewConnectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editConnection"])
    {
        if ([segue.destinationViewController isKindOfClass:[EditConnectionViewController class]])
        {
            EditConnectionViewController *editCtrl = segue.destinationViewController;
            editCtrl.delegate = self;
            editCtrl.connection = self.connection;
        }
    }
}

@end
