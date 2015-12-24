//
// Created by xialeistudio on 15/12/22.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "ContactUtil.h"
#import "DeviceUtil.h"


@implementation ContactUtil {

}
+ (BOOL)isExists:(NSString *)name {
    if ([DeviceUtil getSystemVersion] >= 9.0) {
        CNContactStore *store = [[CNContactStore alloc] init];
        NSArray *contacts = [store unifiedContactsMatchingPredicate:[CNContact predicateForContactsMatchingName:name] keysToFetch:@[[CNContactViewController descriptorForRequiredKeys]] error:nil];
        return contacts.count > 0;
    } else {
        ABAddressBookRef addressBook = nil;
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        CFArrayRef records;
        if (addressBook) {
            records = ABAddressBookCopyArrayOfAllPeople(addressBook);
        } else {
#ifdef DEBUG
            NSLog(@"can not connect to address book");
#endif
            return YES;
        }
        for (int i = 0; i < CFArrayGetCount(records); i++) {
            ABRecordRef record = CFArrayGetValueAtIndex(records, i);
            CFStringRef cfString = ABRecordCopyValue(record, kABPersonFirstNameProperty);
            if ([(__bridge NSString *) cfString isEqualToString:name]) {
                return YES;
            }
        }
        return NO;
    }
}

+ (BOOL)saveContact:(UIViewController *)viewController delegate:(id <CNContactViewControllerDelegate>)delegate realname:(NSString *)realname phone:(NSString *)phone company:(NSString *)company position:(NSString *)position avatar:(NSString *)avatar {
    if ([DeviceUtil getSystemVersion] >= 9.0) {
        CNMutableContact *mutableContact = [[CNMutableContact alloc] init];
        mutableContact.givenName = realname;
        if (company) {
            mutableContact.organizationName = company;
        }
        if (position) {
            mutableContact.jobTitle = position;
        }
        if (avatar) {
            mutableContact.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:avatar]];
        }
        CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:phone]];
        mutableContact.phoneNumbers = @[phoneNumber];

        CNContactViewController *contactViewController = [CNContactViewController viewControllerForNewContact:mutableContact];
        contactViewController.delegate = delegate;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contactViewController];
        [viewController presentViewController:navigationController animated:YES completion:nil];
        return NO;
    } else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

        // 创建一条空的联系人
        ABRecordRef recordRef = ABPersonCreate();
        ABRecordSetValue(recordRef, kABPersonFirstNameProperty, (__bridge CFTypeRef) realname, NULL);
        ABRecordSetValue(recordRef, kABPersonJobTitleProperty, (__bridge CFTypeRef) position, NULL);
        ABRecordSetValue(recordRef, kABPersonOrganizationProperty, (__bridge CFTypeRef) company, NULL);
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:avatar]];
        ABPersonSetImageData(recordRef, (__bridge CFDataRef) imageData, NULL);

        ABMutableMultiValueRef multiValueRef = ABMultiValueCreateMutable(kABStringPropertyType);//添加设置多值属性
        ABMultiValueAddValueAndLabel(multiValueRef, (__bridge CFStringRef) (phone), kABWorkLabel, NULL);//添加工作电话
        ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);

        //添加记录
        ABAddressBookAddRecord(addressBook, recordRef, NULL);

        //保存通讯录，提交更改
        BOOL result = ABAddressBookSave(addressBook, NULL);
        //释放资源
        CFRelease(recordRef);
        CFRelease(multiValueRef);
        return result;
    }
}


@end