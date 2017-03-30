//
//  UICollectionView+OpenFolder.h
//  SFOpenFolder
//
//  Created by Jakey on 2017/3/29.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SFNaviBarHeight 64
#define SFCellMoveDuration 0.5

typedef NS_ENUM(NSInteger, SFMoveDirection) {
    SFMoveDirectionUp = 1,
    SFMoveDirectionDown
};

typedef NS_ENUM(NSInteger, SFOpenStatus) {
    SFOpenStatusClose = 0,
    SFOpenStatusOpening = 1,
    SFOpenStatusClosing = 2,
    SFOpenStatusOpened = 3
};

typedef void(^SFBeginningBlock)(SFOpenStatus openStatus);
typedef void(^SFCompletionBlock)(SFOpenStatus openStatus);
typedef UIView* (^SFContentViewBlock)(id item);

@interface UICollectionView (SFOpenFolder)
@property (nonatomic,strong) UIView *sf_contentView;
@property (assign, nonatomic) SFOpenStatus sf_openStatus;
@property (strong, nonatomic) NSIndexPath *sf_selectedIndexPath;

- (BOOL)sf_openFolderAtIndexPath:(NSIndexPath *)indexPath
                    contentBlock:(SFContentViewBlock)sf_contentViewBlock
                  beginningBlock:(SFBeginningBlock)sf_beginningBlock
                 completionBlock:(SFCompletionBlock)sf_completionBlock;

- (void)sf_closeViewWithSelectedIndexPath:(void (^)(NSIndexPath *selectedIndexPath))completion;
- (void)sf_closeViewWithIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion;
@end

@interface UIView (SFOpenFolderDirection)
@property (assign, nonatomic) SFMoveDirection sf_direction;
@end
