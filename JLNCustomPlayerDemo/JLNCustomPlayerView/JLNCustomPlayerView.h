//
//  JLNCustomPlayerView.h
//  JLNCustomPlayerDemo
//
//  Created by 林若琳 on 16/6/16.
//  Copyright © 2016年 JerryLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLNCustomPlayerView : UIView

@property (nonatomic, strong) NSString *mediaURL;

-(void) play;
-(void) pause;
-(void) close;

@end
