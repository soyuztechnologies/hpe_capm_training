namespace anubhav.db;

using { cuid, managed, temporal, Currency } from '@sap/cds/common';
using { anubhav.common } from './commons';

context master {
    
    entity businesspartner {
        key NODE_KEY: common.Guid @(title : '{i18n>PARTNER_KEY}');
        BP_ROLE: String(2);
        EMAIL_ADDRESS: String(105);
        PHONE_NUMBER: String(32);
        FAX_NUMBER: String(32);
        WEB_ADDRESS: String(44);
        ADDRESS_GUID: Association to address;
        BP_ID: String(32) @(title : 'BP id');
        COMPANY_NAME: String(250) @(title : '{i18n>CO_NAME}');
    }

    entity address {
        key NODE_KEY: common.Guid;
        CITY: String(44);
        POSTAL_CODE: String(8);
        STREET: String(44);
        BUILDING: String(128);
        COUNTRY: String(44) @(title : '{i18n>COUNTRY}');
        ADDRESS_TYPE: String(44);
        VAL_START_DATE: Date;
        VAL_END_DATE: Date;
        LATITUDE: Decimal;
        LONGITUDE: Decimal;
        businesspartner: Association to one businesspartner on
        businesspartner.ADDRESS_GUID = $self;
    }

    entity product{
        key NODE_KEY: common.Guid @(title : '{i18n>PRODUCT_KEY}');
        PRODUCT_ID: String(28) @(title : '{i18n>PROD_ID}');
        TYPE_CODE: String(2);
        CATEGORY: String(32) @(title : '{i18n>CATEGORY}');
        DESCRIPTION: localized String(255);
        SUPPLIER_GUID: Association to master.businesspartner;
        TAX_TARIF_CODE: Integer;
        MEASURE_UNIT: String(2);
        WEIGHT_MEASURE: Decimal(5,2);
        WEIGHT_UNIT: String(2);
        CURRENCY_CODE: String(4);
        PRICE:Decimal(15,2);
        WIDTH:Decimal(5,2);
        DEPTH:Decimal(5,2);
        HEIGHT:Decimal(5,2);
        DIM_UNIT:String(2);
    }

    entity employees: cuid {
        nameFirst: String(40);
        nameMiddle: String(40);
        nameLast: String(40);
        nameInitials: String(40);
        sex: common.Gender;
        language: String(1);
        phoneNumber: common.PhoneNumber;
        email: common.Email;
        loginName: String(12);
        Currency: Currency;
        salaryAmount: common.AmountT;
        accountNumber: String(16);
        bankId: String(40);
        bankName: String(64);
    }
}

context transaction {
    entity purchaseorder: common.Amount, cuid{
        //key NODE_KEY: common.Guid @(title : '{i18n>PO_KEY}');
        PO_ID: String(40) @(title : '{i18n>PO_ID}');
        PARTNER_GUID: Association to master.businesspartner@(title : '{i18n>PARTNER_KEY}');
        LIFECYCLE_STATUS: String(1) @(title : '{i18n>STATUS}');
        OVERALL_STATUS: String(1) @(title : '{i18n>STATUS}');
        Items: Composition of many poitems on Items.PARENT_KEY = $self;
    }

    entity poitems: common.Amount, cuid{
        //key NODE_KEY: common.Guid @(title : '{i18n>PO_ITEM_KEY}');
        PARENT_KEY: Association to purchaseorder;
        PO_ITEM_POS: Integer @(title : '{i18n>ITEM_POS}');
        PRODUCT_GUID: Association to master.product @(title : '{i18n>PRODUCT_KEY}');
    }
}

