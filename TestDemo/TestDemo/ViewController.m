//
//  ViewController.m
//  LFYGroupAvatarMaker
//
//  Created by 路飞 on 17/4/3.
//  Copyright © 2017年 Luffy. All rights reserved.
//

#import "ViewController.h"
#import "LFYGroupAvatarMaker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat avatarWidth = 60;
    CGFloat spacing = ([UIScreen mainScreen].bounds.size.width - 3 * avatarWidth) / 4;
    
    for (int i = 0; i < 12; i++) {
        CGPoint orign = CGPointMake(spacing + (spacing + avatarWidth) * (i % 3),
                                    avatarWidth + (spacing + avatarWidth)* (i / 3));
        CGRect avatarRect = CGRectMake(orign.x, orign.y, avatarWidth, avatarWidth);
        
        if (i <= 7) {
            [self makeAvatarWithImageSize:avatarRect
                           numberOfAvatar:i + 2
                              avatarModel:LFYGroupAvatarModelWeChat];
        } else {
            [self makeAvatarWithImageSize:avatarRect
                           numberOfAvatar:i - 6
                              avatarModel:LFYGroupAvatarModelQQ];
        }
    }
}

- (void)makeAvatarWithImageSize:(CGRect)avatarRect
                 numberOfAvatar:(NSInteger)numberOfAvatar
                    avatarModel:(LFYGroupAvatarModel)aModel {
    UIImageView *aBackImageView = [[UIImageView alloc]
                                   initWithFrame:avatarRect];
    [self.view addSubview:aBackImageView];
    
    NSArray *rsArray = [[self dataSource] subarrayWithRange:NSMakeRange(0, MIN(numberOfAvatar, 9))];
    
    LFYGroupAvatarMaker *maker = [LFYGroupAvatarMaker new];
    
    [aBackImageView setImage:[maker makeGroupHeader:aModel
                                         headerSize:avatarRect.size
                                         dataSource:rsArray]];
}

- (NSArray *)dataSource {
    NSArray *resource = @[@"张l", @"你好", @"李d", @"张四", @"再见", @"赵于成", @"李d", @"good", @"hello"] ;
    
    return resource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
}

@end
