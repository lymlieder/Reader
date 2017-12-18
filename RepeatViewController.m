//
//  RepeatViewController.m
//  Reader
//
//  Created by FairyAnnie on 2017/5/13.
//
//

#import "RepeatViewController.h"

@interface RepeatViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,NSCoding,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate>

@end

@implementation RepeatViewController

@synthesize documentPageCount,documentName,transArray,playArray,textLabel,pickerView,segmentedContorl,attributedString,attch,rowNumber,playDictionary,transDictionary,pickerData,rightNumberArray,imageView,theFileURL,phrase,guid,transArrayType,transArrayNumber,transDictionaryType,transDictionaryNumber,pReciveCells,imageArray,blackView,pageNumber,theFilePath,imageBoard,detailShowBackgrand,rotateTip,peerViewChosenPageNumber,glassView,tipsTip,glassViewTip,tipBackgrand;

/*+(instancetype)repeatView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"RepeatViewController" owner:nil options:nil]lastObject];
}*/

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:playDictionary forKey:@"playDictionary"];
    [aCoder encodeObject:transDictionary forKey:@"transDictionary"];
    [aCoder encodeObject:transDictionaryType forKey:@"transDictionaryType"];
    [aCoder encodeObject:transDictionaryNumber forKey:@"transDictionaryNumber"];
    [aCoder encodeObject:playArray forKey:@"playArray"];
    [aCoder encodeObject:transArrayType forKey:@"transArrayType"];
    [aCoder encodeObject:transArrayNumber forKey:@"transArrayNumber"];
    NSLog(@"调用加密");
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.playDictionary = [aDecoder decodeObjectForKey:@"playDictionary"];
    self.transDictionary = [aDecoder decodeObjectForKey:@"transDictionary"];
    self.transArrayType = [aDecoder decodeObjectForKey:@"transDictionaryType"];
    self.transDictionaryNumber = [aDecoder decodeObjectForKey:@"transDictionaryNumber"];
    self.playArray = [aDecoder decodeObjectForKey:@"playArray"];
    self.transArrayType = [aDecoder decodeObjectForKey:@"transArrayType"];
    self.transArrayNumber = [aDecoder decodeObjectForKey:@"transArrayNumber"];
    NSLog(@"调用解码");
    return self;
}

//ReaderThumbRequest *thumbRequest = [ReaderThumbRequest newForView:thumbCell fileURL:fileURL password:phrase guid:guid page:page size:size];


-(void)showRightImageAt:(NSInteger)page
{
    CGRect imageRect = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    NSLog(@"输出的right数量为:%lu",(unsigned long)rightNumberArray.count);
    
        ReaderContentView *contentView = [[ReaderContentView alloc] initWithFrame:imageRect fileURL:theFileURL page:page password:phrase];
    
    
    imageBoard = [[UIView alloc]initWithFrame:imageView.frame];
    imageBoard.backgroundColor = [UIColor clearColor];
    //imageBoard.alpha = 0.5;
    imageBoard.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *imageTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapped:)];
    imageTapped.numberOfTouchesRequired = 1;
    imageTapped.numberOfTapsRequired = 1;
    imageTapped.delegate = self;
    
    [imageBoard addGestureRecognizer:imageTapped];
    [self.view addSubview:imageBoard];
    [imageView insertSubview:contentView belowSubview:imageBoard];
    //[contentView insertSubview:imageBoard atIndex:0];
    ////////////重要重要！！显示现在页面
    
}

-(void)freshRightImage
{
    if (rightNumberArray.count != 0)
    {
        pageNumber = [rightNumberArray[[pickerView selectedRowInComponent:0]]integerValue];
        [self showRightImageAt:pageNumber];
    }
    else
    {
        //UIImage *image = [UIImage imageNamed:@"repeatMark.png"];
        UIImageView *empty = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        empty.backgroundColor = [UIColor whiteColor];
        //[empty setImage:image];
        [imageView addSubview:empty];
        
    }
   
    NSLog(@"image更新");
}

//滚轮
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSLog(@"repeat.指定pickerview有几个表盘");
    return 1;
};//指定pickerview有几个表盘

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //NSLog(@"repeat.指定每个表盘有几行数据:%@",documentPageCount);
    
    //return [documentPageCount integerValue];
    NSLog(@"repeat.指定每个表盘有几行数据:%lu",(unsigned long)rightNumberArray.count);
    
    return rightNumberArray.count;
}//指定每个表盘上有几行数据

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"repeat.初始化表盘第%ld行为:%@",(long)row,rightNumberArray[row]);
    NSLog(@"表盘行数为:%ld",(unsigned long)rightNumberArray.count);
    NSString *string = rightNumberArray[row];
    return string;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component//更新rowNumber
{
    [self freshRightImage];
    NSLog(@"repeat.选中的行数是:%ld",(long)row);
}


-(void) getDocumentInfoFrom:(ReaderDocument *)document
{
    self.documentName = [[NSString alloc]initWithString: document.fileName ];
    self.documentPageCount = document.pageCount;
    //self.theFileURL = [[NSURL alloc]init];
    self.theFileURL = document.fileURL;
    //self.phrase = [[NSString alloc]initWithString: document.password];
    self.phrase = nil;
    self.guid = [[NSString alloc]initWithString:document.guid];
    NSLog(@"repeat.文件信息设置完毕,页码数为:%@，名字为:%@",documentPageCount,documentName);
    NSLog(@"页码数组加载完毕");
}

-(void) clearAll//
{
    for (int i=0; i<transArray.count; i++) {
        [transArray removeLastObject];
    }
    
    for (int i=0; i<playArray.count; i++) {
        [playArray removeLastObject];
    }
    NSLog(@"暴力清除所有数组元素");
}



-(void) load
{
    textLabel = [[UITextView alloc]init];
    pickerView = [[UIPickerView alloc]init];
    pickerData = [[NSMutableArray alloc]init];
    imageView = [[UIImageView alloc]init];
    imageArray = [[NSMutableArray alloc]init];
    theFilePath = [[NSString alloc]init];
    
    
    for (int i=0; i<[documentPageCount intValue]; i++) {
        NSString *title = [NSString stringWithFormat:@"%i",i+1];
        [pickerData addObject:title];
        NSLog(@"%@",title);//设置页码数组
    }
    NSLog(@"页码数组的元素有%lu个",(unsigned long)pickerData.count);
    
    rightNumberArray = [[NSMutableArray alloc]initWithArray:pickerData];
    NSLog(@"playRight数组的元素有%lu个",(unsigned long)pickerData.count);
    
    [self loadPickerView];
    [self loadTextView];
    [self loadSegmentedControl];
    [self readThePlayOrder];
    //if ([self readTheTransOrder]==NO) {
        //[self freshTransArray];
        NSLog(@"trans读取失败，再创建");
    //}
    
    //[self showTheTransArray];
    //[self contentSizeToFit];
    //[self.view addSubview:self.pickerView];
    //[self freshArrays];
    //transArray = [NSMutableArray arrayWithArray:[self readTheTransOrder]];
    //playArray = [NSMutableArray arrayWithArray:[self readThePlayOrder]];
    //[self showTheTransArray];
    [imageView.layer setMasksToBounds:NO];
    [imageView.layer setCornerRadius:20];
    
    NSLog(@"load结束");
}

-(void) loadTextView
{
    //self.textLabel.text = @"123";
    //textLabel.backgroundColor = [UIColor blueColor];
    //textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //textLabel.numberOfLines = 0;
    //[textLabel sizeToFit];
    //textLabel.textColor = [UIColor blueColor];
    //textLabel.directionalLockEnabled=YES;
    //textLabel.showsVerticalScrollIndicator=YES;
    //textLabel.editable = NO;
    textLabel.delegate = self;
    textLabel.scrollEnabled = YES;
    textLabel.showsVerticalScrollIndicator = YES;
    textLabel.textAlignment = NSTextAlignmentCenter;
    //[self contentSizeToFit];
    
    //textLabel.attributedText = str;
    //textLabel.tag = 36;
    //textLabel.textColor = [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f];
    //textLabel.font = [UIFont systemFontOfSize:15];
    //textLabel.numberOfLines = 0;
    //[textLabel sizeToFit];
    //textLabel.textColor = [UIColor blueColor];
    
    NSLog(@"text界面加载完毕");
}

- (void)contentSizeToFit
{
    //先判断一下有没有文字（没文字就没必要设置居中了）
    //if([self.textLabel.text length]>0)
    {
        //textView的contentSize属性
        CGSize contentSize = self.textLabel.contentSize;
        //CGSize newSize = contentSize;
        //CGPoint offsetPoint;
        
        //如果文字内容高度没有超过textView的高度
        if(contentSize.height <= self.textLabel.frame.size.height)
        {
            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
            CGFloat offsetY = (self.textLabel.frame.size.height - contentSize.height)/2;
            CGPoint offsetPoint = CGPointMake(0, -offsetY);
            
            textLabel.contentOffset = offsetPoint;
        }
        else          //如果文字高度超出textView的高度
        {
            [textLabel scrollRangeToVisible:NSMakeRange(textLabel.text.length, 1)];
            self.textLabel.layoutManager.allowsNonContiguousLayout = NO;
            //text滚动到最后一行
            
            //CGFloat fontSize = 18;
            //通过一个while循环，设置textView的文字大小，使内容不超过整个textView的高度（这个根据需要可以自己设置）
            /*while (contentSize.height > self.textLabel.frame.size.height)
            {
                [self.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                contentSize = self.textLabel.contentSize;
            }*/
            //newSize = contentSize;
        }
        //根据前面计算设置textView的ContentSize和Y方向偏移量
        //[self.textLabel setContentSize:newSize];
        //[self.textLabel setContentInset:offset];
    }
}


-(void) loadSegmentedControl
{
    
}

-(void) loadPickerView
{
    NSInteger a = [pickerView numberOfRowsInComponent:0];
    NSLog(@"滚轮行数反馈为：%ld",(long)a);
    pickerView.backgroundColor = [UIColor blueColor];
    NSLog(@"picker设置结束");
}


-(void) freshTransArray
{
    transArray = [[NSMutableArray alloc]init];
    NSInteger x=0;
    NSInteger y=1;
    CGPoint point = CGPointMake(x, y);//第一位为类型位
    NSValue *value = [NSValue valueWithCGPoint:point];
    [transArray addObject:value];
    //transArray = [[NSMutableArray alloc]initWithObjects:value,nil];
    NSLog(@"repeat.trans初始化完毕，count=%lu",(unsigned long)transArray.count);
    NSLog(@"repeat.trans=%@",transArray);
}

-(void) freshPlayArray
{
    playArray = [[NSMutableArray alloc]init];
    [self freshTransArray];
    [self transTheTransArrayToPlayArray];
    
    NSLog(@"repeat.play初始化完毕，count=%lu",(unsigned long)playArray.count);
}

-(void) freshArrays
{
    [self freshTransArray];
    [self freshPlayArray];
    NSLog(@"repeat.两个数组初始化完毕");
}

-(void) freshAll
{
    [self freshTransArray];
    [self transTheTransArrayToPlayArray];
    [self recordThePlayOrder];
    [self recordTheTransOrder];
    NSLog(@"freshAll finish");
}

/*- (NSAttributedString *)stringWithUIImage:(NSString *) contentStr {
    // 创建一个富文本
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    // 修改富文本中的不同文字的样式
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 5)];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 5)];
    
 
     添加图片到指定的位置
 
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    // 表情图片
    attchImage.image = [UIImage imageNamed:@"jiedu"];
    // 设置图片大小
    attchImage.bounds = CGRectMake(0, 0, 40, 15);
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    [attriStr insertAttributedString:stringImage atIndex:2];
    
    // 设置数字为红色
    
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:30]};
    [attriStr addAttributes:attriBute range:NSMakeRange(5, 9)];
    
    // 添加表情到最后一位
    //NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
   // attch.image = [UIImage imageNamed:@"jiedu"];
    // 设置图片大小
    //attch.bounds = CGRectMake(0, 0, 40, 15);
    // 创建带有图片的富文本
    //NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    //[attriStr appendAttributedString:string];
    
    return attriStr;
}*/

-(void) showTheTransArray//调用text显示trans数组
{
    attributedString = [[NSMutableAttributedString alloc]init];//富文本
    
    
    //判断
    
    for (int i=0; i<transArray.count; i++)
    {
        attch = [[NSTextAttachment alloc]init];//NSTextAttachment可以将要插入的图片作为特殊字符处理
        NSValue *value = [[NSValue alloc]init];
        value = transArray[i];
        CGPoint point = [value CGPointValue];//取出数组元素的值
        NSInteger type = point.x;
        NSLog(@"show type=%ld",(long)type);
        switch (type)
        {
            case 0:
                attch.image = [UIImage imageNamed://@"foreStep"];
                               @"playInOrderG"];
                NSLog(@"图片0");
                break;
                
            case 1:
                attch.image = [UIImage imageNamed:@"foreStep"];
                NSLog(@"图片1");
                break;
                
            case 2:
                attch.image = [UIImage imageNamed:@"playInOrder"];
                NSLog(@"图片2");
                break;
                
            case 3:
                attch.image = [UIImage imageNamed:@"behindStep"];
                NSLog(@"图片3");
                break;
                
            default:
                break;
        }
        attch.bounds = CGRectMake(0, 0, 16, 16);
        NSAttributedString *addType = [NSAttributedString attributedStringWithAttachment:attch];//把特殊字符装进富文本字符串,type
        NSMutableAttributedString *additionType = [[NSMutableAttributedString alloc]initWithAttributedString:addType];//再变成可变富文本字符串
        
        int pointy=point.y;
        NSString *number = [NSString stringWithFormat:@"%i",pointy];
        NSMutableAttributedString *additionNumber = [[NSMutableAttributedString alloc]initWithString:number];//number
       
        
        NSMutableParagraphStyle *muParagraph = [[NSMutableParagraphStyle alloc]init];//行间距等
        muParagraph.lineSpacing = 6; // 行距
        muParagraph.paragraphSpacing = 12; // 段距
        
        NSDictionary *addDic = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:22],//字体大小
                                 NSParagraphStyleAttributeName:muParagraph,//添加行间距等
                                 NSKernAttributeName:[NSNumber numberWithInteger:4]//字间距
                                 };
        
        [additionType addAttributes:addDic range:NSMakeRange(0, [addType length])];//设置富文本效果
        [additionNumber addAttributes:addDic range:NSMakeRange(0, [number length])];
        
        if (transArray.count==1)
        {
            [attributedString appendAttributedString:additionNumber];//0位置的字符,
            [attributedString appendAttributedString:additionType];//类型
        }
        else
        {
            if (i==0)//第一个元素
            {
                //[attributedString insertAttributedString: additionNumber atIndex:0];
                [attributedString appendAttributedString:additionNumber];
            }
            else
            {
                //[attributedString insertAttributedString:additionType atIndex:2*i-1];//把临时富文本转入演示富文本,类型
                [attributedString appendAttributedString:additionType];
                //[attributedString insertAttributedString:additionNumber atIndex:2*i];//页码
                [attributedString appendAttributedString:additionNumber];
            }
        }
    }
    [self contentSizeToFit];
    //textLabel.contentOffset = CGPointMake(0, -100);
    textLabel.attributedText = attributedString;
    
    [self contentSizeToFit];
    //textLabel.editable = NO;
    //[textLabel setNumberOfLines:0];
    //textLabel.lineBreakMode =NSLineBreakByWordWrapping;
    
    /*
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0,0,32,32);
    imageView.image = [UIImage imageNamed:@"playInOrder.png"];
    imageView.backgroundColor = [UIColor clearColor];
    [textLabel addSubview:imageView];*/
    NSLog(@"repeat.text加载完毕");
}

-(void) transTheTransArrayToPlayArray//转录
{
    playArray = [[NSMutableArray alloc]init];
    if (transArray.count <= 1)//小于等于一个元素的时候，顺序编码
    {
        for (int i=0; i<[documentPageCount intValue]; i++)
        {
            [playArray addObject:[NSNumber numberWithInt:i+1]];
            NSLog(@"小于1，重新编码，play=%@",playArray);
        }
    }
    else//否则，多个元素
    {
        [playArray addObject:[NSNumber numberWithInt:1]];//第一个元素为1
        NSLog(@"trans多个元素");
        NSValue *value = [[NSValue alloc]init];//首元素
        value = transArray[1];
        CGPoint point = [value CGPointValue];//取出数组元素的值
        for (int i=1; i<point.y+1; i++)
        {
            //[playArray addObject:[NSNumber numberWithInt:i]];
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
                    if (lastPoint.y<=currentPoint.y)
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

-(void)prerecordTheTrans//transType,transNumber.dic初始化,预存储
{
    transArrayType = [[NSMutableArray alloc]init];
    transArrayNumber = [[NSMutableArray alloc]init];
    //transDictionaryType = [[NSMutableDictionary alloc]init];
    //transDictionaryNumber = [[NSMutableDictionary alloc]init];
    NSLog(@"transArray.count=%lu",(unsigned long)transArray.count);
    for (int i=0; i<transArray.count; i++)
    {
        //NSInteger typeT = [transArray objectAtIndex:i];
        //NSInteger numberT = [transArray objectAtIndex:i]
        /*NSLog(@"point为:%@",transArray[i]);
        NSValue *value = transArray[i];
        NSLog(@"value为:%@",value);
        CGPoint point = [value CGPointValue];
        NSInteger x = point.x;
        NSInteger y = point.y;
        NSLog(@"CGPoint.x为:%ld,y为%ld",(long)x,(long)y);
        NSNumber *type = [NSNumber numberWithInteger:x];
        NSNumber *number = [NSNumber numberWithInteger:y];
        NSLog(@"x,y分别为:%@,%@",type,number);*/
              
        
        NSNumber *type = [NSNumber numberWithInteger:[[transArray objectAtIndex:i]  CGPointValue].x ];
        NSNumber *number = [NSNumber numberWithInteger:[[transArray objectAtIndex:i] CGPointValue].y];
        [transArrayType addObject:type];
        [transArrayNumber addObject:number];
        NSLog(@"预存储元素为:%@,%@",type,number);
    }
    NSLog(@"预存储完成,type为:%lu,number为:%lu",(unsigned long)transArrayType.count,(unsigned long)transArrayNumber.count);
}



-(void)afterReadTheTrans//trans,transType,transNumber,dic初始化,后读取
{
    
    //transDictionaryType = [[NSMutableDictionary alloc]init];
    //transDictionaryNumber = [[NSMutableDictionary alloc]init];
    
    if (transArrayType.count!=transArrayNumber.count) {
        NSLog(@"数据后读取错误");
        [self freshTransArray];
        NSLog(@"后读取错误，重置trans");
    }
    else
    {
        for (int i=0; i<transArrayNumber.count; i++) {
            NSInteger type = [transArrayType[i] integerValue];
            NSInteger number = [transArrayNumber[i] integerValue];
            CGPoint point = CGPointMake(type, number);
            NSValue *value = [NSValue valueWithCGPoint:point];
            [transArray addObject:value];
            NSLog(@"后读取数据为%@",value);
        }
        NSLog(@"trans.count=%lu",(unsigned long)transArray.count);
    }
    NSLog(@"后读取结束");
    if (transArray.count==0) {
        [self freshTransArray];
        NSLog(@"trans初始化完毕");
    }
}

-(void) recordThePlayOrder
{
    [self transTheTransArrayToPlayArray];
    //[NSKeyedArchiver archiveRootObject:playDictionary toFile:@"ReaderPadPlay.plist"];
    NSLog(@"Play.plist文件已被重置");
    /*// 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filepath = [docPath stringByAppendingPathComponent:@"ReaderPadPlay.plist"];*/
    //
    
    //NSArray *page = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //NSString *home = [page objectAtIndex:0];
    
    //NSString *home = NSHomeDirectory();
    //NSString *documentPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *plistNamePlay = [[NSString alloc]initWithFormat:@"%@PlayOrder",documentName];
    NSUserDefaults *plistSavePlay = [NSUserDefaults standardUserDefaults];
    [plistSavePlay setObject:playArray forKey:plistNamePlay];
    [plistSavePlay synchronize];
    
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    //[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentName stringByAppendingString:@"ReaderPadPlay"];
    
    NSString *plistName = [[NSString stringWithFormat:@"%@",filePath] stringByAppendingPathExtension:@"plist"];
    
    NSString *plistPath = [documentPath stringByAppendingPathComponent:plistName];
    
    NSLog(@"文件存在，文件名为 == %@", plistPath);
    //判断文件是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        NSLog(@"play.plist文件不存在");
        BOOL tip=[fileManager createFileAtPath:plistPath contents:nil attributes:nil];//重新创建文件
        if (tip==NO) {
            NSLog(@"存.play.plist创建文件失败");
        }
    }
    playDictionary = [NSMutableDictionary dictionaryWithObject:playArray forKey:documentName];
    [playArray writeToFile:plistPath atomically:YES];*/
    
    NSLog(@"存.Play.plist信息重置完毕");
    NSLog(@"play.dictionary=%@",playDictionary);
    
}

-(void) recordTheTransOrder
{
    [self prerecordTheTrans];//预存储之后，两个字数组都存在
    
    //transDictionaryType = [NSMutableDictionary dictionaryWithObject:transArrayType forKey:documentName];
    //transDictionaryNumber = [NSMutableDictionary dictionaryWithObject:transArrayNumber forKey:documentName];
    
    NSString *plistNameType = [[NSString alloc]initWithFormat:@"%@TransOrderType",documentName];
    NSUserDefaults *plistSaveType = [NSUserDefaults standardUserDefaults];
    [plistSaveType setObject:transArrayType forKey:plistNameType];
    [plistSaveType synchronize];
    
    /*
    //transDictionary=[NSMutableDictionary dictionaryWithObject:transArray forKey:documentName];
    //[NSKeyedArchiver archiveRootObject:dictionary toFile:@"ReaderPadTrans.plist"];
    //NSLog(@"Trans.plist文件已被重置");
    //NSString *home = NSHomeDirectory();
    //NSString *documentPath = [home stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    //[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];//沙盒地址共用
    
    NSString *filePathType = [documentName stringByAppendingString:@"ReaderPadTransType"];
    
    NSString *plistNameType = [[NSString stringWithFormat:@"%@",filePathType] stringByAppendingPathExtension:@"plist"];
    
    NSString *plistPathType = [documentPath stringByAppendingPathComponent:plistNameType];
    
    NSLog(@"存.文件存在，文件名为 == %@", plistPathType);
    //判断文件是否存在
    NSFileManager *fileManagerType = [NSFileManager defaultManager];
    if ([fileManagerType fileExistsAtPath:plistPathType] == NO) {
        NSLog(@"存.transType.plist文件不存在");
        BOOL tip=[fileManagerType createFileAtPath:plistPathType contents:nil attributes:nil];//重新创建文件
        if (tip==NO) {
            NSLog(@"存.transType.plist创建文件失败");
        }
    }
    [transArrayType writeToFile:plistPathType atomically:YES];*/
    NSLog(@"存.TransType.plist信息重置完毕");
    NSLog(@"transType.dictionary=%@",transArrayType);
    
    NSString *plistNameNumber = [[NSString alloc]initWithFormat:@"%@TransOrderNumber",documentName];
    NSUserDefaults *plistSaveNumber = [NSUserDefaults standardUserDefaults];
    [plistSaveNumber setObject:transArrayNumber forKey:plistNameNumber];
    [plistSaveNumber synchronize];
    /*
    NSString *filePathNumber = [documentName stringByAppendingString:@"ReaderPadTransNumber"];
    
    NSString *plistNameNumber = [[NSString stringWithFormat:@"%@",filePathNumber] stringByAppendingPathExtension:@"plist"];
    
    NSString *plistPathNumber = [documentPath stringByAppendingPathComponent:plistNameNumber];
    
    NSLog(@"存.文件存在，文件名为 == %@", plistPathNumber);
    //判断文件是否存在
    NSFileManager *fileManagerNumber = [NSFileManager defaultManager];
    if ([fileManagerNumber fileExistsAtPath:plistPathNumber] == NO) {
        NSLog(@"存.transNumber.plist文件不存在");
        BOOL tip=[fileManagerNumber createFileAtPath:plistPathNumber contents:nil attributes:nil];//重新创建文件
        if (tip==NO) {
            NSLog(@"存.transNumber.plist创建文件失败");
        }
    }
    [transArrayNumber writeToFile:plistPathNumber atomically:YES];*/
    NSLog(@"存.TransNumber.plist信息重置完毕");
    NSLog(@"transNumber.dictionary=%@",transArrayNumber);
    
    //[transArrayType removeAllObjects];
    //[transArrayNumber removeAllObjects];
    //[transDictionaryType removeAllObjects];
    //[transDictionaryNumber removeAllObjects];
}


-(void)readThePlayOrder
{
    //playArray = [[NSMutableArray alloc]init];
    
    NSString *plistName = [[NSString alloc]initWithFormat:@"%@PlayOrder",documentName];
    NSUserDefaults *plistRead = [NSUserDefaults standardUserDefaults];
    NSArray *readArray = [plistRead objectForKey:plistName];
    playArray = [[NSMutableArray alloc]initWithArray:readArray];
    /*
    //NSString *home = NSHomeDirectory();
    //NSString *documentPath = [home stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    //[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentName stringByAppendingString:@"ReaderPadPlay"];
    
    NSString *plistName = [[NSString stringWithFormat:@"%@",filePath] stringByAppendingPathExtension:@"plist"];
    
    NSString *plistPath = [documentPath stringByAppendingPathComponent:plistName];
    
    NSLog(@"读取.文件存在，文件路径为 == %@", plistPath);
    //判断文件是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        NSLog(@"读取.play.plist文件不存在");
        BOOL tip=[fileManager createFileAtPath:plistPath contents:nil attributes:nil];//重新创建文件
        if (tip==NO) {
            NSLog(@"读取.play.plist创建文件失败");
        }
    }
    
    //NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ReaderPadPlay" ofType:@"plist"];
    playArray = [NSMutableArray arrayWithContentsOfFile:plistPath];*/
    NSLog(@"play.dictionary=%@",playArray);
    //playArray = [data objectForKey:documentName];//读到playArray里
    NSLog(@"repeat.play.plist文件提取完毕");
}

-(void)readTheTransOrder
{
    transArray = [[NSMutableArray alloc]init];
    //transArrayType = [[NSMutableArray alloc]init];
    //transArrayNumber = [[NSMutableArray alloc]init];
    
    NSString *plistNameType = [[NSString alloc]initWithFormat:@"%@TransOrderType",documentName];
    NSUserDefaults *plistReadType = [NSUserDefaults standardUserDefaults];
    NSArray *readArrayType = [plistReadType objectForKey:plistNameType];
    transArrayType = [[NSMutableArray alloc]initWithArray:readArrayType];
    
    /*
    NSString *plistName = [[NSString alloc]initWithFormat:@"%@PlayOrder",documentName];
    NSUserDefaults *plistRead = [NSUserDefaults standardUserDefaults];
    NSArray *readArray = [plistRead objectForKey:plistName];
    playArray = [[NSMutableArray alloc]initWithArray:readArray];
    NSString *plistName = [[NSString alloc]initWithFormat:@"%@TransOrder",documentName];
    NSUserDefaults *plistRead = [NSUserDefaults standardUserDefaults];
    NSArray *readArray = [plistRead objectForKey:plistName];
    transArray = [[NSMutableArray alloc]initWithArray:readArray];
    //NSString *home = NSHomeDirectory();
    //NSString *documentPath = [home stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    //NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePathType = [documentName stringByAppendingString:@"ReaderPadTransType"];
    
    NSString *plistNameType = [[NSString stringWithFormat:@"%@",filePathType] stringByAppendingPathExtension:@"plist"];
    
    NSString *plistPathType = [documentPath stringByAppendingPathComponent:plistNameType];
    
    NSLog(@"读取.transType文件存在，文件路径为 == %@", plistPathType);
    //判断文件是否存在
    NSFileManager *fileManagerType = [NSFileManager defaultManager];
    if ([fileManagerType fileExistsAtPath:plistPathType] == NO) {
        NSLog(@"读取.transType.plist文件不存在");
        BOOL tip=[fileManagerType createFileAtPath:plistPathType contents:nil attributes:nil];//重新创建文件
        if (tip==NO) {
            NSLog(@"读取.transType.plist创建文件失败");
        }
    }
    //NSMutableDictionary *dataType = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPathType];
    //transArrayType = [dataType objectForKey:documentName];
    transArrayType = [NSMutableArray arrayWithContentsOfFile:plistPathType];
    */
    
    NSLog(@"repeat.transType.integer提取完毕");
    
    
    NSString *plistNameNumber = [[NSString alloc]initWithFormat:@"%@TransOrderNumber",documentName];
    NSUserDefaults *plistReadNumber = [NSUserDefaults standardUserDefaults];
    NSArray *readArrayNumber = [plistReadNumber objectForKey:plistNameNumber];
    transArrayNumber = [[NSMutableArray alloc]initWithArray:readArrayNumber];
    /*
    NSString *filePathNumber = [documentName stringByAppendingString:@"ReaderPadTransNumber"];
    
    NSString *plistNameNumber = [[NSString stringWithFormat:@"%@",filePathNumber] stringByAppendingPathExtension:@"plist"];
    
    NSString *plistPathNumber = [documentPath stringByAppendingPathComponent:plistNameNumber];
    
    NSLog(@"读取.transNumber文件存在，文件路径为 == %@", plistPathNumber);
    //判断文件是否存在
    NSFileManager *fileManagerNumber = [NSFileManager defaultManager];
    if ([fileManagerNumber fileExistsAtPath:plistPathNumber] == NO) {
        NSLog(@"读取.transNumber.plist文件不存在");
        BOOL tip=[fileManagerNumber createFileAtPath:plistPathNumber contents:nil attributes:nil];//重新创建文件
        if (tip==NO) {
            NSLog(@"读取.transType.plist创建文件失败");
        }
    }
    
    //NSMutableDictionary *dataNumber = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPathNumber];
    //transArrayNumber = [dataNumber objectForKey:documentName];
    transArrayNumber = [NSMutableArray arrayWithContentsOfFile:plistPathNumber];
    */
    NSLog(@"repeat.transNumber.integer提取完毕");
   
    //////////////////////////
    
    if (transArrayType.count == transArrayNumber.count) {
        [self afterReadTheTrans];
        NSLog(@"trans.plist读取成功");
    }
    else
    {
        [self freshTransArray];
        NSLog(@"trans.plist读取失败,trans重置");
        
    }
    NSLog(@"repeat.trans.plist文件提取完毕");
}

-(void) freshPlists//格式化
{
    [self freshTransArray];
    [self freshPlayArray];
    [self recordThePlayOrder];
    [self recordTheTransOrder];
    NSLog(@"repeat.plists格式化完毕");
}

-(void)deleteTheLastElementOfTransArray
{
    if (transArray.count>1)
    {
        [transArray removeLastObject];
        [self transTheTransArrayToPlayArray];
    }
}

-(void) freshRightNumbers
{
    NSValue *Value = transArray[transArray.count-1];
    CGPoint Point = [Value CGPointValue];
    int number = Point.y;
    switch (segmentedContorl.selectedSegmentIndex)
    {
        case 0:
        {
            rightNumberArray = [[NSMutableArray alloc]init];
            for (int i=0; i<number; i++) {
                [rightNumberArray addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
            pickerView.delegate = self;
            NSLog(@"代理加载完毕");
            pickerView.dataSource = self;
            NSLog(@"数据源加载完毕");
            [pickerView reloadAllComponents];
            NSLog(@"right数组元素个数为:%lu",(unsigned long)rightNumberArray.count);
        }
            break;
            
        case 1:
        {
            rightNumberArray = [[NSMutableArray alloc]init];
            for (int i=number; i<[documentPageCount intValue]; i++) {
                [rightNumberArray addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
            pickerView.delegate = self;
            NSLog(@"代理加载完毕");
            pickerView.dataSource = self;
            NSLog(@"数据源加载完毕");
            [pickerView reloadAllComponents];
            NSLog(@"right数组元素个数为:%lu",(unsigned long)rightNumberArray.count);
        }
            break;
            
        case 2:
        {
            rightNumberArray = [[NSMutableArray alloc]init];
            for (int i=number-1; i<[documentPageCount intValue]; i++) {
                [rightNumberArray addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
            pickerView.delegate = self;
            NSLog(@"代理加载完毕");
            pickerView.dataSource = self;
            NSLog(@"数据源加载完毕");
            [pickerView reloadAllComponents];
            NSLog(@"right数组元素个数为:%lu",(unsigned long)rightNumberArray.count);
        }
            break;
            
        default:
            break;
    }
}

-(IBAction)returnBack:(id)sender//返回
{
    [self freshArrays];
    [self clearAll];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"repeat.返回");
}

-(IBAction)record:(id)sender//存储，完成
{
    [self recordTheTransOrder];
    [self recordThePlayOrder];
    //[transArray removeAllObjects];
    //[playArray removeAllObjects];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"repeat.保存结束，退出");
    
    NSLog(@"输出play:");
    for (NSValue *value in playArray ) {
        NSLog(@"%@",value);
    }
    //[reader readTheFinalPlayOrder];
}

-(IBAction)deleteData:(id)sender//删除
{
    NSString *Confirm = NSLocalizedString(@"Confirm", nil);
    NSString *Tip = NSLocalizedString(@"Tip", nil);
    NSString *Sure = NSLocalizedString(@"Sure", nil);
    NSString *Cancel = NSLocalizedString(@"Cancel", nil);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Confirm message:Tip preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:Sure style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
    {
        [transArray removeAllObjects];
        [playArray removeAllObjects];
        [self freshTransArray];
        [self transTheTransArrayToPlayArray];
        [self showTheTransArray];
    }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:Cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:ok];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:^{ }];
    NSLog(@"repeat.删除结束");
}

-(IBAction)backSpeace:(id)sender//回删
{
    [self deleteTheLastElementOfTransArray];//已转录
    [self showTheTransArray];
    [self freshRightNumbers];
    NSLog(@"删除后trans元素个数为:%lu",(unsigned long)transArray.count);
    NSLog(@"repeat.回删");
}

-(IBAction)nextStep:(id)sender//下一步
{
    NSUInteger type = self.segmentedContorl.selectedSegmentIndex+1;
    
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
    
    NSInteger number = [rightNumberArray[[pickerView selectedRowInComponent:0]]integerValue];
    
    //
    if ((type == [[transArray lastObject] CGPointValue].x) && (number == [[transArray lastObject] CGPointValue].y)) {
        NSLog(@"重复");
    }
    
    else
    {
        //[rowNumber integerValue]+1;
        if (number<0) {
            NSLog(@"number<0");
        }
        CGPoint point = {type,number};//+1
        NSValue *value = [NSValue valueWithCGPoint:point];
       
        [transArray addObject:value];
        [self freshRightNumbers];
        [self transTheTransArrayToPlayArray];
        [self showTheTransArray];
        
        NSLog(@"repeat.trans增加元素:%@",value);
    }
    
}

-(void)segmentedClick:(id)sender
{
    [self freshRightNumbers];
    NSLog(@"segClick调用");
    [self freshRightImage];
    NSLog(@"image刷新");
}

-(void)showPeerViewAt:(NSInteger)thePage//显示窥视页内容
{
    //内容视屏
    ReaderContentPage *theContentPage = [[ReaderContentPage alloc] initWithURL:theFileURL page:thePage password:phrase];
    
    float cw = theContentPage.bounds.size.width;//x
    float ch = theContentPage.bounds.size.height;//y
    float sw = [UIScreen mainScreen].bounds.size.width;//x0
    float sh = [UIScreen mainScreen].bounds.size.height;//y0
    float x = 0.0f;
    float y = 0.0f;
    float w = 0.0f;
    float h = 0.0f;
    float a = ch/cw;
    float b = sh/sw;
    
    if (a<b)//
    {
        x=0;
        y=(sh-(sw/cw)*ch)/2.0f;
        w=sw;
        h=(sw/cw)*ch;
    }
    
    else
    {
        y=0;
        x=(sw-(sh/ch)*cw)/2.0f;
        w=(sh/ch)*cw;
        h=sh;
    }
    
    ReaderContentView *theContentView = [[ReaderContentView alloc] initWithFrame:CGRectMake(x, y, w, h) fileURL:theFileURL page:thePage password:phrase];
    //theContentView.layer.borderWidth = 20.0f;
    //theContentView.layer.borderColor = [UIColor yellowColor].CGColor;
    theContentView.alpha = 1.0f;
    theContentView.tag = 35;
    
    NSLog(@"imageTapped");
    
    //触摸视屏
    UITapGestureRecognizer *detialTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailShowTapped:)];
    detialTapped.numberOfTapsRequired = 1;
    detialTapped.numberOfTouchesRequired = 1;
    detialTapped.delegate = self;
    
    detailShowBackgrand = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    detailShowBackgrand.tag = 33;
    
    //滑动手势
    UISwipeGestureRecognizer * recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizerLeft.delegate = self;
    [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer * recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizerRight.delegate = self;
    [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    NSLog(@"show Detail");
    
    //[glassView addSubview:theContentView];
    ///[theContentView addSubview:detailShowBackgrand];
    [detailShowBackgrand addSubview:theContentView];
    [detailShowBackgrand addGestureRecognizer:detialTapped];
    [detailShowBackgrand addGestureRecognizer:recognizerLeft];
    [detailShowBackgrand addGestureRecognizer:recognizerRight];
    [self.view insertSubview:detailShowBackgrand aboveSubview:theContentView];
}

-(void)imageViewPeered:(NSInteger)thePage//真实页数，显示窥视页
{
       //模糊视屏
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    glassView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    if (peerViewChosenPageNumber == 0) {
    //classView.backgroundColor = [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f];
    glassView.tag = 32;
    
    CGFloat bound = MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    glassView.frame = CGRectMake(0, 0, bound, bound);
    
    [self.view addSubview:glassView];
    }
    
    [self showPeerViewAt:thePage];//显示
    
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer//详细页面扫滑手势
{
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"swipe left");
        NSLog(@"peerNumber = %ld",(long)peerViewChosenPageNumber);
        
        NSInteger pickerNumber = [pickerView selectedRowInComponent:0];//滚轮数据
        NSInteger number = [rightNumberArray[pickerNumber]integerValue];
        NSInteger thePickerNumber = pickerNumber + peerViewChosenPageNumber;
        if ((thePickerNumber > -1)&&(thePickerNumber < rightNumberArray.count-1))//左滑
        {
            peerViewChosenPageNumber ++;
            //先删除原来图层
            for (UIView *subviews in [self.glassView subviews])
            {
                if (subviews.tag==35)//内容图层
                {
                    [subviews removeFromSuperview];//移除图层
                }
            }
            
            [self showPeerViewAt:(number+peerViewChosenPageNumber)];
            //[self imageViewPeered:(number+peerViewChosenPageNumber)];//Peer界面向右跳peerViewChosenPageNUmber步
            NSLog(@"左滑");
            NSLog(@"peerNumber = %ld",(long)peerViewChosenPageNumber);
        }
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"swipe right");
        NSLog(@"peerNumber = %ld",(long)peerViewChosenPageNumber);
        
        NSInteger pickerNumber = [pickerView selectedRowInComponent:0];//滚轮数据
        NSInteger number = [rightNumberArray[pickerNumber]integerValue];
        NSInteger thePickerNumber = pickerNumber + peerViewChosenPageNumber;
        if ((thePickerNumber > 0)&&(thePickerNumber < rightNumberArray.count))//右滑
        {
            peerViewChosenPageNumber --;
            //先删除原来图层
            //[self deleteDetial];
            for (UIView *subviews in [self.glassView subviews])
            {
                NSLog(@"图层搜寻");
                if (subviews.tag==35)//内容图层
                {
                    [subviews removeFromSuperview];//移除图层
                    NSLog(@"删除图层");
                }
            }
            
            [self showPeerViewAt:(number+peerViewChosenPageNumber)];
            //[self imageViewPeered:(number+peerViewChosenPageNumber)];//Peer界面向右跳peerViewChosenPageNumber步
            NSLog(@"右滑");
            NSLog(@"peerNumber = %ld",(long)peerViewChosenPageNumber);
        }
    }
}

-(void)imageViewTapped:(UITapGestureRecognizer *)gesture//视图弹出手势
{
    peerViewChosenPageNumber = 0;
    [self imageViewPeered:[rightNumberArray[[pickerView selectedRowInComponent:0]]integerValue]];
    rotateTip = YES;
}

-(void)diviceRotated:(id)gesture//设备翻转回调
{
    [self deleteDetial];
    if (rotateTip == YES) {
        if (peerViewChosenPageNumber != 0) {
            NSInteger pickerNumber = [pickerView selectedRowInComponent:0];
            NSInteger number = [rightNumberArray[pickerNumber]integerValue];
            NSLog(@"Number = %@",rightNumberArray[[pickerView selectedRowInComponent:0]]);
            NSLog(@"滚轮数 number = %ld , peerNumber = %ld",(long)number,(long)peerViewChosenPageNumber);
            [self.pickerView selectRow:(pickerNumber+peerViewChosenPageNumber) inComponent:0 animated:NO];//滚轮
            //[self showRightImageAt:(number+peerViewChosenPageNumber)];//imageView
            NSLog(@"翻转，peerNumber = %ld",(long)peerViewChosenPageNumber);
            peerViewChosenPageNumber = 0;
        }
        [self imageViewPeered:[rightNumberArray[[pickerView selectedRowInComponent:0]]integerValue]];
    }
    
    [self removeTipView];
    if (tipsTip == YES) {
        NSLog(@"设备翻转，tips弹出");
        [self showTip];
    }
}

-(void)deleteDetial//退出具体操作
{
    for (UIView *subviews in [self.view subviews])
    {
        if (subviews.tag==32)//玻璃图层
        {
            [subviews removeFromSuperview];
        }
        else if (subviews.tag==33)//手势图层
        {
            [subviews removeFromSuperview];
        }
        else if (subviews.tag==35)//内容图层
        {
            [subviews removeFromSuperview];
        }
    }//必须从self.view中移除，不能从gpsClickView中移除
}

-(void)detailShowTapped:(id)sender//详细页面被点击时，退出
{
    NSLog(@"detial Tapped");
    
    [self deleteDetial];
    
    NSInteger pickerNumber = [pickerView selectedRowInComponent:0];
    NSInteger number = [rightNumberArray[pickerNumber]integerValue];
    NSLog(@"Number = %@",rightNumberArray[[pickerView selectedRowInComponent:0]]);
    if (peerViewChosenPageNumber != 0) {
        
        NSLog(@"滚轮数 number = %ld , peerNumber = %ld",(long)number,(long)peerViewChosenPageNumber);
        [self.pickerView selectRow:(pickerNumber+peerViewChosenPageNumber) inComponent:0 animated:NO];//滚轮
        [self showRightImageAt:(number+peerViewChosenPageNumber)];//imageView
    }
    
    NSLog(@"退出，peerNumber = %ld",(long)peerViewChosenPageNumber);
    rotateTip = NO;
    peerViewChosenPageNumber = 0;
}

- (IBAction)testTrans:(id)sender {
    NSLog(@"输出trans:");
    for (NSValue *value in transArray ) {
        NSLog(@"%@",value);
    }
}

- (IBAction)testPlay:(id)sender {
    NSLog(@"输出play:");
    for (NSValue *value in playArray ) {
        NSLog(@"%@",value);
    }
}
- (IBAction)richText:(id)sender {
    NSLog(@"富文本数组个数为:%@",attributedString);
}

- (IBAction)Tip:(id)sender
{
    [self showTip];
}

-(void)showTip
{
    
    //玻璃视图
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    glassViewTip = [[UIVisualEffectView alloc]initWithEffect:beffect];
    glassViewTip.tag = 36;
    
    CGFloat bound = MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    
    glassViewTip.frame = CGRectMake(0, 0, bound, bound);
    tipBackgrand = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bound, bound)];
    tipBackgrand.tag = 37;
    
    //text内容
    
    NSString *tipWord1 = NSLocalizedString(@"TipWord1", nil);
    NSString *tipWord2 = NSLocalizedString(@"TipWord2", nil);
    NSString *tipWebSite = NSLocalizedString(@"TipWebSite", nil);
    NSString *tips = [[NSString alloc]initWithFormat:@"%@%@%@",tipWord1,tipWebSite,tipWord2];
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
                range:NSMakeRange([tipWord1 length],[tipWebSite length])];
    NSLog(@"words length = %lu",(unsigned long)[tipWebSite length]);
    
    [str addAttributes:tipWordDic range:NSMakeRange(0, [tips length])];//设置富文本字体样式
    [str addAttributes:tipWebSiteDic range:NSMakeRange([tipWord1 length], [tipWebSite length])];//设置富文本网址样式
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
    tipTextView.tag = 37;
    tipTextView.textColor = [UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f];
    tipTextView.font = [UIFont systemFontOfSize:15];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(wStart*7.0f-50.0f, hStart*7.0f, 100, hStart/2.0f)];
    [button setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tipButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //button.backgroundColor = [UIColor blackColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    button.tag = 38;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //button.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    
    UIButton *buttonFeedback = [[UIButton alloc]initWithFrame:CGRectMake(wStart, hStart*7.0f, 100, hStart/2.0f)];
    [buttonFeedback setTitle:NSLocalizedString(@"FeedBack", nil) forState:UIControlStateNormal];
    [buttonFeedback setTitleColor:[UIColor colorWithRed:(28.0f/255.0f) green:(33.0f/255.0f) blue:(41.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    [buttonFeedback addTarget:self action:@selector(feedbackEmailTapped:) forControlEvents:UIControlEventTouchUpInside];
    //button.backgroundColor = [UIColor blackColor];
    buttonFeedback.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    buttonFeedback.tag = 39;
    buttonFeedback.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //button.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    
    //[tipTextView addSubview:button];
    [tipBackgrand addSubview:tipTextView];
    [tipBackgrand addSubview:button];
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad){
        //[glassViewTip addSubview:buttonFeedback];
        [tipTextView addSubview:buttonFeedback];
    }
    [self.view addSubview:glassViewTip];
    [self.view addSubview:tipBackgrand];
    tipsTip = YES;
    //[self.view addSubview:button];
    
}

-(void)tipButtonTapped:(id)tap//tip中取消按钮点击
{
    NSLog(@"按钮点击");
    [self removeTipView];
    tipsTip = NO;
}

-(void)feedbackEmailTapped:(id)tap
{
    [self eMailWrite];
    NSLog(@"邮件反馈点击");
}

-(void)removeTipView
{
    for (UIView *view in [self.view subviews]) {
        if (view.tag == 36) {
            [view removeFromSuperview];
        }
        else if (view.tag == 37){
            [view removeFromSuperview];
        }
        else if (view.tag == 38){
            [view removeFromSuperview];
        }
        else if (view.tag == 39){
            [view removeFromSuperview];
        }
    }
}

-(void)eMailWrite
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSLog(@"Mail services are available.");
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

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLoad {
 [super viewDidLoad];
    pickerView.delegate = self;
    NSLog(@"代理加载完毕");
    pickerView.dataSource = self;
    NSLog(@"数据源加载完毕");
    [pickerView reloadAllComponents];
    //textLabel.delegate = self;
    [textLabel reloadInputViews];
    [self showTheTransArray];
    NSLog(@"reader-在text上显示初始化数据");
    NSInteger thePageNumber =[rightNumberArray[[pickerView selectedRowInComponent:0]]integerValue];
    [self showRightImageAt:thePageNumber];
    NSLog(@"theNumber = %ld",(long)thePageNumber);
    
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        
        //[self registerForPreviewingWithDelegate:(id)self sourceView:self.imageView];
        
        NSLog(@"3D Touch 可用");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(diviceRotated:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    rotateTip = NO;
    
    tipsTip = NO;
    //[self contentSizeToFit];

    //UIView *view = [UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 300);
    //UIImage *image = [[UIImage imageNamed:@"foreStep.png"];
            
    
    //pickerView.showsSelectionIndicator = YES;
    
    //[pickerView reloadAllComponents];
    //[self.view addSubview:pickerView];
 // Do any additional setup after loading the view from its nib.
 }

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self contentSizeToFit];
    imageBoard = [[UIView alloc]initWithFrame:imageView.frame];
    imageBoard.backgroundColor = [UIColor clearColor];
    imageBoard.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *imageTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapped:)];
    imageTapped.numberOfTouchesRequired = 1;
    imageTapped.numberOfTapsRequired = 1;
    imageTapped.delegate = self;
    
    [imageBoard addGestureRecognizer:imageTapped];
    [self.view addSubview:imageBoard];
    [self freshRightNumbers];
    
    //textLabel.textAlignment = NSTextAlignmentCenter;
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
