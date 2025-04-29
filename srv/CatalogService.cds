using { anubhav.db.master, anubhav.db.transaction } from '../db/datamodel';
using { cappo.cds.CDSViews } from '../db/CDSViews';

service CatalogService @(path:'CatalogService', requires: 'authenticated-user') {

    //@readonly
    entity EmployeeSet @(restrict:[
        {grant: ['READ'], to: 'Viewer', where: 'bankName = $user.BankName'},
        {grant: ['WRITE'], to: 'Admin'}
    ])    
    as projection on master.employees;
    entity AddressSet as projection on master.address;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity ProductSet as projection on master.product;
    entity POs @(
        odata.draft.enabled: true
     ) as projection on transaction.purchaseorder{
        *,
        case OVERALL_STATUS
            when 'P' then 'Pending'
            when 'D' then 'Delivered'
            when 'A' then 'Approved'
            when 'X' then 'Rejected'
                end as OverallStatus : String(10),
        case OVERALL_STATUS
            when 'P' then 2
            when 'D' then 2
            when 'A' then 3
            when 'X' then 1
                end as IconColor : Integer
    }
    actions{
        action boost() returns POs
    };
    entity POItems as projection on transaction.poitems;

    function getLargestOrder() returns POs;
}
