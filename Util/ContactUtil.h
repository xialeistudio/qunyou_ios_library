//
// Created by xialeistudio on 15/12/22.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/CNContactViewController.h>

@interface ContactUtil : NSObject <CNContactViewControllerDelegate>

/**
 * 联系人是否存在
 */
+ (BOOL)isExists:(NSString *)name;

/**
 * 保存联系人
 */
+ (BOOL)saveContact:(UIViewController *)viewController
           delegate:(id <CNContactViewControllerDelegate>)delegate
           realname:(NSString *)realname
              phone:(NSString *)phone
            company:(NSString *)company
           position:(NSString *)position
             avatar:(NSString *)avatar;
@end