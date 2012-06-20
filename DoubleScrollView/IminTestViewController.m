//
//  IminTestViewController.m
//  DoubleScrollView
//
//  Created by oh-sang Kwon, on 12. 6. 18..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "IminTestViewController.h"
#import "iToast.h"
typedef enum {
    CURRENT_LEFT_SIDE = 0,
    CURRENT_RIGHT_SIDE
} TIMELINE_SIDE;

#define FOOT_IMAGE_FRAME CGRectMake(320 - 52 - 35 ,5, 52, 52);
@interface IminTestViewController (){
    TIMELINE_SIDE CURRENT_SIDE;
    BOOL isHorizontalRefresh;

}
- (void)willRigitTableLeave;
- (void)willLeftTableLeave;

@end

@implementation IminTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // navigationBar
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /* 상단 네비게이션 이미지 정의 : iOS5일 때와 iOS5 미만 버전일 경우 구분 */
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f)  {
        UIImage* bgImg = [[UIImage imageNamed:@"topbar_common.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [[self.navigationController navigationBar] setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    } else {
//        UIImage* bgImg = [[UIImage imageNamed:@"topbar_common.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//        [[[self.navigationController navigationBar] layer] setContents:(id)[bgImg CGImage]];
    }

    self.title = @"My FootPrint";

    //상단 Text 추가
    UILabel *titleView = [[UILabel alloc] init];
    [titleView setFont:[UIFont boldSystemFontOfSize:18]];
    [titleView setTextColor:[UIColor blackColor]];
    titleView.text = self.title;
    titleView.backgroundColor = [UIColor clearColor];
    [titleView sizeToFit];

    self.navigationItem.titleView = titleView;


    UIImage *image = [UIImage imageNamed:@"btn_foot_mini.png"];
    iconButton = [[UIButton alloc] init];
    [iconButton setImage:image forState:UIControlStateNormal];
    [iconButton addTarget:self action:@selector(onCheckTouched:) forControlEvents:UIControlEventTouchUpInside];

    iconButton.frame = FOOT_IMAGE_FRAME;
    [self.navigationController.navigationBar addSubview:iconButton];

    UIPanGestureRecognizer *onTap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(futureEffect:)];
    [iconButton addGestureRecognizer:onTap];


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // content
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    _scrollView.contentSize = CGSizeMake(570, 480);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    

    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 480) style:UITableViewStylePlain];
    leftTableView.dataSource = self;
    leftTableView.delegate = self;
    leftTableView.backgroundColor = [UIColor clearColor];
    leftTableView.tag = 1;
    leftTableView.showsVerticalScrollIndicator = NO;
//    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:leftTableView];
    
    UITableView *middleScrollView = [[UITableView alloc] initWithFrame:CGRectMake(250, 0, 70, 480) style:UITableViewStylePlain];
    middleScrollView.dataSource = self;
    middleScrollView.delegate = self;
    middleScrollView.backgroundColor = [UIColor clearColor];
    middleScrollView.tag = 2;
//    middleScrollView.separatorStyle = UITableViewCellSeparatorStyleNone;
    middleScrollView.showsVerticalScrollIndicator = NO;
    [_scrollView addSubview:middleScrollView];
    
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 250, 480) style:UITableViewStylePlain];
    rightTableView.dataSource = self;
    rightTableView.delegate = self;
    rightTableView.backgroundColor = [UIColor clearColor];
    rightTableView.tag = 3;
//    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:rightTableView];
    
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onLeftViewGesture:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftTableView addGestureRecognizer:leftGesture];
    
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onRightViewGesture:)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [rightTableView addGestureRecognizer:rightGesture];

    CURRENT_SIDE = CURRENT_LEFT_SIDE;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1000;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (tableView.tag) {
        case 2:
        {

            _scrollView.userInteractionEnabled = NO;
            [self performSelector:@selector(next:) withObject:nil afterDelay:0];

            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicatorView.center = [[self.view viewWithTag:1] center];
            activityIndicatorView.tag = 10;
            [_scrollView addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];

        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"table tag : %i", tableView.tag);

    switch (tableView.tag) {
        case 1:
            return 150;
        case 3:
            return 550;
        default:
        {
            UITableView *v = nil;
            if (CURRENT_SIDE == CURRENT_LEFT_SIDE){
                v =(UITableView*)[self.view viewWithTag:1];
            } else {
                v =(UITableView*)[self.view viewWithTag:3];
            }
            CGRect frame = [v rectForRowAtIndexPath:indexPath];
            return frame.size.height;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    switch (tableView.tag) {
        case 1:
        case 3:
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"test";
            break;
        }
        default:
        {
            NSString *cellName = @"middleCell";
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];

                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont boldSystemFontOfSize:10];
                label.text = @"10:30";
                [cell addSubview:label];

                UIImageView *lineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line.png"]];
                UIImageView *bigDotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point.png"]];

                CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
                if (CURRENT_SIDE == CURRENT_RIGHT_SIDE) {

                    if (isHorizontalRefresh){
                        lineImageView.frame = CGRectMake(7, 0, 4, [UIScreen mainScreen].bounds.size.height);
                        bigDotImageView.frame = CGRectMake(0, 30, 18, 18);
                        [UIView animateWithDuration:0.3 animations:^(void){
                            lineImageView.frame = CGRectMake(70-11, 0, 4, height);
                            bigDotImageView.frame = CGRectMake(70-18, 30, 18, 18);
                        }];
                    } else {
                        lineImageView.frame = CGRectMake(70-11, 0, 4, height);
                        bigDotImageView.frame = CGRectMake(70-18, 30, 18, 18);
                    }

                    label.frame = CGRectMake(10, 31, 40, 15);
                    label.textAlignment = UITextAlignmentLeft;
                }else{
                    if (isHorizontalRefresh){
                        lineImageView.frame = CGRectMake(70-11, 0, 4, [UIScreen mainScreen].bounds.size.height);
                        bigDotImageView.frame = CGRectMake(70-18, 30, 18, 18);
                        [UIView animateWithDuration:0.3 animations:^(void){
                            lineImageView.frame = CGRectMake(7, 0, 4, height);
                            bigDotImageView.frame = CGRectMake(0, 30, 18, 18);
                        }];

                    } else {
                        lineImageView.frame = CGRectMake(7, 0, 4, height);
                        bigDotImageView.frame = CGRectMake(0, 30, 18, 18);
                    }

                    label.frame = CGRectMake(20, 31, 40, 15);
                    label.textAlignment = UITextAlignmentRight;

                }

                [cell addSubview:lineImageView];
                [cell addSubview:bigDotImageView];
            }
            break;
        }
    }
    return cell;
    
}

#pragma mark - method for header & icon
- (void)onCheckTouched:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"발도장 찍힘" message:nil delegate:nil cancelButtonTitle:@"ok"  otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)futureEffect:(UIPanGestureRecognizer *)recognizer {
//    NSLog(@"recognizer.state : %i", recognizer.state);
    CGRect frame = FOOT_IMAGE_FRAME;
    switch (recognizer.state) {
        case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:0.10 animations:^{
                iconButton.frame = FOOT_IMAGE_FRAME;

            } completion:^(BOOL finished) {
            }];
            break;
        }


        case UIGestureRecognizerStateChanged:
        {

            CGPoint translation = [recognizer translationInView:iconButton];
            NSLog(@"translation : %@", NSStringFromCGPoint(translation));
            iconButton.frame = CGRectMake(iconButton.frame.origin.x, translation.y+iconButton.frame.origin.y, iconButton.bounds.size.width, iconButton.bounds.size.height);
            [recognizer setTranslation:CGPointZero inView:iconButton];


            CGFloat len = translation.y+iconButton.frame.origin.y - frame.origin.y;
            NSLog(@"len : %f", len);

            if (len <= 100) {
                [[[iToast makeText:@"nothing."] setDuration:iToastDurationShort] show];
            }else if (len > 100 && len <= 200) {
                if (translation.x < -30) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"발도장 찍힘" message:nil delegate:nil cancelButtonTitle:@"ok"  otherButtonTitles:nil, nil];
                    [alertView show];
                }else {
                    [[[iToast makeText:@"1 day after."] setDuration:iToastDurationShort] show];
                }
            }else if(len <=300){

                [[[iToast makeText:@"2 day after."] setDuration:iToastDurationShort] show];

            } else {

                [[[iToast makeText:@"further future."] setDuration:iToastDurationShort] show];
            }
            break;

        }
        default:
            break;
    }
}

#pragma mark - method for Scroll
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    UITableView *v = (UITableView*)[self.view viewWithTag:2];

    [v beginUpdates];
    isHorizontalRefresh = true;
    [v reloadRowsAtIndexPaths:[v indexPathsForVisibleRows]
             withRowAnimation:UITableViewRowAnimationAutomatic];

    [v endUpdates];

    isHorizontalRefresh = false;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    switch (scrollView.tag) {
        case 1:
        case 3:
        {
            UITableView *v = (UITableView*)[self.view viewWithTag:2];
            v.contentOffset = scrollView.contentOffset;
        }
            break;
        case 2:
        {
            
            UITableView *v = nil;
            if (CURRENT_SIDE == CURRENT_LEFT_SIDE) {
                v = (UITableView*)[self.view viewWithTag:1];   
            } else {
                v = (UITableView*)[self.view viewWithTag:3];
            }
            v.contentOffset = scrollView.contentOffset;
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - method for Gesture

- (void)onRightViewGesture:(UIPanGestureRecognizer *)recognizer {
//    NSLog(@"recognizer.state : %i", recognizer.state);

    switch (recognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateChanged:
        {
            [self willLeftTableLeave];
        }
            break;
        default:
            break;
    }
}

- (void)onLeftViewGesture:(UIPanGestureRecognizer *)recognizer {
//    NSLog(@"recognizer.state : %i", recognizer.state);

    switch (recognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateChanged:
        {
            [self willRigitTableLeave];
        }
            break;
        default:
            break;
    }
}


#pragma mark - method for Event
- (void)willLeftTableLeave {

    UITableView *v = (UITableView*)[self.view viewWithTag:2];
    v.contentOffset = CGPointMake(0, 0);

    [UIView transitionWithView:_scrollView
                              duration:0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^(void){
                                CURRENT_SIDE = CURRENT_LEFT_SIDE;
                                [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                            }
                            completion:^(BOOL finished){
                            }];
}

- (void)willRigitTableLeave {

    UITableView *v = (UITableView*)[self.view viewWithTag:2];
    v.contentOffset = CGPointMake(0, 0);

    [UIView transitionWithView:_scrollView
                              duration:0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^(void){
                                CURRENT_SIDE = CURRENT_RIGHT_SIDE;
                                [_scrollView setContentOffset:CGPointMake(250, 0) animated:YES];
                            }
                            completion:^(BOOL finished){
                            }];
}

-(void)next:(id)sender{
    [NSThread sleepForTimeInterval:2];
    _scrollView.userInteractionEnabled = YES;
    [[_scrollView viewWithTag:10] removeFromSuperview];
    
    //    if (CURRENT_LEFT_SIDE == CURRENT_LEFT_SIDE){
    //        [_scrollView setContentOffset:CGPointMake(250, 0) animated:YES];
    //    } else {
    //        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    //    }
    
}

@end
