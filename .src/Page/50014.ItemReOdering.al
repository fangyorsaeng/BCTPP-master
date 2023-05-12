page 50014 "Item Re-Ordering"
{
    CardPageID = "Item Card";
    ApplicationArea = all;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = Item;
    SourceTableView = where(Blocked = filter(false), Type = filter(Inventory));
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; "No.")
                {
                    ApplicationArea = all;
                    CaptionClass = 'Part No.';
                }
                field(Description; Description) { ApplicationArea = all; CaptionClass = 'Part Name'; }
                field("Description 2"; "Description 2") { ApplicationArea = all; CaptionClass = 'Model'; }
                field("Item Category Code"; "Item Category Code") { ApplicationArea = all; }
                field("Base Unit of Measure"; "Base Unit of Measure") { ApplicationArea = all; Caption = 'Unit'; }
                field("Order Q"; "Order Q") { ApplicationArea = all; }
                field(Inventory; Inventory) { ApplicationArea = all; }
                field(QtyOrder; Inventory + "Qty. on PR" + "Qty. on Purch. Order") { ApplicationArea = all; Caption = 'Cal. Qty'; }
                field("Reorder Point"; "Reorder Point") { ApplicationArea = all; }
                field("Reorder Quantity"; "Reorder Quantity") { ApplicationArea = all; }
                field("Safety Stock Quantity"; "Safety Stock Quantity") { ApplicationArea = all; }
                field("Lead Time Calculation"; "Lead Time Calculation") { ApplicationArea = all; Caption = 'Lead Time'; }
                field("Unit Cost"; "Unit Cost") { ApplicationArea = all; }
                field(Vendor; Vendor) { ApplicationArea = all; }
                field(Maker; Maker) { ApplicationArea = all; }
                field("Ref. Quotation"; "Ref. Quotation") { ApplicationArea = all; }
                field("Group PD"; "Group PD") { ApplicationArea = all; }
                field(Classification; Classification) { ApplicationArea = all; }
                field(Location; Location) { ApplicationArea = all; }
                field("Qty. on Purch. Order"; "Qty. on Purch. Order") { ApplicationArea = all; }
                field("Qty. on PR"; "Qty. on PR") { ApplicationArea = all; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Calculate)
            {
                Caption = 'Calculate Order';
                ApplicationArea = all;
                Image = Calculate;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    if Confirm('Calculate Re-Order Point?') then begin
                        calOrder();
                        CurrPage.Update(false);
                    end;

                end;
            }
            action(getToLine)
            {
                Caption = 'Get to Line';
                ApplicationArea = all;
                Image = Card;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ItemS2: Record Item;
                    RS: Integer;
                begin
                    RS := 0;
                    ItemS2.Reset();
                    if DocHeader <> '' then begin
                        CurrPage.SetSelectionFilter(ItemS2);
                        if ItemS2.Find('-') then begin
                            repeat
                                CopyToPR(ItemS2."No.", ItemS2."Order Q");
                            until ItemS2.Next = 0;
                        end;
                    end;
                    CurrPage.Close();
                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        SetFilter("Location Filter", '<>%1', 'NG');
        SetRange("Reordering Policy", "Reordering Policy"::"Fixed Reorder Qty.");
        CalcFields(Vendor);
        //CalcFields("Qty. on Purch. Order");
        //CalcFields("Qty. on PR");
        //CalcFields(Inventory);

    end;

    trigger OnInit()
    begin
        //CalOrder();
    end;

    trigger OnOpenPage()
    begin
        calOrder();
        SetFilter("Order Q", '>%1', 0);
    end;

    trigger OnClosePage()
    var
        ItemS2: Record Item;
        RS: Integer;
    begin

    end;

    var
        utility: Codeunit Utility;
        ItemS: Record Item;
        DocHeader: Code[30];

    procedure calOrder()
    var
        OrderQ: Decimal;
        QtySM: Decimal;
    begin
        ItemS.Reset();
        ItemS.SetRange(Blocked, false);
        ItemS.SetRange("Purchasing Blocked", false);
        ItemS.SetRange("Reordering Policy", ItemS."Reordering Policy"::"Fixed Reorder Qty.");
        ItemS.SetFilter("Reorder Point", '>%1', 0);
        ItemS.SetFilter("Location Filter", '<>%1', 'NG');
        if ItemS.find('-') then begin
            repeat
                OrderQ := 0;
                ItemS.CalcFields(Inventory);
                ItemS.CalcFields("Qty. on PR");
                ItemS.CalcFields("Qty. on Purch. Order");

                QtySM := (ItemS.Inventory + ItemS."Qty. on PR" + ItemS."Qty. on Purch. Order") - ItemS."Safety Stock Quantity";
                if (QtySM <= ItemS."Reorder Point") then begin
                    OrderQ := ItemS."Reorder Quantity";
                    if (OrderQ > 0) and (ItemS."Minimum Order Quantity" > OrderQ) then
                        OrderQ := ItemS."Minimum Order Quantity";
                end;
                // if (QtySM <= ItemS."Safety Stock Quantity") and ("Safety Stock Quantity" > 0) then begin
                //     OrderQ := ItemS."Safety Stock Quantity";
                //     if (OrderQ > 0) and (ItemS."Minimum Order Quantity" > OrderQ) then
                //         OrderQ := ItemS."Minimum Order Quantity";
                // end;
                ///////////////////////
                ItemS."Order Q" := OrderQ;
                ItemS.Modify(false);
            ///////////////////////
            until ItemS.Next = 0;
        end;

    end;

    procedure Setdoc(Docx: Code[20])
    begin
        DocHeader := Docx;
    end;

    procedure CopyToPR(CodeNo: Code[20]; Qty: Decimal)
    var
        POLine: Record "Purchase Line";
        PRLine: Record "Purchase Line";
        POHD: Record "Purchase Header";
        rows1: Integer;
        VendorS: Record Vendor;

    begin
        if DocHeader = '' then
            exit;
        rows1 := 0;
        POLine.Reset();
        POLine.SetRange("Document No.", DocHeader);
        POLine.SetRange("Document Type", POLine."Document Type"::Quote);
        if POLine.FindLast() then
            rows1 := POLine."Line No.";

        POHD.Reset();
        POHD.SetRange("No.", DocHeader);
        POHD.SetRange("Document Type", POHD."Document Type"::Quote);
        POHD.SetRange(Status, POHD.Status::Open);
        if POHD.Find('-') then begin
            ItemS.Reset();
            ItemS.Get(CodeNo);
            PRLine.Reset();
            PRLine.SetRange("Document Type", PRLine."Document Type"::Quote);
            PRLine.SetRange("Document No.", DocHeader);
            PRLine.SetRange("No.", CodeNo);
            if NOT PRLine.Find('-') then begin
                //  repeat
                rows1 := rows1 + 10000;
                POLine.Init;
                POLine."Document No." := DocHeader;
                POLine."Line No." := rows1;
                POLine."Document Type" := POLine."Document Type"::Quote;
                POLine.Type := POLine.Type::Item;
                POLine.Validate("No.", ItemS."No.");
                POLine.Validate("Unit of Measure Code", ItemS."Base Unit of Measure");
                POLine.Validate(Quantity, Qty);
                POLine.Validate("Location Code", ItemS.Location);
                if POLine."Direct Unit Cost" = 0 then
                    POLine.Validate("Direct Unit Cost", ItemS."Unit Cost");
                // POLine."Expected Receipt Date" := PRLine."Expected Receipt Date";
                // POLine."Quote Line" := PRLine."Line No.";
                //  POLine."Quote No." := PRLine."Document No.";
                //  POLine.Description := PRLine.Description;
                POLine."Description 2" := ItemS."Description 2";
                POLine."Ref Quote No." := ItemS."Ref. Quotation";
                VendorS.Reset();
                VendorS.SetRange("No.", ItemS."Vendor No.");
                if VendorS.Find('-') then
                    POLine."Supplier Name" := VendorS."Search Name";
                POLine.Maker := ItemS.Maker;
                POLine.LeadTime := ItemS."Lead Time";
                POLine."PO Status" := POLine."PO Status"::Open;
                POLine."Create Date" := CurrentDateTime;
                POLine."Create By" := utility.UserFullName(UserId);
                POLine.Classification := ItemS.Classification;
                POLine.Insert(true);
                // until PRLine.Next = 0;
            end;
        end;

    end;
}