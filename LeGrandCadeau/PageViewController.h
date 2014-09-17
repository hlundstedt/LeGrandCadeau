//
//  ViewController.h
//  LeGrandCadeau
//
//  Created by Henrik Lundstedt on 2014-09-12.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PageContentViewController.h"
#import "Mixpanel.h"

@interface PageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageImages;

@end
