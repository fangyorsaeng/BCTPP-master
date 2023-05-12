page 50008 "Temporary PO Card"
{
    Caption = 'Temporary PO Card';
    PageType = Document;
    SourceTable = "Temporary DL Req.";
    RefreshOnActivate = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    //ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group("Create Temp. PO")
            {
                field(TDNo; TDNo)
                {
                    ApplicationArea = all;
                    Caption = 'Temp. DL No.';
                    AssistEdit = true;
                    Editable = TDNo = '';
                    trigger OnAssistEdit()
                    begin
                        AssistEdit2(Rec);
                        CurrPage.Update();
                    end;

                    trigger OnValidate()
                    var
                        NoseriesM: Codeunit NoSeriesManagement;
                    begin


                    end;
                }
                field("Document Date"; "Document Date")
                {
                    //Editable = false;
                    ApplicationArea = all;
                }

                field("Supplier Code"; "Supplier Code")
                {
                    ApplicationArea = all;
                }
                field("Supplier Name"; "Supplier Name")
                {
                    ApplicationArea = all;
                }
                field("Ref. PONo."; "Ref. PONo.")
                {
                    ApplicationArea = all;
                }
            }
            group(General)
            {
                field(DLNo; DLNo)
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Delivery No.';
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    begin
                        //   AssistEdit(Rec);
                        CurrPage.Update();
                    end;
                }
                field(Process; Process)
                {
                    Editable = false;
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
                    Editable = false;
                    ApplicationArea = all;
                }

                field("Req By."; "Req By.")
                {
                    Editable = false;
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
                field(Supplier; Supplier)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Note; Note)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(DateShiped; DateShiped)
                {
                    Editable = false;
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
                    Editable = false;
                    ApplicationArea = all;
                }
            }
            part(TempLine; "Temporary DL Line Sub")
            {
                Editable = false;
                Caption = 'Temp PO Line.';
                ApplicationArea = Suite;

                Enabled = Process <> '';
                SubPageLink = "Document No." = FIELD("DLNo");
                UpdatePropagation = Both;
            }
            group(Box)
            {
                Editable = false;
                Caption = 'BOX (PD2)';

                field("Box 1"; "Box 1")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Box 2"; "Box 2")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Cover 1"; "Cover 1")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Cover 2"; "Cover 2")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Plastic Pallet"; "Plastic Pallet")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Wood Pallet"; "Wood Pallet")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Total; Total)
                {
                    Editable = false;
                    ApplicationArea = all;

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Print)
            {
                Caption = 'Print PD1';
                Promoted = true;
                PromotedCategory = Process;
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
                Caption = 'Print PD2';
                Promoted = true;
                PromotedCategory = Process;
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

        }
    }
    trigger OnOpenPage()
    begin
        calTotalH(Rec.DLNo);
    end;

    var
        utility: Codeunit Utility;
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure AssistEdit2(var TempOrder: Record "Temporary DL Req."): Boolean
    var
        PurSetup: Record "Purchases & Payables Setup";
        NewCode: Code[20];
    begin


        //  GetPurchSetup();
        PurSetup.Get();
        PurSetup.TestField("Temp. DL No.");
        if (TempOrder.TDNo = '') and (PurSetup."Temp Nos." <> '') then begin
            if NoSeriesMgt.SelectSeries(PurSetup."Temp Nos.", '', NewCode) then begin
                // TestNoSeries();
                // NoSeriesMgt.SetSeries("No.");
                if NewCode <> '' then
                    TempOrder.TDNo := NoSeriesMgt.GetNextNo(NewCode, Today, true);
                TempOrder.Status := TempOrder.Status::Process;
                TempOrder."Temp. Date" := Today;
                TempOrder."Temp. By" := utility.UserFullName(UserId);
                if Group = 'PD2_W1' then begin
                    //DLTEMP1
                    TempOrder."Ref. PONo." := NoSeriesMgt.GetNextNo('DLTEMP1', "Document Date", false);
                end;
                if Group = 'PD2_W2' then begin
                    //DLTEMP2
                    TempOrder."Ref. PONo." := NoSeriesMgt.GetNextNo('DLTEMP2', "Document Date", false);
                end;
                if Group = 'PD1' then begin
                    //DLTEMP3
                    TempOrder."Ref. PONo." := NoSeriesMgt.GetNextNo('DLTEMP3', "Document Date", false);
                end;
                if Group = 'PD3' then begin
                    //DLTEMP3
                    //  TempOrder."Ref. PONo." := NoSeriesMgt.GetNextNo('DLTEMP3', "Document Date", false);
                end;

                exit(true);
            end;
        end;

    end;
}