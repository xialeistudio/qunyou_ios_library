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
        ABAddressBookRef addressBook = ABAddressBookCreate();
//等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        CFArrayRef searchedPerson = ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef) name);
        NSArray *array = (__bridge NSArray *) searchedPerson;
        CFRelease(searchedPerson);
        return array.count > 0;
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
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABRecordRef record = ABPersonCreate();
        ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef) realname, NULL);
        ABRecordSetValue(record, kABPersonJobTitleProperty, (__bridge CFTypeRef) position, NULL);
        ABRecordSetValue(record, kABPersonOrganizationProperty, (__bridge CFTypeRef) company, NULL);
        //手机号码
        ABMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFTypeRef) phone, kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(record, kABPersonPhoneProperty, phoneNumbers, NULL);
        //头像
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:avatar]];
        ABPersonSetImageData(record, (__bridge CFDataRef) imageData, NULL);

        BOOL result = ABAddressBookAddRecord(addressBook, record, NULL);
        //释放对象
        CFRelease(record);
        CFRelease(addressBook);
        CFRelease(phoneNumbers);

        return result;
    }
}


@end