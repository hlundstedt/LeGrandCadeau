//
//  PageContentViewController.h
//  LeGrandCadeau
//
//  Created by Henrik Lundstedt on 2014-09-12.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property NSUInteger pageIndex;
@property NSString *imageFile;

@end
