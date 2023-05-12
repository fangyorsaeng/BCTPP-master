page 50023 "Temporary Receipt Sub"
{
    SourceTable = "Temp. Receipt Line";
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
                    trigger OnValidate()
                    var
                        TempL: Record "Temp. Receipt Line";
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
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    var
                        ItemLedger: Record "Temporary DL Req. Line";
                        SelectLitP: page "Select Lot List For Receipt";
                        ItemS: Record Item;
                    begin
                        ItemS.Reset();
                        ItemS.SetRange("No.", "Part No.");
                        if ItemS.Find('-') then begin
                            Clear(SelectLitP);
                            ItemLedger.Reset();
                            ItemLedger.SetRange("Part No.", "Part No.");
                            ItemLedger.SetFilter("Remain Qty", '>%1', 0);
                            ItemLedger.SetFilter("Lot No.", '<>%1', '');
                            if ItemLedger.Find('-') then begin
                                SelectLitP.setDoc(Rec."Document No.", Rec."Line No.", 'RC');
                                SelectLitP.SetTableView(ItemLedger);
                                SelectLitP.RunModal();
                                CurrPage.Update(false);
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        TempL: Record "Temp. Receipt Line";
                        CRow: Integer;
                    begin
                        if "Lot No." <> '' then begin
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
                field(Quantity; Quantity)
                {
                    // Editable = "Receipt Qty" = 0;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        "Line Total" := Quantity + NGQ;
                        //calTotal2(Rec."Document No.");
                        // CurrPage.Update();
                    end;
                }
                field(NGQ; NGQ)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        "Line Total" := Quantity + NGQ;
                    end;
                }
                field("Line Total"; "Line Total")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Part Name"; "Part Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

            }
            // group("Summary Total")
            // {
            //     ShowCaption = false;
            //     field(Totalx; Totalx)
            //     {
            //         Caption = 'Sum Total';
            //         ApplicationArea = all;
            //         Editable = false;
            //         trigger OnValidate()
            //         begin

            //         end;
            //     }
            // }

        }

    }
    actions
    {
        area(Processing)
        {
            action(ListSP)
            {
                Caption = 'List Qty.';
                ApplicationArea = all;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;
                Image = List;
                trigger OnAction()
                var
                    PageList: Page "Temporary Qty On Supplier";
                    TempL: Record "Temporary DL Req. Line";
                begin
                    Clear(PageList);
                    TempL.Reset();
                    if Rec."Part No." <> '' then
                        TempL.SetRange("Part No.", Rec."Part No.");
                    if TempL.Find('-') then;
                    PageList.setDocu(Rec."Document No.");
                    PageList.SetTableView(TempL);
                    PageList.RunModal();
                end;
            }
            action(Update)
            {
                Caption = 'Update Qty.';
                ApplicationArea = all;
                Image = UpdateXML;
                Visible = false;
                trigger OnAction()
                var
                    PosteJnlUp: Codeunit "Posted Receipt Temp.";
                    TempLC: Record "Temp. Receipt Line";
                    TempH: Record "Temp. Receipt Header";
                begin
                    Clear(TempH);
                    TempH.Reset();
                    TempH.SetRange("Receipt No.", Rec."Document No.");
                    if TempH.Find('-') then begin
                        TempLC.Reset();
                        TempLC.SetRange("Document No.", TempH."Receipt No.");
                        TempLC.SetFilter("Part No.", '<>%1', '');
                        TempLC.SetFilter(Quantity, '<>%1', 0);
                        TempLC.SetRange(Status, TempLC.Status::Completed);
                        if TempLC.Find('-') then begin
                            repeat
                                PosteJnlUp.UpdateReceipt(TempLC, TempH);
                            until TempLC.Next = 0;
                            Message('completed.');
                        end;
                    end;
                    // 
                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        // Remain := Quantity;
        //  Remain := Quantity - "Receipt Qty";
        // CalcFields(Totalx);

    end;

    trigger OnModifyRecord(): Boolean
    begin

    end;


    var
        Remain: Decimal;
        TotalLine: Decimal;






}