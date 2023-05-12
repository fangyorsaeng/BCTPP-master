codeunit 50001 "Event Script C"
{
    trigger OnRun()
    begin

    end;

    var
        CK: Integer;
        utility: Codeunit Utility;
    ///Report//
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::"Customer - Top 10 List" then
            NewReportId := Report::"Customer - Top 10 List";
    end;

    ///Page//
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', false, false)]
    local procedure OnAfterGetPageID(RecordRef: RecordRef; var PageID: Integer)
    begin

    end;


    //
    ///Event 1////
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Whse.-Post Receipt + Pr. Pos.", 'OnBeforeCode', '', true, true)]
    local procedure "C1_OnBeforeCode"
       (
           var WarehouseReceiptLine: Record "Warehouse Receipt Line";
           var IsHandled: Boolean
       )
    var
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";

    begin
        // IsHandled := true;
        // with WarehouseReceiptLine do begin
        //     //Check Lot//
        //     if utility.CheckUseLogReceipt(WarehouseReceiptLine) then begin
        //         WhsePostReceipt.Run(WarehouseReceiptLine);
        //         Message('Posted Completed.');
        //     end;

        // end;

    end;

    ///Event 1////
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Whse.-Post Receipt (Yes/No)", 'OnBeforeConfirmWhseReceiptPost', '', true, true)]
    local procedure "C2_OnBeforeConfirmWhseReceiptPost"
       (
        var WhseReceiptLine: Record "Warehouse Receipt Line";
        var HideDialog: Boolean;
        var IsPosted: Boolean
       )
    var
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        Text000: Label 'Do you want to post the receipt?';
        whseRecipt: Record "Warehouse Receipt Header";
    begin

        IsPosted := true;
        // HideDialog := true;
        // if not Confirm(Text000, false) then
        //    exit;
        with WhseReceiptLine do begin
            //Check Lot//
            if utility.CheckUseLogReceipt(WhseReceiptLine) then begin

                WhsePostReceipt.Run(WhseReceiptLine);
                Clear(WhsePostReceipt);
                //exit;
                // Message('Posted Completed.');
                // whseRecipt.Reset();
                // whseRecipt.SetRange("No.", WhseReceiptLine."No.");
                // if whseRecipt.Find('-') then begin
                //     whseRecipt.Delete(true);
                // end;
            end;

        end;


    end;
    //////////////
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Purch.-Post", 'OnBeforePurchRcptHeaderInsert', '', true, true)]
    local procedure "C3_OnBeforePurchRcptHeaderInsert"
   (
    var PurchRcptHeader: Record "Purch. Rcpt. Header";
    var PurchaseHeader: Record "Purchase Header";
    CommitIsSupressed: Boolean;
    WarehouseReceiptHeader: Record "Warehouse Receipt Header";
    WhseReceive: Boolean;
    WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    WhseShip: Boolean
   )
    var

    begin
        with PurchRcptHeader do begin
            PurchRcptHeader."Invoice Date" := WarehouseReceiptHeader."Invoice Date";
            PurchRcptHeader."Invoice No" := WarehouseReceiptHeader."Invoice No";
            PurchRcptHeader."Create By" := utility.UserFullName("User ID");
            PurchRcptHeader."Create Date" := CurrentDateTime;
        end;

    end;
    // OnInsertReceiptLineOnAfterInitPurchRcptLine
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Purch.-Post", 'OnInsertReceiptLineOnAfterInitPurchRcptLine', '', true, true)]
    local procedure "C4_OnInsertReceiptLineOnAfterInitPurchRcptLine"
        (
        var PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchLine: Record "Purchase Line";
        ItemLedgShptEntryNo: Integer;
        xPurchLine: Record "Purchase Line";
        var PurchRcptHeader: Record "Purch. Rcpt. Header";
        var CostBaseAmount: Decimal;
        PostedWhseRcptHeader: Record "Posted Whse. Receipt Header";
        WhseRcptHeader: Record "Warehouse Receipt Header";
        var WhseRcptLine: Record "Warehouse Receipt Line"
        )
    var
        POHD: Record "Purchase Header";
        WhseRcptLine2: Record "Warehouse Receipt Line";

    begin
        with PurchRcptLine do begin
            PurchRcptLine."Invoice Date" := WhseRcptHeader."Invoice Date";
            PurchRcptLine."Invoice No" := WhseRcptHeader."Invoice No";
            PurchRcptLine."Create By" := WhseRcptHeader."Create By";
            PurchRcptLine."Create Date" := WhseRcptHeader."Create Date";
            PurchRcptLine."Ref. Whse No." := WhseRcptHeader."No.";
            PurchRcptLine."PO Status" := PurchLine."PO Status";

            WhseRcptLine2.Reset();
            WhseRcptLine2.SetRange("No.", WhseRcptHeader."No.");
            WhseRcptLine2.SetRange("Source No.", PurchLine."Document No.");
            WhseRcptLine2.SetRange("Source Line No.", PurchLine."Line No.");
            if WhseRcptLine2.Find('-') then begin
                PurchRcptLine.Grade := WhseRcptLine2.Grade;
                PurchRcptLine.Size := WhseRcptLine2.Size;
                PurchRcptLine.Heat := WhseRcptLine2.Heat;
                PurchRcptLine.Inspection := WhseRcptLine2.Inspection;
            end;

        end;

    end;
    //OnAfterPurchRcptLineInsert
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', true, true)]
    local procedure "C5_OnAfterPurchRcptLineInsert"
    (
        PurchaseLine: Record "Purchase Line";
        var PurchRcptLine: Record "Purch. Rcpt. Line";
        ItemLedgShptEntryNo: Integer;
        WhseShip: Boolean; WhseReceive: Boolean;
        CommitIsSupressed: Boolean;
        PurchInvHeader: Record "Purch. Inv. Header";
        var TempTrackingSpecification: Record "Tracking Specification" temporary;
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        TempWhseRcptHeader: Record "Warehouse Receipt Header";
        xPurchLine: Record "Purchase Line"
    )
    var
        PurLine: Record "Purchase Line";
    begin
        // PurLine.Reset();
        // PurLine.SetRange("Document No.", xPurchLine."Document No.");
        // PurLine.SetRange("Line No.", xPurchLine."Line No.");
        // PurLine.SetRange("Document Type", xPurchLine."Document Type");
        // if PurLine.Find('-') then begin
        //     PurLine."Invoice No" := PurchRcptHeader."Invoice No";// PurchRcptLine."Invoice No";
        //     PurLine."Invoice Date" := PurchRcptHeader."Invoice Date";//
        //     PurLine.Modify();
        // end;
    end;
    //OnCopyPurchDocPurchLineOnAfterSetFilters
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Copy Document Mgt.", 'OnCopyPurchDocPurchLineOnAfterSetFilters', '', true, true)]
    local procedure "C6_OnCopyPurchDocPurchLineOnAfterSetFilters"
    (
        FromPurchHeader: Record "Purchase Header";
        var FromPurchLine: Record "Purchase Line";
        var ToPurchHeader: Record "Purchase Header";
        var RecalculateLines: Boolean
    )
    var
        PurLine: Record "Purchase Line";
    begin

        FromPurchLine.CalcFields("PO No.");
        FromPurchLine.SetFilter("PO Status", '%1', FromPurchLine."PO Status"::Open);
        FromPurchLine.SetFilter("PO No.", '%1', '');
        if FromPurchHeader.Status <> FromPurchHeader.Status::Released then begin
            FromPurchLine.SetRange("Line No.", 0);
        end;

    end;
    //OnBeforeInsertToPurchLine
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Copy Document Mgt.", 'OnBeforeInsertToPurchLine', '', true, true)]
    local procedure "C7_OnBeforeInsertToPurchLine"
        (
            var ToPurchLine: Record "Purchase Line";
            FromPurchLine: Record "Purchase Line";
            FromDocType: Option; RecalcLines: Boolean;
            var ToPurchHeader: Record "Purchase Header";
            DocLineNo: Integer; var NexLineNo: Integer
        )
    var
        PurLine: Record "Purchase Line";
    begin
        ToPurchLine."Quote No." := FromPurchLine."Document No.";
        ToPurchLine."Quote Line" := FromPurchLine."Line No.";
        ToPurchLine.LeadTime := FromPurchLine.LeadTime;
        ToPurchLine.Maker := FromPurchLine.Maker;

        // ToPurchLine."PO Date" := CurrentDateTime;
        // ToPurchLine."PO By" := utility.UserFullName(UserId);
    end;

    ///Page//
    //OnBeforeInsertToPurchLine
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Assembly Line Management", 'OnAfterTransferBOMComponent', '', true, true)]
    local procedure "C8_OnAfterTransferBOMComponent"
        (
           var AssemblyLine: Record "Assembly Line";
           BOMComponent: Record "BOM Component";
           AssemblyHeader: Record "Assembly Header"
        )
    var
        ItemS: Record Item;
    begin
        ItemS.Reset();
        ItemS.SetRange("No.", AssemblyLine."No.");
        // ItemS.SetFilter(Location, '%1', AssemblyLine."Location Code");
        if ItemS.Find('-') then begin
            AssemblyLine.Validate("Location Code", ItemS.Location);
        end;
    end;

    //OnBeforeInsertToPurchLine
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', true, true)]
    local procedure "C9_OnBeforeInsertItemLedgEntry"
        (
        var ItemLedgerEntry: Record "Item Ledger Entry";
        ItemJournalLine: Record "Item Journal Line";
        TransferItem: Boolean;
        OldItemLedgEntry: Record "Item Ledger Entry";
        ItemJournalLineOrigin: Record "Item Journal Line"
        )
    var
        cust: Code[30];
    begin
        ItemLedgerEntry.Customer := ItemJournalLine.Customer;
        cust := ItemJournalLineOrigin.Customer;
        //Error('Cust1');
    end;


}