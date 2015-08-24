//
//  FirstViewController.m
//  EVideoPlayer
//
//  Created by Ethan.Qiu on 15/3/8.
//  Copyright (c) 2015年 ucanmobile. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)play:(id)sender {
    
    UINavigationController *player=[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"player"]];
    [self presentViewController:player animated:YES completion:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [UIApplication sharedApplication].statusBarHidden=NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
