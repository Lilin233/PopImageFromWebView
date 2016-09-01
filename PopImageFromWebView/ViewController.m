//
//  ViewController.m
//  PopImageFromWebView
//
//  Created by Kai Liu on 16/8/31.
//  Copyright © 2016年 Kai. All rights reserved.
//

#import "ViewController.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()<UIWebViewDelegate, UIViewControllerTransitioningDelegate>{
    UIWebView *_webView;
    UIImageView *_ghostImageView;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:webView];
        webView.delegate = self;
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp"
                                                              ofType:@"html"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        [webView loadHTMLString:htmlCont baseURL:baseURL];
        webView;
    });
    
    _ghostImageView = ({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imageView.hidden = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_webView addSubview:imageView];
        imageView;
    });
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString* sJs = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"loadimg" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil];
    [_webView stringByEvaluatingJavaScriptFromString:sJs];

    [_webView stringByEvaluatingJavaScriptFromString:@"autolayoutImg()"];
    [_webView stringByEvaluatingJavaScriptFromString:@"addClickFun()"];

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSRange range;
    range  = [requestString rangeOfString:@"myweb:imageClick:"];
    if (range.location != NSNotFound)
    {
        NSString* tempStr = [requestString substringFromIndex:range.length];
        NSArray *array= [tempStr componentsSeparatedByString:@"*"];
        CGFloat x = [array[0] floatValue];
        CGFloat y = [array[1] floatValue];
        CGFloat width = [array[2] floatValue];
        CGFloat height = [array[3] floatValue];
        NSString *sUrl = array[4];
        
        _ghostImageView.frame = CGRectMake(x, y, width, height);
        [_ghostImageView sd_setImageWithURL:[NSURL URLWithString:sUrl] placeholderImage:[UIImage imageNamed:@"Information_Image_Loading"]];
        TGRImageViewController *imageVC  = [[TGRImageViewController alloc]initWithImageUrl:[NSURL URLWithString:sUrl]];
        imageVC.transitioningDelegate = self;
        imageVC.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [self presentViewController:imageVC animated:YES completion:nil];
        
    }
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}
#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:_ghostImageView];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:_ghostImageView];
    }
    return nil;
}


@end
