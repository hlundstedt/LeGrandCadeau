//
//  ViewController.m
//  LeGrandCadeau
//
//  Created by Henrik Lundstedt on 2014-09-12.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_pageImages = @[@"IMG_4743.png", @"IMG_4744.png", @"IMG_4746.png", @"IMG_4747.png", @"IMG_4748.png", @"IMG_4749.png", @"IMG_4750.png", @"IMG_4751.png", @"IMG_4752.png", @"IMG_4753.png"];
    
    _pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index <= 0 || index == NSNotFound) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index - 1];
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index + 1 >= [_pageImages count] || index == NSNotFound) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index + 1];
}

#pragma mark - Page View Controller Delegate

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    int index = -1;
    if (finished) {
        index = ((PageContentViewController*) pageViewController.viewControllers[0]).pageIndex;
        if (index == 0) {
            [[Mixpanel sharedInstance] track:@"Naviate to first page"];
        } else if (index == _pageImages.count - 1) {
            [[Mixpanel sharedInstance] track:@"Naviate to last page"];
        } else {
            [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"Navigate to page: %d", index]];
        }
    }
}

- (PageContentViewController*)viewControllerAtIndex:(NSUInteger)index
{
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = _pageImages[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (IBAction)onSharePressed:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        [mailer setSubject:@"Le Grand Cadeau"];
        [mailer setMessageBody:@"Check out Le Grand Cadeau!" isHTML:NO];
        [mailer addAttachmentData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LeGrandWorkShop" ofType:@"pdf"]] mimeType:@"application/pdf" fileName:@"LeGrandWorkShop.pdf"];
        
        mailer.mailComposeDelegate = self;
        [self.parentViewController presentViewController:mailer animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
