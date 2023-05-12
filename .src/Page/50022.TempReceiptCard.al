page 50022 "Temporary Receipt Card"
{
    PageType = Document;
    SourceTable = "Temp. Receipt Header";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Receipt No."; "Receipt No.")
                {
                    ApplicationArea = all;
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    begin
                        AssistEdit(Rec);
                        CurrPage.Update();
                    end;
                }
                field("Receipt Date"; "Receipt Date")
                {
                    ApplicationArea = all;
                }
                field("Receipt By"; "Receipt By")
                {
                    ApplicationArea = all;
                }
                field(Group; Group)
                {
                    ApplicationArea = all;
                }
                field("Ref. No."; "Ref. No.")
                {
                    ApplicationArea = all;
                }
                field("Ref. Date"; "Ref. Date")
                {
                    ApplicationArea = all;
                }
                field("Ref. By"; "Ref. By")
                {
                    ApplicationArea = all;
                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Total; Total)
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Total OK';
                }
                field(TotalNG; TotalNG)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Total NG';
                }

            }
            part(TempLine; "Temporary Receipt Sub")
            {
                Caption = 'Temp PO Line.';
                ApplicationArea = Suite;
                Editable = ("Receipt No." <> '') and (Status <> Status::Completed);
                Enabled = ("Ref. No." <> '') and (Status <> Status::Completed);
                SubPageLink = "Document No." = FIELD("Receipt No.");
                UpdatePropagation = Both;
            }
        }

    }
    actions
    {

        area(Processing)
        {
            action(Posted)
            {
                Caption = 'Post';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                trigger OnAction()
                var
                    PosteJL: Codeunit "Posted Receipt Temp.";

                begin
                    if Confirm('Do you want Posting Document?') then begin
                        PosteJL.Code(Rec);
                        Rec.Status := Status::Completed;
                        Rec.Modify();
                    end;
                end;
            }

            action(CoverSh)
            {
                ApplicationArea = all;
                Caption = 'Print';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Print;
                Visible = false;
                trigger OnAction()
                var
                    TempPO: Record "Temp. Receipt Header";
                    ReportPO: Report "Temp. PO Sheet";
                begin
                    // TempPO := Rec;
                    // CurrPage.SetSelectionFilter(TempPO);
                    // ReportPO.SetTableView(TempPO);
                    // ReportPO.RunModal();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields(Total);
        CalcFields(TotalNG);
    end;

    var
        utility: Codeunit Utility;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CK: Boolean;

    procedure AssistEdit(var TempOrder: Record "Temp. Receipt Header"): Boolean
    var
        PurSetup: Record "Purchases & Payables Setup";
        NewCode: Code[20];
    begin


        //  GetPurchSetup();
        PurSetup.Get();
        PurSetup.TestField("Temp RCNo.");
        if (TempOrder."Receipt No." = '') and (PurSetup."Temp RCNo." <> '') then begin
            if NoSeriesMgt.SelectSeries(PurSetup."Temp RCNo.", '', NewCode) then begin
                // TestNoSeries();
                // NoSeriesMgt.SetSeries("No.");
                if NewCode <> '' then
                    TempOrder."Receipt No." := NoSeriesMgt.GetNextNo(NewCode, Today, true);
                TempOrder.Status := Status::Open;
                exit(true);
            end;
        end;

    end;
}