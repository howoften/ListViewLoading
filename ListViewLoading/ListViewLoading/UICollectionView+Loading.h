//
//  UICollectionView+Loading.h
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/15.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UICollectionViewLoadingDelegate <NSObject>
@required
- (NSInteger)sectionsOfloadingCollectionView:(UICollectionView *)collectionView;
- (NSInteger)loadingCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)loadingCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (UICollectionReusableView *)loadingCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
@end

@interface UICollectionView (Loading)
@property (nonatomic, readonly)BOOL loading;

- (void)startLoading;
- (void)stopLoading;

@end
NS_ASSUME_NONNULL_END
