page 50007 "Temp PO Subform"
{
    SourceTable = "Temporary DL Req. Line";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    layout
    {
        area(Content)
        {

            repeater(Control1)
            {
                ShowCaption = false;
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Item No."; "Part No.")
                {
                    ApplicationArea = all;
                    Caption = 'Part No.';
                    CaptionClass = 'Part No.';
                    trigger OnValidate()
                    var
                        TempL: Record "Temporary DL Req. Line";
                        CRow: Integer;
                    begin
                        if "Part No." <> '' then begin
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
                field(Description; "Part Name")
                {
                    ApplicationArea = all;
                    Caption = 'Part Name';
                    CaptionClass = 'Part Name';
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = all;
                }
                field(Qty; Quantity)
                {
                    ApplicationArea = all;
                }
                field(Box; Box)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = true;
                }

            }
        }
    }
}