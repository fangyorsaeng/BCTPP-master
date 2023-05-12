page 50046 "Transfer Production List"
{
    CardPageID = "Transfer Production Card";
    //Editable = false;
    PageType = List;
    SourceTable = "Transfer Production Header";
    SourceTableView = sorting("Req. No.") order(ascending);
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field("Req. No."; "Req. No.") { ApplicationArea = all; }
                field("Req. Date"; "Req. Date") { ApplicationArea = all; }
                field("Req. By"; "Req. By") { ApplicationArea = all; }
                field(Remark; Remark) { ApplicationArea = all; }
                field("Ref. Document"; "Ref. Document") { ApplicationArea = all; }
                field(Process; Process) { ApplicationArea = all; }
                field(Status; Status) { ApplicationArea = all; }
                field("Create Date"; "Create Date") { ApplicationArea = all; Editable = false; }
                field("Create By"; "Create By") { ApplicationArea = all; Editable = false; }
                field("Receipt No."; "Receipt No.") { ApplicationArea = all; Editable = false; }
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
                trigger OnAction()
                var
                    MaterialH: Record "Transfer Production Header";
                    invtPS: Page "Invt. Receipt";
                begin
                    if DocNo <> '' then begin
                        CurrPage.SetSelectionFilter(MaterialH);
                        if MaterialH.Find('-') then begin
                            // repeat
                            invtPS.getInsertMDL(MaterialH, DocNo);
                            //   until MaterialH.Next = 0;
                        end;

                    end;
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields("Receipt No.");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        MaterialH: Record "Transfer Production Header";
        invtPS: Page "Invt. Receipt";
    begin

        if CloseAction = Action::OK then begin

        end;
    end;

    var
        utility: Codeunit Utility;
        DocNo: Code[20];

    procedure setDoc(Docx: Code[20])
    begin
        DocNo := Docx;

    end;






}