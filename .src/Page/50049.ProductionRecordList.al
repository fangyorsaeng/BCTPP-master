page 50049 "Production Record List"
{
    CardPageID = "Production Record Card";
    //Editable = false;
    PageType = List;
    SourceTable = "Production Record Header";
    SourceTableView = sorting("Req. No.") order(ascending);
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field(Status; Status) { ApplicationArea = all; StyleExpr = Sty; }
                field(Process; Process) { ApplicationArea = all; StyleExpr = Sty; }
                field("Process Name"; "Process Name") { ApplicationArea = all; }
                field("Req. No."; "Req. No.") { ApplicationArea = all; }
                field("Req. Date"; "Req. Date") { ApplicationArea = all; StyleExpr = 'Unfavorable'; }
                field("Req. By"; "Req. By") { ApplicationArea = all; }
                field(Remark; Remark) { ApplicationArea = all; }
                field("Ref. Document"; "Ref. Document") { ApplicationArea = all; }

                field("Create Date"; "Create Date") { ApplicationArea = all; Editable = false; }
                field("Create By"; "Create By") { ApplicationArea = all; Editable = false; }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Card)
            {
                Caption = 'Get To Line';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                trigger OnAction()
                var
                    MaterialH: Record "Production Record Header";
                    invtPS: Page "Invt. Receipt";
                begin
                    if DocNo <> '' then begin
                        CurrPage.SetSelectionFilter(MaterialH);
                        if MaterialH.Find('-') then begin
                            // repeat
                            //invtPS.getInsertMDL(MaterialH, DocNo);
                            //   until MaterialH.Next = 0;
                        end;

                    end;
                    CurrPage.Close();
                end;
            }
            action(report)
            {
                ApplicationArea = all;
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    RPT: Report "Production Record Report";
                begin
                    RPT.Run();
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
                    ItemLedgerList.RunModal();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Sty := 'Standard';
        if Status = Status::Completed then
            Sty := 'Favorable';
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        MaterialH: Record "Production Record Header";
        invtPS: Page "Invt. Receipt";
    begin

        if CloseAction = Action::OK then begin

        end;
    end;

    var
        utility: Codeunit Utility;
        DocNo: Code[20];
        Sty: Text[30];

    procedure setDoc(Docx: Code[20])
    begin
        DocNo := Docx;

    end;






}