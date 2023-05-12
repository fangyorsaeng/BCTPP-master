page 50018 "Temporary Card"
{
    Caption = 'Temporary Card';
    PageType = Document;
    SourceTable = "Temporary DL Req.";
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(DLNo; DLNo)
                {
                    ApplicationArea = all;
                    Caption = 'Delivery No.';
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    begin
                        AssistEdit(Rec);
                        CurrPage.Update();
                    end;
                }
                field(Process; Process)
                {
                    ApplicationArea = ll;
                    trigger OnValidate()
                    begin
                        if Process = 'WASHING#2' then
                            Note := 'After machining parts';
                        if Process = 'WASHING#1' then
                            Note := 'Foriging parts';
                    end;
                }
                field(Group; Group)
                {
                    ApplicationArea = all;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = all;
                }
                field("Req By."; "Req By.")
                {
                    ApplicationArea = all;
                }
                // field("Part No."; "Part No.")
                // {
                //     ApplicationArea = all;
                // }
                // field("Part Name"; "Part Name")
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // }
                field("Supplier Code"; "Supplier Code")
                {
                    ApplicationArea = all;
                }
                field(Supplier; Supplier)
                {
                    ApplicationArea = all;
                    Editable = false;
                    // AssistEdit = true;
                    // trigger OnAssistEdit()
                    // var
                    //     VendorP: Page "Vendor List";
                    //     SName: Text[200];
                    //     VendorS: Record Vendor;
                    // begin
                    //     if PAGE.RunModal(27, VendorS) = ACTION::LookupOK then begin
                    //         Rec.Supplier := VendorS."Search Name";
                    //     end;
                    // if VendorS.RunModal() = ACTION::LookupOK then begin

                    // end;
                    //end;
                }
                field(Note; Note)
                {
                    ApplicationArea = all;
                }
                field(DateShiped; DateShiped)
                {
                    ApplicationArea = all;
                    Caption = 'Date Shiped';
                }
                // field("Lot No."; "Lot No.")
                // {
                //     ApplicationArea = all;
                //     Importance = Promoted;
                // }
                field(Status; Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            part(TempLine; "Temporary DL Line Sub")
            {
                Caption = 'Temp PO Line.';
                ApplicationArea = Suite;
                Editable = Process <> '';
                Enabled = Status = Status::Waiting;
                SubPageLink = "Document No." = FIELD("DLNo");
                UpdatePropagation = Both;
            }
            group(Box)
            {
                Caption = 'BOX (PD2)';

                field("Box 1"; "Box 1")
                {
                    ApplicationArea = all;
                }
                field("Box 2"; "Box 2")
                {
                    ApplicationArea = all;
                }
                field("Cover 1"; "Cover 1")
                {
                    ApplicationArea = all;
                }
                field("Cover 2"; "Cover 2")
                {
                    ApplicationArea = all;
                }
                field("Plastic Pallet"; "Plastic Pallet")
                {
                    ApplicationArea = all;
                }
                field("Wood Pallet"; "Wood Pallet")
                {
                    ApplicationArea = all;
                }
                field(Total; Total)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Fix TempDL"; "Fix TempDL")
                {
                    ApplicationArea = all;
                    Editable = true;
                    Caption = 'Fix Temp DL (warning)';
                    Style = Attention;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CoverSh)
            {
                Caption = 'Cover Sheet';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Print;
                trigger OnAction()
                var
                    TempPO: Record "Temporary DL Req.";
                    ReportPO: Report "Temp. PO Sheet";
                begin
                    TempPO := Rec;
                    CurrPage.SetSelectionFilter(TempPO);
                    ReportPO.SetTableView(TempPO);
                    ReportPO.RunModal();
                end;
            }
            action(Print)
            {
                Caption = 'Print (PD1)';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Print;
                trigger OnAction()
                var
                    TempPO: Record "Temporary DL Req.";
                    ReportPO: Report "Temp PO";
                begin
                    TempPO := Rec;
                    CurrPage.SetSelectionFilter(TempPO);
                    ReportPO.SetTableView(TempPO);
                    ReportPO.RunModal();
                end;
            }
            action(Print2)
            {
                Caption = 'Print (PD2)';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Print;
                trigger OnAction()
                var
                    TempPO: Record "Temporary DL Req.";
                    ReportPO: Report "Temp PO2";
                begin
                    TempPO := Rec;
                    CurrPage.SetSelectionFilter(TempPO);
                    ReportPO.SetTableView(TempPO);
                    ReportPO.RunModal();
                end;
            }
            group(SetStatus)
            {
                Caption = 'Set Status';
                Image = Setup;
                action(SetC)
                {
                    Caption = 'Set Completed';
                    //Promoted = true;
                    //PromotedCategory = Process;
                    // PromotedIsBig = true;
                    Image = ReleaseDoc;
                    trigger OnAction()
                    begin
                        if Confirm('Do you want Set to Completed.') then
                            Rec.Status := Status::Completed;
                        CurrPage.Update();
                    end;
                }
                action(SetOP)
                {
                    Caption = 'Set Waiting';
                    //  Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
                    Image = Open;
                    trigger OnAction()
                    var
                        TempDL: Record "Temporary DL Req. Line";
                    begin
                        if Confirm('Do you want Set to Waiting.') then begin
                            Rec.Status := Status::Waiting

                        end;

                        CurrPage.Update();

                    end;
                }
                action(SetCancel)
                {
                    Caption = 'Set Cancel';
                    // PromotedCategory = Process;
                    //PromotedIsBig = true;
                    Image = Cancel;
                    trigger OnAction()
                    begin
                        if Confirm('Do you want Set to Cancel.') then
                            Rec.Status := Status::Cancel;
                        CurrPage.Update();
                    end;
                }
                action(SetD)
                {
                    Caption = 'Set Process';
                    //Promoted = true;
                    //PromotedCategory = Process;
                    // PromotedIsBig = true;
                    Image = ReleaseDoc;
                    trigger OnAction()
                    begin
                        if Confirm('Do you want Set to Process.') then
                            Rec.Status := Status::Process;
                        CurrPage.Update();
                    end;
                }
                action(Update2)
                {
                    Caption = 'Set Update Remain';
                    Image = ReleaseDoc;
                    trigger OnAction()
                    var
                        TempL: Record "Temporary DL Req. Line";
                    begin
                        if Confirm('Do you want Set to Remain.') then begin
                            TempL.Reset();
                            TempL.SetRange("Document No.", Rec.DLNo);
                            if TempL.Find('-') then begin
                                repeat
                                    TempL."Remain Qty" := TempL.Quantity - TempL."Receipt Qty";
                                    TempL.Modify();
                                until TempL.Next = 0;
                            end;
                        end;
                        CurrPage.Update();
                    end;
                }
            }
            action(Posted)
            {
                Image = Post;
                ApplicationArea = all;
                Caption = 'Post Cut Stock';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Post to Cut Stock from Washing From Item';
                trigger OnAction()
                var
                    PostStock: Codeunit "Posted Stock";
                    TempDLL: Record "Temporary DL Req. Line";
                    CKT: Boolean;
                begin
                    CKT := true;
                    if Confirm('Do you want Post Cut Stock') then begin
                        if NOT "Fix TempDL" then
                            TestField(Status, Status::Process)
                        else begin
                            if Confirm('Do you want Posted With Fix Temp. DL?') then begin
                                Rec.TDNo := Rec.DLNo;
                                Rec."Temp. By" := 'Auto';
                                Rec."Temp. Date" := Today();
                                Rec.Status := Status::Process;
                                Rec.Modify();
                            end else begin
                                exit;
                            end;

                        end;

                        TempDLL.Reset();
                        TempDLL.SetRange("Document No.", Rec.DLNo);
                        TempDLL.SetRange("Cut from Stock", false);
                        if TempDLL.Find('-') then begin
                            repeat
                                if "Fix TempDL" then begin

                                    TempDLL."Cut from Stock" := true;
                                    TempDLL."Remain Qty" := TempDLL.Quantity - TempDLL."Receipt Qty";
                                    TempDLL.Modify();
                                end
                                else begin
                                    PostStock.CustStockWashing(TempDLL);
                                    TempDLL.Modify();
                                end;

                            until TempDLL.Next = 0;
                        end;
                    end;
                    CurrPage.Update();
                end;
            }

        }
    }
    trigger OnOpenPage()
    begin
        calTotalH(Rec.DLNo);
    end;

    var
        utility: Codeunit Utility;
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure AssistEdit(var TempOrder: Record "Temporary DL Req."): Boolean
    var
        PurSetup: Record "Purchases & Payables Setup";
        NewCode: Code[20];
    begin


        //  GetPurchSetup();
        PurSetup.Get();
        PurSetup.TestField("Temp. DL No.");
        if (TempOrder.DLNo = '') and (PurSetup."Temp. DL No." <> '') then begin
            if NoSeriesMgt.SelectSeries(PurSetup."Temp. DL No.", '', NewCode) then begin
                // TestNoSeries();
                // NoSeriesMgt.SetSeries("No.");
                if NewCode <> '' then
                    TempOrder.DLNo := NoSeriesMgt.GetNextNo(NewCode, Today, true);
                exit(true);
            end;
        end;

    end;
}