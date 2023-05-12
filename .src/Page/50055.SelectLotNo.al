page 50055 "Select Lot List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Select Lot No.';
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ShowFilter = true;
    RefreshOnActivate = true;
    SourceTable = "Item Ledger Entry";
    SourceTableView = sorting("Item No.", "Location Code", "Posting Date") WHERE("Remaining Quantity" = filter(> 0));
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = all;
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; "Document Type")
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
                    ItemLed: Record "Item Ledger Entry";

                begin
                    if DocNo <> '' then begin
                        CurrPage.SetSelectionFilter(ItemLed);
                        if ItemLed.Find('-') then begin
                            if dType = 'DL' then begin
                                TempDL(ItemLed."Lot No.", ItemLed."Remaining Quantity");
                            end
                            else
                                if dType = 'RC' then begin
                                    TempRC(ItemLed."Lot No.");
                                end else begin
                                    //Move Stock
                                    MovdStockDL(ItemLed."Lot No.");
                                end;
                        end;
                    end;
                    CurrPage.Close();
                end;
            }
        }
    }
    var
        DocNo: Code[20];
        Line2: Integer;
        dType: Text[20];

    procedure setDoc(Docx: Code[20]; LineNo: Integer; dTypex: Text[20])
    begin
        DocNo := Docx;
        Line2 := LineNo;
        dType := dTypex;
    end;


    procedure MovdStockDL(LotNo: Code[20])
    var
        MoveL: Record "MoveStock Line";
    begin
        MoveL.Reset();
        MoveL.SetRange("Document No.", DocNo);
        MoveL.SetRange("Line No.", Line2);
        if MoveL.Find('-') then begin
            MoveL."Lot No." := LotNo;
            MoveL.Modify();
        end;
    end;

    procedure TempDL(LotNo: Code[20]; Qty: Decimal)
    var
        MoveL: Record "Temporary DL Req. Line";
    begin
        // Message(LotNo);
        MoveL.Reset();
        MoveL.SetRange("Document No.", DocNo);
        MoveL.SetRange("Line No.", Line2);
        if MoveL.Find('-') then begin
            MoveL."Lot No." := LotNo;
            MoveL.Validate(Quantity, Qty);
            MoveL.Modify();
        end;
    end;

    procedure TempRC(LotNo: Code[20])
    var
        MoveL: Record "Temp. Receipt Line";
    begin

        MoveL.Reset();
        MoveL.SetRange("Document No.", DocNo);
        MoveL.SetRange("Line No.", Line2);
        if MoveL.Find('-') then begin
            MoveL."Lot No." := LotNo;
            MoveL.Modify();
        end;
    end;
}