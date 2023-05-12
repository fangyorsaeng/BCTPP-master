page 50053 "MoveStock Card"
{
    PageType = Document;
    SourceTable = "MoveStock Header";
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
                Editable = Status = Status::Open;

                field("Req. No."; "Req. No.")
                {
                    ApplicationArea = all;
                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(Rec) then
                            CurrPage.Update;
                    end;
                }
                field("Req. Date"; "Req. Date") { ApplicationArea = all; }
                field("Req. By"; "Req. By") { ApplicationArea = all; }
                field("Ref. Document"; "Ref. Document") { ApplicationArea = all; }
                field(Remark; Remark) { ApplicationArea = all; }
                field(Process; Process)
                {
                    ApplicationArea = all;
                    //  Caption = 'Line Name';
                    ShowMandatory = true;
                    trigger OnValidate()
                    var
                        ProL: Page "Production Record Subform";
                    begin

                    end;
                }
                field("Process Name"; "Process Name")
                {
                    ApplicationArea = all;
                }
                field("for Visual Check"; "for Visual Check")
                {
                    ApplicationArea = all;
                }
                field(Status1; Status) { ApplicationArea = all; Editable = false; Caption = 'Status'; }
                field("Create By"; "Create By") { ApplicationArea = all; Editable = false; }
                field("Create Date"; "Create Date") { ApplicationArea = all; Editable = false; }

            }
            group(ScanKanban)
            {
                Editable = Status = Status::Open;
                Caption = 'Scan Kanban';
                field(Scaner; Scaner)
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        if Scaner <> '' then begin
                            //Insert to PurLine//
                            AddItemOrKanban(Scaner, format("Scan Item"));
                            //  Rec.Validate("Invoice Discount Amount", 0);
                            /////////////////////
                        end;
                        Scaner := '';
                        CurrPage.SetFieldFocus.SetFocusOnField('Scaner');

                    end;
                }
                field("Scan Item"; "Scan Item")
                {
                    ApplicationArea = all;
                }
            }

            part(Line; "MoveStock Subform")
            {
                Caption = 'Line';
                ApplicationArea = all;
                // Editable = (Process <> Enum::"Prod. Process"::" ");
                Enabled = Status = Status::Open;
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
                Caption = 'Print Report';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ReportMDL: Report "MoveStock Report";
                    DeliveryMT: Record "MoveStock Header";
                begin
                    Clear(ReportMDL);
                    CurrPage.SetSelectionFilter(DeliveryMT);
                    ReportMDL.SetTableView(DeliveryMT);
                    ReportMDL.Run();

                end;
            }
            group(Statusx)
            {
                Caption = 'Status';
                action(Reopen)
                {
                    ApplicationArea = all;
                    Caption = 'Reopen';
                    Image = ReOpen;
                    Visible = false;

                    trigger OnAction()
                    begin
                        // exit;
                        TestField(Status, Status::Completed);
                        //Message('Undo on Item Ledger Entry!');
                        //exit;
                        if Confirm('Do you want Re-Open Document?') then begin
                            Rec.Status := Rec.Status::Open;
                            Rec.Modify();

                        end;
                        CurrPage.Update();
                        // Message('Completed');
                    end;

                }
                action(Completed)
                {
                    ApplicationArea = all;
                    Caption = 'Post Document';
                    Image = Post;
                    Visible = true;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        TestField(Status, Status::Open);
                        CheckItemNoBeforeComplate(Rec."Req. No.");
                        if Confirm('Do you want Post Document?') then begin
                            UpdateMoveStock(Rec."Req. No.", 'POST');
                            Rec.Status := Rec.Status::Completed;
                            Rec.Modify();
                        end;
                        CurrPage.Update();
                        Message('Completed');
                    end;

                }
            }

        }
    }
    trigger OnOpenPage()
    begin
        // Message("Req. No.");
    end;

    trigger OnAfterGetRecord()
    begin
        // CalcFields("Receipt No.");
    end;

    var
        utility: Codeunit Utility;
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;


    procedure AssistEdit(var TempOrder: Record "MoveStock Header"): Boolean
    var
        PurSetup: Record "Purchases & Payables Setup";
        NewCode: Code[20];
    begin
        SalesSetup.Get();
        SalesSetup.TestField("Move Stock");
        if (TempOrder."Req. No." = '') and (SalesSetup."Move Stock" <> '') then begin
            if NoSeriesMgt.SelectSeries(SalesSetup."Move Stock", '', NewCode) then begin
                if NewCode <> '' then
                    TempOrder."Req. No." := NoSeriesMgt.GetNextNo(NewCode, Today, true);
                TempOrder.Status := TempOrder.Status::Open;
                TempOrder."Create By" := utility.UserFullName(UserId);
                TempOrder."Create Date" := CurrentDateTime;
                TempOrder.Remark := 'บันทึกการย้าย Location';
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
        InvtL: Record "MoveStock Line";
        RowNo: Integer;
        QtyK: Decimal;
    begin

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
            InvtL.Validate(Quantity, 0);
            InvtL.Validate("Ref. Process", Rec.Process);
            InvtL.Insert();


        end;

    end;

    procedure CheckItemNoBeforeComplate(Doc: Code[30])
    var
        ItemS: Record Item;
        MoveL: Record "MoveStock Line";
        ItemJnlBatch: Record "Item Journal Batch";
    begin

        ItemJnlBatch.Reset();
        ItemJnlBatch.SetRange("Journal Template Name", 'ITEM');
        ItemJnlBatch.SetRange(Name, 'Z-MOVE');
        if NOT ItemJnlBatch.Find('-') then begin
            Error('Item Jnl Batch Not have Name Z-MOVE !!');
        end;
        MoveL.Reset();
        MoveL.SetRange("Document No.", Doc);
        if MoveL.Find('-') then begin
            repeat
                ItemS.Reset();
                ItemS.SetRange("No.", MoveL."Part No.");
                if ItemS.Find('-') then begin
                    if ItemS.Blocked then
                        Error('Some Item is Blocked.');
                    if ItemS."Item Tracking Code" <> '' then begin
                        if (MoveL."Lot No." = '') then
                            Error('Please.. Input LotNo on Item :' + MoveL."Part No.");
                    end;
                    if ItemS.Location = '' then
                        Error('Plase.. Input Location on Item :' + MoveL."Part No." + ' On Item Card.');
                    if MoveL.Quantity < 0 then
                        Error('Please.. Input Quantity!');
                    if MoveL."OLD Location" = '' then
                        Error('Please.. Input OLD Location!');
                    if MoveL."New Locatin" = '' then
                        Error('Please..Input New Location!');
                end;
            until MoveL.Next = 0;
        end;
    end;

    procedure UpdateMoveStock(Doc: Code[30]; Typex: Code[20])
    var
        // AssemblyH: Record "Assembly Header";
        // AssemblyL: Record "Assembly Line";
        ProRecH: Record "MoveStock Header";
        ProRecL: Record "MoveStock Line";
        QtyAmount: Decimal;
        RemainQty: Decimal;
    begin

        ProRecH.Reset();
        ProRecH.SetRange("Req. No.", Doc);
        if ProRecH.Find('-') then begin
            ProRecL.Reset();
            ProRecL.SetRange("Document No.", ProRecH."Req. No.");
            if ProRecL.Find('-') then begin
                repeat
                    if Typex = 'POST' then
                        utility.PostedMoveStock(ProRecH, ProRecL);
                until ProRecL.Next = 0;
            end;

        end;
    end;


}