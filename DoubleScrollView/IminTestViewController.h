//
//  IminTestViewController.h
//  DoubleScrollView
//
//  Created by oh-sang Kwon, on 12. 6. 18..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IminTestViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    UIScrollView *_scrollView;
}

@end
