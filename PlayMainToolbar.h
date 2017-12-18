//
//  PlayMainToolbar.h
//  Reader
//
//  Created by Lieder on 2017/8/6.
//
//

#import "UIXToolbarView.h"
#import <UIKit/UIKit.h>
#import "ReaderDocument.h"
#import "BlueToothViewController.h"
#import "BlueToothController.h"

@class PlayMainToolbar;
@class ReaderDocument;

@protocol PlayMainToolbarDelegate <NSObject>

@required // Delegate protocols

- (void)tappedInToolbar:(PlayMainToolbar *)toolbar doubleButton:(UIButton *)button;
//////////blee 定义双页演奏
- (void)tappedInToolbar:(PlayMainToolbar *)toolbar blueButton:(UIButton *)button;
//蓝牙编辑

@end

@interface PlayMainToolbar : UIXToolbarView

@property (nonatomic, weak, readwrite) id <PlayMainToolbarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame documentName:(NSString *)documentName;

//- (void)setBookmarkState:(BOOL)state;

- (void)hideToolbar;
- (void)showToolbar;

@end
