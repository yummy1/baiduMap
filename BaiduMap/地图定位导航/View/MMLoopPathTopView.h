//
//  MMLoopPathTopView.h
//  happyDot
//
//  Created by MM on 17/4/14.
//
//

#import <UIKit/UIKit.h>
@class MMLoopPathTopView;
@protocol MMLoopPathTopViewDelegate <NSObject>

@optional
- (void)clickTrafficBtnOnMMLoopPathTopView:(MMLoopPathTopView *)view index:(NSInteger)pathIndex start:(NSString *)startAddress end:(NSString *)endAddress;

@end
@interface MMLoopPathTopView : UIView
@property(nonatomic,weak)id<MMLoopPathTopViewDelegate>delegate;
@property(nonatomic, strong)NSString *cityName;
@property(nonatomic, strong)NSString *startStr;
/**终点*/
@property(nonatomic, strong)UILabel *endAddress;
@end
