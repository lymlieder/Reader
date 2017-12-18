//
//  BlueToothViewController.h
//  Reader
//
//  Created by FairyAnnie on 2017/5/12.
//
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BlueToothController.h"

@interface BlueToothViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) IBOutlet UIProgressView *engeryLevel;
@property (strong, nonatomic) IBOutlet UIProgressView *signalLevel;
-(IBAction)Tip:(id)sender;//提示
@property (strong, nonatomic) IBOutlet UILabel *label;

@property BOOL confirm;
@property (nonatomic) float engeryValue;
@property (nonatomic) float signalValue;
@property (nonatomic) NSInteger rSSI;
@property (nonatomic) NSInteger batterValue;

@property (strong,nonatomic) NSMutableArray *peripherals;//外设列表
@property (strong,nonatomic) NSMutableArray *peripheralsNames;//用来显示在TableView上
@property (strong,nonatomic) NSString *chosenName;//选定设备名字
@property (nonatomic) NSInteger chosenNumber;
@property (nonatomic,strong) UIButton *blueTipButton;
@property (nonatomic) BOOL blueTipsTip;//反转指示
@property (nonatomic,strong) UIVisualEffectView *blueGlassView;
@property (nonatomic,strong) UIView *bluePlayground;
//@property (nonatomic,strong) BlueToothController *blueTooth;
@property (nonatomic,strong) NSMutableArray *tempPeriArray;
@property (nonatomic,strong) NSMutableArray *chosenPeriNameArray;
//@property(nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSUserDefaults *periRead;

-(void)load:(BlueToothController *)theBlueTooth;

//-(void)transPeripherals:(NSArray *)peripheralsNameArray;//记录外设名字，记录到peripherals里

@end
