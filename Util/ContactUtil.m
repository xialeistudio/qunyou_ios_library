//
// Created by xialeistudio on 15/12/22.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import "ContactUtil.h"


@implementation ContactUtil {

}
+ (BOOL)isExists:(NSString *)name {
    CNContactStore *store = [[CNContactStore alloc] init];
    NSArray *contacts = [store unifiedContactsMatchingPredicate:[CNContact predicateForContactsMatchingName:name] keysToFetch:@[[CNContactViewController descriptorForRequiredKeys]] error:nil];
    return contacts.count > 0;
}

+ (void)saveContact:(UIViewController *)viewController delegate:(id <CNContactViewControllerDelegate>)delegate realname:(NSString *)realname phone:(NSString *)phone company:(NSString *)company position:(NSString *)position avatar:(NSString *)avatar {
    CNMutableContact *mutableContact = [[CNMutableContact alloc] init];

    mutableContact.givenName = realname;
    if(company){
        mutableContact.organizationName = company;
    }
    if(position){
        mutableContact.jobTitle = position;
    }
    if(avatar){
        mutableContact.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:avatar]];
    }
    CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:phone]];
    mutableContact.phoneNumbers = @[phoneNumber];

    CNContactViewController *contactViewController = [CNContactViewController viewControllerForNewContact:mutableContact];
    contactViewController.delegate = delegate;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contactViewController];
    [viewController presentViewController:navigationController animated:YES completion:nil];
}


@end