page 50009 "Temporary Order Lists"
{
    ApplicationArea = All;
    Caption = 'Temporary Order Lists';
    PageType = List;
    SourceTable = "Temporary DL Req.";
    //SourceTableView = where(Status = filter(Waiting));
    UsageCategory = Lists;
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    CardPageId = "Temporary PO Card";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Status; Status) { ApplicationArea = all; StyleExpr = StyleExprTxt; }
                field(TDNo; TDNo)
                {
                    ApplicationArea = all;
                    Caption = 'Temp. DL No.';
                    StyleExpr = StyleExprTxt;
                }
                field("Supplier Name"; "Supplier Name") { ApplicationArea = all; }
                field(DLNo; DLNo) { ApplicationArea = all; Caption = 'Delivery No.'; StyleExpr = StyleExprTxt; }

                field("Document Date"; "Document Date")
                {
                    ApplicationArea = all;

                }
                field("Req By."; "Req By.")
                {
                    ApplicationArea = all;

                }
                field(Group; Group)
                {
                    ApplicationArea = all;

                }
                field(Process; Process)
                {
                    ApplicationArea = all;

                }

                field(Note; Note) { ApplicationArea = all; }
                field(Supplier; Supplier) { ApplicationArea = all; }
                field(Total; Total) { ApplicationArea = all; AutoFormatType = 1; }
                field("Box 1"; "Box 1") { ApplicationArea = all; }
                field("Box 2"; "Box 2") { ApplicationArea = all; }
                field("Cover 1"; "Cover 1") { ApplicationArea = all; }
                field("Cover 2"; "Cover 2") { ApplicationArea = all; }
                field("Plastic Pallet"; "Plastic Pallet") { ApplicationArea = all; }
                field("Wood Pallet"; "Wood Pallet") { ApplicationArea = all; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(OpenCard)
            {
                Caption = 'Open Card';
                Image = Card;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    TempH: Record "Temporary DL Req.";
                    TempPOC: Page "Temporary PO Card";
                begin
                    Clear(TempH);
                    TempH.Reset();
                    CurrPage.SetSelectionFilter(TempH);
                    TempPOC.SetTableView(TempH);
                    TempPOC.Run();

                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        StyleExprTxt := '';
        sty := false;
        if Status = Status::Completed then begin
            sty := true;
            StyleExprTxt := 'Favorable';
        end
        else
            if Status = Status::Waiting then begin
                StyleExprTxt := 'Attention';
            end
            else
                if Status = Status::Process then begin
                    StyleExprTxt := 'AttentionAccent';
                end;

    end;

    var
        utility: Codeunit Utility;
        sty: Boolean;
        StyleExprTxt: Text;
        SS: Option None,Standard,StandardAccent,Strong,StrongAccent,Attention,AttentionAccent,Favorable,Unfavorable,Ambiguous,Subordinate;

}