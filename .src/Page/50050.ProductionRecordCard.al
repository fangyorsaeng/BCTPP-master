page 50050 "Production Record Card"
{
    PageType = Document;
    SourceTable = "Production Record Header";

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

            part(Line; "Production Record Subform")
            {
                Caption = 'Line';
                ApplicationArea = all;
                Editable = (Process <> Enum::"Prod. Process"::" ");
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
                Caption = 'Print List';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ReportMDL: Report "Production Record Report";
                    DeliveryMT: Record "Production Record Header";
                begin
                    Clear(ReportMDL);
                    CurrPage.SetSelectionFilter(DeliveryMT);
                    ReportMDL.SetTableView(DeliveryMT);
                    ReportMDL.Run();

                end;
            }
            group(Posted)
            {
                action(Completed)
                {
                    ApplicationArea = all;
                    Caption = 'Post Receive';
                    Image = Process;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        TestField(Status, Status::Open);
                        CheckItemNoBeforeComplate(Rec."Req. No.");
                        if Confirm('Do you want Post Document?') then begin
                            Rec.Status := Rec.Status::Completed;
                            Rec.Modify();
                            UpdateAssambleOrder(Rec."Req. No.", 'POST');
                        end;

                        CurrPage.Update();
                        Message('Completed');
                    end;

                }
            }
            group(Statusx)
            {
                Caption = 'Undo';
                action(Reopen)
                {
                    ApplicationArea = all;
                    Caption = 'Undo Document';
                    Image = ReOpen;
                    trigger OnAction()
                    begin
                        TestField(Status, Status::Completed);
                        //Message('Undo on Item Ledger Entry!');
                        //exit;
                        if Confirm('Do you want Undo Document?') then begin
                            Rec.Status := Rec.Status::Open;
                            Rec.Modify();
                            UpdateAssambleOrder(Rec."Req. No.", 'OPEN');
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


    procedure AssistEdit(var TempOrder: Record "Production Record Header"): Boolean
    var
        PurSetup: Record "Purchases & Payables Setup";
        NewCode: Code[20];
    begin
        SalesSetup.Get();
        SalesSetup.TestField("Prod. Record");
        if (TempOrder."Req. No." = '') and (SalesSetup."Prod. Record" <> '') then begin
            if NoSeriesMgt.SelectSeries(SalesSetup."Prod. Record", '', NewCode) then begin
                if NewCode <> '' then
                    TempOrder."Req. No." := NoSeriesMgt.GetNextNo(NewCode, Today, true);
                TempOrder.Status := TempOrder.Status::Open;
                TempOrder."Create By" := utility.UserFullName(UserId);
                TempOrder."Create Date" := CurrentDateTime;
                TempOrder.Remark := 'บันทึกประจำวัน';
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
        InvtL: Record "Production Record Line";
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
        ProRecL: Record "Production Record Line";
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.Reset();
        ItemJnlBatch.SetRange("Journal Template Name", 'ITEM');
        ItemJnlBatch.SetRange(Name, 'Z-AUTO');
        if NOT ItemJnlBatch.Find('-') then begin
            Error('Item Jnl Batch Not have Name Z-AUTO!!');
        end;
        ProRecL.Reset();
        ProRecL.SetRange("Document No.", Doc);
        if ProRecL.Find('-') then begin
            repeat
                ItemS.Reset();
                ItemS.SetRange("No.", ProRecL."Part No.");
                if ItemS.Find('-') then begin
                    if ItemS.Blocked then
                        Error('Some Item is Blocked.');
                    if ItemS."Item Tracking Code" <> '' then begin
                        if (ProRecL."Lot No." = '') then
                            Error('Please.. Input LotNo on Item :' + ProRecL."Part No.");
                    end;
                    if ItemS.Location = '' then
                        Error('Plase.. Input Location on Item :' + ProRecL."Part No." + ' On Item Card.');
                end;
            until ProRecL.Next = 0;
        end;
    end;

    procedure UpdateAssambleOrder(Doc: Code[30]; Typex: Code[20])
    var
        AssemblyH: Record "Assembly Header";
        AssemblyL: Record "Assembly Line";
        ProRecH: Record "Production Record Header";
        ProRecL: Record "Production Record Line";
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
                        utility.ProductionRecordPosted(ProRecH, ProRecL);
                    if Typex = 'OPEN' then
                        utility.ProductionRecordPostedReOpen(ProRecH, ProRecL);

                // AssemblyH.Reset();
                // AssemblyH.SetAutoCalcFields("Received Qty");
                // AssemblyH.SetRange("Item No.", ProRecL."Part No.");
                // AssemblyH.SetRange("Due Date", ProRecH."Req. Date");
                // if AssemblyH.Find('-') then begin
                //     QtyAmount := getAmountQty('', AssemblyH."Due Date", AssemblyH."Item No.");
                //     RemainQty := AssemblyH.Quantity - QtyAmount;
                //     if RemainQty < 0 then
                //         RemainQty := 0;
                //     AssemblyH."Assembled Quantity" := QtyAmount;
                //     AssemblyH."Assembled Quantity (Base)" := QtyAmount;
                //     AssemblyH."Remaining Quantity" := RemainQty;
                //     AssemblyH."Remaining Quantity (Base)" := RemainQty;
                //     AssemblyH.Modify();
                ///Posted to Item Ledger Entry//
                // end;
                until ProRecL.Next = 0;
            end;

        end;
    end;

    procedure getAmountQty(Doc: Code[20]; Ddate: Date; PartNo: Code[20]): Decimal
    var
        QtyAmount: Decimal;
        ProRecH: Record "Production Record Header";
        ProRecL: Record "Production Record Line";
    begin
        QtyAmount := 0;
        ProRecH.Reset();
        ProRecH.SetRange("Req. Date", Ddate);
        ProRecH.SetRange(Status, Status::Completed);
        if ProRecH.Find('-') then begin
            repeat

                ProRecL.Reset();
                ProRecL.SetRange("Document No.", ProRecH."Req. No.");
                ProRecL.SetRange("Part No.", PartNo);
                if ProRecL.Find('-') then begin
                    repeat
                        QtyAmount += ProRecL.Quantity;// + ProRecL."NG Qty";
                    until ProRecL.Next = 0;
                end;
            until ProRecH.Next = 0;

        end;

        exit(QtyAmount);
    end;
}