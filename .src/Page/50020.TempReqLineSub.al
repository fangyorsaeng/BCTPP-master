page 50020 "Temporary DL Line Sub"
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
                // field("Document No."; "Document No.")
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Part No."; "Part No.")
                {
                    ApplicationArea = all;
                    Editable = true;

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
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = all;
                    Editable = "Part No." <> '';
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    var
                        ItemLedger: Record "Item Ledger Entry";
                        SelectLitP: page "Select Lot List";
                        ItemS: Record Item;
                    begin
                        ItemS.Reset();
                        ItemS.SetRange("No.", Rec."Transfer From Item No.");
                        if ItemS.Find('-') then begin
                            Clear(SelectLitP);
                            ItemLedger.Reset();
                            ItemLedger.SetRange("Item No.", Rec."Transfer From Item No.");
                            ItemLedger.SetRange("Location Code", ItemS.Location);
                            ItemLedger.SetFilter("Remaining Quantity", '>%1', 0);
                            ItemLedger.SetFilter("Lot No.", '<>%1', '');
                            if ItemLedger.Find('-') then begin
                                SelectLitP.setDoc(Rec."Document No.", Rec."Line No.", 'DL');
                                SelectLitP.SetTableView(ItemLedger);
                                SelectLitP.RunModal();
                                CurrPage.Update(false);
                            end;
                        end;

                    end;

                    trigger OnValidate()
                    var
                        TempL: Record "Temporary DL Req. Line";
                        CRow: Integer;
                        TempH: Record "Temporary DL Req.";
                    begin
                        if Rec."Lot No." <> '' then begin
                            //Check Lot No.
                            if Rec."Line No." = 0 then begin
                                TempL.Reset();
                                TempL.SetRange("Document No.", Rec."Document No.");
                                TempL.SetFilter("Lot No.", '<>%1', '');
                                TempL.SetFilter("Lot No.", Rec."Lot No.");
                                if TempL.Find('-') then begin
                                    Error('Lot No. Duplicate!');
                                end;
                            end;

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
                            //Insert Part No.//
                        end;
                    end;
                }
                field(Quantity; Quantity)
                {
                    Editable = "Receipt Qty" = 0;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        "Remain Qty" := Quantity - "Receipt Qty";
                        //calTotal2(Rec."Document No.");
                        // CurrPage.Update();
                        // calTotal(Rec, xRec);
                    end;
                }
                field("Receipt Qty"; "Receipt Qty")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = true;
                    Style = Favorable;
                }
                field("Remain Qty"; "Remain Qty")
                {
                    ApplicationArea = all;
                }
                // field(Remain; Remain)
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // }
                field("Part Name"; "Part Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Transfer From Item No."; "Transfer From Item No.")
                {
                    ApplicationArea = all;
                }
                field("Cut from Stock"; "Cut from Stock")
                {
                    ApplicationArea = all;
                }

            }
            group("Summary Total")
            {
                ShowCaption = false;
                field(Totalx; Totalx)
                {
                    Caption = 'Sum Total';
                    ApplicationArea = all;
                    Editable = false;
                    trigger OnValidate()
                    begin

                    end;
                }
            }

        }

    }
    actions
    {
        area(Processing)
        {
            group(UndoStock)
            {
                Caption = 'Undo Stock';
                action(Undo1)
                {
                    Caption = 'Undo Stock';
                    Image = Undo;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        TempDLL: Record "Temporary DL Req. Line";
                        PostedStock: Codeunit "Posted Stock";
                    begin
                        if Confirm('Do you want Undo Stock Transfer?') then begin
                            TempDLL.Reset();
                            TempDLL.SetRange("Document No.", Rec."Document No.");
                            TempDLL.SetRange("Cut from Stock", true);
                            if TempDLL.Find('-') then begin
                                PostedStock.CustStockWashingUNDO(TempDLL);
                                TempDLL.Modify();
                            end;
                        end;
                        CurrPage.Update();
                    end;

                }
            }
            group("Item Ledger Entries")
            {
                action(ItemLedgerEntry1)
                {
                    Caption = 'Item Ledger Washing';
                    Image = ItemLedger;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        ItemLedger: Record "Item Ledger Entry";
                        ItemLedgerList: Page "Item Ledger Entries";
                    begin
                        Clear(ItemLedgerList);
                        ItemLedger.Reset();
                        ItemLedger.SetRange("Item No.", Rec."Part No.");
                        //ItemLedger.SetRange("Document Type", ItemLedger."Document Type"::"Transfer Shipment", ItemLedger."Document Type"::"Transfer Receipt");
                        if ItemLedger.Find('-') then begin
                            ItemLedgerList.SetTableView(ItemLedger);
                            ItemLedgerList.RunModal();
                        end;
                    end;
                }
                action(ItemLedgerEntry2)
                {
                    Caption = 'Item Ledger Transfer';
                    Image = ItemLedger;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        ItemLedger: Record "Item Ledger Entry";
                        ItemLedgerList: Page "Item Ledger Entries";
                    begin
                        Clear(ItemLedgerList);
                        ItemLedger.Reset();
                        ItemLedger.SetRange("Item No.", Rec."Transfer From Item No.");
                        ItemLedger.SetRange("Document Type", ItemLedger."Document Type"::"Transfer Shipment", ItemLedger."Document Type"::"Transfer Receipt");
                        if ItemLedger.Find('-') then begin
                            ItemLedgerList.SetTableView(ItemLedger);
                            ItemLedgerList.RunModal();
                        end;
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        // Remain := Quantity;
        // Remain := Quantity - "Receipt Qty";
        CalcFields(Totalx);

    end;

    trigger OnModifyRecord(): Boolean
    begin

    end;


    var
        Remain: Decimal;






}