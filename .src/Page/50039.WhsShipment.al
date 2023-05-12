page 50039 "Whs. Sales Order List"
{
    ApplicationArea = all;
    Caption = 'Whs. Sales Order List';
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    // PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Order,Release,Posting,Navigate';
    QueryCategory = 'Whs. Sales Order List';
    RefreshOnActivate = true;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = CONST(Order), "Outstanding Qty. (Base)" = filter(> 0));
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                showCaption = false;
                field(rNo; rNo) { ApplicationArea = all; Caption = 'Row No.'; Editable = false; }
                field("Document No."; "Document No.") { ApplicationArea = all; Editable = false; StyleExpr = Stry2; Style = Favorable; }
                field("Planned Delivery Date"; "Planned Delivery Date") { ApplicationArea = all; }
                field("No."; "No.") { ApplicationArea = all; Editable = false; CaptionClass = 'Part No.'; }
                field(Description; Description) { ApplicationArea = all; Editable = false; CaptionClass = 'Part Name'; }
                field("Short Name"; "Short Name") { ApplicationArea = all; }
                field("Unit of Measure Code"; "Unit of Measure Code") { ApplicationArea = all; Editable = false; }
                field(Quantity; Quantity) { ApplicationArea = all; Editable = false; }
                field("Outstanding Quantity"; "Outstanding Quantity") { ApplicationArea = all; Editable = false; }
                field("Qty. Shipped (Base)"; "Qty. Shipped (Base)") { ApplicationArea = all; Editable = false; }
                field("Unit Cost"; "Unit Cost") { ApplicationArea = all; Editable = false; }
                field(Amount; Amount) { ApplicationArea = all; Editable = false; }
                field("Sell-to Customer No."; "Sell-to Customer No.") { ApplicationArea = all; }

                //    field("Amount Including VAT"; "Amount Including VAT") { ApplicationArea = all; Editable = false; }
                field("Location Code"; "Location Code") { ApplicationArea = all; Editable = false; }
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
        CalcFields("Short Name");
    end;

    var
        rNo: Integer;
        Stry: Boolean;
        Stry2: Boolean;
        DocNo: Code[20];
        CustS: Record Customer;

    procedure setDocNo(Codex: Code[20])
    begin
        DocNo := Codex;
    end;

}