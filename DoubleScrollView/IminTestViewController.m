//
//  IminTestViewController.m
//  DoubleScrollView
//
//  Created by oh-sang Kwon, on 12. 6. 18..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "IminTestViewController.h"

@interface IminTestViewController ()

@end

@implementation IminTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    _scrollView.contentSize = CGSizeMake(570, 480);
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];

    

    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 480)];
    leftTableView.dataSource = self;
    leftTableView.delegate = self;
    leftTableView.tag = 1;
    leftTableView.showsVerticalScrollIndicator = NO;
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:leftTableView];
    
    UITableView *middleScrollView = [[UITableView alloc] initWithFrame:CGRectMake(250, 0, 70, 480)];
    middleScrollView.dataSource = self;
    middleScrollView.delegate = self;
    middleScrollView.tag = 2;
    middleScrollView.backgroundColor = [UIColor lightGrayColor];
    middleScrollView.separatorStyle = UITableViewCellSeparatorStyleNone;
    middleScrollView.showsVerticalScrollIndicator = NO;
    [_scrollView addSubview:middleScrollView];
    
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 250, 480)];
    rightTableView.dataSource = self;
    rightTableView.delegate = self;
    rightTableView.tag = 3;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:rightTableView];
    
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftEffect:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftTableView addGestureRecognizer:leftGesture];
    
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightEffect:)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [rightTableView addGestureRecognizer:rightGesture];
    
}
//- (void)onRightShow{
//    UITableView *v = (UITableView*)[self.view viewWithTag:2];
//    v.te
//}
//- (void)onLeftShow{
//    
//}
- (void)rightEffect:(UIPanGestureRecognizer *)recognizer {
    NSLog(@"recognizer.state : %i", recognizer.state);

    switch (recognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateChanged:
        {
            UITableView *v = (UITableView*)[self.view viewWithTag:2];
            v.contentOffset = CGPointMake(0, 0);

//            [UIView transitionWithView:_scrollView 
//                              duration:0
//                               options:UIViewAnimationOptionTransitionCrossDissolve
//                            animations:^{ 
                                [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];    
//                            } 
//                            completion:NULL];
        }
            break;
        default:
            break;
    }
}

- (void)leftEffect:(UIPanGestureRecognizer *)recognizer {
    NSLog(@"recognizer.state : %i", recognizer.state);
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateChanged:
        {
            UITableView *v = (UITableView*)[self.view viewWithTag:2];
            v.contentOffset = CGPointMake(0, 0);
            
            
//            [UIView transitionWithView:_scrollView 
//                              duration:0
//                               options:UIViewAnimationOptionTransitionCrossDissolve 
//                            animations:^{ 
                                [_scrollView setContentOffset:CGPointMake(250, 0) animated:YES];    
//                            } 
//                            completion:NULL];
        }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    switch (scrollView.tag) {http://www.asiae.co.kr/company/suggest.htm
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
            if (_scrollView.contentOffset.x <= 10) {
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
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1000;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellName = @"tempCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellName"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%i", indexPath.row];
    return cell;
    
}

@end
