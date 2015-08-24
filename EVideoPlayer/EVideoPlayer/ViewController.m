//
//  ViewController.m
//  EVideoPlayer
//
//  Created by Ethan.Qiu on 15/2/28.
//  Copyright (c) 2015年 ucanmobile. All rights reserved.
//

#import "ViewController.h"
#import "AVPlayerDemoPlaybackView.h"
#import "AVPlayerManager.h"
@interface ViewController ()
{
    
    CGRect viewBounds;
    UITapGestureRecognizer *tapHideUI;
    CGPoint center1;
    CGPoint center2;

}
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UISlider *scrubSlider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIView *processView;
@property (weak, nonatomic) IBOutlet UIProgressView *processBar;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlBottomConstraint;


@property(nonatomic,strong)AVPlayerDemoPlaybackView *playBackView;
@property(nonatomic,strong)AVPlayerManager *playerManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//   [UIApplication sharedApplication].statusBarHidden=YES;
    [self.navigationController.navigationBar setBarTintColor:self.controlsView.backgroundColor];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back)];
    
    viewBounds=CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,self.view.bounds.size.width,self.view.bounds.size.height);
    UIScreen *screen = [UIScreen mainScreen];
    if (![screen respondsToSelector:@selector(fixedCoordinateSpace)] && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        viewBounds=CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,self.view.bounds.size.height,self.view.bounds.size.width);
    }
    self.playBtn.hidden=YES;
    self.pauseBtn.hidden=YES;
    self.playBtn.enabled=NO;
    self.pauseBtn.enabled=NO;
    self.currentTimeLabel.text=[self convertTimetoString:0];
    self.totalTimeLabel.text=[self convertTimetoString:0];
    [self.scrubSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [self.scrubSlider setMaximumTrackImage:[UIImage imageNamed:@"sliderbg_2"] forState:UIControlStateNormal];
    [self.scrubSlider setMinimumTrackImage:[UIImage imageNamed:@"sliderbg"] forState:UIControlStateNormal];
    [self.volumeSlider setMinimumTrackTintColor:[UIColor lightGrayColor]];
    [self.volumeSlider setMaximumTrackTintColor:[UIColor blackColor]];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"vslider"] forState:UIControlStateNormal];
    
    self.processBar.progressTintColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.processBar.trackTintColor=[UIColor clearColor];
   
        

    
    [self createPlayer];
    
    self.volumeSlider.value=self.playerManager.volume;
    
    tapHideUI=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    tapHideUI.numberOfTapsRequired=1;
    tapHideUI.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:tapHideUI];

    
}
-(void)createPlayer
{

    self.playBackView=[[AVPlayerDemoPlaybackView alloc] initWithFrame:viewBounds];
    [self.view addSubview:self.playBackView];
    
    self.playerManager=[[AVPlayerManager alloc] init];
    //设置url
    //self.playerManager.URL=[[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp4"];
    //self.playerManager.URL=[[NSBundle mainBundle] URLForResource:@"2" withExtension:@"mov"];
    self.playerManager.URL=[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];
    //设置播放界面
    self.playerManager.mPlaybackView=self.playBackView;
    //设置时间轴
    self.playerManager.scrubSlider=self.scrubSlider;
    //播放出错回调
    self.playerManager.failedBlock=^(NSError *error){
        if (error) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[error description] message:[error debugDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    };
    __weak ViewController *weakself=self;
    //播放状态改变
    self.playerManager.statusChangeBlock=^(BOOL isPlaying){
        weakself.playBtn.hidden=isPlaying;
        weakself.pauseBtn.hidden=!isPlaying;
    };
    //播放结束
    self.playerManager.playEndBlock=^(){
        NSLog(@"播放结束");
    };
    //准备好播放
    self.playerManager.readyToPlayBlock=^(){
        weakself.totalTimeLabel.text=[weakself convertTimetoString:weakself.playerManager.duration];
        weakself.playBtn.enabled=YES;
        weakself.pauseBtn.enabled=YES;
        [weakself.playerManager play];
   
        
    };
    //播放过程时间改变
    self.playerManager.timeChangedBlock=^(double time)
    {
        weakself.currentTimeLabel.text=[weakself convertTimetoString:time];
    };
    //声音发生改变
    self.playerManager.volumeChangedBlock=^(){
        weakself.volumeSlider.value=weakself.playerManager.volume;
    };
    //缓冲时间
    self.playerManager.bufferChangedBlock=^(double buffered){
        weakself.processBar.progress=buffered/weakself.playerManager.duration;
        weakself.speedLabel.text=[NSString stringWithFormat:@"%0.0fkb/s",weakself.playerManager.bufferSpeed];
    };
    
    //初始化完毕，准备播放
    [self.playerManager prepare];
   
    
}
- (NSString *)convertTimetoString:(double)time
{
    
    if (time==0)
    {
        return @"00:00";
    }
    
    NSUInteger dMinutes = floor((int)time/ 60);
    NSUInteger dSeconds = floor((int)time%60);
    
    NSString *timeString = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
    return timeString;
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    if (self.navigationController.navigationBarHidden) {
        [self showUI];
    }
    else
    {
        [self hideUI];
    }
}
-(void)showUI
{

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.controlBottomConstraint.constant=0;
    [self.processView setNeedsUpdateConstraints];
    [self.controlsView setNeedsUpdateConstraints];

    [UIView animateWithDuration:0.5 animations:^{
        [self.processView layoutIfNeeded];
        [self.controlsView layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}
-(void)hideUI
{
  
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.controlBottomConstraint.constant=self.processView.frame.origin.y-viewBounds.size.height;
    [self.processView setNeedsUpdateConstraints];
    [self.controlsView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5 animations:^{
          [self.processView layoutIfNeeded];
          [self.controlsView layoutIfNeeded];
 
    } completion:^(BOOL finished) {
          }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view sendSubviewToBack:self.playBackView];
}

- (IBAction)play:(id)sender
{
    [self.playerManager play];
}

- (IBAction)pause:(id)sender
{
    [self.playerManager pause];
}

- (IBAction)volumeChanged:(id)sender
{
    self.playerManager.volume=((UISlider *)sender).value;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
