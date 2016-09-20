//
//  GuideViewController.m
//  PokectDog
//
//  Created by 石少庸 on 15/9/23.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController ()<UIScrollViewDelegate>

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH * 4, 0);
    scroll.pagingEnabled = YES;
    scroll.userInteractionEnabled = YES;
    scroll.delegate = self;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    
    for (int i = 0; i < 4; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d",i + 1]];
        imageView.userInteractionEnabled = YES;
        [scroll addSubview:imageView];
        
        if (i == 3)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            button.frame  = CGRectMake(SCREEN_WIDTH - RESIZE_UI(96) - RESIZE_UI(185), SCREEN_HEIGHT - RESIZE_UI(100), RESIZE_UI(185), RESIZE_UI(55));
            [imageView addSubview:button];
            
            [button addTarget:self action:@selector(startHuaMu) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    [self.view addSubview:scroll];
}

- (void)startHuaMu {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingGuide" object:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x  > 3 *SCREEN_WIDTH) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingGuide" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
