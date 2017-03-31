//
//  UICollectionView+OpenFolder.m
//  SFOpenFolder
//
//  Created by Jakey on 2017/3/29.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import "UICollectionView+SFOpenFolder.h"
#define SFCollectionScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define SFCollectionScreenWidth ([UIScreen mainScreen].bounds.size.width)

#import  <objc/runtime.h>


static const void *k_sf_collection_contentView = &k_sf_collection_contentView;
static const void *k_sf_collection_open = &k_sf_collection_open;
static const void *k_sf_collection_animationCells = &k_sf_collection_animationCells;
static const void *k_sf_collection_animationHeaders = &k_sf_collection_animationHeaders;
static const void *k_sf_collection_up = &k_sf_collection_up;
static const void *k_sf_collection_down = &k_sf_collection_down;

static const void *k_sf_collection_beginningblock = &k_sf_collection_beginningblock;
static const void *k_sf_collection_completionblock = &k_sf_collection_completionblock;
static const void *k_sf_collection_contentblock = &k_sf_collection_contentblock;

static const void *k_sf_collection_selectedindexpath = &k_sf_collection_selectedindexpath;
static const void *k_sf_collection_direction = &k_sf_collection_direction;
static const void *k_sf_collection_duration = &k_sf_collection_duration;
static const void *k_sf_collection_content_frame = &k_sf_collection_content_frame;

@interface UICollectionView()
@property (strong, nonatomic) NSMutableArray *sf_animationCells;
@property (strong, nonatomic) NSMutableArray *sf_animationHeaders;
@property (assign, nonatomic) CGRect sf_collection_content_frame;

//@property (strong, nonatomic) NSMutableArray *sf_animationFooters; //todo

@property (assign, nonatomic) CGFloat sf_collection_open_up;
@property (assign, nonatomic) CGFloat sf_collection_open_down;
@property (assign, nonatomic) NSTimeInterval sf_collection_open_duration;
@property (copy, nonatomic) SFCollectionBeginningBlock sf_beginningBlock;
@property (copy, nonatomic) SFCollectionCompletionBlock sf_completionBlock;
@property (copy, nonatomic) SFCollectionContentViewBlock sf_contentViewBlock;
@end

@implementation UICollectionView (SFOpenFolder)
//+ (void)load {
//    SEL selectors[] = {
//        @selector(reloadData),
//        @selector(reloadSections:),
//        @selector(reloadItemsAtIndexPaths:)
//    };
//
//    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
//        SEL originalSelector = selectors[index];
//        SEL swizzledSelector = NSSelectorFromString([@"sf_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
//        Method originalMethod = class_getInstanceMethod(self, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//#pragma mark -- swizzle
//- (void)sf_reloadData {
//    [self sf_reloadData];
//}
//- (void)sf_reloadSections:(NSIndexSet *)sections{
//    if ([self numberOfItemsInSection:self.sf_selectedIndexPath.section]==0) {
//        [self sf_closeViewWithSelectIndexPath:self.sf_selectedIndexPath];
//    }
//    [self sf_reloadSections:sections];
//}
//- (void)sf_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;{
//    if ([self numberOfItemsInSection:self.sf_selectedIndexPath.section]==0) {
//        [self sf_closeViewWithSelectIndexPath:self.sf_selectedIndexPath];
//    }
//    [self sf_reloadItemsAtIndexPaths:indexPaths];
//}
#pragma mark -- property
-(NSIndexPath *)sf_selectedIndexPath{
    return objc_getAssociatedObject(self, k_sf_collection_selectedindexpath);
}
-(void)setSf_selectedIndexPath:(NSIndexPath *)sf_selectedIndexPath{
    objc_setAssociatedObject(self, k_sf_collection_selectedindexpath, sf_selectedIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)sf_contentView{
    return objc_getAssociatedObject(self, k_sf_collection_contentView);
}
- (void)setSf_contentView:(UIView *)sf_contentView{
    objc_setAssociatedObject(self, k_sf_collection_contentView, sf_contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (SFCollectionOpenStatus)sf_openStatus{
    return (SFCollectionOpenStatus)[objc_getAssociatedObject(self, k_sf_collection_open) integerValue];
}
- (void)setSf_openStatus:(SFCollectionOpenStatus)sf_openStatus{
    objc_setAssociatedObject(self,k_sf_collection_open, @(sf_openStatus), OBJC_ASSOCIATION_ASSIGN);
}
- (NSMutableArray *)sf_animationCells{
    return objc_getAssociatedObject(self, k_sf_collection_animationCells);
}
- (void)setSf_animationCells:(NSMutableArray *)sf_animationCells{
    objc_setAssociatedObject(self,k_sf_collection_animationCells, sf_animationCells, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)sf_animationHeaders{
    return objc_getAssociatedObject(self, k_sf_collection_animationHeaders);
}
- (void)setSf_animationHeaders:(NSMutableArray *)sf_animationHeaders{
    objc_setAssociatedObject(self,k_sf_collection_animationHeaders, sf_animationHeaders, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)sf_collection_open_up{
    return [objc_getAssociatedObject(self, k_sf_collection_up) floatValue];
}
- (void)setSf_collection_open_up:(CGFloat)sf_collection_open_up{
    objc_setAssociatedObject(self,k_sf_collection_up, @(sf_collection_open_up), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)sf_collection_open_down{
    return [objc_getAssociatedObject(self, k_sf_collection_down) floatValue];
}
- (void)setSf_collection_open_down:(CGFloat)sf_collection_open_down{
    objc_setAssociatedObject(self,k_sf_collection_down, @(sf_collection_open_down), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (SFCollectionBeginningBlock)sf_beginningBlock{
    return objc_getAssociatedObject(self, k_sf_collection_beginningblock);
}
- (void)setSf_beginningBlock:(SFCollectionBeginningBlock)sf_beginningBlock{
    objc_setAssociatedObject(self,k_sf_collection_beginningblock,sf_beginningBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SFCollectionCompletionBlock)sf_completionBlock{
    return objc_getAssociatedObject(self, k_sf_collection_completionblock);
}
- (void)setSf_completionBlock:(SFCollectionCompletionBlock)sf_completionBlock{
    objc_setAssociatedObject(self,k_sf_collection_completionblock,sf_completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SFCollectionContentViewBlock)sf_contentViewBlock{
    return objc_getAssociatedObject(self, k_sf_collection_contentblock);
}
- (void)setSf_contentViewBlock:(SFCollectionContentViewBlock)sf_contentViewBlock{
    objc_setAssociatedObject(self,k_sf_collection_contentblock,sf_contentViewBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSTimeInterval)sf_collection_open_duration{
    return [objc_getAssociatedObject(self, k_sf_collection_duration) doubleValue];
}
- (void)setSf_collection_open_duration:(NSTimeInterval)sf_collection_open_duration{
    objc_setAssociatedObject(self,k_sf_collection_duration, @(sf_collection_open_duration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)sf_table_content_frame{
    return CGRectFromString([objc_getAssociatedObject(self, k_sf_collection_content_frame) description]);
}
- (void)setSf_table_content_frame:(CGRect)sf_table_content_frame{
    objc_setAssociatedObject(self,k_sf_collection_content_frame, NSStringFromCGRect(sf_table_content_frame), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark -
#pragma mark -- Opend Method
- (void)sf_closeViewWithSelectedIndexPath:(void (^)(NSIndexPath *selectedIndexPath))completion

{
    [self sf_closeViewWithIndexPath:self.sf_selectedIndexPath completion:^{
        completion(self.sf_selectedIndexPath);
    }];
}
- (BOOL)sf_openFolderAtIndexPath:(NSIndexPath *)indexPath
                    contentBlock:(SFCollectionContentViewBlock)sf_contentViewBlock
                  beginningBlock:(SFCollectionBeginningBlock)sf_beginningBlock
                 completionBlock:(SFCollectionCompletionBlock)sf_completionBlock{
   return [self sf_openFolderAtIndexPath:indexPath
                                duration:SFCollectionCellMoveDuration
                            contentBlock:sf_contentViewBlock
                          beginningBlock:sf_beginningBlock
                         completionBlock:sf_completionBlock];
}
- (BOOL)sf_openFolderAtIndexPath:(NSIndexPath *)indexPath
                        duration:(NSTimeInterval)duration
                    contentBlock:(SFCollectionContentViewBlock)sf_contentViewBlock
                  beginningBlock:(SFCollectionBeginningBlock)sf_beginningBlock
                 completionBlock:(SFCollectionCompletionBlock)sf_completionBlock{
    self.sf_beginningBlock = [sf_beginningBlock copy];
    self.sf_completionBlock = [sf_completionBlock copy];
    self.sf_contentViewBlock = [sf_contentViewBlock copy];
    self.sf_selectedIndexPath = indexPath;
    self.sf_collection_open_duration = duration;

    if (self.sf_openStatus == SFCollectionOpenStatusOpening) {
        return YES;
    }
    if (self.sf_openStatus ==  SFCollectionOpenStatusOpened) {
        if (self.sf_beginningBlock) {
            self.sf_beginningBlock(SFCollectionOpenStatusOpening);
        }
        [self sf_closeViewWithIndexPath:indexPath completion:nil];
    }
    
    if (self.sf_openStatus == SFCollectionOpenStatusClose) {
        if (self.sf_contentViewBlock) {
            self.sf_contentView = self.sf_contentViewBlock(nil);
        }else{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
            self.sf_contentView = view;
        }
        self.sf_table_content_frame = self.sf_contentView.frame;
        
        if (!self.sf_animationCells) {
            self.sf_animationCells = [NSMutableArray array];
        }
        if (!self.sf_animationHeaders) {
            self.sf_animationHeaders = [NSMutableArray array];
        }
        if (self.sf_beginningBlock) {
            self.sf_beginningBlock(SFCollectionOpenStatusClosing);
        }
        [self sf_openViewWithSelectIndexPath:indexPath];
        
    }
    //    NSLog(@"open status:%zd",self.sf_openStatus);
    return YES;
}
- (void)sf_openViewWithSelectIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat bottomY = [self sf_offsetBottomWithIndexPath:indexPath];
    //    NSLog(@"bottomY:%lf",bottomY);
    
    if (bottomY >= self.sf_contentView.frame.size.height)
    {
        
        self.sf_collection_open_down = self.sf_contentView.frame.size.height;
        [self sf_moveDownFromIndexPath:indexPath];
        //增加contentview
        CGRect selectCellFinalFrame =  [self cellForItemAtIndexPath:indexPath].frame;
        CGFloat contentHeight = self.sf_contentView.frame.size.height;
        self.sf_contentView.frame = CGRectMake(0, CGRectGetMaxY(selectCellFinalFrame), self.sf_contentView.frame.size.width,0);
        self.sf_contentView.clipsToBounds = YES;
        [self addSubview:self.sf_contentView];
        
        [UIView animateWithDuration:self.sf_collection_open_duration animations:^{
            self.sf_contentView.frame = CGRectMake(0, CGRectGetMaxY(selectCellFinalFrame), self.sf_contentView.frame.size.width,contentHeight);
        } completion:^(BOOL finished) {
            //完成状态
            if (self.sf_completionBlock) {
                self.sf_completionBlock(SFCollectionOpenStatusOpened);
                self.sf_openStatus = SFCollectionOpenStatusOpened;
            }
        }];
    }
    else
    {
        //增加contentview
        CGRect selectCelOldFrame =  [self cellForItemAtIndexPath:indexPath].frame;
        self.sf_collection_open_up = self.sf_contentView.frame.size.height - bottomY;
        self.sf_collection_open_down = bottomY;
        [self sf_moveUPandDownFromIndexPath:indexPath];
        CGRect selectCelFinalFrame =  [self cellForItemAtIndexPath:indexPath].frame;
        
        CGFloat contentHeight = self.sf_contentView.frame.size.height;
        self.sf_contentView.frame = CGRectMake(0, CGRectGetMaxY(selectCelOldFrame), self.sf_contentView.frame.size.width,0);
        self.sf_contentView.clipsToBounds = YES;
        [self addSubview:self.sf_contentView];
        [UIView animateWithDuration:self.sf_collection_open_duration animations:^{
            self.sf_contentView.frame = CGRectMake(0, CGRectGetMaxY(selectCelFinalFrame), self.sf_contentView.frame.size.width,contentHeight);
        } completion:^(BOOL finished) {
            //完成状态
            if (self.sf_completionBlock) {
                self.sf_completionBlock(SFCollectionOpenStatusOpened);
                self.sf_openStatus = SFCollectionOpenStatusOpened;
            }
        }];
    }
    
    self.scrollEnabled = NO;
}
- (void)sf_moveDownFromIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"直接展开");
    NSArray *visiblePaths = [self indexPathsForVisibleItems];
    NSArray *visibleSections = [self indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionHeader];
    UICollectionViewCell *selectCell = (UICollectionViewCell *)[self cellForItemAtIndexPath:indexPath];
    
    
    [visiblePaths enumerateObjectsUsingBlock:^(NSIndexPath *path, NSUInteger idx, BOOL *stop) {
        UICollectionViewCell *moveCell = (UICollectionViewCell *)[self cellForItemAtIndexPath:path];
        
        if ((path.section > indexPath.section))
        {
            [self sf_animateView:moveCell WithDirection:SFCollectionMoveDirectionDown distance:self.sf_collection_open_down isOpening:YES];
            [self.sf_animationCells addObject:moveCell];
        }
        else if ((path.section  == indexPath.section) && (path.row > indexPath.row) && selectCell.frame.origin.y != moveCell.frame.origin.y){
            [self sf_animateView:moveCell WithDirection:SFCollectionMoveDirectionDown distance:self.sf_collection_open_down isOpening:YES];
            [self.sf_animationCells addObject:moveCell];
        }
        else
        {
            self.sf_openStatus = SFCollectionOpenStatusOpened;
        }
        
        if (path.row != indexPath.row)
        {
            //改变当前cell样式;
        }
        
    }];
    
    
    [visibleSections enumerateObjectsUsingBlock:^(NSIndexPath *index, NSUInteger idx, BOOL *stop) {
        
        if ((index.section > indexPath.section ))
        {
            UICollectionReusableView *sectionHeader = [self supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:index];
            
            if (sectionHeader) {
                [self sf_animateView:sectionHeader WithDirection:SFCollectionMoveDirectionDown distance:self.sf_collection_open_down isOpening:YES];
                [self.sf_animationHeaders addObject:sectionHeader];
            }
        }
    }];
}
- (void)sf_moveUPandDownFromIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"移动展开");
    NSArray *visiblePaths = [self indexPathsForVisibleItems];
    NSArray *visibleSections = [self indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionHeader];
    CGRect selectCellFrame =  [self layoutAttributesForItemAtIndexPath:indexPath].frame;
    
    
    [visiblePaths enumerateObjectsUsingBlock:^(NSIndexPath *path, NSUInteger idx, BOOL *stop) {
        UICollectionViewCell *moveCell = (UICollectionViewCell *)[self cellForItemAtIndexPath:path];
        
        if ((path.section < indexPath.section))
        {
            [self sf_animateView:moveCell WithDirection:SFCollectionMoveDirectionUp distance:self.sf_collection_open_up isOpening:YES];
            [self.sf_animationCells addObject:moveCell];
            
        }
        else if ((path.section  == indexPath.section))
        {
            //                NSLog(@"{selecct: %zd,%zd}",indexPath.section,indexPath.row);
            //                NSLog(@"{move:%zd,%zd}",path.section,path.row);
            
            if ((path.row <= indexPath.row)) {
                [self sf_animateView:moveCell WithDirection:SFCollectionMoveDirectionUp distance:self.sf_collection_open_up isOpening:YES];
                [self.sf_animationCells addObject:moveCell];
                
            }else{
                CGRect m =  [self layoutAttributesForItemAtIndexPath:path].frame;
                if ((m.origin.y  - selectCellFrame.origin.y != 0)) {
                    [self sf_animateView:moveCell WithDirection:SFCollectionMoveDirectionDown distance:self.sf_collection_open_down isOpening:YES];
                    [self.sf_animationCells addObject:moveCell];
                }else{
                    [self sf_animateView:moveCell WithDirection:SFCollectionMoveDirectionUp distance:self.sf_collection_open_up isOpening:YES];
                    [self.sf_animationCells addObject:moveCell];
                }
            }
        }
        else
        {
            [self sf_animateView:moveCell WithDirection:SFCollectionMoveDirectionDown distance:self.sf_collection_open_down isOpening:YES];
            [self.sf_animationCells addObject:moveCell];
        }
        if (path.row != indexPath.row)
        {
            //改变当前cell样式;
        }
        //        //完成状态
        //        if ((moveCell == [self.sf_animationCells lastObject]) && self.sf_completionBlock) {
        //            self.sf_completionBlock(SFOpenStatusOpened);
        //            self.sf_openStatus = SFOpenStatusOpened;
        //        }
    }];
    
    [visibleSections enumerateObjectsUsingBlock:^(NSIndexPath *index, NSUInteger idx, BOOL *stop) {
        UICollectionReusableView *sectionHeader = [self supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:index];
        
        if (sectionHeader)
        {
            if ((index.section < indexPath.section))
            {
                [self sf_animateView:sectionHeader WithDirection:SFCollectionMoveDirectionUp distance:self.sf_collection_open_up isOpening:YES];
            }else if (index.section  == indexPath.section) {
                [self sf_animateView:sectionHeader WithDirection:SFCollectionMoveDirectionUp distance:self.sf_collection_open_up isOpening:YES];
            }else{
                [self sf_animateView:sectionHeader WithDirection:SFCollectionMoveDirectionDown distance:self.sf_collection_open_down isOpening:YES];
            }
            [self.sf_animationHeaders addObject:sectionHeader];
        }
    }];
}

#pragma mark -
#pragma mark -- Close Method
- (void)sf_closeViewWithIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion
{
    if (self.sf_openStatus == SFCollectionOpenStatusClose) {
        if (completion) {
            completion();
        }
        NSLog(@"折叠section");
        return;
    }
    NSLog(@"关闭");
    [self.sf_animationCells enumerateObjectsUsingBlock:^(UICollectionViewCell *moveCell, NSUInteger idx, BOOL *stop) {
        if (moveCell.sf_collection_direction == SFCollectionMoveDirectionUp)
        {
            [self sf_animateView:moveCell WithDirection:SFCollectionMoveDirectionDown distance:self.sf_collection_open_up isOpening:NO];
        }
        else
        {
            [self sf_animateView:moveCell WithDirection:SFCollectionMoveDirectionUp distance:self.sf_collection_open_down  isOpening:NO];
        }
    }];
    
    
    [self.sf_animationHeaders enumerateObjectsUsingBlock:^(UICollectionReusableView *moveCell, NSUInteger idx, BOOL *stop) {
        if (moveCell.sf_collection_direction == SFCollectionMoveDirectionUp)
        {
            [self sf_animateView:moveCell WithDirection:SFCollectionMoveDirectionDown distance:self.sf_collection_open_up  isOpening:NO];
        }
        else
        {
            [self sf_animateView:moveCell WithDirection:SFCollectionMoveDirectionUp distance:self.sf_collection_open_down  isOpening:NO];
        }
    }];
    
    if (self.sf_collection_open_up==0) {
        [UIView animateWithDuration:self.sf_collection_open_duration animations:^{
            self.sf_contentView.frame = CGRectMake(self.sf_contentView.frame.origin.x, self.sf_contentView.frame.origin.y, self.sf_contentView.frame.size.width,0);
        } completion:^(BOOL finished) {
            self.sf_contentView.frame = self.sf_table_content_frame;
            [self.sf_contentView removeFromSuperview];
            if (self.sf_completionBlock) {
                self.sf_completionBlock(SFCollectionOpenStatusClose);
                self.sf_openStatus = SFCollectionOpenStatusClose;
            }
            if (completion) {
                completion();
            }
        }];
    }else{
        [UIView animateWithDuration:self.sf_collection_open_duration animations:^{
            CGRect frame = self.sf_contentView.frame;
            frame.origin.y = frame.origin.y + self.sf_collection_open_up;
            self.sf_contentView.frame = frame;
            [UIView animateWithDuration:self.sf_collection_open_duration animations:^{
                CGRect frame = self.sf_contentView.frame;
                frame.size.height = 0;
                self.sf_contentView.frame = frame;
            } completion:^(BOOL finished) {
                self.sf_contentView.frame = self.sf_table_content_frame;
                [self.sf_contentView removeFromSuperview];
            }];
        } completion:^(BOOL finished) {
            self.sf_contentView.frame = self.sf_table_content_frame;
            [self.sf_contentView removeFromSuperview];
            if (self.sf_completionBlock) {
                self.sf_completionBlock(SFCollectionOpenStatusClose);
                self.sf_openStatus = SFCollectionOpenStatusClose;
            }
            if (completion) {
                completion();
            }
        }];
    }
    
    
    //    NSArray *paths = [collectionView indexPathsForVisibleItems];
    //    for (NSIndexPath *path in paths)
    //    {
    //      //更改除选中cell之外的cell样式
    //    }
    [self sf_clean];
}
- (void)sf_clean{
    self.sf_collection_open_up = 0;
    self.sf_collection_open_down = 0;
    self.sf_selectedIndexPath = nil;
    self.scrollEnabled = YES;
    [self.sf_animationCells removeAllObjects];
    [self.sf_animationHeaders removeAllObjects];
}

#pragma mark -
#pragma mark Actions
- (CGFloat)sf_offsetBottomWithIndexPath:(NSIndexPath *)indexPath
{
    //    CGFloat screenHeight = SFScreenHeight - SFNaviBarHeight;
    CGFloat screenHeight = self.frame.size.height;
    CGRect cellFrame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;;
    CGFloat frameY = cellFrame.origin.y;
    CGFloat offY = self.contentOffset.y;
    CGFloat bottomY = screenHeight - (frameY - offY) - cellFrame.size.height;
    return bottomY;
}

- (void)sf_animateView:(UIView *)view WithDirection:(SFCollectionMoveDirection)direction distance:(CGFloat)dis isOpening:(BOOL)isOpening
{
    CGRect newFrame = view.frame;
    view.sf_collection_direction = direction;
    switch (direction)
    {
        case SFCollectionMoveDirectionUp:
            newFrame.origin.y -= dis;
            break;
        case SFCollectionMoveDirectionDown:
            newFrame.origin.y += dis;
            break;
        default:NSAssert(NO, @"无法识别的方向");
            break;
    }
    
    if (isOpening) {
        self.sf_openStatus = SFCollectionOpenStatusOpening;
    }else{
        self.sf_openStatus = SFCollectionOpenStatusClosing;
    }
    
    [UIView animateWithDuration:self.sf_collection_open_duration
                     animations:^{
                         view.frame = newFrame;
                     } completion:^(BOOL finished) {
                         //                         if (isOpening) {
                         //                             self.sf_openStatus = SFOpenStatusOpened;
                         //                         }else{
                         //                             self.sf_openStatus = SFOpenStatusClose;
                         //                         }
                     }];
}
@end

@implementation UIView (SFOpenFolderDirection)
- (SFCollectionMoveDirection)sf_collection_direction{
    return (SFCollectionMoveDirection)[objc_getAssociatedObject(self, k_sf_collection_direction) integerValue];
}
- (void)setSf_collection_direction:(SFCollectionMoveDirection)sf_collection_direction{
    objc_setAssociatedObject(self,k_sf_collection_direction, @(sf_collection_direction), OBJC_ASSOCIATION_ASSIGN);
}
@end


