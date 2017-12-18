//
//  BlueToothController.h
//  Reader
//
//  Created by FairyAnnie on 2017/5/22.
//
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
//#import "BlueToothViewController.h"

@interface BlueToothController : CBCentralManager<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (nonatomic, strong) CBCentralManager *myCentralManager;
//@property (nonatomic, strong) BlueToothViewController *blueViewController;
@property (nonatomic) float powerValue;
@property (nonatomic) float signValue;
@property (nonatomic, strong) CBService *theService;
@property (nonatomic, strong) NSMutableArray *peripheralsNameArray;//只有临时作用
@property (nonatomic, strong) NSMutableArray *peripheralsArray;
@property (nonatomic, strong) NSMutableArray *periHasChosenArray;
@property (nonatomic, weak) NSBlockOperation *operation2;
@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic,strong) NSNumber* rSSI;
@property (nonatomic,strong) NSUserDefaults *periReader;
@property (nonatomic) BOOL tipForCentralState;

-(void)load;
-(void)connectThePeripheralNamed:(NSString *)peripheralName;

@end
