page 50004 "Receipt Lists"
{
    SourceTable = "Purch. Rcpt. Line";
    ApplicationArea = all;
    UsageCategory = Lists;
    PageType = List;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    RefreshOnActivate = true;
    ShowFilter = true;
    SourceTableView = where(Quantity = filter(> 0));
    layout
    {

        area(Content)
        {

            repeater(Control1)
            {
                field("Posting Date"; "Posting Date") { ApplicationArea = all; Caption = 'Receipt Date.'; }
                field("Document No."; "Document No.") { ApplicationArea = all; Caption = 'Receipt No.'; }
                field("Order No."; "Order No.") { ApplicationArea = all; Caption = 'PO No.'; }
                field("Invoice No"; "Invoice No") { ApplicationArea = all; }
                field("Invoice Date"; "Invoice Date") { ApplicationArea = all; }
                field("Order Line No."; "Order Line No.") { ApplicationArea = all; Caption = 'PO Line No.'; }
                field("No."; "No.") { ApplicationArea = all; CaptionClass = 'Part No.'; }
                field(Description; Description) { ApplicationArea = all; CaptionClass = 'Part Name'; }
                field("Location Code"; "Location Code") { ApplicationArea = all; }
                field(Quantity; Quantity) { ApplicationArea = all; }
                field("Unit of Measure Code"; "Unit of Measure Code") { ApplicationArea = all; }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group") { ApplicationArea = all; }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group") { ApplicationArea = all; }
                field("Buy-from Vendor No."; "Buy-from Vendor No.") { ApplicationArea = all; Caption = 'Vendor No.'; }
                field("Create By"; "Create By") { ApplicationArea = all; }
                field("Create Date"; "Create Date") { ApplicationArea = all; }
                field(Grade; Grade) { ApplicationArea = all; }
                field(Size; Size) { ApplicationArea = all; }
                field(Heat; Heat) { ApplicationArea = all; }
                field(Inspection; Inspection) { ApplicationArea = all; }
                field("PO Status"; "PO Status") { ApplicationArea = all; }
                field("Ref. Whse No."; "Ref. Whse No.") { ApplicationArea = all; }
            }
        }
    }
    actions
    {

    }
    trigger OnInit()
    begin
        RCDate := CalcDate('<-CM-1M>', Today);

    end;

    trigger OnOpenPage()
    begin
        SetFilter("Posting Date", '%1..', RCDate);
    end;

    trigger OnAfterGetRecord()
    begin

    end;

    var
        RCDate: Date;


}