//
//  ViewController.m
//  PartDemo
//
//  Created by Burt on 2018/10/17.
//  Copyright © 2018年 com.burt. All rights reserved.
//

#import "ViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) JSContext *context;
@property(nonatomic,strong)UIWebView * webView;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    _webView.delegate=self;
    [self.view addSubview:_webView];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"car6S.html" withExtension:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    
    [self.webView loadRequest:request];
}

- (NSString *)loadJsFile:(NSString*)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSString *jsScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return jsScript;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [self.context evaluateScript:[self loadJsFile:@"car6S"]];
    
    // 打印异常
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
    
    __weak typeof(self) weakSelf=self;
    //多参数block提供给js调用
    self.context[@"mutiParams"] =
    ^(NSString *part,NSString *state)
    {
        if ([state isEqualToString:@"select"]) {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:part message:state preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * ac=[UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                
                
                
            }];
            
            UIAlertAction * ac1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                [weakSelf change:part];
                
            }];
            
            [alert addAction:ac];
            [alert addAction:ac1];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        NSLog(@"%@ %@",part,state);
    };
    
}

-(void)change:(NSString*)partName
{
    
    JSValue *function = [self.context objectForKeyedSubscript:@"ocCallJsChangeColor"];
    //OC调JS改变颜色
    BOOL result = [function callWithArguments:@[partName,@"#333333"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
