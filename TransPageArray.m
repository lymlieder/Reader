//
//  TransPageArray.m
//  Reader
//
//  Created by FairyAnnie on 2017/5/1.
//
//

#import "TransPageArray.h"

@implementation TransPageArray

-(void)addTransPageArrayType:(NSString *)_type andSteps:(NSString *)_step atTime:(int)n
{
    //document.pageNumber;
    return;
}

-(void)setTransPageArrayType:(NSString *)_type andSteps:(NSString *)_step atDocument:(ReaderDocument *)theDocument//添加字符串并将字符串写入同名文件
{
    NSArray *start = @[@"1"];
    type=[NSMutableArray arrayWithArray:start];
    [type addObject:_type];
    
    steps=[NSMutableArray arrayWithArray:start];
    [steps addObject:_step];
    
    NSString *name = theDocument.fileName;
    NSString *textNameType = [name stringByAppendingString:@"_Type.txt"];
    NSString *textNameSteps = [name stringByAppendingString:@"_Steps.txt"];
    [type writeToFile:textNameType atomically:YES];//将操作类型文件写入记录文档
    [steps writeToFile:textNameSteps atomically:YES];//将操作步数文件写入记录文档
    
}

-(void)addTransPageArray:(NSMutableArray *)_array toTextOf:(ReaderDocument *)document
{
    
}
@end
