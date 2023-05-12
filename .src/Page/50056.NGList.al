page 50056 "NG Lists"
{

    SourceTable = "NG List";
    AutoSplitKey = true;
    Caption = 'NG Lists';
    PageType = List;
    SourceTableView = sorting(EntryNo) order(ascending);
    MultipleNewLines = true;
    UsageCategory = Lists;
    ApplicationArea = all;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                //field("Document No."; "Document No.") { ApplicationArea = all; Editable = false; }
                //field("Line No."; "Line No.") { ApplicationArea = all; }
                field("Ref. Process"; "Ref. Process") { ApplicationArea = all; Editable = true; }
                field("NG Date"; "NG Date") { ApplicationArea = all; }
                field("Part No."; "Part No.")
                {
                    ApplicationArea = all;
                }
                field("Part Name"; "Part Name") { ApplicationArea = all; Editable = false; }
                field("OLD Location"; "OLD Location") { ApplicationArea = all; Caption = 'From Location'; }
                //field("New Locatin"; "New Locatin") { ApplicationArea = all; StyleExpr = 'Favorable'; }
                field(Quantity; Quantity) { ApplicationArea = all; StyleExpr = 'StandardAccent'; Caption = 'NG Qty'; }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = all;
                    Editable = "Part No." <> '';
                    AssistEdit = false;
                    // trigger OnAssistEdit()
                    // var
                    //     ItemLedger: Record "Item Ledger Entry";
                    //     SelectLitP: page "Select Lot List";
                    // begin
                    //     Clear(SelectLitP);
                    //     ItemLedger.Reset();
                    //     ItemLedger.SetRange("Item No.", "Part No.");
                    //     ItemLedger.SetRange("Location Code", "OLD Location");
                    //     ItemLedger.SetFilter("Remaining Quantity", '>%1', 0);
                    //     ItemLedger.SetFilter("Lot No.", '<>%1', '');
                    //     if ItemLedger.Find('-') then begin
                    //         SelectLitP.setDoc(Rec."Document No.", Rec."Line No.");
                    //         SelectLitP.SetTableView(ItemLedger);
                    //         SelectLitP.RunModal();
                    //     end;

                    // end;
                }
                field(Remark; Remark) { ApplicationArea = all; }
                field(Process; Process) { ApplicationArea = all; Caption = 'Process Name'; }
                field("Machine No."; "Machine No.") { ApplicationArea = all; }
                field("Dept."; "Dept.") { ApplicationArea = all; }
                field("Req. By"; "Req. By") { ApplicationArea = all; }
                field("Ref. Doc No"; "Ref. Doc No") { ApplicationArea = all; }
            }
        }
    }



}