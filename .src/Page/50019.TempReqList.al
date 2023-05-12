page 50019 "Temporary Delivery Lists"
{
    ApplicationArea = All;
    Caption = 'Temporary Deliverys';
    PageType = List;
    SourceTable = "Temporary DL Req.";
    UsageCategory = Lists;
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    CardPageId = "Temporary Card";
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(DLNo; DLNo) { ApplicationArea = all; Caption = 'Delivery No.'; StyleExpr = StyleExprTxt; }
                field(Status; Status) { ApplicationArea = all; StyleExpr = StyleExprTxt2; }
                field("Cut Stock"; "Cut Stock")
                {
                    ApplicationArea = all;
                }
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
                field(TDNo; TDNo)
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
    trigger OnAfterGetRecord()
    begin
        CalcFields("Cut Stock");
        StyleExprTxt := '';
        sty := false;
        StyleExprTxt2 := 'Favorable';
        if NOT ("Cut Stock") then begin
            StyleExprTxt2 := 'Attention';
        end;

        if Status = Status::Completed then begin
            sty := true;
            StyleExprTxt := 'Favorable';
        end
        else
            if Status = Status::Process then begin
                StyleExprTxt := 'Attention';
            end;
    end;

    trigger OnOpenPage()
    begin

        SetFilter("Document Date", '%1..', CalcDate('<-1Y+2M>', WorkDate()));
    end;

    var
        utility: Codeunit Utility;
        sty: Boolean;
        StyleExprTxt: Text;
        StyleExprTxt2: Text;
        SS: Option None,Standard,StandardAccent,Strong,StrongAccent,Attention,AttentionAccent,Favorable,Unfavorable,Ambiguous,Subordinate;

}