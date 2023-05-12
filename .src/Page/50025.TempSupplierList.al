page 50025 "Temporary Qty On Supplier"
{
    ApplicationArea = All;
    PageType = List;
    SourceTable = "Temporary DL Req. Line";
    SourceTableView = where("Remain Qty" = filter(> 0));
    UsageCategory = Lists;
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleExprTxt;
                }
                field("Part No."; "Part No.")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleExprTxt;
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Receipt Qty"; "Receipt Qty")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = true;
                }
                field("Remain Qty"; "Remain Qty")
                {
                    ApplicationArea = all;
                }
                field("Part Name"; "Part Name")
                {
                    ApplicationArea = all;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;

                }
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        StyleExprTxt := '';
        if "Receipt Qty" > 0 then
            StyleExprTxt := 'AttentionAccent';
    end;

    trigger OnClosePage()
    var
        TempL: Record "Temporary DL Req. Line";
    begin
        if DocCode <> '' then begin
            CurrPage.SetSelectionFilter(TempL);
            if TempL.Find('-') then begin
                repeat
                    CopyToTempL(TempL);
                until TempL.Next = 0;
            end;
        end;
    end;

    var
        StyleExprTxt: Text;
        DocCode: Code[20];

    procedure setDocu(cCode: Code[20])
    begin
        DocCode := cCode;
    end;

    procedure CopyToTempL(TempL: Record "Temporary DL Req. Line")
    var
        TempRH: Record "Temp. Receipt Header";
        TempRL: Record "Temp. Receipt Line";
        Rows: Integer;
    begin
        Rows := 0;
        TempRH.Reset();
        TempRH.SetRange("Receipt No.", DocCode);
        if TempRH.Find('-') then begin
            TempRL.Reset();
            TempRL.SetRange("Document No.", DocCode);
            if TempRL.FindLast() then
                Rows := TempRL."Line No.";

            TempRL.Init();
            TempRL."Document No." := DocCode;
            TempRL."Line No." := Rows + 1;
            TempRL.Validate("Part No.", TempL."Part No.");
            TempRL.Validate("Lot No.", TempL."Lot No.");
            TempRL.Validate(Quantity, TempL."Remain Qty");
            TempRL.Insert();
        end;
    end;
}
