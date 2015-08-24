//
//  AVPlayerManager.h
//  EVideoPlayer
//
//  Created by Ethan.Qiu on 15/2/28.
//  Copyright (c) 2015年 ucanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>
typedef void(^AVPlayerManagerFailedBlock)(NSError *error);
//播放状态改变
typedef void(^AVPlayerManagerPlayingStatusChangedBlock)(BOOL isPlaying);
//准备完毕，可以播放了
typedef void(^AVPlayerManagerReadyToPlayBlock)();
//播放结束
typedef void(^AVPlayerManagerPlayEndBlock)();
//播放时间改变
typedef void(^AVPlayerManagerCurrentTimeChanged)(double currentTime);
//声音发生改变，主要是按音量键
typedef void(^AVPlayerManagerVolumeChanged)();
//缓冲回调
typedef void(^AVPlayerManagerBufferChanged)(double bufferedSecond);
/*
//开始预缓冲
typedef void(^AVPlayerManagerBufferBegin)();
//结束预缓冲
typedef void(^AVPlayerManagerBufferEnd)();
 */

@interface AVPlayerManager : NSObject
/**
 *  Called when an asset fails to prepare for playback
 */
@property(nonatomic,copy) AVPlayerManagerFailedBlock failedBlock;
@property(nonatomic,copy) AVPlayerManagerPlayingStatusChangedBlock statusChangeBlock;
@property(nonatomic,copy) AVPlayerManagerReadyToPlayBlock readyToPlayBlock;
@property(nonatomic,copy) AVPlayerManagerPlayEndBlock playEndBlock;
@property(nonatomic,copy) AVPlayerManagerCurrentTimeChanged timeChangedBlock;
@property(nonatomic,copy) AVPlayerManagerVolumeChanged volumeChangedBlock;
@property(nonatomic,copy) AVPlayerManagerBufferChanged bufferChangedBlock;
//@property(nonatomic,copy) AVPlayerManagerBufferBegin preBufferBeginBlock;
//@property(nonatomic,copy) AVPlayerManagerBufferEnd preBufferEndBlock;


@property(nonatomic,assign,readonly) BOOL isPlaying;
@property(nonatomic,assign) double duration;
@property(nonatomic,assign) double currentTime;
@property(nonatomic,assign) UIView *mPlaybackView;
@property(nonatomic,strong) NSURL *URL;
@property(nonatomic,assign) UISlider *scrubSlider;
@property(nonatomic,assign) float volume;
@property(nonatomic,assign,readonly) double bufferedSecond;
@property(nonatomic,assign) float rate;
/**
 *  网速，单位kb/s
 */
@property(nonatomic,assign,readonly) float bufferSpeed;
//网络视频需要预缓冲多少，例如5，表示缓冲的数据至少需要5秒
//@property(nonatomic,assign) float preCacheSecond;
//当准备完毕后会自动播放
-(void)prepare;
-(void)play;
-(void)seekTo:(float)time;
-(void)pause;
@end
