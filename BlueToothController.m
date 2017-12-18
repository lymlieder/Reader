//
//  BlueToothController.m
//  Reader
//
//  Created by FairyAnnie on 2017/5/22.
//
//

#import "BlueToothController.h"

@implementation BlueToothController
{
    //NSBlockOperation *operation1;
    //NSBlockOperation *operation2;
}

@synthesize discoveredPeripheral,myCentralManager,powerValue,signValue,theService,peripheralsNameArray,peripheralsArray,operation2,timer1,timer2,rSSI,periHasChosenArray,periReader,tipForCentralState;

-(void)load//1
{
    NSLog(@"blueTC-蓝牙启动");
    tipForCentralState = NO;
    peripheralsNameArray = [[NSMutableArray alloc]init];
    peripheralsArray = [[NSMutableArray alloc]init];
    periHasChosenArray = [[NSMutableArray alloc]init];
    myCentralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) options:@{CBCentralManagerOptionShowPowerAlertKey:@(NO)}];
    
    NSLog(@"blueTC-BlueController load 运行");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectThePeripheralNamed:) name:@"connectThePeripheral" object:nil];//注册通知,用于收到连接的指令
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopScan) name:@"stopScan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelConnect:) name:@"cancelConnect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timersSwitch:) name:@"timersSwitch" object:nil];//刷新开关
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeHandsForShowingLabel) name:@"shakeHandsForShowingLabel" object:nil];
    
    
    timer1 = [[NSTimer alloc]init];
    timer2 = [[NSTimer alloc]init];
    NSLog(@"开始创建时间");
    if (timer1 != nil) {
        NSLog(@"timer1创建成功");
    }
    if (timer2 != nil) {
        NSLog(@"timer2创建成功");
    }

    
    //[self autofreshTheTableView];
    
    rSSI = [[NSNumber alloc]init];
}

-(void)shakeHandsForShowingLabel
{
    if (tipForCentralState == NO) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"labelShow" object:self userInfo:[NSDictionary dictionaryWithObject:@"show" forKey:@"option"]];
    }
    else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"labelShow" object:self userInfo:[NSDictionary dictionaryWithObject:@"cover" forKey:@"option"]];
    }
    NSLog(@"提示握手信息发出");
}
-(void)timersSwitch:(NSNotification *)noti
{
    if ([[noti.userInfo objectForKey:@"option"] isEqualToString:@"turnOn"])
    {
        [self autofreshTheTableView];
        NSLog(@"autofreshTheTableView 重新创建");
    }
    else if ([[noti.userInfo objectForKey:@"option"] isEqualToString:@"turnOff"])
    {
        [timer1 invalidate];
        [timer2 invalidate];
        timer1 = nil;
        timer2 = nil;
        NSLog(@"开始销毁时间");
        if (timer1 != nil) {
            NSLog(@"timer1销毁失败");
        }
        if (timer2 != nil) {
            NSLog(@"timer2销毁失败");
        }
    }
}

-(void)getThePeriWaitingForCanceled:(NSNotification *)noti
{
    if ([noti.userInfo objectForKey:@"getBackThePeriArrayWaitingForCanceled"] != nil) {//传回数据不为空
        [periHasChosenArray removeAllObjects];
        [periHasChosenArray addObjectsFromArray:[noti.userInfo objectForKey:@"getBackThePeriArrayWaitingForCanceled"]];
        NSLog(@"periChosenArray = %@",periHasChosenArray);
    }
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central//中心设备信息变更后调取,2
{
    switch (central.state)
    {
        case CBManagerStatePoweredOn:
        {
            NSLog(@"蓝牙信息中心 开机");
            tipForCentralState =YES;
            [self startScan];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"labelShow" object:self userInfo:[NSDictionary dictionaryWithObject:@"cover" forKey:@"option"]];
        }
            break;
        
        case CBManagerStatePoweredOff:
        {
            NSLog(@"蓝牙信息中心 关机");
            tipForCentralState = NO;
            //[timer1 invalidate];
            //[timer2 invalidate];
            NSLog(@"停止计时1");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriDeleteForRefreshingTableview" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteTheConnectedPeripheral" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"labelShow" object:self userInfo:[NSDictionary dictionaryWithObject:@"show" forKey:@"option"]];
            [self freshTableView];
        }
            break;
            
        case CBManagerStateUnsupported:
        {
            NSLog(@"蓝牙信息中心 不支持");
            tipForCentralState = NO;
            //[timer1 invalidate];
            //[timer2 invalidate];
            NSLog(@"停止计时2");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriDeleteForRefreshingTableview" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteTheConnectedPeripheral" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"labelShow" object:self userInfo:[NSDictionary dictionaryWithObject:@"show" forKey:@"option"]];
            [self freshTableView];
        }
            break;
            
        case CBManagerStateUnknown:
            //设备不支持的状态
            NSLog(@"蓝牙信息中心 状态位置");
            break;
            
        case CBManagerStateUnauthorized:
            //正在重置状态
            NSLog(@"蓝牙信息中心 未授权");
            break;
            
        case CBManagerStateResetting:
            //设备不支持的状态
        {
            NSLog(@"蓝牙信息中心 重新设置");
            tipForCentralState = NO;
            //[timer1 invalidate];
            //[timer2 invalidate];
            NSLog(@"停止计时3");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriDeleteForRefreshingTableview" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteTheConnectedPeripheral" object:self userInfo:nil];//给view
            [[NSNotificationCenter defaultCenter]postNotificationName:@"labelShow" object:self userInfo:[NSDictionary dictionaryWithObject:@"show" forKey:@"option"]];
            [self freshTableView];
        }
            break;
    }
}

-(void)startScan
{
    [myCentralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
    
    NSLog(@"blueTC-开始扫描");
}


-(void)autofreshTheTableView//自动向tableview发送通知，每3秒进行一次数组刷新
{
    NSLog(@"2%@", [NSThread currentThread]);
    [timer1 invalidate];
    [timer2 invalidate];
    //timer1 = nil;
    //timer2 = nil;
    //NSLog(@"停止计时5");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        timer1 = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(freshTableView) userInfo:@{@"key":@"value"} repeats:true];
        [[NSRunLoop currentRunLoop] run];
        
    });
    
        NSLog(@"blueTC-外设数组自动刷新开始,123多线程%@",  [NSThread currentThread]);
    
    
    if (timer1 != nil) {
        NSLog(@"timer1创建成功");
    }
    
}

-(void)freshTableView//在tableview刷新的5秒内，先清空一次外设数组，2秒后刷新一次tableview，尘埃落定
{
    NSLog(@"blueTC-外设数组自动刷新开始,多线程%@",  [NSThread currentThread]);
    
    [self.peripheralsArray removeAllObjects];
    NSLog(@"blueTC-清空外设数组");
    
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadTheTableView) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:UITrackingRunLoopMode];
    
}

-(void)reloadTheTableView
{
    NSLog(@"blueTC-外设数组目前为:%@",peripheralsArray);
    
    NSDictionary *dict = @{@"periArray":peripheralsArray};
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"freshTableView" object:self userInfo:dict];//刷新TableView
    });
    NSLog(@"blueTC-发送transBlue刷新信号");
}


-(void)stopScan
{
    [super stopScan];
    NSLog(@"blueTC-停止扫描");
    //[timer1 invalidate];
    //[timer2 invalidate];
    NSLog(@"停止计时6");
}




-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI//1,搜索外设，设备开了就会自动调用,会不停调用,直到[ stopScan]此函数中无单独peripheralsNameArray
{
    //NSLog(@"name = %@",peripheral.name);
    if (peripheral.name != nil && [peripheralsArray containsObject:peripheral] == NO )
    {
        //如果是新外设
        [peripheralsArray addObject:peripheral];
        
    }
}

-(void)connectThePeripheralNamed:(NSNotification *)notification//2，连接在tableView里已经选定的外设,被通知connectThePeripheral使用
{
    NSLog(@"blueTC-收到连接通知，并开始连接外设，%@",notification);
    NSString *peripheralName = [[NSString alloc]initWithString:[notification.userInfo objectForKey:@"periNameChosen"]];//取出通知中传来的选定的外设名字
    NSLog(@"连接名字为：%@",peripheralName);
    
    for (CBPeripheral *peri in peripheralsArray) {
        if (peri.name == peripheralName) {//发现这个外设时
            discoveredPeripheral = peri;
            [myCentralManager connectPeripheral:peri options:nil];//🔗选中外设
            NSLog(@"blueTC-外设已连接，为%@",peri);
        }
    }
    NSLog(@"blueTC-连接选中外设函数结束1");
}

-(void)cancelConnect:(NSNotification *)notification
{
    NSLog(@"blueTC-收到断开连接通知，并开始断开连接外设");
    NSArray *periArray = [[NSArray alloc]initWithArray:[notification.userInfo objectForKey:@"connnectedPeripheralNameArray"]];
    
    if (periArray.count > 0)
    {
        NSLog(@"成功进入删除步骤");
        NSString *periName = [[NSString alloc]initWithString:periArray[0]];
        
        if (periHasChosenArray.count > 0)
        {
            for (CBPeripheral *peri in periHasChosenArray)
            {
                if ([peri.name isEqualToString:periName])
                {//发现这个外设时
                    [myCentralManager cancelPeripheralConnection:peri];//🔗选中外设
                    NSLog(@"blueTC-外设已断开，为%@",peri);
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriDeleteForRefreshingTableview" object:self userInfo:nil];//为BTCV发送取消通知,删除tableView内容
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteTheConnectedPeripheral" object:self userInfo:nil];//为Play发送取消通知
                    
                    //[self autofreshTheTableView];
                    //NSLog(@"blueTC-重新扫描外设");
                }
                else
                    NSLog(@"没找到这个外设，所有外设为：%@",periHasChosenArray);
            }
        }
        else NSLog(@"peri = 0");
    }
    
    NSLog(@"periHasChosenArray = %@",periHasChosenArray);
    [periHasChosenArray removeAllObjects];
    //[periReader removeObjectForKey:@"chosenPeri"];
    //[periReader synchronize];
   
    NSLog(@"blueTC-连接选中外设函数结束2");
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:0] forKey:@"batterValue"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProgress" object:self userInfo:dict];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral//连接到设备时就会调用
{
    NSLog(@"blueTC-已连接到设备:%@",peripheral.name);
    peripheral.delegate = self;
    //[myCentralManager stopScan];
    //[timer1 invalidate];
    //[timer2 invalidate];
    [peripheral discoverServices:nil];//寻找服务
    [[NSNotificationCenter defaultCenter]postNotificationName:@"periConnected" object:self userInfo:[NSDictionary dictionaryWithObject:peripheral.name forKey:@"periName"]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"recordTheConnectedPeripheral" object:self userInfo:[NSDictionary dictionaryWithObject:[[NSArray alloc]initWithObjects:peripheral.name, nil] forKey:@"connnectedPeripheral"]];//为Play发送存储通知
    
    [periHasChosenArray addObject:peripheral];
    NSLog(@"peri=%@,periArray=%@",peripheral,periHasChosenArray);
    
    NSLog(@"数组对象为：%@",periHasChosenArray);
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error//设备连接失败时调用
{
    NSLog(@"blueTC-设备连接失败，重新连接");
    [central connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];
}
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error//一旦失去外设就会调用
{
    if (error){
        NSLog(@"blueTC-搜索特征时发生错误:%@",  [error localizedDescription]);
        [central connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];
    }
    //[timer1 invalidate];
    //[timer2 invalidate];
    NSLog(@"blueTC-外设%@失去连接",peripheral.name);
    
    
    if ([peripheralsArray containsObject:peripheral]) {
        [peripheralsArray removeObject:peripheral];
        NSLog(@"blueTC-删除peri");
        [self startScan];
        //[self autofreshTheTableView];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriDeleteForRefreshingTableview" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteTheConnectedPeripheral" object:self userInfo:nil];//为Play发送取消通知
    }
    
    else
        NSLog(@"blueTC-peripheralsArray中不存在%@",peripheral);
    
    //[peripheralsNameArray removeObject:peripheral.name];
    //self.discoveredPeripheral = peripheral;
    //[peripheral discoverServices:nil];//发现peri的所有服务
}

/*
-(void)freshTableView:(NSString *)periName//在外设发生变动的时候发通知，更新选择器
{
    NSLog(@"blueTC-调用:freshTableView:");
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if (periName != nil) {
        [dict setObject:periName forKey:@"deletedPeriName"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"freshTableView" object:self userInfo:dict];//发送通知说更新外设
        NSLog(@"blueTC-tableView刷新,dict = %@",dict);
    });
}*/

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error//读到服务UUID时候会调用
{
    NSLog(@"blueTC-获取设备服务");
    
    if (error) {
        NSLog(@"blueTC-获取设备服务失败: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"blueTC-所有的servicesUUID%@",peripheral.services);
    
    //遍历所有service
    for (CBService *service in peripheral.services)
    {
        NSLog(@"blueTC-服务%@",service.UUID);
        //找到你需要的servicesuuid
        //if ([service.UUID isEqual:[CBUUID UUIDWithString:@"dfb0"]])
        {//监听它
            [peripheral discoverCharacteristics:nil forService:service];
            NSLog(@"blueTC-监听服务内容");
        }
    }
    NSLog(@"此时链接的peripheral：%@",peripheral);
    //[peripheral discoverCharacteristics:nil forService:theService];//读取服务service特征值UUID下面的字符串
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error//读取特征值里的字符
{
    //NSLog(@"blueTC-读取特征值里的字符");
    for (int i=0; i<service.characteristics.count; i++)
    {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        NSLog(@"blueTC-服务特征值里的内容：%@ 和权限：%lu",c,(unsigned long)c.properties);
        [peripheral readValueForCharacteristic:c];
        [peripheral readRSSI];
        if ([[c UUID] isEqual:[CBUUID UUIDWithString:@"dfb1"]])
        {
            NSLog(@"blueTC-读取到动作");
        }
        [peripheral setNotifyValue:YES forCharacteristic:c];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error//数据更新回调
{
    //[peripheral readRSSI];
    NSLog(@"blueTC-数据更新:%@",characteristic);
    //characteristic.value是NSData类型的，具体开发时，会根据开发协议去解析数据
    NSData *originData = [[NSData alloc]initWithData:characteristic.value];
    NSString *datas = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"获取外设发来的数据:%@,为%@",originData,datas);
    NSLog(@"数据为：%@",datas);
    
    if ([datas containsString:@"short"]) {//如果短按
        NSLog(@"zhaodaoshuju");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"incrementPage" object:self userInfo:nil];
    }
    if ([datas containsString:@"long"]) {//如果长按
        [[NSNotificationCenter defaultCenter] postNotificationName:@"decrementPage" object:self userInfo:nil];
    }
    if ([datas containsString:@"ba:"]) {//如果读到电池数据
        
        NSNumber *batterValue;
        
        NSArray *array = [datas componentsSeparatedByString:@"ba:"];
        
        if (array.count > 1 && array[1] != nil) {
            batterValue = [NSNumber numberWithInteger:[array[1] integerValue]];
        }
        else batterValue = [NSNumber numberWithInteger:0];
        
        NSLog(@"电池电量为：%@",batterValue);
        
        [peripheral readRSSI];
        NSLog(@"");
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:batterValue, @"batterValue", rSSI, @"RSSI", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProgress" object:self userInfo:dict];
    }
    //根据协议解析数据
    //因为数据是异步返回的,我并不知道现在返回的数据是是哪种数据,返回的数据中应该会有标志位来识别是哪种数据;
    //如下图,我的设备发来的是8byte数据,收到蓝牙的数据后,打印characteristic.value:
    //获取外设发来的数据:<0af37ab219b0>
    //解析数据,判断首尾数据为a0何b0,即为mac地址,不同设备协议不同
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"char = %@",characteristic);
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    NSLog(@"blueTC-RSSI = %@",RSSI);
    rSSI = RSSI;
}

-(void)dealloc
{
    //[super dealloc];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getTheConnectedPeriDeleteForRefreshingTableview" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:@"connectThePeripheral"];
    [[NSNotificationCenter defaultCenter]removeObserver:@"stopScan"];
    [[NSNotificationCenter defaultCenter]removeObserver:@"cancelConnect"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"getTheConnectedPeriDeleteForRefreshingTableview"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"timersSwitch"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"shakeHandsForShowingLabel"];
    [timer1 invalidate];
    //[timer2 invalidate];
    NSLog(@"停止计时8");
}


@end
