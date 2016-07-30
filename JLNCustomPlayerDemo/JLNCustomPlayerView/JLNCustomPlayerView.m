//
//  JLNCustomPlayerView.m
//  JLNCustomPlayerDemo
//
//  Created by 林若琳 on 16/6/16.
//  Copyright © 2016年 JerryLin. All rights reserved.
//

#import "JLNCustomPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

@interface JLNCustomPlayerView ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@end

@implementation JLNCustomPlayerView


+(Class)layerClass{
    return [AVPlayerLayer class];
}

-(AVPlayer *)player{
    return [(AVPlayerLayer *)[self layer] player];
}

-(void)setPlayer:(AVPlayer *)player{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

-(void)dealloc{
    [self.player removeObserver:self forKeyPath:@"status"];
}

-(instancetype)init{
    if (self = [super init]) {
//        self.backgroundColor = [UIColor colorWithHue:0.8 saturation:0.4 brightness:0.7 alpha:1.0];
        [self setupSubviews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame andURL:(NSString *)url{
    if (self = [self initWithFrame:frame]) {
        self.mediaURL = url;
    }
    return self;
}

-(void) setupSubviews{
    
    [self.bottomView addSubview:self.timeLabel];
    [self.bottomView addSubview:self.fullScreenBtn];
    [self.bottomView addSubview:self.progressSlider];
    [self.bottomView addSubview:self.playBtn];
    [self addSubview:self.bottomView];
    
}

-(void) play{
    [self.player play];
}

-(void) pause{
    [self.player pause];
}

-(void) close{
    
}

-(void)layoutSubviews{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@60);
        make.leading.trailing.bottom.equalTo(self).offset(0);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.leading.equalTo(self.bottomView.mas_leading).offset(10);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-10);
    }];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.trailing.equalTo(self.bottomView.mas_trailing).offset(-10);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(-10);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-10);
    }];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.playBtn.mas_trailing).equalTo(@10);
        make.bottom.equalTo(self.playBtn.mas_bottom).equalTo(@(-10));
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).equalTo(@(-10));
    }];
}

#pragma mark - action
-(void)clickPlayBtn:(UIButton *)abtn{
    
    //按钮被选中，处于播放中
    if (abtn.selected) {
        [self.player pause];
    }
    //按钮未被选中，处于暂停状态
    else{
        [self.player play];
    }
    abtn.selected = !abtn.selected;
}

- (void) clickFullScreenBtn:(UIButton *)btn{
    //选中全屏
    if (btn.selected) {
        //本身view做逆时针旋转90°，然后调整自身frame
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        CGRect tmpFrame = self.frame;
        tmpFrame.size = CGSizeMake(self.frame.size.height, self.frame.size.width);
        self.frame = tmpFrame;
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
    }
    //退出全屏
    else{
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        CGRect tmpFrame = self.frame;
        tmpFrame.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        self.frame = tmpFrame;
    }
    btn.selected = !btn.selected;
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    AVPlayer *player = object;
    if ([keyPath isEqualToString:@"status"]) {
        switch (player.status) {
            case AVPlayerStatusReadyToPlay:
                NSLog(@"ready");
                self.playBtn.enabled = true;
                break;
            case AVPlayerStatusFailed:
                NSLog(@"failed");
                break;
            case AVPlayerStatusUnknown:
                NSLog(@"unknown");
            default:
                NSLog(@"default");
                break;
        }
    }
}
-(void)setTimeLabelText:(NSString *)text{
    self.timeLabel.text = text;
    [self.timeLabel sizeToFit];
}

#pragma mark - setter & getter
-(void)setMediaURL:(NSString *)mediaURL{
    if (_mediaURL != mediaURL) {
        _mediaURL = mediaURL;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"mp4"];
        NSURL *url = [NSURL fileURLWithPath:path];
        AVAsset *asset = [AVAsset assetWithURL:url];
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
//        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_mediaURL]];
        AVPlayer *tmpPlayer = [AVPlayer playerWithPlayerItem:item];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:tmpPlayer];
        playerLayer.frame = self.frame;
        [self setPlayer:tmpPlayer];
        [tmpPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.text = @"00:00/00:00";
    }
    return _timeLabel;
}

-(UISlider *)progressSlider{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
    }
    return _progressSlider;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor blackColor];
        _bottomView.alpha = 0.2;
    }
    return _bottomView;
}

-(UIButton *)fullScreenBtn{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [[UIButton alloc] init];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"btn_video_zoom_out"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"btn_video_zoom_in"] forState:UIControlStateSelected];
        _playBtn.showsTouchWhenHighlighted = true;
        [_fullScreenBtn addTarget:self action:@selector(clickFullScreenBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setImage:[UIImage imageNamed:@"btn_video_play_normal"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"btn_video_pause_normal"] forState:UIControlStateSelected];
        _playBtn.showsTouchWhenHighlighted = true;
        _playBtn.enabled = false;
        [_playBtn addTarget:self action:@selector(clickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

@end
