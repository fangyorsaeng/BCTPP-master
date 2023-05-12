page 50051 "Production Record Subform"
{
    SourceTable = "Production Record Line";
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
                field("Ref. Process"; "Ref. Process") { ApplicationArea = all; Editable = true; }
                field("Part No."; "Part No.")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        TempL: Record "Production Record Line";
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
                // field("NC Date"; "NC Date") { ApplicationArea = all; }
                field("Machine No."; "Machine No.") { ApplicationArea = all; }
                // field("MC Date"; "MC Date") { ApplicationArea = all; }
                field(Shift; Shift) { ApplicationArea = all; }
                //field("RRD Date"; "RRD Date") { ApplicationArea = all; Caption = 'Reamer/Rolling/De burr Date'; }
                // field("Reamer Machine"; "Reamer Machine") { ApplicationArea = all; }
                field("Lot No."; "Lot No.") { ApplicationArea = all; Editable = "Part No." <> ''; }
                field(Box; Box)
                {
                    ApplicationArea = all;
                    Caption = 'Box Qty';
                    Editable = "Part No." <> '';
                    trigger OnValidate()
                    var
                        ItemS2: Record Item;
                    begin
                        if Box > 0 then begin
                            ItemS2.Reset();
                            ItemS2.SetRange("No.", Rec."Part No.");
                            ItemS2.SetFilter("PCS per Pallet", '<>%1', 0);
                            if ItemS2.Find('-') then begin
                                Rec.Quantity := ItemS2."PCS per Pallet" * Rec.Box;
                            end;

                        end;
                    end;
                }
                field(Quantity; Quantity) { ApplicationArea = all; StyleExpr = 'StandardAccent'; Caption = 'Total Qty'; }
                field("NG Qty"; "NG Qty") { ApplicationArea = all; }
                field(Remark; Remark) { ApplicationArea = all; }
                field("Ref. Assembly No"; "Ref. Assembly No") { ApplicationArea = all; }


            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        //  CalcFields("Receipt No.");
    end;

    trigger OnInit()
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ProH: Record "Production Record Header";
    begin
        ProH.Reset();
        ProH.SetRange("Req. No.", Rec."Document No.");
        if ProH.Find('-') then
            "Ref. Process" := ProH.Process;
    end;


}