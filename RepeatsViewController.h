//
//  RepeatsViewController.h
//  Reader
//
//  Created by FairyAnnie on 2017/5/13.
//
//

#import <UIKit/UIKit.h>
#import "ReaderDocument.h"

@interface RepeatsViewController : UIViewController

@property(nonatomic, copy) NSString *documentName;
@property(nonatomic, copy) NSNumber *documentPageCount;

@property(nonatomic, copy) NSMutableArray *transArray;
@property(nonatomic, copy) NSMutableArray *playArray;

@property(nonatomic, weak) NSMutableDictionary * playDictionary;
@property(nonatomic, weak) NSMutableDictionary * transDictionary;
@property(nonatomic, copy) NSMutableAttributedString *attributedString;//富文本
@property(nonatomic, copy) NSTextAttachment *attch;
@property(nonatomic,strong) NSMutableArray *pickerData;

@property(nonatomic,strong) UILabel *textLabel;
@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) UISegmentedControl *segmentedContorl;
@property(nonatomic,strong) NSNumber *rowNumber;
@property(nonatomic,strong) UIButton *returnBack;
@property(nonatomic,strong) UIButton *record;
@property(nonatomic,strong) UIButton *deleteData;
@property(nonatomic,strong) UIButton *backSpace;
@property(nonatomic,strong) UIButton *nextStep;

-(void)returnBackButtonTapped:(UIButton *)button;
-(void)recodeButtonTapped:(UIButton *)button;
-(void)deleteDataButtonTapped:(UIButton *)button;
-(void)backSpaceButtonTapped:(UIButton *)button;
-(void)nestStepButtonTapped:(UIButton *)button;

-(void) getDocumentInfoFrom:(ReaderDocument *)document;
-(void) load;//加载
-(void) loadTextView;
-(void) loadSegmentedControl;
-(void) loadPickerView;
-(void) loadButtons;
-(void) freshTransArray;//重写
-(void) freshPlayArray;
-(void) freshArrays;
-(void) freshPlists;
-(void) showTheTransArray;//显示
-(void) transTheTransArrayToPlayArray;//转录
-(void) recordThePlayOrder;//存储文件
-(void) recordTheTransOrder;
-(void) deleteTheLastElementOfTransArray;//删除最后一个元素，并转录
-(NSMutableArray *)readThePlayOrder;//读取文件
-(NSMutableArray *)readTheTransOrder;



//-(IBAction)returnBack:(id)sender;//返回
//-(IBAction)record:(id)sender;//记录，完成
//-(IBAction)deleteData:(id)sender;//删除;
//-(IBAction)backSpeace:(id)sender;//回删
//-(IBAction)nextStep:(id)sender;//完成
@end

