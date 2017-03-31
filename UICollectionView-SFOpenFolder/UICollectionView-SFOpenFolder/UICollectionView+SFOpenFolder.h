//
//  UICollectionView+OpenFolder.h
//  SFOpenFolder
//
//  Created by Jakey on 2017/3/29.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SFCollectionNaviBarHeight 64
#define SFCollectionCellMoveDuration 0.5

typedef NS_ENUM(NSInteger, SFCollectionMoveDirection) {
    SFCollectionMoveDirectionUp = 1,
    SFCollectionMoveDirectionDown
};

typedef NS_ENUM(NSInteger, SFOpenStatus) {
    SFCollectionOpenStatusClose = 0,
    SFCollectionOpenStatusOpening = 1,
    SFCollectionOpenStatusClosing = 2,
    SFCollectionOpenStatusOpened = 3
};

typedef void(^SFCollectionBeginningBlock)(SFOpenStatus openStatus);
typedef void(^SFCollectionCompletionBlock)(SFOpenStatus openStatus);
typedef UIView* (^SFCollectionContentViewBlock)(id item);

@interface UICollectionView (SFOpenFolder)
@property (nonatomic,strong) UIView *sf_contentView;
@property (assign, nonatomic) SFOpenStatus sf_openStatus;
@property (strong, nonatomic) NSIndexPath *sf_selectedIndexPath;

- (BOOL)sf_openFolderAtIndexPath:(NSIndexPath *)indexPath
                    contentBlock:(SFCollectionContentViewBlock)sf_contentViewBlock
                  beginningBlock:(SFCollectionBeginningBlock)sf_beginningBlock
                 completionBlock:(SFCollectionCompletionBlock)sf_completionBlock;

- (void)sf_closeViewWithSelectedIndexPath:(void (^)(NSIndexPath *selectedIndexPath))completion;
- (void)sf_closeViewWithIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion;
@end

@interface UIView (SFOpenFolderDirection)
@property (assign, nonatomic) SFCollectionMoveDirection sf_collection_direction;
@end
