//
//  PlayViewControllorDelegate.h
//  Reader
//
//  Created by Lieder on 2017/8/8.
//
//

#ifndef PlayViewControllorDelegate_h
#define PlayViewControllorDelegate_h

@protocol PlayViewControllorDelegate <NSObject>

- (void) passValue:(NSInteger)value and:(BOOL)tip;

@end

#endif /* PlayViewControllorDelegate_h */
