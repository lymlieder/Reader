//
//  RepeatViewController+More.m
//  Reader
//
//  Created by FairyAnnie on 2017/5/10.
//
//

#import "RepeatViewController+More.h"

@implementation RepeatViewController (More)

-(void)frenshArrays//初始化两个数组,不删除plist中记录,不推荐
{
    //将repeat置为{0,1}
    CGPoint theTransPoint={0,1};//将读取的录入数据暂时theTransPoint中,0代表灰色顺序演奏，1代表第1页，1在前
    NSValue * transTip =[NSValue valueWithCGPoint:theTransPoint]; //转换成value值
    NSMutableArray *transPath = [[NSMutableArray alloc]initWithObjects:transTip, nil];
    self.transArray = [[NSMutableArray alloc]initWithArray:transPath] ;//将读到数字点加入transArray记录数列中
    NSLog(@"重置transArray数组完毕，freshArrays，为%@",self.transArray[0]);
    
    NSNumber * playTip = [NSNumber numberWithUnsignedInteger:0];
    NSMutableArray * playPath=[[NSMutableArray alloc]initWithObjects:playTip, nil];
    self.playArray = [[NSMutableArray alloc]initWithArray:playPath];//paly数组中第一个元素设为0
    NSLog(@"初始化playArray数组完毕，freshArrays，为%@",self.playArray[0]);
    NSLog(@"两个数组均重置");
}

-(void)freshThePlayPlistOfDocument:(ReaderDocument *)document//Play，用零元素覆盖之前的元素，覆盖plist文件
{  //play数组
    NSNumber * number = [NSNumber numberWithUnsignedInteger:1];
    NSMutableArray * oneArray2=[NSMutableArray arrayWithObject:number];
    NSMutableDictionary * dictionary2=[NSMutableDictionary dictionaryWithObject:oneArray2 forKey:document.fileName];//把一个文章的临时数组增加在dictionary里，文件名为key，一个dictionary表示一个pdf文件的演奏方式或临时文件的记录方式（）
    [NSKeyedArchiver archiveRootObject:dictionary2 toFile:@"ReaderPadTrans.plist"];//把dictionary存在ReadPadTrans.plist文件里
    NSLog(@"Play.plist文件已被重置");
}

-(void)freshPlistsOfDocument:(ReaderDocument *)document//同时重置两个文件,不推荐
{
    //[self freshTheTransPlistOfDocument:document];
    [self freshThePlayPlistOfDocument:document];
}

-(void)frenshPlayArrays//重置Play数组,不删除plist中记录,不推荐
{
    
    NSLog(@"开始重置palyArray数组，repeat");
    
    NSNumber * playTip = [NSNumber numberWithUnsignedInteger:0];
    NSMutableArray * playPath=[[NSMutableArray alloc]initWithObjects:playTip, nil];
    self.playArray = [[NSMutableArray alloc]initWithArray:playPath];//paly数组中第一个元素设为0
    NSLog(@"初始化playArray数组完毕");
    NSLog(@"为%@",self.playArray[0]);
}

@end
