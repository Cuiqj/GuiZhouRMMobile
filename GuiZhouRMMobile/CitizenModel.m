//
//  CitizenModel.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "CitizenModel.h"

@implementation CitizenModel

- (id)initWithCitizen:(Citizen *)citizen{
    self = [super init];
    if (self && citizen) {
        self.parent_id = citizen.caseinfo_id;
        self.patry_type = citizen.party_type;
        self.party = citizen.party;
        self.citizen_flag = citizen.citizen_flag;
        self.sex = citizen.sex;
        self.legal_spokesman = citizen.legal_spokesman;
        self.age = citizen.age.stringValue;
        self.nation = citizen.nation;
        self.original_home = citizen.original_home;
        self.tel_number = citizen.tel_number;
        self.postalcode = citizen.postalcode;
        self.address = citizen.address;
        self.profession = citizen.profession;
        self.duty = citizen.duty;
        self.org_name = citizen.org_name;
        self.org_address = citizen.org_address;
        self.org_tel_number = citizen.org_tel_number;
        self.org_principal = citizen.org_principal;
        self.org_principal_tel_number = citizen.org_principal_tel_number;
        self.org_principal_duty = citizen.org_principal_duty;
        self.driver = citizen.driver;
        self.automobile_pattern = citizen.automobile_pattern;
        self.automobile_number = citizen.automobile_number;
        self.automobile_address = citizen.automobile_address;
        self.automobile_owner = citizen.automobile_owner;
        self.automobile_owner_address = citizen.automobile_owner_address;
        self.automobile_owner_flag = citizen.automobile_owner_flag;
        self.nationality = citizen.nationality;
        self.identity_card = citizen.identity_card;
        self.card_no = citizen.card_no;
        self.organizer_desc = citizen.organizer_desc;
        self.remark = citizen.remark;
        self.proxyman = citizen.proxyman;
        self.proxysex = citizen.proxysex;
        self.proxyage = citizen.proxyage.stringValue;
        self.proxytel = citizen.proxytel;
        self.proxyaddress = citizen.proxyaddress;
        self.proxyunit = citizen.proxyunit;
        self.proxyidentity = citizen.proxyidentity;
        self.driver_relation = citizen.driver_relation;
        self.driver_tel = citizen.driver_tel;
        self.driver_address = citizen.driver_address;
        self.automobile_trademark = citizen.automobile_trademark;
    } else {
        return nil;
    }
    return self;
}
@end
