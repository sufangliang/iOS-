//
//  EAGuideView.m
//  mobile
//
//  Created by ChenLei on 15/10/8.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EAGuideView.h"

@implementation EAGuideView
{
    UIScrollView *_scrollView;
    UIImageView *_guideImgView1;
    UIImageView *_guideImgView2;
    UIImageView *_guideImgView3;
    UIPageControl *_pageCtrl;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _guideImgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _guideImgView1.image = [UIImage imageNamed:@"guideImg1"];
        _guideImgView1.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_guideImgView1];
        
        _guideImgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
        _guideImgView2.image = [UIImage imageNamed:@"guideImg2"];
        _guideImgView2.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_guideImgView2];
        
        _guideImgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * 2, 0, frame.size.width, frame.size.height)];
        _guideImgView3.image = [UIImage imageNamed:@"guideImg3"];
        _guideImgView3.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_guideImgView3];
        
        _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake((frame.size.width - 50) / 2, kScreenHeight > 480 ? frame.size.height - 80 : frame.size.height - 40, 50, 20)];
        _pageCtrl.numberOfPages = 3;
        [self addSubview:_pageCtrl];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((frame.size.width - 200) / 2, kScreenHeight > 480 ? frame.size.height - 150 : frame.size.height - 100, 200, 45);
        btn.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:107.0/255.0 blue:47.0/255.0 alpha:1];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"立即体验" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(didClickDismiss:) forControlEvents:UIControlEventTouchUpInside];
        [_guideImgView3 addSubview:btn];
        _guideImgView3.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)didClickDismiss:(id)sender
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageCtrl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

@end
