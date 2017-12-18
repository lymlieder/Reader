//
//  MenuViewController.m
//  Reader
//
//  Created by FairyAnnie on 2017/5/26.
//
//

#import "MenuViewController.h"

@interface MenuViewController () <ReaderViewControllerDelegate>

@end

@implementation MenuViewController


@synthesize thumbsView,theThumbsView,thumbsXCount,thumbsYCount,thumbXLeft,size,scrollView,pdfsCount,pdfs,theBigThumbsView,image,imageView,document,blackView,phrase,quit,theBigViewSize,theChosenNumber,imageR,theDocumentName,thumbYTop,scrollViewRect,blankLabel,blankDown,freshTip;
#define PAGE_THUMB_SMALL 160
#define PAGE_THUMB_LARGE 256
-(void)loadView//系统自动调用
{
    [super loadView];
    [self load];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self load];
}

-(void)blankSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self load];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self load];
    NSLog(@"滑动刷新");
}

//-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
    
//}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (freshTip == YES)
    {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self load];
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self load];
        NSLog(@"滑动刷新1");
    }
    
}

-(instancetype)init
{
    return [super init];
}

-(BOOL)prefersStatusBarHidden
{
    return NO;// 返回YES表示隐藏，返回NO表示显示
}

-(void)transTheDocumentIndex:(NSString *)indexName
{
    theDocumentName = [[NSMutableString alloc]initWithString:indexName];
    NSLog(@"documentIndex = %@",theDocumentName);
}

-(void)load
{
    
    freshTip = NO;
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];//获取存放pdf的document地址
    NSLog(@"documentPath = %@",documentPath);
    
    NSArray *fileNameArray = [[NSArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil]] ;//获取document中所有文件的文件名，放入fileNameArray
    NSLog(@"fileNameArray = %@",fileNameArray);
    
    if (fileNameArray.count == 0)
    {
        freshTip = YES;
        CGSize viewSize = [UIScreen mainScreen].bounds.size;
        CGFloat weith = viewSize.width;
        blankLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, weith, 20)];
        //blankLabel = [[UILabel alloc]initWithFrame:[UIScreen mainScreen].bounds];
        blankLabel.backgroundColor = [UIColor blueColor];
        //blankLabel.editable = NO;
        //blankLabel.delegate = self;
        //blankLabel.scrollEnabled = YES;
        //blankTextView.showsVerticalScrollIndicator = YES;
        //tipTextView.attributedText = str;
        blankLabel.text = NSLocalizedString(@"BlankFresh", nil);
        blankLabel.textAlignment = NSTextAlignmentCenter;
        blankLabel.tag = 37;
        //blankLabel.enabled = YES;
        blankLabel.textColor = [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f];
        blankLabel.font = [UIFont systemFontOfSize:20];
        blankLabel.userInteractionEnabled = NO;
        //blankLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        //blankLabel.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        blankLabel.center = CGPointMake(viewSize.width * 0.5f, viewSize.height * 0.5f);
        
        scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        scrollView.backgroundColor = [UIColor grayColor];
        scrollView.bounds = self.view.bounds;
        scrollView.contentSize = self.view.bounds.size;
        scrollView.delegate = self;
        scrollView.directionalLockEnabled = YES;//只能一个方向滑动
        scrollView.pagingEnabled = NO; //是否翻页
        scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
        scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
        scrollView.bounces = YES;
        scrollView.alwaysBounceVertical = YES;
        
        blankDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(blankSwipeDown:)];
        [blankDown setDirection:UISwipeGestureRecognizerDirectionDown];
        
        //[self.view addSubview:scrollView];
        [scrollView addSubview:blankLabel];
        [self.view addSubview:scrollView];
        [self.view addGestureRecognizer:blankDown];
        NSLog(@"无文件");
    }
    
    else
    {
        pdfs = [[NSMutableArray alloc]init];
        NSLog(@"menu.fileCount is %lu",(unsigned long)fileNameArray.count);//输出文件名数组元素个数
        
        for (NSInteger i=0; i<fileNameArray.count; i++) {//把文件名套上地址存在pdfs里
            NSString *tempFilePath = [documentPath stringByAppendingPathComponent:[fileNameArray objectAtIndex:i]];
            
            if ([[tempFilePath pathExtension] isEqualToString:@"pdf"]) {
                [pdfs addObject:tempFilePath];
            }
            NSLog(@"menu.文件目录序列,未检录：%@",tempFilePath);
        }
        
        for (NSString *filePathName in pdfs) {//遍历pdfs
            NSLog(@"menu.遍历文件地址目录，已检录：%@",filePathName);
        }
        
        //scrollViewRect.origin = [UIScreen mainScreen].bounds.origin;
        //scrollViewRect.size =[UIScreen mainScreen].bounds.size;
        
        CGFloat gap = (([UIScreen mainScreen].bounds.size.height) / 30);
        thumbYTop = gap*1.5;
        
        scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        scrollView.bounds = self.view.bounds;
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, thumbsYCount*size.height*1.2+thumbYTop*2);
        scrollView.backgroundColor = [UIColor grayColor];
        scrollView.delegate = self;
        scrollView.directionalLockEnabled = YES;//只能一个方向滑动
        scrollView.pagingEnabled = NO; //是否翻页
        scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
        scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
        
        //self.view.frame.size.height+1);
        
        //[scrollView setContentSize:newSize];//设置滚动视图
        [self.view addSubview:scrollView];//滚动页面加在主页底上
        //[scrollView setContentSize:newSize];//设置滚动视图
        
        blankDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(blankSwipeDown:)];
        [blankDown setDirection:UISwipeGestureRecognizerDirectionDown];
        
        [scrollView addGestureRecognizer:blankDown];
        
        
        [self updateContentSize:pdfsCount];//小方视图大小，得到CGSize size = theThumbsView.contentSize;
        [self setBigThumbsView:pdfsCount];
        
        
        NSLog(@"底层页面与滚动视图已设计好");
        
        
        //加载pdf信息
        
        //pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
        //NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
        
        
        
        pdfsCount = pdfs.count;
        
        NSLog(@"menu.pdfCount=%lu",(unsigned long)pdfsCount);
        
        //theBigThumbsView = [[ReaderThumbsView alloc]init];
        [self setBigThumbsView:pdfsCount];//设置有效视图
        
        //thumbXLeft + (gap * thumbsYCount);
        
        theBigThumbsView = [[ReaderThumbsView alloc]initWithFrame:CGRectMake(0, thumbYTop, theBigViewSize.width, theBigViewSize.height)];
        NSLog(@"有效视图size=%f,%f",theBigViewSize.width,theBigViewSize.height);
        
        theBigThumbsView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:theBigThumbsView];//有效视图加在滚动页面上
        
        NSLog(@"有效视图添加完毕");
        
        [self addThumbViews];
        
    }
    
    
}

- (void)addThumbViews
{

    //[self load];
    
    
    if (pdfsCount > 0)
    {
        
        for (NSInteger i=0; i<pdfsCount; i++)
        {
            NSLog(@"开始加载第%ld个thumb",(long)i);
            
            phrase = nil; // Document password (for unlocking most encrypted PDF files)
            
            NSString *filePath = pdfs[i];
            assert(filePath != nil); // Path to first PDF file
            
            NSLog(@"文件地址为：%@",filePath);
            
            document = [ReaderDocument withDocumentFilePath:filePath password:phrase];//初始化document
            
            NSLog(@"document=%@",document);
            
            do {
                quit = YES;
                if (document == nil)//弹出提示框
                {//有密码
                    NSString *Confirm = NSLocalizedString(@"Confirm", nil);
                    NSString *Password1 = NSLocalizedString(@"Password1", nil);
                    NSString *Password2 = NSLocalizedString(@"Password2", nil);
                    NSString *Tip = [NSString stringWithFormat:@"%@%@%@",Password1,document.fileName,Password2];
                    NSString *Sure = NSLocalizedString(@"Sure", nil);
                    NSString *Cancel = NSLocalizedString(@"Cancel", nil);
                    //NSString *Confirm = @"提示";
                    //NSString *Tip = [NSString stringWithFormat:@"请输入文档《%@》的密码",document.fileName];
                    //NSString *Sure = @"确认";
                    //NSString *Cancel = @"取消";
                    
                    self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
                    
                    self.blackView.backgroundColor = [UIColor blackColor];
                    
                    self.blackView.alpha = 0.5;
                    
                    
                    [self.view addSubview:blackView];//背景蒙版
                    
                    quit = YES;
                    //提示版,输入密码后更改phase值
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Confirm message:Tip preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                     
                        NSString *PlaceHolder = NSLocalizedString(@"PlaceHolder", nil);
                        
                        textField.placeholder = PlaceHolder;
                        
                        textField.secureTextEntry = NO;
                        
                        textField.clearButtonMode=UITextFieldViewModeAlways;
                        
                        //监听输入https://segmentfault.com/a/1190000004622916
                        
                        NSLog(@"%@",textField.text);
                        }];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:Sure style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                         
                    {
                        //获取第1个输入框；
                        UITextField *passwordTextField = alert.textFields.lastObject;
                        [phrase setString:passwordTextField.text];
                        document = [ReaderDocument withDocumentFilePath:filePath password:phrase];//再次初始化document
                        if (document == nil)
                        {
                            quit = NO;
                        }
                    }];
                    
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                    {
                        phrase = nil;
                        quit = YES;
                    }];
                    
                    [alert addAction:ok];
                    
                    [alert addAction:cancel];
                    
                    [self presentViewController:alert animated:YES completion:^{ }];
                
                }
                
            } while (quit == NO);
            
            document = [ReaderDocument withDocumentFilePath:filePath password:phrase];//再次初始化document
            
            CGRect imageRect = [self thumbCellFrameForIndex:i];//设置第i个小图的边框位置，大小
            
            CGFloat newHeight = imageRect.size.height;
            CGFloat newWidth = ((newHeight / 3.0f) *2.0f);
            
            CGFloat newPointX = ((newHeight - newWidth)/2.0f);
            
            imageR.origin = CGPointMake(newPointX, 0);
            imageR.size = CGSizeMake(newWidth, newHeight);
            
            
            ReaderContentView *contentView = [[ReaderContentView alloc] initWithFrame:imageR fileURL:document.fileURL page:1 password:phrase];//真实内容视图
            
            contentView.backgroundColor = [UIColor whiteColor];
            contentView.layer.shadowColor = [UIColor blackColor].CGColor;
            contentView.layer.shadowOffset = CGSizeMake(0, 0);
            contentView.layer.shadowOpacity = 0.5;
            contentView.layer.shadowRadius = 10;
            
            imageView = [[UIImageView alloc]initWithFrame:imageRect];
            imageView.userInteractionEnabled = YES;
            Tap *tap = [[Tap alloc]initWithTarget:self action:@selector(whenClickImage:)];
            
            tap.numberOfTouchesRequired = 1; //手指数
            tap.numberOfTapsRequired = 1; //tap次数
            tap.delegate = self;
            tap.chosenNumber = i;
            
            [imageView addGestureRecognizer:tap];
            imageView.backgroundColor = [UIColor clearColor];
            
            [imageView addSubview:contentView];//真实内容加载在小视图上
            
            [theBigThumbsView addSubview:imageView];//小视图加载在有效视图上
        //最终返回imageView
            
        }
        //for循环结束，文档首页目录加载完毕
        
    }
}


- (void)whenClickImage:(id)sender
{
    Tap *tap = (Tap*)sender;
    theChosenNumber = tap.chosenNumber;
    
    

    
    NSString *filePath = pdfs[theChosenNumber];
    assert(filePath != nil); // Path to first PDF file
    
    document = [ReaderDocument withDocumentFilePath:filePath password:phrase];//初始化document
    
    NSUserDefaults *lastDocument = [NSUserDefaults standardUserDefaults];//存入最后选择项
    [lastDocument setObject:document.fileName forKey:@"lastFileName"];
    [lastDocument synchronize];
    
    NSLog(@"documentName=%@",theDocumentName);
    /*if ([document.fileName isEqualToString:theDocumentName]) {
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"退出");
    }
    
    else*/
    {
        if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            
            readerViewController.delegate = self; // Set the ReaderViewController delegate to self
            
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
            
            [self.navigationController pushViewController:readerViewController animated:YES];
            
#else // present in a modal view controller
            
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:readerViewController animated:YES completion:NULL];
            
#endif // DEMO_VIEW_CONTROLLER_PUSH
            NSString *lastPageName = [[NSString alloc]initWithFormat:@"%@LastPage",document.fileName];
            NSUserDefaults *lastDocumentPage = [NSUserDefaults standardUserDefaults];
            NSInteger lastPageNumber = [lastDocumentPage integerForKey:lastPageName]-1;
            
            [readerViewController incrementPageNumberNSteps:lastPageNumber];
            
            NSLog(@"使用lastPageNumber is :%ld",(long)lastPageNumber);
        }
        else // Log an error so that we know that something went wrong
        {
            NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
        }
        //显示选择的视图，跳过去
    }
    
}


- (void)setBigThumbsView:(NSUInteger)thumbCount//内容有效视图大小，得到theBigView
{
    //BOOL canUpdate = NO; // Disable updates
    
    if (thumbCount > 0) // Have some thumbs如果缩略图数量大于0
    {
        CGFloat bw = self.view.bounds.size.width;//bw=页面宽度
        
        thumbsXCount = (bw / size.width);//X=页面宽度除以thumb宽度，既每行thumb数量
        
        thumbsYCount = (thumbCount / thumbsXCount);//Y等于缩略图数量除以每行数量，既行数
        
        if (thumbsXCount < 1) thumbsXCount = 1;//如果每行数量小于1
        
        thumbsYCount = (thumbCount / thumbsXCount);//Y为横行数
        
        if ((thumbsXCount * thumbsYCount) < thumbCount) thumbsYCount++;
        
        CGFloat tw = (thumbsXCount * size.width);//tw等于每行数量乘以每个宽度，有效宽度
        CGFloat th = (thumbsYCount * size.height+thumbsYCount*size.height*0.2);//th等于行数乘以每行宽度，有效高度
        
        if (tw < bw)//如果有效宽度小于页面宽度
            thumbXLeft = ((bw - tw) * 0.5f);//设置左边留白,使之居中
        else
            thumbXLeft = 0; // Reset，否则留白为零
        
        if (tw < bw) tw = bw; // Limit
        
        [theBigThumbsView setContentSize:CGSizeMake(tw, th)];//有效尺寸
        theBigViewSize = CGSizeMake(tw, th);
    }
    else // Zero (0) thumbs
    {
        [theBigThumbsView setContentSize:CGSizeZero];//零尺寸
        theBigViewSize = CGSizeZero;
    }
    
    //canUpdate = YES; // Enable updates
}

- (CGRect)thumbCellFrameForIndex:(NSInteger)index//每个单元框位置
{
    CGRect thumbRect; thumbRect.size = size;//缩略框尺寸
    
    NSInteger theThumbY = ((index / thumbsXCount) * size.height*1.2); // X, Y，指数除以每行个数乘以有效边框高度，就是在第几行的多高
    
    NSInteger theThumbX = (((index % thumbsXCount) * size.width) + thumbXLeft);//指数取每行个数的余数，乘以每个单元格的宽度，就是在该行第几个
    
    thumbRect.origin.x = theThumbX; thumbRect.origin.y = theThumbY;//每个小框的起始位置
    
    return thumbRect;
}


- (void)updateContentSize:(NSUInteger)thumbCount//小方视图大小，size和theThumbsView
{
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        CGRect viewRect = [UIScreen mainScreen].bounds;//大视图边框
        
        CGSize viewSize = viewRect.size; // 大视图尺寸
    
        NSLog(@"screen.size=%f,%f",viewSize.width,viewSize.height);
        
        CGFloat min = ((viewSize.width < viewSize.height) ? viewSize.width : viewSize.height);//大视图最小边长
    
        CGFloat thumbSize = ((min > 320.0f) ? floorf(min / 3.0f) :
                             PAGE_THUMB_SMALL);//如果最小边长大于320,min/3.0取整为中视图边长
        
        NSLog(@"thumbSize = %f",thumbSize);
        
        [theThumbsView setThumbSize:CGSizeMake(thumbSize, thumbSize)];//小方视图尺寸设置为正方形，边长以大视图短边长的三分之一计
        size = CGSizeMake(thumbSize, thumbSize);
        NSLog(@"size=%f,%f",size.width,size.height);
    }
    
    else // Set thumb size for large (iPad) devices
    {
        [theThumbsView setThumbSize:CGSizeMake(PAGE_THUMB_LARGE, PAGE_THUMB_LARGE)];
        size = CGSizeMake(PAGE_THUMB_LARGE, PAGE_THUMB_LARGE);
        NSLog(@"不是小设备");
    }
    
    //[theThumbsView setThumbSize:CGSizeMake(thumbSize, thumbSize)];
    //size = CGSizeMake(thumbSize, thumbSize);//中视图size等于最小的方框
}



- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSLog(@"屏幕翻转");
    [self load];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self load];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"目录页面加载完毕");
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


@interface Tap ()

@end


@implementation Tap

@synthesize chosenNumber;

-(instancetype)initWithTarget:(id)target action:(SEL)action
{
    return [super initWithTarget:target action:action];
}

@end
