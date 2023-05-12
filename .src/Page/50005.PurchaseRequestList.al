page 50005 "Purchase Request List"
{

    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type" = const(Quote));
    UsageCategory = Lists;
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    RefreshOnActivate = true;
    ShowFilter = true;
    //CardPageId = "Purchase Quote";
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("PO No."; "PO No.") { ApplicationArea = all; Caption = 'PO No.'; }
                field("PO Date"; "PO Date") { ApplicationArea = all; }
                field("Supplier Name"; "Supplier Name") { ApplicationArea = all; }
                field(DocDate; DocDate) { ApplicationArea = all; Caption = 'Doc.Date'; }
                field("Document No."; "Document No.") { Caption = 'PR No.'; ApplicationArea = all; StyleExpr = Sty; Style = Attention; }
                field("No."; "No.") { CaptionClass = 'Part No.'; ApplicationArea = all; }
                field(Description; Description) { ApplicationArea = all; CaptionClass = 'Part Name'; }
                field("Description 2"; "Description 2") { ApplicationArea = all; Caption = 'Model'; }
                // field("Description 2"; "Description 2") { ApplicationArea = all; Caption = 'Model#'};
                field(Quantity; Quantity) { ApplicationArea = all; }
                field("Unit of Measure Code"; "Unit of Measure Code") { ApplicationArea = all; Caption = 'Unit'; }
                field("Unit Cost"; "Unit Cost") { ApplicationArea = all; }
                field("Line Amount"; "Line Amount") { ApplicationArea = all; Caption = 'Amount'; }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code") { ApplicationArea = all; }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code") { ApplicationArea = all; }
                //field(; ShowDimensions[3]) { ApplicationArea = all; }
                field(CreateBy; CreateBy) { ApplicationArea = all; }
                field(CreateDate; CreateDate) { ApplicationArea = all; }
                field("PO Status"; "PO Status") { ApplicationArea = all; StyleExpr = Sty; Style = Attention; }
                field("PO By"; "PO By") { ApplicationArea = all; }
                field("Ref Quote No."; "Ref Quote No.") { ApplicationArea = all; Editable = false; }
                field(RMQty; RMQty) { ApplicationArea = all; Caption = 'Remain Receipt Qty.'; }


            }


        }
    }
    actions
    {
        area(Processing)
        {
            action(Card)
            {
                Caption = 'Card P/R';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PageP: Page "Purchase Quote";
                    PurQ: Record "Purchase Header";
                begin
                    PurQ.Reset();
                    PurQ.SetRange("No.", Rec."Document No.");
                    PurQ.SetRange("Document Type", PurQ."Document Type"::Quote);
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
        RCDate := CalcDate('<-CM>', Today);

    end;

    trigger OnOpenPage()
    begin
        SetFilter("Order No.", '%1', '');
        SetFilter("No.", '<>%1', '');
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(CreateBy);
        Clear(CreateDate);
        Clear(DocDate);
        Sty := false;
        PurchH.Reset();
        PurchH.SetRange("No.", Rec."Document No.");
        PurchH.SetRange("Document Type", PurchH."Document Type"::Quote);
        if PurchH.FindFirst() then begin
            CreateBy := PurchH."Create By";
            CreateDate := PurchH."Create Date";
            DocDate := PurchH."Document Date";
        end;
        if "PO Status" <> "PO Status"::Open then
            Sty := true;

        CalcFields("PO No.");
        CalcFields("PO Date");
        CalcFields("PO By");
        CalcFields(RMQty);

    end;

    var
        PurchH: Record "Purchase Header";
        RCDate: Date;
        DocDate: Date;
        CreateDate: DateTime;
        CreateBy: Text[100];
        Sty: Boolean;
}