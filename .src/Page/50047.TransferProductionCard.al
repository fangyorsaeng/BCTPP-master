page 50047 "Transfer Production Card"
{
    PageType = Document;
    SourceTable = "Transfer Production Header";
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
                field(Process; Process) { ApplicationArea = all; Caption = 'Line Name'; }
                field(Status1; Status) { ApplicationArea = all; Editable = false; Caption = 'Status'; }
                field("Create By"; "Create By") { ApplicationArea = all; Editable = false; }
                field("Create Date"; "Create Date") { ApplicationArea = all; Editable = false; }
                field("Receipt No."; "Receipt No.") { ApplicationArea = all; Editable = false; }


            }
            group(ScanKanban)
            {
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

            part(Line; "Transfer Production Subform")
            {
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
                    ReportMDL: Report "Transfer Production";
                    DeliveryMT: Record "Transfer Production Header";
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
                    Caption = 'set Open';
                    Image = ReOpen;
                    trigger OnAction()
                    begin
                        if Confirm('Do you want Re-Open Document?') then
                            Rec.Status := Rec.Status::Open;
                        CurrPage.Update();
                    end;

                }
                action(Completed)
                {
                    ApplicationArea = all;
                    Caption = 'set Process';
                    Image = Process;
                    trigger OnAction()
                    begin
                        if Confirm('Do you want Process Document?') then
                            Rec.Status := Rec.Status::Process;
                        CurrPage.Update();
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
        CalcFields("Receipt No.");
    end;

    var
        utility: Codeunit Utility;
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;


    procedure AssistEdit(var TempOrder: Record "Transfer Production Header"): Boolean
    var
        PurSetup: Record "Purchases & Payables Setup";
        NewCode: Code[20];
    begin
        SalesSetup.Get();
        SalesSetup.TestField("Transfer Order");
        if (TempOrder."Req. No." = '') and (SalesSetup."Transfer Order" <> '') then begin
            if NoSeriesMgt.SelectSeries(SalesSetup."Transfer Order", '', NewCode) then begin
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
        InvtL: Record "Transfer Production Line";
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
            InvtL.Validate(Quantity, QtyK);
            InvtL.Validate("Ref. Process", Rec.Process);
            InvtL.Insert();

        end;

    end;
}