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

    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [[EnigmaClient sharedInstance] performAction:BoxCommandToggleStandBy];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    });
    
}

- (IBAction)restart:(id)sender
{
    [self zapAnimation:self.restartCell];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [[EnigmaClient sharedInstance] performAction:BoxCommandRestart];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    });
}

- (IBAction)reboot:(id)sender
{
    [self zapAnimation:self.rebootCell];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [[EnigmaClient sharedInstance] performAction:BoxCommandReboot];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    });
    
}

- (IBAction)shutdown:(id)sender
{
    [self zapAnimation:self.shutdownCell];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [[EnigmaClient sharedInstance] performAction:BoxCommandShutDown];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    });
    
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
