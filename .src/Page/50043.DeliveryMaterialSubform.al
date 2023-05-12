page 50043 "Delivery Material Subform"
{
    SourceTable = "Material Delivery Line";
    AutoSplitKey = true;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTableView = sorting("Document No.", "Line No.") order(ascending);
    MultipleNewLines = true;
    UsageCategory = History;
    ApplicationArea = all;
    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                //field("Document No."; "Document No.") { ApplicationArea = all; Editable = false; }
                field("Line No."; "Line No.") { ApplicationArea = all; }
                field("Part No."; "Part No.")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        TempL: Record "Material Delivery Line";
                        CRow: Integer;
                        ItemS: Record Item;
                    begin
                        // if "Part No." <> '' then begin
                        //     CRow := 0;
                        //     if "Line No." = 0 then begin
                        //         TempL.Reset();
                        //         TempL.SetFilter("Line No.", '<>%1', 0);
                        //         TempL.SetRange("Document No.", Rec."Document No.");
                        //         if TempL.FindLast() then begin
                        //             CRow := TempL."Line No.";
                        //         end;
                        //         CRow := CRow + 1;
                        //         Rec."Line No." := CRow;
                        //     end;
                        //     ItemS.Reset();
                        //     ItemS.SetRange("No.", "Part No.");
                        //     if ItemS.Find('-') then begin
                        //         "Part Name" := ItemS.Description;
                        //     end;
                        // end;
                    end;
                }
                field("Part Name"; "Part Name") { ApplicationArea = all; Editable = false; }
                field(Quantity; Quantity) { ApplicationArea = all; StyleExpr = 'StandardAccent'; }
                field(Machine; Machine) { ApplicationArea = all; }
                field(Process; Process) { ApplicationArea = all; }
                field(Remark; Remark) { ApplicationArea = all; }
                field("Shipment No."; "Shipment No.") { ApplicationArea = all; Editable = false; }
                field("Shipment Quantity"; "Shipment Quantity") { ApplicationArea = all; CaptionClass = 'Shipped'; Editable = false; }
                field("Lot No."; "Lot No.") { ApplicationArea = all; Editable = false; }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields("Shipment Line");
        CalcFields("Shipment No.");
        CalcFields("Shipment Quantity");
        "Lot No." := '';
        invtShLine.Reset();
        invtShLine.SetRange("MDLH No.", Rec."Document No.");
        invtShLine.SetRange("MDLH Line No.", Rec."Line No.");
        if invtShLine.Find('-') then begin
            invtShLine.CalcFields("Lot No.");
            "Lot No." := invtShLine."Lot No.";
        end;
    end;

    var
        invtShLine: Record "Invt. Shipment Line";
}