page 50021 "Temporary Receipt Lists"
{
    ApplicationArea = All;
    PageType = List;
    SourceTable = "Temp. Receipt Header";
    UsageCategory = Lists;
    InsertAllowed = true;
    Editable = false;
    DeleteAllowed = false;
    CardPageId = "Temporary Receipt Card";
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Status; Status) { ApplicationArea = all; StyleExpr = StyleExprTxt; }
                field("Receipt No."; "Receipt No.")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleExprTxt;
                }
                field("Receipt Date"; "Receipt Date") { ApplicationArea = all; }
                field("Receipt By"; "Receipt By") { ApplicationArea = all; }
                field(Group; Group) { ApplicationArea = all; }
                field(Note; Note) { ApplicationArea = all; }
                field("Ref. No."; "Ref. No.") { ApplicationArea = all; }
                field("Ref. Date"; "Ref. Date") { ApplicationArea = all; }
                field("Ref. By"; "Ref. By") { ApplicationArea = all; }
                field(Total; Total) { ApplicationArea = all; Caption = 'Total OK'; }
                field(TotalNG; TotalNG) { ApplicationArea = all; Caption = 'Total NG'; }

            }
        }
    }
    actions
    {

    }
    trigger OnAfterGetRecord()
    begin
        CalcFields(Total);
        CalcFields(TotalNG);
        StyleExprTxt := '';
        sty := false;
        if Status = Status::Completed then begin
            sty := true;
            StyleExprTxt := 'Favorable';
        end
        else
            if Status = Status::Open then begin
                //  StyleExprTxt := 'Attention';
            end;


    end;

    var
        Sty: Boolean;
        StyleExprTxt: Text;

}