page 50030 "Sales Quote Sub Annual"
{
    AutoSplitKey = true;
    Caption = 'Annual Usage';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line Annual Usage";
    //SourceTableView = WHERE("Document Type" = FILTER(Quote));
    layout
    {
        area(Content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Document No."; "Document No.") { Visible = false; }
                field("Line No."; "Line No.") { ApplicationArea = all; Caption = 'No.'; Editable = true; }
                field("Annual Text"; "Annual Text")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        TempL: Record "Sales Line Annual Usage";
                        CRow: Integer;
                    begin
                        if "Annual Text" <> '' then begin
                            CRow := 0;
                            if "Line No." = 0 then begin
                                TempL.Reset();
                                TempL.SetFilter("Line No.", '<>%1', 0);
                                TempL.SetRange("Document No.", Rec."Document No.");
                                if TempL.FindLast() then begin
                                    CRow := TempL."Line No.";
                                end;
                                CRow := CRow + 1;
                                Rec."Line No." := CRow;
                            end;
                        end;
                    end;
                }
                field("Annual Usage"; "Annual Usage") { ApplicationArea = all; Editable = "Annual Text" <> ''; Style = StandardAccent; StyleExpr = true; }
                field(PricePerPcs; PricePerPcs) { ApplicationArea = all; Editable = "Annual Text" <> ''; }
                field("Raw Material Timing"; "Raw Material Timing") { ApplicationArea = all; Editable = "Annual Text" <> ''; }

            }
        }
    }
}