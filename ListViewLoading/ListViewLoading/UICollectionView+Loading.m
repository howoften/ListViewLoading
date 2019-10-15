//
//  UICollectionView+Loading.m
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/15.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <objc/runtime.h>
#import "UICollectionView+Loading.h"
#import "UIView+Sunshine.h"

@implementation UICollectionView (Loading)

- (void)method_swizzing {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            Method num_section = class_getInstanceMethod(self.dataSource.class, @selector(numberOfSectionsInCollectionView:));
            Method num_section_replace = class_getInstanceMethod(self.class, @selector(t_numberOfSectionsInCollectionView:));
            BOOL didAddMethod = class_addMethod(self.dataSource.class, @selector(numberOfSectionsInCollectionView:), method_getImplementation(num_section_replace), method_getTypeEncoding(num_section_replace));
            if (didAddMethod) {
                class_replaceMethod(self.dataSource.class, @selector(t_numberOfSectionsInCollectionView:),
                                    method_getImplementation(num_section),
                                    method_getTypeEncoding(num_section));
            } else {
                method_exchangeImplementations(num_section, num_section_replace);
            }
        }
        if ([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            Method num_row = class_getInstanceMethod(self.dataSource.class, @selector(collectionView:numberOfItemsInSection:));
            Method num_row_replace = class_getInstanceMethod(self.class, @selector(t_collectionView:numberOfItemsInSection:));
            BOOL didAddMethod = class_addMethod(self.dataSource.class, @selector(collectionView:numberOfItemsInSection:), method_getImplementation(num_row_replace), method_getTypeEncoding(num_row_replace));
            if (didAddMethod) {
                class_replaceMethod(self.dataSource.class, @selector(t_collectionView:numberOfItemsInSection:),
                                    method_getImplementation(num_row),
                                    method_getTypeEncoding(num_row));
            } else {
                method_exchangeImplementations(num_row, num_row_replace);
            }
        }
        
        if ([self.dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
            Method cell = class_getInstanceMethod(self.dataSource.class, @selector(collectionView:cellForItemAtIndexPath:));
            Method cell_replace = class_getInstanceMethod(self.class, @selector(t_collectionView:cellForItemAtIndexPath:));
            BOOL didAddMethod = class_addMethod(self.dataSource.class, @selector(collectionView:cellForItemAtIndexPath:), method_getImplementation(cell_replace), method_getTypeEncoding(cell_replace));
            if (didAddMethod) {
                class_replaceMethod(self.dataSource.class, @selector(t_collectionView:cellForItemAtIndexPath:),
                                    method_getImplementation(cell),
                                    method_getTypeEncoding(cell));
            } else {
                method_exchangeImplementations(cell, cell_replace);
            }
        }
        
        if ([self.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            Method header = class_getInstanceMethod(self.dataSource.class, @selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:));
            Method header_replace = class_getInstanceMethod(self.class, @selector(t_collectionView:viewForSupplementaryElementOfKind:atIndexPath:));
            BOOL didAddMethod = class_addMethod(self.dataSource.class, @selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:), method_getImplementation(header_replace), method_getTypeEncoding(header_replace));
            if (didAddMethod) {
                class_replaceMethod(self.dataSource.class, @selector(t_collectionView:viewForSupplementaryElementOfKind:atIndexPath:),
                                    method_getImplementation(header),
                                    method_getTypeEncoding(header));
            } else {
                method_exchangeImplementations(header, header_replace);
            }
        }
       
    });
    
}

- (NSInteger)t_numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([collectionView loading]) {
        id<UICollectionViewLoadingDelegate> load_delegate = (id<UICollectionViewLoadingDelegate>)self;
        return [load_delegate sectionsOfloadingCollectionView:collectionView];
    }else {
        return [collectionView t_numberOfSectionsInCollectionView:collectionView];
    }
}

- (NSInteger)t_collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView loading]) {
        id<UICollectionViewLoadingDelegate> load_delegate = (id<UICollectionViewLoadingDelegate>)self;
        return [load_delegate loadingCollectionView:collectionView numberOfItemsInSection:section];
    }else {
        return [collectionView t_collectionView:collectionView numberOfItemsInSection:section];
    }
}

- (UICollectionViewCell *)t_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView loading]) {
        id<UICollectionViewLoadingDelegate> load_delegate = (id<UICollectionViewLoadingDelegate>)self;
        UICollectionViewCell *cell = [load_delegate loadingCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        [collectionView beginLoadingAnimation:cell];
        return cell;
    }else {
        UICollectionViewCell *cell = [collectionView t_collectionView:collectionView cellForItemAtIndexPath:indexPath];
        [collectionView stopLoadingAnimation:cell];
        return cell;
    }
}

- (UICollectionReusableView *)t_collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView loading]) {
        id<UICollectionViewLoadingDelegate> load_delegate = (id<UICollectionViewLoadingDelegate>)self;
        UICollectionReusableView *header = [load_delegate loadingCollectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        [collectionView beginLoadingAnimation:header];
        return header;
    }else {
        UICollectionReusableView *header = [collectionView t_collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        [collectionView stopLoadingAnimation:header];
        return header;
    }
}

- (void)startLoading {
    if ([self.dataSource conformsToProtocol:@protocol(UICollectionViewLoadingDelegate)]) {
        if ([self.dataSource respondsToSelector:@selector(sectionsOfloadingCollectionView:)] && [self.dataSource respondsToSelector:@selector(loadingCollectionView:numberOfItemsInSection:)] && [self.dataSource respondsToSelector:@selector(loadingCollectionView:cellForItemAtIndexPath:)]) {
            [self setLoading:YES];
            [self method_swizzing];
            [self reloadData];
        }
    }
}

- (void)stopLoading {
    if ([self.dataSource conformsToProtocol:@protocol(UICollectionViewLoadingDelegate)]) {
        if ([self.dataSource respondsToSelector:@selector(sectionsOfloadingCollectionView:)] && [self.dataSource respondsToSelector:@selector(loadingCollectionView:numberOfItemsInSection:)] && [self.dataSource respondsToSelector:@selector(loadingCollectionView:cellForItemAtIndexPath:)]) {
            [self setLoading:NO];
            [self reloadData];
        }
    }
}

- (void)setLoading:(BOOL)loading {
    objc_setAssociatedObject(self, @selector(loading), @(loading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)loading {
    return [objc_getAssociatedObject(self, @selector(loading)) boolValue];
}

- (void)beginLoadingAnimation:(__kindof UIView *)view {
    [view beginSunshineAnimation];
    for (UIView *subview in view.subviews) {
        [self beginLoadingAnimation:subview];
    }
}

- (void)stopLoadingAnimation:(__kindof UIView *)view {
    [view endSunshineAnimation];
    for (UIView *subview in view.subviews) {
        [self stopLoadingAnimation:subview];
    }
}

@end
