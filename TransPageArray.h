//
//  TransPageArray.h
//  Reader
//
//  Created by FairyAnnie on 2017/5/1.
//
//

#import <Foundation/Foundation.h>
#import "ReaderDocument.h"

@interface TransPageArray : NSArray
{
    NSMutableArray *type;
    NSMutableArray *steps;
    ReaderDocument *document;
}

/////////////blee 等待传参
-(void)addTransPageArrayType:(NSString *)_type andSteps:(NSString *)_step atTime:(int)n;
-(void)setTransPageArrayType:(NSString *)_type andSteps:(NSString *)_step atDocument:(ReaderDocument *)document;
-(void)addTransPageArray:(NSMutableArray *)_array toTextOf:(ReaderDocument *)document;
@end


