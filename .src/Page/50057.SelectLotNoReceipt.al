page 50057 "Select Lot List For Receipt"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Select Receipt Lot No.';
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ShowFilter = true;
    RefreshOnActivate = true;
    SourceTable = "Temporary DL Req. Line";
    SourceTableView = sorting("Document No.", "Line No.") where("Remain Qty" = filter(> 0));
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field("Docu. Date"; "Docu. Date")
                {
                    ApplicationArea = all;
                }
                field("Part No."; "Part No.")
                {
                    ApplicationArea = all;
                }
                field("Part Name"; "Part Name")
                {
                    ApplicationArea = all;
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = all;
                }
                field("Remaining Quantity"; "Remain Qty")
                {
                    ApplicationArea = all;
                }

                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                }
                field("Transfer From Item No."; "Transfer From Item No.")
                {
                    ApplicationArea = all;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {
            action(Card)
            {
                Caption = 'Get Lot';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    ItemLed: Record "Temporary DL Req. Line";

                begin
                    if DocNo <> '' then begin
                        CurrPage.SetSelectionFilter(ItemLed);
                        if ItemLed.Find('-') then begin
                            TempRC(ItemLed."Lot No.", ItemLed."Remain Qty");
                        end;
                    end;
                    CurrPage.Close();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields("Docu. Date");
    end;

    var
        DocNo: Code[20];
        Line: Integer;
        dType: Text[20];

    procedure setDoc(Docx: Code[20]; LineNo: Integer; dTypex: Text[20])
    begin
        DocNo := Docx;
        Line := LineNo;
        dType := dTypex;
    end;



    procedure TempRC(LotNo: Code[20]; Qty: Decimal)
    var
        MoveL: Record "Temp. Receipt Line";
    begin
        MoveL.Reset();
        MoveL.SetRange("Document No.", DocNo);
        MoveL.SetRange("Line No.", Line);
        if MoveL.Find('-') then begin
            MoveL."Lot No." := LotNo;
            MoveL.Quantity := Qty;
            MoveL."Line Total" := Qty;

            MoveL.Modify(true);
        end;
    end;
}