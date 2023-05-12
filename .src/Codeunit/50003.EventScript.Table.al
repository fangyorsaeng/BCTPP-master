codeunit 50003 "Event Script T"
{
    trigger OnRun()
    begin

    end;

    var
        CK: Integer;
        utility: Codeunit Utility;

    [EventSubscriber(ObjectType::Table, DataBase::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', true, true)]
    local procedure "T1_OnBeforeInsertToPurchLine"
    (
        var SalesHeader: Record "Sales Header";
        SellToCustomer: Record Customer;
        CurrentFieldNo: Integer;
        var SkipBillToContact: Boolean
    )
    begin
        SalesHeader."Address 3" := SellToCustomer."Address 3";
        SalesHeader."Phone No." := SellToCustomer."Phone No.";
        SalesHeader."Fax No." := SellToCustomer."Fax No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeTestNoItemLedgEntiesExist', '', true, true)]
    local procedure "F2_OnBeforeTestNoItemLedgEntiesExist"
       (
       Item: Record Item;
       CurrentFieldName: Text[100];
       var IsHandled: Boolean
       )
    var
        InvSetoup: Record "Inventory Setup";
    begin

        InvSetoup.Reset();
        if InvSetoup.Find('-') then begin
            if InvSetoup."Skip Check Tracking" then begin
                IsHandled := true;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeTestNoPurchLinesExist', '', true, true)]
    local procedure "F3_OnBeforeTestNoPurchLinesExist"
    (
    Item: Record Item;
    CurrentFieldName: Text[100];
    var IsHandled: Boolean
    )
    var
        InvSetoup: Record "Inventory Setup";
    begin

        InvSetoup.Reset();
        if InvSetoup.Find('-') then begin
            if InvSetoup."Skip Check Tracking" then begin
                IsHandled := true;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeTestNoWhseEntriesExist', '', true, true)]
    local procedure "F4_OnBeforeTestNoWhseEntriesExist"
   (
        Item: Record Item;
        CurrentFieldName: Text;
        var IsHandled: Boolean
   )
    var
        InvSetoup: Record "Inventory Setup";
    begin

        InvSetoup.Reset();
        if InvSetoup.Find('-') then begin
            if InvSetoup."Skip Check Tracking" then begin
                IsHandled := true;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeTestNoOpenDocumentsWithTrackingExist', '', true, true)]
    local procedure "F5_OnBeforeTestNoOpenDocumentsWithTrackingExist"
    (
        Item: Record Item;
        ItemTrackingCode2: Record "Item Tracking Code";
        var IsHandled: Boolean
    )
    var
        InvSetoup: Record "Inventory Setup";
    begin

        InvSetoup.Reset();
        if InvSetoup.Find('-') then begin
            if InvSetoup."Skip Check Tracking" then begin
                IsHandled := true;
            end;
        end;
    end;



}