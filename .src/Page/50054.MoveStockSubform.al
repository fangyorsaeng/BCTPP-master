page 50054 "MoveStock Subform"
{
    SourceTable = "MoveStock Line";
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
                }
                field("Part Name"; "Part Name") { ApplicationArea = all; Editable = false; }
                field("OLD Location"; "OLD Location") { ApplicationArea = all; StyleExpr = 'Unfavorable'; }
                field("New Locatin"; "New Locatin") { ApplicationArea = all; StyleExpr = 'Favorable'; }
                field(Quantity; Quantity) { ApplicationArea = all; StyleExpr = 'StandardAccent'; Caption = 'Move Qty'; }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = all;
                    Editable = "Part No." <> '';
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    var
                        ItemLedger: Record "Item Ledger Entry";
                        SelectLitP: page "Select Lot List";
                    begin
                        Clear(SelectLitP);
                        ItemLedger.Reset();
                        ItemLedger.SetRange("Item No.", "Part No.");
                        ItemLedger.SetRange("Location Code", "OLD Location");
                        ItemLedger.SetFilter("Remaining Quantity", '>%1', 0);
                        ItemLedger.SetFilter("Lot No.", '<>%1', '');
                        if ItemLedger.Find('-') then begin
                            SelectLitP.setDoc(Rec."Document No.", Rec."Line No.", 'MOVE');
                            SelectLitP.SetTableView(ItemLedger);
                            SelectLitP.RunModal();
                        end;

                    end;
                }
                field(Remark; Remark) { ApplicationArea = all; }
                field("Machine No."; "Machine No.") { ApplicationArea = all; }
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
        ProH: Record "MoveStock Header";
    begin
        ProH.Reset();
        ProH.SetRange("Req. No.", Rec."Document No.");
        if ProH.Find('-') then
            "Ref. Process" := ProH.Process;
    end;


}