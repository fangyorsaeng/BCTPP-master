page 50000 "Purchase Line Lists"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Purchase Line List';
    CardPageID = "Purchase Order";
    DataCaptionFields = "Buy-from Vendor No.";
    Editable = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Order,Release,Posting,Navigate';
    QueryCategory = 'Purchase Order List';
    RefreshOnActivate = true;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = CONST(Order), Quantity = filter(> 0));
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                showCaption = false;

                field(rNo; rNo) { ApplicationArea = all; Caption = 'Row No.'; Editable = false; }
                field("PO Status"; "PO Status") { ApplicationArea = all; Editable = false; StyleExpr = Stry; Style = Attention; }
                field("Document No."; "Document No.") { ApplicationArea = all; Editable = false; StyleExpr = Stry2; Style = Favorable; }
                field("Document Type"; "Document Type") { ApplicationArea = all; Editable = false; }
                field("No."; "No.") { ApplicationArea = all; Editable = false; CaptionClass = 'Part No.'; }
                field(Description; Description) { ApplicationArea = all; Editable = false; CaptionClass = 'Part Name'; }
                field("Location Code"; "Location Code") { ApplicationArea = all; Editable = false; }
                field("Unit of Measure Code"; "Unit of Measure Code") { ApplicationArea = all; Editable = false; }
                field(Quantity; Quantity) { ApplicationArea = all; Editable = false; }
                field("Unit Cost"; "Unit Cost") { ApplicationArea = all; Editable = false; }
                field(Amount; Amount) { ApplicationArea = all; Editable = false; }
                field("Amount Including VAT"; "Amount Including VAT") { ApplicationArea = all; Editable = false; }
                field("Outstanding Quantity"; "Outstanding Quantity") { ApplicationArea = all; Editable = false; }
                field("Quantity Received"; "Quantity Received") { ApplicationArea = all; Editable = false; }
                field("Over-Receipt Quantity"; "Over-Receipt Quantity") { ApplicationArea = all; Editable = false; }
                field("Quote No."; "Quote No.") { ApplicationArea = all; Editable = false; }
                // field("Quote Line"; "Quote Line") { ApplicationArea = all; Editable = false; }
                field("Invoice Date"; "Invoice Date") { ApplicationArea = all; Editable = false; }
                field("Invoice No"; "Invoice No") { ApplicationArea = all; Caption = 'Invoice No.'; Editable = false; }
            }

        }

    }
    actions
    {
        area(Processing)
        {
            action(Card)
            {
                Caption = 'Card P/O';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PageP: Page "Purchase Order";
                    PurQ: Record "Purchase Header";
                begin
                    PurQ.Reset();
                    PurQ.SetRange("No.", Rec."Document No.");
                    PurQ.SetRange("Document Type", PurQ."Document Type"::Order);
                    if PurQ.Find('-') then begin
                        Clear(PageP);
                        PageP.SetTableView(PurQ);
                        PageP.Run();

                    end;
                end;
            }
        }
    }
    trigger OnInit()
    begin
        rNo := 0;
    end;

    trigger OnAfterGetRecord()
    begin
        rNo += 1;
        Stry := false;
        Stry2 := false;
        if "PO Status" = "PO Status"::Cancel then begin
            Stry := true;
        end;
        if ("Invoice No" <> '') then
            Stry2 := true;
    end;

    var
        rNo: Integer;
        Stry: Boolean;
        Stry2: Boolean;

}