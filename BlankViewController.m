//
//  BlankViewController.m
//  Reader
//
//  Created by Lieder on 2017/10/5.
//

#import "BlankViewController.h"

@interface BlankViewController ()<UITextViewDelegate>

@end

@implementation BlankViewController

@synthesize scrollView,textView;

- (void)loadView
{
    UITextView *tipTextView = [[UITextView alloc]init];
    CGFloat hStart = ([UIScreen mainScreen].bounds.size.height)/8.0f;
    CGFloat wStart = ([UIScreen mainScreen].bounds.size.width)/8.0f;
    tipTextView.frame = CGRectMake(wStart, hStart, wStart*6.0f, hStart*6.0f);
    tipTextView.backgroundColor = [UIColor clearColor];
    tipTextView.editable = NO;
    tipTextView.delegate = self;
    tipTextView.scrollEnabled = YES;
    tipTextView.showsVerticalScrollIndicator = YES;
    //tipTextView.attributedText = str;
    tipTextView.tag = 37;
    tipTextView.textColor = [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f];
    tipTextView.font = [UIFont systemFontOfSize:15];
    scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.backgroundColor = [UIColor grayColor];
    //scrollView.contentSize = textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
