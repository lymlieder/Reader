//
//  RepeatViewController.h
//  Reader
//
//  Created by FairyAnnie on 2017/5/13.
//
//

#import <UIKit/UIKit.h>
#import "ReaderDocument.h"
#import "ReaderContentView.h"
#import "ReaderThumbRequest.h"
#import "ReaderThumbCache.h"
#import <err.h>
#import "ThumbsMainToolbar.h"
#import "ReaderThumbsView.h"
#import "ReaderConstants.h"
#import "ThumbsViewController.h"
#import "ReaderContentPage.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface RepeatViewController : UIViewController



@property(nonatomic, copy) NSString *documentName;
@property(nonatomic, copy) NSNumber *documentPageCount;

@property(nonatomic, strong) NSMutableArray *transArray;
@property(nonatomic, strong) NSMutableArray *playArray;
@property(nonatomic, strong) NSMutableArray *transArrayType;
@property(nonatomic, strong) NSMutableArray *transArrayNumber;

@property(nonatomic, weak) NSMutableDictionary * playDictionary;
@property(nonatomic, weak) NSMutableDictionary * transDictionary;
@property(nonatomic, strong) NSMutableDictionary * transDictionaryType;
@property(nonatomic, strong) NSMutableDictionary * transDictionaryNumber;
@property(nonatomic, copy) NSMutableAttributedString *attributedString;//富文本
@property(nonatomic, copy) NSTextAttachment *attch;
@property(nonatomic,strong) NSMutableArray *pickerData;//字符串数组，从1到页码结束
@property(nonatomic, copy) NSMutableArray * rightNumberArray;//字符串数组，负责滚轮显示
@property(nonatomic, copy) NSMutableArray *pReciveCells;
@property(nonatomic) NSInteger pageNumber;
//@property(nonatomic, strong) ReaderViewController *reader;
@property(nonatomic,strong) UIView *imageBoard;

@property(nonatomic,strong) IBOutlet UITextView *textLabel;
@property(nonatomic,strong) IBOutlet UIPickerView *pickerView;
@property(nonatomic,weak) IBOutlet UISegmentedControl *segmentedContorl;
@property(nonatomic,strong) IBOutlet UIImageView *imageView;
@property(nonatomic,strong) NSNumber *rowNumber;
@property(nonatomic,strong) NSURL *theFileURL;
@property(nonatomic,strong) NSString *theFilePath;
@property(nonatomic) NSUInteger page;
@property(nonatomic,strong) NSString *phrase;
@property(nonatomic,strong) NSString *guid;
//@property(nonatomic,weak) ThumbsViewController *thumbs;
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,weak) UIView *blackView;
@property(nonatomic,strong) UIView *detailShowBackgrand;
@property(nonatomic) BOOL rotateTip;
@property(nonatomic) NSInteger peerViewChosenPageNumber;
@property(nonatomic,strong) UIVisualEffectView *glassView;
@property(nonatomic,strong) UIVisualEffectView *glassViewTip;
@property(nonatomic,strong) UIView *tipBackgrand;
@property(nonatomic) BOOL tipsTip;

-(void) getDocumentInfoFrom:(ReaderDocument *)document;
-(void) load;//加载
-(void) loadTextView;
-(void) loadSegmentedControl;
-(void) loadPickerView;
-(void) freshTransArray;//重写
-(void) freshPlayArray;
-(void) freshArrays;
-(void) freshPlists;
-(void) showTheTransArray;//显示
-(void) transTheTransArrayToPlayArray;//转录
-(void) recordThePlayOrder;//存储文件
-(void) recordTheTransOrder;
-(void) deleteTheLastElementOfTransArray;//删除最后一个元素，并转录
-(void) clearAll;
-(void)readThePlayOrder;//读取文件
-(void)readTheTransOrder;
-(void)freshRightNumbers;//重排滚轮显示数组
//-(void)reciveCells:(NSMutableArray *)array;
//-(void)showImageFor:(NSInteger)page;
//-(void)recordImages:(UIImage *)image for:(int)i;
-(void)freshAll;
//-(void)setDocumentInfo:(ReaderViewController *)readerViewController;
-(void)freshRightImage;
- (void)contentSizeToFit;


-(IBAction)returnBack:(id)sender;//返回
-(IBAction)record:(id)sender;//记录，完成
-(IBAction)deleteData:(id)sender;//删除;
-(IBAction)backSpeace:(id)sender;//回删
-(IBAction)nextStep:(id)sender;//完成
-(IBAction)Tip:(id)sender;//提示
-(IBAction)segmentedClick:(id)sender;//点击事件
-(void)imageViewTapped:(UITapGestureRecognizer *)gesture;
@end

