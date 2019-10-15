//
//  UITableView+Loading.m
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/14.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "UITableView+Loading.h"
#import "UIView+Sunshine.h"

@implementation UITableView (Loading)

- (void)method_swizzing {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            Method num_section = class_getInstanceMethod(self.dataSource.class, @selector(numberOfSectionsInTableView:));
            Method num_section_replace = class_getInstanceMethod(self.class, @selector(t_numberOfSectionsInTableView:));
            BOOL didAddMethod = class_addMethod(self.dataSource.class, @selector(numberOfSectionsInTableView:), method_getImplementation(num_section_replace), method_getTypeEncoding(num_section_replace));
            if (didAddMethod) {
                class_replaceMethod(self.dataSource.class, @selector(t_numberOfSectionsInTableView:),
                                    method_getImplementation(num_section),
                                    method_getTypeEncoding(num_section));
            } else {
                method_exchangeImplementations(num_section, num_section_replace);
            }
        }
        if ([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            Method num_row = class_getInstanceMethod(self.dataSource.class, @selector(tableView:numberOfRowsInSection:));
            Method num_row_replace = class_getInstanceMethod(self.class, @selector(t_tableView:numberOfRowsInSection:));
            BOOL didAddMethod = class_addMethod(self.dataSource.class, @selector(tableView:numberOfRowsInSection:), method_getImplementation(num_row_replace), method_getTypeEncoding(num_row_replace));
            if (didAddMethod) {
                class_replaceMethod(self.dataSource.class, @selector(t_tableView:numberOfRowsInSection:),
                                    method_getImplementation(num_row),
                                    method_getTypeEncoding(num_row));
            } else {
                method_exchangeImplementations(num_row, num_row_replace);
            }
        }
        
        if ([self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
            Method cell = class_getInstanceMethod(self.dataSource.class, @selector(tableView:cellForRowAtIndexPath:));
            Method cell_replace = class_getInstanceMethod(self.class, @selector(t_tableView:cellForRowAtIndexPath:));
            BOOL didAddMethod = class_addMethod(self.dataSource.class, @selector(tableView:cellForRowAtIndexPath:), method_getImplementation(cell_replace), method_getTypeEncoding(cell_replace));
            if (didAddMethod) {
                class_replaceMethod(self.dataSource.class, @selector(t_tableView:cellForRowAtIndexPath:),
                                    method_getImplementation(cell),
                                    method_getTypeEncoding(cell));
            } else {
                method_exchangeImplementations(cell, cell_replace);
            }
        }
        
        if ([self.dataSource respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
            Method header = class_getInstanceMethod(self.dataSource.class, @selector(tableView:viewForHeaderInSection:));
            Method header_replace = class_getInstanceMethod(self.class, @selector(t_tableView:viewForHeaderInSection:));
            BOOL didAddMethod = class_addMethod(self.dataSource.class, @selector(tableView:viewForHeaderInSection:), method_getImplementation(header_replace), method_getTypeEncoding(header_replace));
            if (didAddMethod) {
                class_replaceMethod(self.dataSource.class, @selector(t_tableView:viewForHeaderInSection:),
                                    method_getImplementation(header),
                                    method_getTypeEncoding(header));
            } else {
                method_exchangeImplementations(header, header_replace);
            }
        }
        if ([self.dataSource respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
            Method footer = class_getInstanceMethod(self.dataSource.class, @selector(tableView:viewForFooterInSection:));
            Method footer_replace = class_getInstanceMethod(self.class, @selector(t_tableView:viewForFooterInSection:));
            BOOL didAddMethod = class_addMethod(self.dataSource.class, @selector(tableView:viewForHeaderInSection:), method_getImplementation(footer_replace), method_getTypeEncoding(footer_replace));
            if (didAddMethod) {
                class_replaceMethod(self.dataSource.class, @selector(t_tableView:viewForFooterInSection:),
                                    method_getImplementation(footer),
                                    method_getTypeEncoding(footer));
            } else {
                method_exchangeImplementations(footer, footer_replace);
            }
        }
    });
    
}

- (NSInteger)t_numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView loading]) {
        id<UITableViewLoadingDelegate> load_delegate = (id<UITableViewLoadingDelegate>)self;
        return [load_delegate sectionsOfloadingTableView:tableView];
    }else {
        return [tableView t_numberOfSectionsInTableView:tableView];
    }
}

- (NSInteger)t_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView loading]) {
        id<UITableViewLoadingDelegate> load_delegate = (id<UITableViewLoadingDelegate>)self;
        return [load_delegate loadingTableView:tableView numberOfRowsInSection:section];
    }else {
        return [tableView t_tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)t_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView loading]) {
        id<UITableViewLoadingDelegate> load_delegate = (id<UITableViewLoadingDelegate>)self;
        UITableViewCell *cell = [load_delegate loadingTableView:tableView cellForRowAtIndexPath:indexPath];
        [tableView beginLoadingAnimation:cell];
        return cell;
    }else {
         UITableViewCell *cell = [tableView t_tableView:tableView cellForRowAtIndexPath:indexPath];
        [tableView stopLoadingAnimation:cell];
        return cell;
    }
}

- (UIView *)t_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView loading]) {
        id<UITableViewLoadingDelegate> load_delegate = (id<UITableViewLoadingDelegate>)self;
        UIView *header = [load_delegate loadingTableView:tableView viewForHeaderInSection:section];
        [tableView beginLoadingAnimation:header];
        return header;
    }else {
        UIView *header = [tableView t_tableView:tableView viewForHeaderInSection:section];
        [tableView stopLoadingAnimation:header];
        return header;
    }
}

- (UIView *)t_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([tableView loading]) {
        id<UITableViewLoadingDelegate> load_delegate = (id<UITableViewLoadingDelegate>)self;
        UIView *footer = [load_delegate loadingTableView:tableView viewForFooterInSection:section];
        [tableView beginLoadingAnimation:footer];
        return footer;
    }else {
        UIView *footer = [tableView t_tableView:tableView viewForFooterInSection:section];
        [tableView stopLoadingAnimation:footer];
        return footer;
    }
}

- (void)startLoading {
    if ([self.dataSource conformsToProtocol:@protocol(UITableViewLoadingDelegate)]) {
        if ([self.dataSource respondsToSelector:@selector(sectionsOfloadingTableView:)] && [self.dataSource respondsToSelector:@selector(loadingTableView:numberOfRowsInSection:)] && [self.dataSource respondsToSelector:@selector(loadingTableView:cellForRowAtIndexPath:)]) {
            [self setLoading:YES];
            [self method_swizzing];
            [self reloadData];
        }
    }
}

- (void)stopLoading {
    if ([self.dataSource conformsToProtocol:@protocol(UITableViewLoadingDelegate)]) {
        if ([self.dataSource respondsToSelector:@selector(sectionsOfloadingTableView:)] && [self.dataSource respondsToSelector:@selector(loadingTableView:numberOfRowsInSection:)] && [self.dataSource respondsToSelector:@selector(loadingTableView:cellForRowAtIndexPath:)]) {
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
