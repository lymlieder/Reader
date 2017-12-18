//
//  RepeatViewController+More.h
//  Reader
//
//  Created by FairyAnnie on 2017/5/10.
//
//

#import "RepeatViewController.h"

@interface ReaderViewController (More)

-(void)frenshArrays;//两个数组一起重置,不推荐
-(void)freshThePlayPlistOfDocument:(ReaderDocument *)document;//Play，用零元素覆盖之前的元素，覆盖plist文件,不推荐
-(void)freshPlistsOfDocument:(ReaderDocument *)document;//两个文件一起重置，不推荐
-(void)frenshPlayArrays;//重置Play数组,不删除plist中记录,不推荐

@end
