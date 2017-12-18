//
//  PlayViewController.h
//  Reader
//
//  Created by Lieder on 2017/7/26.
//
//

#import <UIKit/UIKit.h>//显示播放页面，并且显示双页开关、蓝牙开关，方便时监控蓝牙状态就行，加上一个工具栏，这些在工具栏里显示
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>

#import "ReaderDocument.h"
#import "RepeatViewController.h"
#import "BlueToothController.h"
#import "BlueToothViewController.h"
#import "RepeatViewController.h"
#import "PlayMainToolbar.h"
#import "ReaderDocument.h"
#import "PlayViewControllorDelegate.h"


@interface PlayViewController : UIViewController{
    
    NSObject <PlayViewControllorDelegate> * delegate;
    
}

@property (nonatomic, retain) NSObject<PlayViewControllorDelegate> *delegate;
@property (nonatomic, strong) UIView *backGround;
@property (nonatomic, strong) NSMutableArray *playArray;
@property (nonatomic, strong) NSString *documentName;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic) CGFloat screenWidth,screenHight;
@property(nonatomic,strong) NSURL *theFileURL;
@property(nonatomic,strong) NSString *phrase;
@property(nonatomic) NSInteger lastPlayPoint;
@property (nonatomic, strong) UIView *gestureTopView;
@property (nonatomic,strong) PlayMainToolbar *playToolbar;
@property (nonatomic) BOOL showThePlayToolbar;
@property (nonatomic) BOOL doublePlayTip;
@property (nonatomic) NSInteger thePageCount;
@property (nonatomic, strong) BlueToothController *blueTooth;
@property (nonatomic, strong) NSMutableArray *connnectedPeripheralNameArray;

typedef enum{
    NoDoublePlay,
    HomeButtonUpOrDown,
    HomeButtonLeftOrRight
    
} DoublePlayType;


- (void)getTheFileNameForPlayPage:(ReaderDocument *)document;//第一步，获取文档名字，才能读取演奏顺序
- (void)getTheLastPlayPoint:(NSInteger)lastPoint andDoublePlayTip:(BOOL)doubleTip;
- (void)load;
- (void)readThePlayOrder;//第二个，读取play数据
- (void)play;//第三个

@end
