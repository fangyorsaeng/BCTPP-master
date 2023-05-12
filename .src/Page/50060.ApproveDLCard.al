page 50060 "Approve DL Card"
{
    PageType = Document;
    SourceTable = "Material Delivery Header";
    Editable = false;

    layout
    {
        area(Content)
        {
            usercontrol(SetFieldFocus; SetFieldFocus)
            {
                ApplicationArea = All;
                trigger Ready()
                begin
                    CurrPage.SetFieldFocus.SetFocusOnField('No.');
                end;
            }
            group(General)
            {
                field("Req. No."; "Req. No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(Rec) then
                            CurrPage.Update;
                    end;
                }
                field("Req. Date"; "Req. Date") { ApplicationArea = all; Editable = false; }
                field("Req. By"; "Req. By") { ApplicationArea = all; Editable = false; }
                field("Ref. Document"; "Ref. Document") { ApplicationArea = all; Editable = false; }
                field(Remark; Remark) { ApplicationArea = all; }
                field(Process; Process) { ApplicationArea = all; Caption = 'Line Name'; Editable = false; }
                field("From Washing"; "From Washing") { ApplicationArea = ALL; Editable = false; }
                field(Status; Status) { ApplicationArea = all; Editable = false; }
                field("Create By"; "Create By") { ApplicationArea = all; Editable = false; }
                field("Create Date"; "Create Date") { ApplicationArea = all; Editable = false; }
                field("Shipment No."; "Shipment No.") { ApplicationArea = all; Editable = false; }

            }

            part(Line; "Approve DL Subform")
            {
                //Editable = Status = Status::Open;
                Caption = 'Line';
                ApplicationArea = all;
                SubPageView = sorting("Document No.", "Line No.")
                              order(ascending);
                SubPageLink = "Document No." = field("Req. No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Print1)
            {
                ApplicationArea = all;
                Image = Print;
                Caption = 'Print Voucher';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ReportMDL: Report "Material Delivery";
                    DeliveryMT: Record "Material Delivery Header";
                begin
                    CheckBeforePrint(Rec."Req. No.");
                    Clear(ReportMDL);
                    CurrPage.SetSelectionFilter(DeliveryMT);
                    ReportMDL.SetTableView(DeliveryMT);
                    ReportMDL.Run();

                end;
            }
            action(Reopen)
            {
                ApplicationArea = all;
                Caption = 'Posted Document';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = Status = Status::Open;
                trigger OnAction()
                var
                    PosteStock: Codeunit "Posted Stock";
                begin
                    CheckBeforePosted();
                    if Confirm('Do you want Posted Document?') then begin
                        Posteddocument();
                        Rec.Status := Rec.Status::Completed;
                        Rec."Approve By" := utility.UserFullName(UserId);
                        Rec."Approve Date" := CurrentDateTime;
                        Message('Completed.');
                    end;

                    CurrPage.Update();
                end;

            }

        }
    }
    trigger OnOpenPage()
    begin
        // Message("Req. No.");
    end;

    trigger OnAfterGetRecord()
    begin
        //CalcFields("Shipment No.");
    end;

    var
        utility: Codeunit Utility;
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure CheckBeforePosted()
    var
        DMLH: Record "Material Delivery Header";
        DMLL: Record "Material Delivery Line";
        ItemS: Record Item;
        ItemLedger: Record "Item Ledger Entry";
        SumQ: Decimal;
    begin
        DMLH.Reset();
        DMLH.SetRange("Req. No.", Rec."Req. No.");
        if DMLH.Find('-') then begin
            DMLL.Reset();
            DMLL.SetRange("Document No.", DMLH."Req. No.");
            DMLL.SetFilter(Quantity, '>%1', 0);
            if DMLL.Find('-') then begin
                repeat
                    ItemS.Reset();
                    ItemS.SetRange("No.", DMLL."Part No.");
                    if ItemS.Find('-') then begin
                        SumQ := 0;
                        ItemLedger.Reset();
                        ItemLedger.SetRange("Item No.", DMLL."Part No.");
                        ItemLedger.SetRange("Location Code", ItemS.Location);
                        ItemLedger.SetFilter("Location Code", '<>%1&<>%2', 'PROCESS', 'NG');
                        if ItemLedger.Find('-') then begin
                            repeat
                                SumQ += ItemLedger."Remaining Quantity";
                            until ItemLedger.Next = 0;
                        end;
                        if SumQ < DMLL.Quantity then
                            Error('Quantity ' + DMLL."Part No." + ' Not enough!');
                    end;
                until DMLL.Next = 0;
            end;
        end;
    end;

    procedure Posteddocument()
    var
        DMLH: Record "Material Delivery Header";
        DMLL: Record "Material Delivery Line";
        ItemS: Record Item;
        ItemLedger: Record "Item Ledger Entry";
        SumQ: Decimal;
        PostedH: Codeunit "Posted Stock";
    begin
        DMLH.Reset();
        DMLH.SetRange("Req. No.", Rec."Req. No.");
        if DMLH.Find('-') then begin
            DMLL.Reset();
            DMLL.SetRange("Document No.", DMLH."Req. No.");
            DMLL.SetFilter(Quantity, '>%1', 0);
            if DMLL.Find('-') then begin
                repeat
                    ItemS.Reset();
                    ItemS.SetRange("No.", DMLL."Part No.");
                    ItemS.SetFilter(Location, '<>%1', '');
                    ItemS.SetRange("For Washing", true);
                    if ItemS.Find('-') then begin
                        //Cut Stock//
                        //Empty Code!!
                        PostedH.PostedStockToBefore_OnProcess(DMLH, DMLL, DMLL."Part No.");


                    end;
                until DMLL.Next = 0;
                //Move to Process//
                PostedH.PostedStockToOnProcessApprov(DMLH."Req. No.");
            end;
        end;
    end;

    procedure AssistEdit(var TempOrder: Record "Material Delivery Header"): Boolean
    var
        PurSetup: Record "Purchases & Payables Setup";
        NewCode: Code[20];
    begin
        exit;
        SalesSetup.Get();
        SalesSetup.TestField("Material DLNo.");
        if (TempOrder."Req. No." = '') and (SalesSetup."Material DLNo." <> '') then begin
            if NoSeriesMgt.SelectSeries(SalesSetup."Material DLNo.", '', NewCode) then begin
                // TestNoSeries();
                // NoSeriesMgt.SetSeries("No.");
                if NewCode <> '' then
                    TempOrder."Req. No." := NoSeriesMgt.GetNextNo(NewCode, Today, true);
                TempOrder.Status := TempOrder.Status::Open;
                TempOrder."Create By" := utility.UserFullName(UserId);
                TempOrder."Create Date" := CurrentDateTime;
                TempOrder."Req. Date" := WorkDate();
                exit(true);
            end;
        end;

    end;

    procedure AddItemOrKanban(Scaner: Code[100]; ScanItem: Text[20])
    var
        KanbanL: Record "Kanban List";
        ItemS: Record Item;
        PartNo: Code[20];
        InvtL: Record "Material Delivery Line";
        RowNo: Integer;
        QtyK: Decimal;
    begin
        exit;
        PartNo := Scaner;
        QtyK := 1;
        if ScanItem = 'Kanban' then begin
            KanbanL.Reset();
            KanbanL.SetRange("Master No.", Scaner);
            if KanbanL.Find('-') then begin
                PartNo := KanbanL."Part No.";
                QtyK := KanbanL.Qty;

            end;
        end;

        ItemS.Reset();
        ItemS.SetRange("No.", PartNo);
        if ItemS.Find('-') then begin
            InvtL.Reset();
            InvtL.SetRange("Document No.", Rec."Req. No.");
            if InvtL.FindLast() then
                RowNo := InvtL."Line No.";
            RowNo := RowNo + 1;

            InvtL.Reset();
            InvtL.Init();
            InvtL."Document No." := Rec."Req. No.";
            InvtL."Line No." := RowNo;
            InvtL."Part No." := PartNo;
            InvtL."Part Name" := ItemS.Description;
            InvtL.Validate(Quantity, QtyK);
            InvtL.Validate("Ref. Process", Rec.Process);
            InvtL.Insert();

        end;

    end;

    procedure CheckBeforePrint(DocNo: Code[20])
    var
        DMDL: Record "Material Delivery Line";
        DMDH: Record "Material Delivery Header";
        ItemS: Record Item;
        CKA: Integer;
    begin
        exit;
        CKA := 0;
        if NOT Rec."From Washing" then begin
            DMDL.Reset();
            DMDL.SetRange("Document No.", DocNo);
            if DMDL.Find('-') then begin
                repeat
                    ItemS.Reset();
                    ItemS.SetRange("No.", DMDL."Part No.");
                    if ItemS.Find('-') then begin
                        if ItemS."For Washing" then begin
                            CKA += 1;
                            if ItemS."To Material Item" = '' then begin
                                Error('Item Card to Material Item is Empty!');
                            end;
                        end;

                    end;
                until DMDL.Next = 0;
            end;
            if (CKA > 0) then
                Error('Please.. Check From Washing');

        end;
    end;
}