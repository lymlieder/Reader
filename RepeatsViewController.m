//
//  RepeatsViewController.m
//  Reader
//
//  Created by FairyAnnie on 2017/5/13.
//
//

/*#import "RepeatsViewController.h"

@interface RepeatsViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,NSCoding>

@end

@implementation RepeatsViewController

@synthesize documentPageCount,documentName,transArray,playArray,textLabel,pickerView,segmentedContorl,attributedString,attch,rowNumber,playDictionary,transDictionary,pickerData,returnBack,deleteData,backSpace,nextStep,record;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:playDictionary forKey:@"playDictionary"];
    [aCoder encodeObject:transDictionary forKey:@"transDictionary"];
    NSLog(@"调用加密");
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.playDictionary = [aDecoder decodeObjectForKey:@"playDictionary"];
    self.transDictionary = [aDecoder decodeObjectForKey:@"transDictionary"];
    NSLog(@"调用解码");
    return self;
}



-(void) getDocumentInfoFrom:(ReaderDocument *)document
{
    self.documentName = document.fileName;
    self.documentPageCount = document.pageCount;
    NSLog(@"repeat.文件信息设置完毕,页码数为:%@，名字为:%@",documentPageCount,documentName);
    NSLog(@"页码数组加载完毕");
}

-(void) clearAll//
{
    self.transArray = [[NSMutableArray alloc]init];
    [self.transArray removeAllObjects];
    
    self.playArray = [[NSMutableArray alloc]init];
    [self.playArray removeAllObjects];
    NSLog(@"清除所有数组元素");
}

-(void)loadButtons
{
    returnBack = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBack.frame = CGRectMake(37, 108, 46, 30);
    returnBack.backgroundColor = [UIColor clearColor];
    [returnBack setTitle:@"返回" forState:UIControlStateNormal];
    [returnBack setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [returnBack addTarget:self action:@selector(returnBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBack];
    
    record = [UIButton buttonWithType:UIButtonTypeSystem];
    record.frame = CGRectMake(291, 108, 46, 30);
    record.backgroundColor = [UIColor clearColor];
    [record setTitle:@"完成" forState:UIControlStateNormal];
    [record setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [record addTarget:self action:@selector(recodeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:record];
    
    deleteData = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteData.frame = CGRectMake(37, 606, 46, 30);
    deleteData.backgroundColor = [UIColor clearColor];
    [deleteData setTitle:@"删除" forState:UIControlStateNormal];
    [deleteData setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [deleteData addTarget:self action:@selector(deleteDataButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteData];
    
    backSpace = [UIButton buttonWithType:UIButtonTypeSystem];
    backSpace.frame = CGRectMake(199, 606, 46, 30);
    backSpace.backgroundColor = [UIColor clearColor];
    [backSpace setTitle:@"回删" forState:UIControlStateNormal];
    [backSpace setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backSpace addTarget:self action:@selector(backSpaceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backSpace];
    
    nextStep = [UIButton buttonWithType:UIButtonTypeSystem];
    nextStep.frame = CGRectMake(291, 606, 46, 30);
    nextStep.backgroundColor = [UIColor clearColor];
    [nextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStep setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [nextStep addTarget:self action:@selector(recodeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStep];
}


-(void) load
{
    
    textLabel = [[UILabel alloc]initWithFrame:CGRectMake(37, 108, 46, 30)];
    segmentedContorl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(37, 346, 300, 29)];
    pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(37, 382, 131, 198)];
    
    pickerData = [[NSMutableArray alloc]init];
    // [pickerData addObject:@"1"];
    //[pickerData addObject:@"1"];
    //[pickerData addObject:@"1"];
    //[pickerData addObject:@"1"];
    for (int i=0; i<[documentPageCount intValue]; i++) {
        NSString *title = [NSString stringWithFormat:@"%i",i+1];
        [pickerData addObject:title];
        NSLog(@"%@",title);
    }
    
    [self loadPickerView];
    [self loadTextView];
    [self loadSegmentedControl];
    //[self.view addSubview:self.pickerView];
    NSLog(@"load结束");
}

-(void) loadTextView
{
    textLabel.text = @"";
    //textLabel.backgroundColor = [UIColor blueColor];
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 0;
    [textLabel sizeToFit];
    textLabel.textColor = [UIColor blueColor];
    NSLog(@"text界面加载完毕");
}

-(void) loadSegmentedControl
{
    
}

-(void) loadPickerView
{
    pickerView.delegate = self;
    NSLog(@"代理加载完毕");
    pickerView.dataSource = self;
    NSLog(@"数据源加载完毕");
    pickerView.showsSelectionIndicator = YES;
    //[self.view addSubview:pickerView];
    [pickerView reloadAllComponents];
    for (int i=0; i<[documentPageCount intValue]; i++) {
        [pickerView selectRow:i inComponent:0 animated:nil];
    }
    //for (int i=0; i<[documentPageCount intValue]; i++) {
    //  [self pickerView:pickerView titleForRow:i forComponent:0];
    //}//加载每行标题
    NSInteger a = [pickerView numberOfRowsInComponent:0];
    NSLog(@"滚轮行数反馈为：%ld",(long)a);
    pickerView.backgroundColor = [UIColor blueColor];
    //[pickerView ]
    [pickerView reloadAllComponents];
    //[self.view addSubview:pickerView];
    NSLog(@"picker设置结束");
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSLog(@"repeat.滚轮数量加载完毕");
    return 1;
};//指定pickerview有几个表盘

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"repeat.滚轮指定行数为:%@",documentPageCount);
    
    return [documentPageCount integerValue];
}//指定每个表盘上有几行数据

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //row = row+1;
    //NSString * title = [NSString stringWithFormat:@"%li",(long)row];
    NSLog(@"repeat.初始化滚轮第%ld行为:%@",(long)row,pickerData[row]);
    NSLog(@"滚轮行数为:%ld",pickerData.count);
    return [pickerData objectAtIndex:row];
    //return @"a";
}

//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component//更新rowNumber
//{
//  rowNumber = [NSNumber numberWithInteger:row];
//NSLog(@"repeat.选中的行数是:%@",rowNumber);
//}




-(void) freshTransArray
{
    NSInteger x=0;
    NSInteger y=1;
    CGPoint point = CGPointMake(x, y);//第一位为类型位
    NSValue *value = [NSValue valueWithCGPoint:point];
    transArray = [[NSMutableArray alloc]initWithObjects:value,nil];
    NSLog(@"repeat.trans初始化完毕，count=%lu",(unsigned long)transArray.count);
}

-(void) freshPlayArray
{
    playArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[documentPageCount intValue]; i++)
    {
        NSNumber *number = [NSNumber numberWithInteger:i];
        [playArray addObject:number];
    }
    NSLog(@"repeat.play初始化完毕，count=%lu",(unsigned long)playArray.count);
}

-(void) freshArrays
{
    [self freshTransArray];
    [self freshPlayArray];
    NSLog(@"repeat.两个数组初始化完毕");
}

-(void) showTheTransArray//调用text显示trans数组
{
    attributedString = [[NSMutableAttributedString alloc]init];//富文本
    attch = [[NSTextAttachment alloc]init];//NSTextAttachment可以将要插入的图片作为特殊字符处理
    
    //判断
    
    for (int i=0; i<transArray.count; i++)
    {
        NSValue *value = [[NSValue alloc]init];
        value = transArray[i];
        CGPoint point = [value CGPointValue];//取出数组元素的值
        NSInteger type = point.x;
        switch (type)
        {
            case 0:
                attch.image = [UIImage imageNamed:@"playInOrderG"];
                break;
                
            case 1:
                attch.image = [UIImage imageNamed:@"foreStep"];
                break;
                
            case 2:
                attch.image = [UIImage imageNamed:@"playInOrder"];
                break;
                
            case 3:
                attch.image = [UIImage imageNamed:@"behindStep"];
                break;
                
            default:
                break;
        }
        attch.bounds = CGRectMake(0, 0, 32, 32);
        NSAttributedString *additionType = [NSAttributedString attributedStringWithAttachment:attch];//把特殊字符装进富文本字符串,type
        
        NSString *number = [NSString stringWithFormat:@"%f",point.x];
        NSAttributedString *additionNumber = [[NSMutableAttributedString alloc]initWithString:number];//number
        
        if (transArray.count==1)
        {
            [attributedString insertAttributedString: additionNumber atIndex:0];//0位置的字符,
            [attributedString insertAttributedString:additionType atIndex:1];//类型
        }
        else
        {
            if (i==0)//第一个元素
            {
                [attributedString insertAttributedString: additionNumber atIndex:0];
            }
            else
            {
                [attributedString insertAttributedString:additionType atIndex:2*i-1];//把临时富文本转入演示富文本,类型
                [attributedString insertAttributedString:additionNumber atIndex:2*i];//页码
            }
        }
    }
    textLabel.attributedText = attributedString;
    //textLabel.text=@"\ue415\ue056";
    NSLog(@"repeat.text加载完毕");
}

-(void) transTheTransArrayToPlayArray//转录
{
    playArray = [[NSMutableArray alloc]init];
    if (transArray.count == 1)//只有一个元素的时候，顺序编码
    {
        for (int i=0; i<[documentPageCount intValue]; i++)
        {
            [playArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    else//否则，多个元素
    {
        NSValue *value = [[NSValue alloc]init];//首元素
        value = transArray[1];
        CGPoint point = [value CGPointValue];//取出数组元素的值
        for (int i=1; i<point.y+1; i++)
        {
            [playArray addObject:[NSNumber numberWithInt:i]];
        }
        for (int i=1; i<transArray.count; i++)//第二个元素开始
        {
            NSValue *lastValue = [[NSValue alloc]init];
            NSValue *currentValue = [[NSValue alloc]init];
            lastValue = transArray[i-1];
            currentValue = transArray[i];
            CGPoint lastPoint = [lastValue CGPointValue];
            CGPoint currentPoint = [currentValue CGPointValue];//取出数组元素的值
            NSInteger type = currentPoint.x;
            
            switch (type)
            {
                case 1:
                    [playArray addObject:[NSNumber numberWithInt:currentPoint.y]];
                    break;
                    
                case 2:
                {
                    if (lastPoint.y<currentPoint.y)
                    {
                        for (int j=lastPoint.y+1; j<currentPoint.y+1; j++)
                        {
                            [playArray addObject:[NSNumber numberWithInt:j]];
                        }
                    }
                    else
                        NSLog(@"repeat.trans演奏逆序");
                }
                    break;
                    
                case 3:
                    [playArray addObject:[NSNumber numberWithInt:currentPoint.y]];
                    break;
                    
                default:
                    break;
            }
        }
    }
    NSLog(@"repeat.转录完成");
}

-(void) recordThePlayOrder
{
    playDictionary=[NSMutableDictionary dictionaryWithObject:playArray forKey:documentName];
    [NSKeyedArchiver archiveRootObject:playDictionary toFile:@"ReaderPadPlay.plist"];
    NSLog(@"Play.plist文件已被重置");
}

-(void) recordTheTransOrder
{
    transDictionary=[NSMutableDictionary dictionaryWithObject:transArray forKey:documentName];
    [NSKeyedArchiver archiveRootObject:transDictionary toFile:@"ReaderPadTrans.plist"];
    NSLog(@"Trans.plist文件已被重置");
}

-(NSMutableArray *)readThePlayOrder
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ReaderPadPlay" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    result = [data objectForKey:documentName];
    NSLog(@"repeat.play.plist文件提取完毕");
    return result;
}

-(NSMutableArray *)readTheTransOrder
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ReaderPadPTrans" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    result = [data objectForKey:documentName];
    NSLog(@"repeat.trans.plist文件提取完毕");
    return result;
}

-(void) freshPlists//重写
{
    [self freshTransArray];
    [self freshPlayArray];
    [self recordThePlayOrder];
    [self recordTheTransOrder];
    NSLog(@"repeat.plists重写完毕");
}

-(void)deleteTheLastElementOfTransArray
{
    [transArray removeLastObject];
    [self transTheTransArrayToPlayArray];
}

-(void)returnBackButtonTapped:(UIButton *)button//返回
{
    [self freshArrays];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"repeat.返回");
}

-(void)recodeButtonTapped:(UIButton *)button//存储，完成
{
    [self recordTheTransOrder];
    [self recordThePlayOrder];
    [transArray removeAllObjects];
    [playArray removeAllObjects];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"repeat.保存结束，退出");
}

-(void)deleteDataButtonTapped:(UIButton *)button//删除
{
    NSString *Confirm = NSLocalizedString(@"Confirm", nil);
    NSString *Tip = NSLocalizedString(@"Tip", nil);
    NSString *Sure = NSLocalizedString(@"Sure", nil);
    NSString *Cancel = NSLocalizedString(@"Cancel", nil);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Confirm message:Tip preferredStyle:UIAlertControllerStyleAlert];
    
    //[alert setalert]
    
    UITextField * text = [[UITextField alloc] initWithFrame:CGRectMake(15, 64, 240, 30)];//wight = 270;
    text.borderStyle = UITextBorderStyleRoundedRect;//设置边框的样式
    [alert.view addSubview:text];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:Sure style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                         {
                             [self freshArrays];
                             [self freshPlists];
                             [self showTheTransArray];
                         }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:ok];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{ }];
    NSLog(@"repeat.删除结束");
}

-(void)backSpaceButtonTapped:(UIButton *)button//回删
{
    [self deleteTheLastElementOfTransArray];
    [self showTheTransArray];
    NSLog(@"repeat.回删");
}

-(void)nestStepButtonTapped:(UIButton *)button//下一步
{
    NSInteger type = self.segmentedContorl.selectedSegmentIndex+1;
    
    if (segmentedContorl.selectedSegmentIndex == 0) {
        NSLog(@"1");
    }
    else if (segmentedContorl.selectedSegmentIndex == 1){
        NSLog(@"2");
    }
    else if (segmentedContorl.selectedSegmentIndex == 2){
        NSLog(@"3");
    }
    else if (segmentedContorl.selectedSegmentIndex == 3){
        NSLog(@"4");
    }
    NSInteger number = [pickerView selectedRowInComponent:0 ];
    //[rowNumber integerValue]+1;
    CGPoint point = {type,number};
    NSValue *value = [NSValue valueWithCGPoint:point];
    [transArray addObject:value];
    NSLog(@"repeat.trans增加元素:%@",value);
}

-(void)viewDidLoad {
    [super viewDidLoad];
    //[self.view addSubview:pickerView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 

@end*/
