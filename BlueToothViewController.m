//
//  BlueToothViewController.m
//  Reader
//
//  Created by FairyAnnie on 2017/5/12.
//
//

#import "BlueToothViewController.h"

@interface BlueToothViewController ()<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BlueToothViewController
@synthesize peripherals,engeryLevel,signalLevel,engeryValue,signalValue,theTableView,chosenName,confirm,blueTipButton,blueTipsTip,blueGlassView,bluePlayground,chosenNumber,peripheralsNames,tempPeriArray,rSSI,batterValue,chosenPeriNameArray,periRead,label;

-(void)periConnected:(NSNotification *)noti//选定后增加
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        NSLog(@"?????????????????/???????????%@",noti);
        [chosenPeriNameArray removeAllObjects];
        [chosenPeriNameArray addObject:noti.userInfo[@"periName"]];
        NSLog(@"chosenName=%@",chosenPeriNameArray);//临时数组
        
        
        //[periRead removeObjectForKey:@"chosenPeri"];
        //[periRead synchronize];//删
        
        //[periRead setObject:[[NSArray alloc]initWithArray: chosenPeriNameArray] forKey:@"chosenPeri"];
        //[periRead synchronize];//存
        
        
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        
        [self.theTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    });
}

-(void)labelShow:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        label.textColor = [UIColor redColor];
        if ([[noti.userInfo objectForKey:@"option"] isEqualToString:@"show"])
        {
            label.text = @"请确认您的蓝牙是否打开";
        }
        else if ([[noti.userInfo objectForKey:@"option"] isEqualToString:@"cover"])
        {
            label.text = @"  ";
            NSLog(@"label.text清除");
        }
    });
}

-(void)periCanceled
{
    //[periRead removeObjectForKey:@"chosenPeri"];
    //[periRead synchronize];//删
    
    [chosenPeriNameArray removeAllObjects];
    NSLog(@"BlueTVC-删除连接外设");
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.theTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(void)periConnectCanceled:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        NSLog(@":::::::::::::::::::::::::::%@",noti);
        //NSString *name = [[NSString alloc]initWithString:noti.userInfo[@"periNameCanceled"]];
        
        [self periCanceled];
    });
}

-(void)reloadTableViewMain:(NSNotification *)notification//
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        
        ////杂项
        NSLog(@"大小为：%f,%f,%f,%f",theTableView.frame.size.height,theTableView.frame.size.width,theTableView.frame.origin.x,theTableView.frame.origin.y);
        NSLog(@"reloadTableMain");
        
        rSSI = [notification.userInfo[@"rssi"] integerValue];
        NSLog(@"..........更新的rssi=%ld",(long)rSSI);
        signalValue = labs(rSSI) / 100;
        signalLevel.progress = signalValue;
        NSLog(@"..........更新的signValue=%f",signalValue);
        //10^((abs(RSSI) - A) / (10 * n))
        
        
        ////刷新视图
        [tempPeriArray removeAllObjects];//临时数组加项目，内容为外设全部信息
        [tempPeriArray addObjectsFromArray:notification.userInfo[@"periArray"]];
        NSLog(@"临时数组为：%@",tempPeriArray);
        
        NSMutableArray *tempPeriName = [[NSMutableArray alloc]init];
        
        for (CBPeripheral *peris in tempPeriArray) {
            [tempPeriName addObject:peris.name];
        }//加入名字，成立tempPeriName
        
        for (NSString *name in tempPeriName) {
            if ([peripheralsNames containsObject:name] == NO) {
                NSUInteger count = peripheralsNames.count;
                [peripheralsNames insertObject:name atIndex:count];
            }
        }//增加没有项
        NSArray *peripheralsNamesCopy = [NSArray arrayWithArray:peripheralsNames];
        for (NSString *name in peripheralsNamesCopy) {
            if ([tempPeriName containsObject:name] == NO) {
                [peripheralsNames removeObject:name];
            }
        }//删除多余项
        NSLog(@"peripheralsNames更新后为：%@",peripheralsNames);
        
        if (peripheralsNames.count != tempPeriArray.count) {
            [peripheralsNames removeAllObjects];
            for (CBPeripheral *peris in tempPeriArray) {
                [peripheralsNames addObject:peris.name];
            }
            NSLog(@"强制刷新结束");
        }//如果数量不等则强制刷新
       
        [theTableView beginUpdates];
        [theTableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [theTableView endUpdates];
    });
    
}

-(void)reloadProgress:(NSNotification *)noti//外设发布电池信息的时候调用
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        batterValue = [noti.userInfo[@"batterValue"] integerValue];
        NSLog(@"..........更新的batter=%ld",(long)batterValue);
        engeryValue = (batterValue / 700.0f);
        engeryLevel.progress = engeryValue;
        
        
        rSSI = [noti.userInfo[@"RSSI"] integerValue];
        NSLog(@"..........更新的rssi=%ld",(long)rSSI);
        signalValue = 1.0f / MAX(((labs(rSSI))/100.0f), 1.0f);
        signalLevel.progress = signalValue;
        
        NSLog(@"..........更新的enegerValue=%f",engeryValue);
        NSLog(@"..........更新的signValue=%f",signalValue);
        //10^((abs(RSSI) - A) / (10 * n))
    });
}

-(void)load:(BlueToothController *)theBlueTooth
{
    UISwipeGestureRecognizer * swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    swipeDown.delegate = self;
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeDown];//下拉手势
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewMain:) name:@"freshTableView" object:nil];//注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadProgress:) name:@"reloadProgress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(periConnected:) name:@"periConnected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(periConnectCanceled:) name:@"getTheConnectedPeriDeleteForRefreshingTableview" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBackTheConnectedPeri:) name:@"getTheConnectedPeriNotiBackForRefreshingTableView" object:nil];//获取已连接Peri信息，另一半在viewWillAppare里，第二步
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriShankingHands" object:self userInfo:[NSDictionary dictionaryWithObject:@"record" forKey:@"option"]];//向Play握手获取已连接的Peri,第一步
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTheConnectedPeriFromViewRecord) name:@"cancelTheConnectedPeri" object:nil];//删除后从view中回传数据
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(labelShow:) name:@"labelShow" object:nil];//提示显示
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"shakeHandsForShowingLabel" object:nil];//发出蓝牙连接提示握手信息
    
    theTableView.tag = 100;
    NSLog(@"blueTVC-开始load");
    theTableView.delegate = self;
    theTableView.dataSource = self;
    
    peripherals = [[NSMutableArray alloc]initWithArray:theBlueTooth.peripheralsArray];
    peripheralsNames = [[NSMutableArray alloc]init];//初始化数组
    tempPeriArray = [[NSMutableArray alloc]init];
    
    for (CBPeripheral *peri in peripherals) {
        [peripheralsNames addObject:peri.name];//把所有外设名字传入数组
    }
    
    NSLog(@"blueTVC-重要 外设peripheralsNameArray = %@",peripheralsNames);
    
    chosenNumber = -1;
    
    confirm = NO;
    blueTipButton = [[UIButton alloc]init];
    
    //[theTableView cellForRowAtIndexPath:i];
    NSLog(@"blueTVC-count=%lu",(unsigned long)peripherals.count);
    
    for (NSString *object in peripheralsNames) {
        NSLog(@"blueTVC-object in peripherals is%@,",object);
    }

    NSLog(@"blueTVC-periarray=%@",peripherals);
    
    [self loadTableView];
    [theBlueTooth.myCentralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
    
    
    NSLog(@"blueTVC-peri初始化完毕");
}



-(void)cancelTheConnectedPeriFromViewRecord
{
    [chosenPeriNameArray removeAllObjects];
    NSLog(@"chosenPeriArray删除");
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self.theTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                   });
}

-(void)getBackTheConnectedPeri:(NSNotification *)noti//最终接收一个peri数组，初始化chosenPeriNameArray，供section0使用
{
    //NSArray *arr;
    if ([noti.userInfo objectForKey:@"recordedTheConnectedPeriArray"] != nil)
    {
        chosenPeriNameArray = [[NSMutableArray alloc]initWithArray:[noti.userInfo objectForKey:@"recordedTheConnectedPeriArray"]];
        NSLog(@"recordedTheConnectedPeriArray/chosenPeriNameArray=%@",chosenPeriNameArray);
    }
    else
    {
        chosenPeriNameArray = [[NSMutableArray alloc]init];
        NSLog(@"chosenPeriNameArray为数组");
    }
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.theTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(void)swipe:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        NSLog(@"下拉");
       [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)loadTableView
{
    //signalLevel = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //engeryLevel = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //[theTableView setEditing:YES animated:YES];
    [theTableView reloadData];
    NSLog(@"blueTVC-loadTableView");
}



//tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView//tableView的部分数
{
    NSLog(@"blueTVC-部分数加载完毕");
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section//table的行数//必须要实现
{
    if (section == 1) {
        NSLog(@"blueTVC-每部分行数加载完毕,为%lu",(unsigned long)peripheralsNames.count);
        return peripheralsNames.count;
        //return 1;
    }
    else
    {
        return chosenPeriNameArray.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"已连接蓝牙";
    }
    else
        return @"周边设备";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && chosenPeriNameArray.count == 0) {
        return NO;
    }
    else
        return YES;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *connectSwipe = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"连接" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
    {
        NSLog(@"点击了tianjia");
        NSLog(@"行序列:%ld",(long)indexPath.row);
        NSLog(@"blueTVC-选中%@行时方法调用",indexPath);
        chosenNumber = indexPath.row;
        chosenName = [[NSString alloc]initWithString: [theTableView cellForRowAtIndexPath:indexPath].textLabel.text];
        //[[NSString alloc]initWithString:peripheralsNames[chosenNumber]];
        

        if (chosenName != nil)
        {
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:chosenName,@"periNameChosen", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"connectThePeripheral" object:self userInfo:dict];
            NSLog(@"blueTVC-连接通知已发送");
        }
        
    }];
    
    connectSwipe.backgroundColor = [UIColor greenColor];
    
    UITableViewRowAction *deleteSwipe = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"断开" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
    {
        NSLog(@"blueTVC-点击取消按钮");
        
        NSString *periName = [[NSString alloc]initWithString: [theTableView cellForRowAtIndexPath:indexPath].textLabel.text];//[[NSUserDefaults standardUserDefaults] objectForKey:@"peri"];
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:periName,@"cancelPeriName", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriShankingHands" object:self userInfo:[NSDictionary dictionaryWithObject:@"delete" forKey:@"option"]];//从play里调取存储的Peri postNotificationName:@"getTheConnectedPeriShankingHands" object:[NSDictionary dictionaryWithObject:@"delete" forKey:@"option"]];//从play里调取存储的Peri
        
        NSLog(@"取消的蓝牙为：%@",dict);
        NSLog(@"blueTVC-取消蓝牙连接中1");
        
        //[self periCanceled];
        
    }];
    deleteSwipe.backgroundColor = [UIColor redColor];
    
    if(indexPath.section == 1)
    {
        return @[connectSwipe];
    }
    else
    {
        return @[deleteSwipe];
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//table必须要实现
{
    NSLog(@"blueTVC-!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!tableview每行实现开始");
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    if (indexPath.section == 1)
    {
        if (peripheralsNames.count > 0)
        {
            cell.textLabel.text = peripheralsNames[row];
            NSLog(@"blueTVC-main输 出%@",peripheralsNames[row]);
        }
        else
        {
            cell.textLabel.text = nil;
        }
    }
    
    else
    {
        if (chosenPeriNameArray.count > 0) {
            cell.textLabel.text = chosenPeriNameArray[row];
            NSLog(@"blueTVC-head输出%@",peripheralsNames[row]);
        }
        else
        {
            cell.textLabel.text = nil;
        }
    }
    
    cell.textLabel.textColor = [UIColor blueColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath//选中行时的相应方法,输出chosenName即可
{
    NSLog(@"blueTVC-选中%@行时方法调用",indexPath);
    chosenNumber = indexPath.row;
    NSLog(@"blueTVC-theVhosenNumber is %ld",(long)chosenNumber);
    chosenName = [[NSString alloc]initWithString:peripheralsNames[chosenNumber]];
    NSLog(@"blueTVC-theChosenName为:%@",chosenName);
    
    NSString *periNameType = @"peri";
    NSUserDefaults *plistSaveType = [NSUserDefaults standardUserDefaults];
    [plistSaveType setObject:chosenName forKey:periNameType];
    [plistSaveType synchronize];
}

- (void)tableView:(nonnull UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath// 取消选中某行cell会调用 (当我选中第0行的时候，如果现在要改为选中第1行 - 》会先取消选中第0行，然后调用选中第1行的操作)
{
    NSLog(@"blueTVC-取消选中 didDeselectRowAtIndexPath row = %ld ", (long)indexPath.row);
}

////tip
-(void)showTip
{
    
    //玻璃视图
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    blueGlassView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    blueGlassView.tag = 46;
    
    CGFloat bound = MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    
    blueGlassView.frame = CGRectMake(0, 0, bound, bound);
    bluePlayground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bound, bound)];
    bluePlayground.tag = 50;
    
    //text内容
    
    NSString *blueTipWord1 = NSLocalizedString(@"BlueTipWord1", nil);
    NSString *tipWord2 = NSLocalizedString(@"TipWord2", nil);
    NSString *tipWebSite = NSLocalizedString(@"TipWebSite", nil);
    NSString *tips = [[NSString alloc]initWithFormat:@"%@%@%@",blueTipWord1,tipWebSite,tipWord2];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:tips];
    
    NSDictionary *tipWordDic = @{
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f]
                                 };
    
    NSDictionary *tipWebSiteDic = @{
                                    NSForegroundColorAttributeName: [UIColor blueColor],
                                    NSUnderlineStyleAttributeName:@1,
                                    };
    
    NSMutableParagraphStyle *muParagraph = [[NSMutableParagraphStyle alloc]init];
    muParagraph.lineSpacing = 6; // 行距
    muParagraph.paragraphSpacing = 12; // 段距
    muParagraph.firstLineHeadIndent = 30; // 首行缩进
    NSDictionary *tipsDic = @{
                              NSFontAttributeName:[UIFont systemFontOfSize:16],//字体大小
                              NSParagraphStyleAttributeName:muParagraph
                              };
    
    [str addAttribute:NSLinkAttributeName value:@"http://www.tongchengjinrong.com"
                range:NSMakeRange([blueTipWord1 length],[tipWebSite length])];
    NSLog(@"blueTVC-words length = %lu",(unsigned long)[tipWebSite length]);
    
    [str addAttributes:tipWordDic range:NSMakeRange(0, [tips length])];//设置富文本字体样式
    [str addAttributes:tipWebSiteDic range:NSMakeRange([blueTipWord1 length], [tipWebSite length])];//设置富文本网址样式
    [str addAttributes:tipsDic range:NSMakeRange(0, [tips length])];
    
    //textView
    UITextView *tipTextView = [[UITextView alloc]init];
    CGFloat hStart = ([UIScreen mainScreen].bounds.size.height)/8.0f;
    CGFloat wStart = ([UIScreen mainScreen].bounds.size.width)/8.0f;
    tipTextView.frame = CGRectMake(wStart, hStart, wStart*6.0f, hStart*6.0f);
    tipTextView.backgroundColor = [UIColor clearColor];
    tipTextView.editable = NO;
    tipTextView.delegate = self;
    tipTextView.scrollEnabled = YES;
    tipTextView.showsVerticalScrollIndicator = YES;
    tipTextView.attributedText = str;
    tipTextView.tag = 47;
    tipTextView.textColor = [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f];
    tipTextView.font = [UIFont systemFontOfSize:15];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(wStart*7.0f-50.0f, hStart*7.0f, 100, hStart/2.0f)];
    [button setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tipButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //button.backgroundColor = [UIColor blackColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    button.tag = 48;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //button.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    
    UIButton *buttonFeedback = [[UIButton alloc]initWithFrame:CGRectMake(wStart, hStart*7.0f, 100, hStart/2.0f)];
    [buttonFeedback setTitle:NSLocalizedString(@"FeedBack", nil) forState:UIControlStateNormal];
    [buttonFeedback setTitleColor:[UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    [buttonFeedback addTarget:self action:@selector(feedbackEmailTapped:) forControlEvents:UIControlEventTouchUpInside];
    //button.backgroundColor = [UIColor blackColor];
    buttonFeedback.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    buttonFeedback.tag = 49;
    buttonFeedback.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //button.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    
    //[tipTextView addSubview:button];
    //[blueGlassView addSubview:tipTextView];
    [bluePlayground addSubview:tipTextView];
    //[blueGlassView addSubview:button];
    [bluePlayground addSubview:button];
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad){
        //[blueGlassView addSubview:buttonFeedback];
        [bluePlayground addSubview:buttonFeedback];
    }
    [self.view addSubview:blueGlassView];
    [self.view addSubview:bluePlayground];
    blueTipsTip = YES;
    //[self.view addSubview:button];
    
}

-(void)feedbackEmailTapped:(id)tap
{
    [self eMailWrite];
    NSLog(@"blueTVC-邮件反馈点击");
}

-(void)eMailWrite
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSLog(@"blueTVC-Mail services are available.");
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc]init];
        
        //[mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:fileName];
        
        [mailComposer setSubject:NSLocalizedString(@"FeedBackContent", nil)]; // Use the document file name for the subject
        [mailComposer setToRecipients:@[@"357274178@qq.com"]];
        
        mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
        
        mailComposer.mailComposeDelegate = self; // MFMailComposeViewControllerDelegate
        
        [self presentViewController:mailComposer animated:YES completion:nil];
        
        //return;
    }
}

-(void)tipButtonTapped:(id)tap//tip中取消按钮点击
{
    NSLog(@"blueTVC-按钮点击");
    [self removeTipView];
    blueTipsTip = NO;
}

-(void)removeTipView
{
    for (UIView *view in [self.view subviews]) {
        if (view.tag == 46) {
            [view removeFromSuperview];
        }
        else if (view.tag == 47){
            [view removeFromSuperview];
        }
        else if (view.tag == 48){
            [view removeFromSuperview];
        }
        else if (view.tag == 49){
            [view removeFromSuperview];
        }
        else if (view.tag == 50){
            [view removeFromSuperview];
        }
    }
}

-(void)diviceRotated:(id)gesture//设备翻转回调
{
    [self removeTipView];
    if (blueTipsTip == YES) {
        NSLog(@"blueTVC-设备翻转，tips弹出");
        [self showTip];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.theTableView.dataSource = self;
    self.theTableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"timersSwitch" object:self userInfo:[NSDictionary dictionaryWithObject:@"turnOn" forKey:@"option"]];
    
    NSLog(@"blueTVC-viewDidLoad");
    
    engeryValue = 0;
    signalValue = 0;
    [engeryLevel setProgress:engeryValue];
    [signalLevel setProgress:signalValue];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(diviceRotated:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    blueTipsTip = NO;
    
    // Do any additional setup after loading the view from its nib.
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //[self load];
    
    [self.theTableView reloadData];
    NSLog(@"blueTVC-viewWillAppear");
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //theTableView.frame =CGRectMake(23, 33, 128, 238);
    //[self.view addSubview:theTableView];
    //UISwipeGestureRecognizer
}

/*-(IBAction)action:(id)sender
{
    [engeryLevel setProgress:engeryValue];
    [signalLevel setProgress:signalValue];
    NSLog(@"更新进度条");
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (IBAction)connect:(id)sender {
    confirm = YES;
    NSLog(@"blueTVC-连接按钮点击");
    if (chosenName != nil)
    {
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:chosenName,@"periNameChosen", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"connectThePeripheral" object:self userInfo:dict];
        NSLog(@"blueTVC-连接通知已发送");
    }
}

- (IBAction)deleteConnect:(id)sender {
    NSLog(@"blueTVC-点击取消按钮");
    
    NSString *plistNameType = @"peri";
    NSUserDefaults *plistReadType = [NSUserDefaults standardUserDefaults];
    NSString *readName = [plistReadType objectForKey:plistNameType];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:readName,@"cancelPeriName", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelConnect" object:self userInfo:dict];
    NSLog(@"blueTVC-取消蓝牙连接中");
}*/

- (IBAction)finish:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Tip:(id)sender
{
    [self showTip];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"stopScan" object:self userInfo:nil];
}
-(void)dealloc
{
    //[super dealloc];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"timersSwitch" object:self userInfo:[NSDictionary dictionaryWithObject:@"turnOff" forKey:@"option"]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"stopScan" object:self userInfo:nil];
    
    if (chosenPeriNameArray.count > 0) {
        //NSUserDefaults *periSaveType = [NSUserDefaults standardUserDefaults];
        //[periRead removeObjectForKey:@"chosenPeri"];
        //[periRead setObject:[[NSArray alloc]initWithArray: chosenPeriNameArray] forKey:@"chosenPeri"];
        //[periRead synchronize];
        NSLog(@"peri存入文件，名称为：%@",chosenPeriNameArray);
    }
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:@"freshTableView"];
    [[NSNotificationCenter defaultCenter]removeObserver:@"reloadProgress"];
    [[NSNotificationCenter defaultCenter]removeObserver:@"periConnected"];
    [[NSNotificationCenter defaultCenter]removeObserver:@"getTheConnectedPeriDeleteForRefreshingTableview"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"getTheConnectedPeriNotiBackForRefreshingTableView"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"cancelTheConnectedPeri"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"labelShow"];
    
    
    
    
    //[[NSNotificationCenter defaultCenter]removeObserver:@"connectThePeripheral"];
}

@end
