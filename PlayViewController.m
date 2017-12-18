//
//  PlayViewController.m
//  Reader
//
//  Created by Lieder on 2017/7/26.
//
//

#import "PlayViewController.h"

@interface PlayViewController () <UIScrollViewDelegate,UIGestureRecognizerDelegate,PlayMainToolbarDelegate>


@end

@implementation PlayViewController
{
    NSInteger maximumPage, minimumPage, currentPage;
    CGPoint newPoint;
    DoublePlayType doublePlayType;
    UIDevice *device;
}

@synthesize backGround,playArray,documentName,backScrollView,screenWidth,screenHight,theFileURL,phrase,lastPlayPoint,gestureTopView,delegate,playToolbar,showThePlayToolbar,doublePlayTip,thePageCount,blueTooth,connnectedPeripheralNameArray;

/*- (void)passValue:(NSInteger)value
{
    self.lastPlayPoint = value;
    NSLog(@"母文件lastPlayPoint录入为：%ld",(long)lastPlayPoint);
}*/

- (void)getTheLastPlayPoint:(NSInteger)lastPoint andDoublePlayTip:(BOOL)doubleTip
{
    lastPlayPoint = lastPoint;
    doublePlayTip = doubleTip;
    NSLog(@"子函数，lastPoint = %ld",(long)lastPlayPoint);
}

- (void)getTheFileNameForPlayPage:(ReaderDocument *)document//第一个运行的函数
{
    self.documentName = [[NSString alloc]initWithString:document.fileName];
    self.theFileURL = document.fileURL;
    self.phrase = document.password;
    self.thePageCount = [document.pageCount integerValue];
}
//检测蓝牙状态如果连上显示蓝色，如果没有连上显示红色
//1.读取play文件中的数据，从play数组的第一页开始显示
- (void)readThePlayOrder//第二个，读取play数据
{
    NSString *plistNamePlay = [[NSString alloc]initWithFormat:@"%@PlayOrder",documentName];
    NSUserDefaults *plistReadPlay = [NSUserDefaults standardUserDefaults];
    NSArray *readArrayPlay = [plistReadPlay objectForKey:plistNamePlay];
    playArray = [[NSMutableArray alloc]initWithArray:readArrayPlay];
    minimumPage = 0;
    maximumPage = playArray.count-1;
    /*
    playArray = [[NSMutableArray alloc]init];
    //NSString *home = NSHomeDirectory();
    //NSString *documentPath = [home stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    NSString *filePath = [documentName stringByAppendingString:@"ReaderPadPlay"];
    
    NSString *plistName = [[NSString stringWithFormat:@"%@",filePath] stringByAppendingPathExtension:@"plist"];
    
    NSString *plistPath = [documentPath stringByAppendingPathComponent:plistName];
    
    NSLog(@"读取.文件存在，文件路径为 == %@", plistPath);
    //判断文件是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        NSLog(@"读取.play-play.plist文件不存在");
        BOOL tip=[fileManager createFileAtPath:plistPath contents:nil attributes:nil];//重新创建文件
        if (tip==NO) {
            NSLog(@"读取.play-play.plist创建文件失败");
        }
    }
    
    
    playArray = [NSMutableArray arrayWithContentsOfFile:plistPath];*/
    if (playArray.count == 0) {
        playArray = [[NSMutableArray alloc]init];
        for (NSInteger i=0; i<thePageCount; i++) {
            [playArray addObject:[NSNumber numberWithInteger:i+1]];
        }
    }
    NSLog(@"play-play.dictionary=%@",playArray);
    NSLog(@"play.play.plist文件读取1完毕");
}

- (void)load//第三个,获取一些其他值
{
    
    
    currentPage = lastPlayPoint;
    self.view.autoresizesSubviews = YES;
    self.view.backgroundColor = [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f];
    
    blueTooth = [[BlueToothController alloc]init];//blee 蓝牙启动
    [blueTooth load];
    
    
    screenHight = [UIScreen mainScreen].bounds.size.height;
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    device = [UIDevice currentDevice];
    connnectedPeripheralNameArray = [[NSMutableArray alloc]init];
    showThePlayToolbar = YES;
    if (doublePlayTip == YES) {
        [self showDoublePlay];
        //currentPage = lastPlayPoint/2;
        NSLog(@"doublePlay");
    }
    else
    {
        [self showSingleShow];
        NSLog(@"singlePlay");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheConnectedPeriShankingHands:) name:@"getTheConnectedPeriShankingHands" object:nil];//注册通知,用于收到连接的蓝牙用作存储，握手信息1
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordTheConnectedPeripheral:) name:@"recordTheConnectedPeripheral" object:nil];//注册通知,用于收到连接的蓝牙用作存储,存储peri数组
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteTheConnectedPeripheral) name:@"deleteTheConnectedPeripheral" object:nil];//删除蓝牙连接记录
    
    
}

- (void)recordTheConnectedPeripheral:(NSNotification *)noti
{
    NSLog(@"收到蓝牙信息，为%@",noti);
    [connnectedPeripheralNameArray removeAllObjects];
    [connnectedPeripheralNameArray addObjectsFromArray:[noti.userInfo objectForKey:@"connnectedPeripheral"]];
    if ([noti.userInfo objectForKey:@"connnectedPeripheral"] == nil) {
        NSLog(@"..................$$$$$$$$传输失败");
    }
    NSLog(@"connnectedPeripheral = %@",connnectedPeripheralNameArray);
}

- (void)getTheConnectedPeriShankingHands:(NSNotification *)noti
{
    NSString *tip = [[NSString alloc]initWithString:[noti.userInfo objectForKey:@"option"]];
    
    if ([tip isEqualToString:@"record"])
    {
        if (connnectedPeripheralNameArray.count > 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriNotiBackForRefreshingTableView" object:self userInfo:[NSDictionary dictionaryWithObject:connnectedPeripheralNameArray forKey:@"recordedTheConnectedPeriArray"]];//传回存储的peri
            NSLog(@"取得连接的PeriName，%@",connnectedPeripheralNameArray);
        }
        else
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriNotiBackForRefreshingTableView" object:self userInfo:nil];//传回存储的peri
            NSLog(@"无存储PeriName");
        }
    }
    
    else if ([tip isEqualToString:@"delete"])
    {
        if (connnectedPeripheralNameArray.count > 0) {
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriDeleteForRefreshingTableview" object:self userInfo:[NSDictionary dictionaryWithObject:connnectedPeripheralNameArray forKey:@"getBackThePeriArrayWaitingForCanceled"]];//传回存储的peri到view
            [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelConnect" object:self userInfo:[NSDictionary dictionaryWithObject:connnectedPeripheralNameArray forKey:@"connnectedPeripheralNameArray"]];
            NSLog(@"取得连接的PeriName，%@",connnectedPeripheralNameArray);
        }
        else
        {
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriDeleteForRefreshingTableview" object:self userInfo:nil];//传回存储的peri
            NSLog(@"无存储PeriName");
        }
    }
    
}

- (void)deleteTheConnectedPeripheral
{
    NSLog(@"收到蓝牙删除信息");
    [connnectedPeripheralNameArray removeAllObjects];
    NSLog(@"删除后connnectedPeripheral = %@",connnectedPeripheralNameArray);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelTheConnectedPeri" object:self userInfo:nil];
}

- (void)play//第四个，播放画面
{
    CGRect toolbarRect = self.view.bounds;
    toolbarRect.size.height = 44.0f;
    playToolbar = [[PlayMainToolbar alloc] initWithFrame:toolbarRect documentName:documentName]; // ReaderMainToolbar
    playToolbar.delegate = self; // ReaderMainToolbarDelegate
    [self.view addSubview:playToolbar];
    //currentPage = lastPlayPoint;
    //screenWidth = [UIScreen mainScreen].bounds.size.width;
    //screenHight = [UIScreen mainScreen].bounds.size.height;
    
    //CGFloat bound = MAX(screenWidth, screenHight);
    CGFloat backGroundWidth = ([UIScreen mainScreen].bounds.size.width)*(playArray.count);
    CGFloat backGroundHeigh = [UIScreen mainScreen].bounds.size.height;
    switch (doublePlayType) {
        case NoDoublePlay:
        {
            NSLog(@"NoDoublePlay");
        }
            //backGround = [[UIView alloc]initWithFrame:CGRectMake(0,0,([UIScreen mainScreen].bounds.size.width)*(playArray.count),[UIScreen mainScreen].bounds.size.height)];//画布
            break;
            
        case HomeButtonUpOrDown:
        {
            backGroundWidth = ([UIScreen mainScreen].bounds.size.width)*((playArray.count+1)/2);
            NSLog(@"HomeButtonUpOrDown:");
        }
            //backGround = [[UIView alloc]initWithFrame:CGRectMake(0,0,([UIScreen mainScreen].bounds.size.width)*(playArray.count)/2.0f,[UIScreen mainScreen].bounds.size.height)];//画布
            break;
            
        case HomeButtonLeftOrRight:
        {
            backGroundWidth = ([UIScreen mainScreen].bounds.size.width)*((playArray.count+1)/2);
            NSLog(@"HomeButtonLeftOrRight:");
        }
            //backGround = [[UIView alloc]initWithFrame:CGRectMake(0,0,([UIScreen mainScreen].bounds.size.width)*(playArray.count)/2.0f,[UIScreen mainScreen].bounds.size.height)];//画布
            break;
            
        default:
            break;
    }
    backGround = [[UIView alloc]initWithFrame:CGRectMake(0,0,backGroundWidth,backGroundHeigh)];//画布
    backGround.backgroundColor = [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f];
    backGround.tag = 41;
    
    backScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backScrollView.backgroundColor = [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f];
    backScrollView.delegate = self;
    backScrollView.directionalLockEnabled = YES;//只能一个方向滑动
    backScrollView.pagingEnabled = NO; //是否翻页
    backScrollView.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    backScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    backScrollView.showsHorizontalScrollIndicator = YES;//水平方向的滚动指示
    backScrollView.tag = 40;
    backScrollView.contentSize = backGround.frame.size;
   
    
    //CGSize newSize = CGSizeMake(playArray.count*screenWidth, screenHight);
    //newPoint = CGPointMake((lastPlayPoint*screenWidth), 0);
    
    /*switch (doublePlayType) {
        case HomeButtonUpOrDown:
            self.backScrollView.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width)*playArray.count/2.0f, ([UIScreen mainScreen].bounds.size.height));
            break;
            
        case HomeButtonLeftOrRight:
            self.backScrollView.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width)*playArray.count/2.0f, ([UIScreen mainScreen].bounds.size.height));
            break;
            
        case NoDoublePlay:
            self.backScrollView.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width)*playArray.count, ([UIScreen mainScreen].bounds.size.height));
            break;
            
        default:
            break;
    }*/
    //CGSizeMake(([UIScreen mainScreen].bounds.size.width)*playArray.count, ([UIScreen mainScreen].bounds.size.height));
    //self.backScrollView.contentSize = newSize;//设置滚动视图显示范围
    //self.backScrollView.contentOffset = newPoint;
    self.backScrollView.bounces = YES;
    
    
    for (int i = 0; i < playArray.count; i++)
    {
        ReaderContentPage *theContentPage = [[ReaderContentPage alloc] initWithURL:theFileURL page:[playArray[i] integerValue] password:phrase];
        theContentPage.backgroundColor = [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f];
        float cw = theContentPage.bounds.size.width;//x
        float ch = theContentPage.bounds.size.height;//y
        float sw = screenWidth;//x0
        float sh = screenHight;//y0
        float x = 0.0f;
        float y = 0.0f;
        float w = 0.0f;
        float h = 0.0f;
        float a = ch/cw;
        float b = sh/sw;
        float offsetX;
        float offsetY;
        
        if (a<b)//如果内容偏宽
            {
                x=0;
                y=(sh-(sw/cw)*ch)/2.0f;
                w=sw;
                h=(sw/cw)*ch;
            }
        
        else//如果内容偏高
            {
                y=0;
                x=(sw-(sh/ch)*cw)/2.0f;
                w=(sh/ch)*cw;
                h=sh;
            }
        
        switch (doublePlayType) {
            case HomeButtonUpOrDown:
            {
                offsetX = x+(i/2)*sw;
                offsetY = y+(i%2)*sh;
            }
                break;
                
            case HomeButtonLeftOrRight:
            {
                offsetX = x+i*sw;
                offsetY = y;
            }
                break;
                
            case NoDoublePlay:
            {
                offsetX = x+i*sw;
                offsetY = y;
            }
                break;
                
            default:
                break;
        }
        //offsetX = x+i*sw;
        //offsetY = y;
        
        NSLog(@"%d 余数 2 = %d",i,i%2);
        NSLog(@"%d 除以 2 = %d",i,i/2);
        
        ReaderContentView *theContentView = [[ReaderContentView alloc] initWithFrame:CGRectMake(offsetX, offsetY, w, h) fileURL:theFileURL page:[playArray[i] integerValue] password:phrase];
        theContentView.backgroundColor = [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f];
        
        theContentView.alpha = 1.0f;
        theContentView.tag = 40+i+2;
        
        [backGround addSubview:theContentView];
    }
    
    //滑动手势
    /*UISwipeGestureRecognizer * recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizerLeft.delegate = self;
    [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer * recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizerRight.delegate = self;
    [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];*/
    
    UISwipeGestureRecognizer * recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizerUp.delegate = self;
    [recognizerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    
    UISwipeGestureRecognizer * recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizerDown.delegate = self;
    [recognizerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toolbarShowTapped:)];
    tap.delegate = self;
    
    
    backScrollView.pagingEnabled = YES;
    //gestureTopView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //[gestureTopView addGestureRecognizer:recognizerLeft];
    //[gestureTopView addGestureRecognizer:recognizerRight];
    //[gestureTopView addGestureRecognizer:recognizerDown];
    newPoint = CGPointMake((currentPage*[UIScreen mainScreen].bounds.size.width), 0);
    [backScrollView setContentOffset:newPoint];
    [backScrollView addGestureRecognizer:recognizerUp];
    [backScrollView addGestureRecognizer:recognizerDown];
    [backScrollView addGestureRecognizer:tap];
    [backScrollView addSubview:backGround];
    [self.view addSubview:backScrollView];//滚动页面加在主页底上
    //[self.view addSubview:gestureTopView];
    //[self.view bringSubviewToFront:gestureTopView];
    //currentPage = (newPoint.x / screenWidth);
    if (showThePlayToolbar == YES) {
       [self.view bringSubviewToFront:playToolbar];
        //showThePlayToolbar = NO;
        NSLog(@"显示toolbar");
    }
    
}




//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"调用设备旋转");
    //[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self resizeTheVIew];
}
- (void)resizeTheVIew
{
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHight = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"旋转，currentPage = %ld",(long)currentPage);
    lastPlayPoint = currentPage;
    NSLog(@"lastPage= %ld",(long)lastPlayPoint);
    //(backScrollView.contentOffset.x)/screenWidth;
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    if (doublePlayTip == YES) {
        [self showDoublePlay];
        NSLog(@"doublePlay");
    }
    else
    {
        //currentPage = lastPlayPoint;
        [self showSingleShow];
    }
    NSLog(@"重新布局");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*CGFloat number = (scrollView.contentOffset.x)/screenWidth;
    NSInteger intNumber = (NSInteger) number;
    lastPlayPoint = [playArray[intNumber] integerValue];
    NSLog(@"滚轮监听调用，最后页数为：%ld",(long)lastPlayPoint);*/
    currentPage = (backScrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    lastPlayPoint = currentPage;
    NSLog(@"滑动，currentPage = %ld",(long)currentPage);
}

- (void)toolbarShowTapped:(UITapGestureRecognizer *)recognizer
{
    if (showThePlayToolbar == NO) {
        [playToolbar showToolbar];
        showThePlayToolbar = YES;
    }
    else{
        [playToolbar hideToolbar];
        showThePlayToolbar = NO;
    }
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    
    NSLog(@"触动");
    currentPage = (backScrollView.contentOffset.x)/([UIScreen mainScreen].bounds.size.width);
    NSLog(@"触动滑动，currentPage = %ld",(long)currentPage);
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        NSLog(@"上推");
        [self blueTooths];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        NSLog(@"下拉");
        lastPlayPoint = currentPage;
        [delegate passValue:self.lastPlayPoint and:doublePlayTip];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


//2.逐页翻页

-(BOOL)prefersStatusBarHidden
{
    return YES;
}



- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    [self resizeTheVIew];
    NSLog(@"根本上翻转");
}

- (void)showDoublePlay
{
    if (doublePlayTip == NO) {
        lastPlayPoint = lastPlayPoint/2;
    }
    currentPage = lastPlayPoint;
    
    doublePlayTip = YES;
    if (device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight)
    {
        for (UIView *view in [self.view subviews]) {
            [view removeFromSuperview];
        }
        screenWidth = [UIScreen mainScreen].bounds.size.width/2.0f;
        screenHight = [UIScreen mainScreen].bounds.size.height;
        doublePlayType = HomeButtonLeftOrRight;
    }
    else
    {
        for (UIView *view in [self.view subviews]) {
            [view removeFromSuperview];
        }
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHight = [UIScreen mainScreen].bounds.size.height/2.0f;
        doublePlayType = HomeButtonUpOrDown;
    }

    [self play];
    
}

-(void)showSingleShow
{
    if (doublePlayTip == YES) {
        lastPlayPoint = lastPlayPoint*2;
    }
    currentPage = lastPlayPoint;
    doublePlayTip = NO;
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHight = [UIScreen mainScreen].bounds.size.height;
    doublePlayType = NoDoublePlay;
    [self play];
}

- (void)tappedInToolbar:(PlayMainToolbar *)toolbar doubleButton:(UIButton *)button
{
    NSLog(@"lastPoint=%ld",(long)lastPlayPoint);
    if (doublePlayTip == NO) {
       [self showDoublePlay];
        doublePlayTip = YES;
    }
    else
    {
        [self showSingleShow];
        doublePlayTip = NO;
    }
    
#if (READER_STANDALONE == FALSE) // Option
    
    //[self closeDocument]; // Close ReaderViewController
    
    //MenuViewController *menu = [[MenuViewController alloc]initWithNibName:nil bundle:nil];
    
    //[menu transTheDocumentIndex:document.fileName];
    //NSLog(@"name=%@",document.fileName);
    
    //[self presentViewController:menu animated:YES completion:nil];
    
#endif // end of READER_STANDALONE Option
}

- (void)tappedInToolbar:(PlayMainToolbar *)toolbar blueButton:(UIButton *)button
{
    [self blueTooths];
}

-(void)blueTooths
{
    NSLog(@"blue点击");
    BlueToothViewController *blueToothView = [[BlueToothViewController alloc]init];
    [blueToothView load:blueTooth];
    [self presentViewController:blueToothView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleDeviceOrientationDidChange:)  name:UIDeviceOrientationDidChangeNotification object:nil];
    //[self.view bringSubviewToFront:playToolbar];
    NSLog(@"view did load");
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decrementPage) name:@"decrementPage" object:nil];//注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incrementPage) name:@"incrementPage" object:nil];//注册通知
    });
    // Do any additional setup after loading the view.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"decrementPage"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"incrementPage"];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"chosenPeri"];
    //[[NSUserDefaults standardUserDefaults] synchronize];//删
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"recordTheConnectedPeripheral"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deleteTheConnectedPeripheral"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"getTheConnectedPeriShankingHands"];
}

- (void)decrementPage
{
    if ((maximumPage > minimumPage) && (currentPage != minimumPage))
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGPoint contentOffset = backScrollView.contentOffset; // Offset
        
        contentOffset.x -= screenWidth; // View X--
        
        [backScrollView setContentOffset:contentOffset animated:YES];
        });
        NSLog(@"向后翻页");
    }
}
- (void)incrementPage
{
    if ((maximumPage > minimumPage) && (currentPage != maximumPage))
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGPoint contentOffset = backScrollView.contentOffset; // Offset
        
        contentOffset.x += screenWidth; // View X++
        
        [backScrollView setContentOffset:contentOffset animated:YES];
        });
        NSLog(@"向前翻页");
    }
}
-(void)incrementPages
{
    if ((maximumPage > minimumPage) && (currentPage != maximumPage))
    {
        CGPoint contentOffset = backScrollView.contentOffset;//offset
        
        contentOffset.x += screenWidth; // View X++
        
        [backScrollView setContentOffset:contentOffset animated:YES];
        
    }
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
