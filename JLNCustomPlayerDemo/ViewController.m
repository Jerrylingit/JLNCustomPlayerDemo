//
//  ViewController.m
//  JLNCustomPlayerDemo
//
//  Created by 林若琳 on 16/6/16.
//  Copyright © 2016年 JerryLin. All rights reserved.
//

#import "ViewController.h"
#import "JLNCustomPlayerView.h"

NSString *const remoteVideoURL = @"http://183.2.219.207/sohu/s26h23eab6/xdispatch/sohu.vod.qingcdn.com/176/252/RD9iPy8AEc3te94Ekx1Q8L.mp4?key=JgMQ4rBFfEU6-xI6D9GDADhQXT1hgsNL&n=1&a=1822&cip=183.48.87.247&prod=app";
//NSString *const remoteVideoURL = @"http://14.29.86.12/music.qqvideo.tc.qq.com/b0020op7h63.p301.1.mp4?vkey=3A70B4967225A3DEDDE678CCD598BDC0C8F50170EF5D7E1CD708057FB1159177859BF9CD5AD2D57D37EBC3E53A5C106A24F235B6E3A51444AAE9EA9712AFA8B36EAB65AB9505AF3D74058711B1699BC5D94D9C38603CA76D&locid=7703bb82-a704-4f37-b177-020d7c456e51&size=31705757&ocid=300556204";


@interface ViewController ()
@property (nonatomic, strong) JLNCustomPlayerView *playerView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
}

-(void) setupViews{
    self.playerView.hidden = false;
}

#pragma mark - setter & getter

-(JLNCustomPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[JLNCustomPlayerView alloc] init];
        _playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _playerView.frame = self.view.bounds;
        [self.view addSubview:_playerView];
        _playerView.mediaURL = remoteVideoURL;
    }
    return _playerView;
}



@end
