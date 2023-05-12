page 50010 "Purchase Order Summary"
{
    Caption = 'Purchase Order Summary';
    PageType = Worksheet;
    SourceTable = "Temp Report";
    //SourceTableView = where(UserID = filter());
    UsageCategory = Lists;
    ApplicationArea = all;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field(CRow; CRow) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(Year; Rec.Year) { ApplicationArea = All; StyleExpr = Sty; Style = Unfavorable; }
                field("Part No."; "Part No.") { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field("Part Name"; "Part Name") { ApplicationArea = all; }
                field("Item Cat."; "Item Cat.") { ApplicationArea = all; }
                field(JAN; JAN) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(FEB; FEB) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(MAR; MAR) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(APR; APR) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(MAY; MAY) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(JUN; JUN) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(JUL; JUL) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(AUG; AUG) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(SEP; SEP) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(OCT; OCT) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(NOV; NOV) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(DEC; DEC) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }
                field(Total; Total) { ApplicationArea = all; StyleExpr = Sty; Style = Unfavorable; }

            }

        }

    }
    actions
    {
        area(Processing)
        {
            action(Calc)
            {
                ApplicationArea = all;
                Image = Calculate;
                Caption = 'Calculate';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    utility: Codeunit Utility;
                begin
                    //Cal Report//
                    RowNo2 := 0;
                    utility.CalculatePurchaeReport();
                    CurrPage.Update(false);
                end;
            }
            action(ItemLedger)
            {
                ApplicationArea = all;
                Image = ItemLedger;
                Caption = 'Item Ledger.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    utility: Codeunit Utility;
                    PageItemL: Page "Item Ledger Entries";
                    ItemLedger: Record "Item Ledger Entry";
                begin
                    // ItemLedger.Reset();
                    // ItemLedger.SetRange("Item No.", Rec."Part No.");
                    //  if ItemLedger.Find('-') then
                    //      PageItemL.SetTableView(ItemLedger);
                    PageItemL.RunModal();
                end;
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        RowNo2 += 1;
        Sty := false;
        if "Part No." = 'TOTAL' then
            Sty := true;
    end;

    trigger OnOpenPage()
    begin
        SetRange(SUserID, UserID);
        RowNo2 := 0;
    end;

    var
        RowNo2: Integer;
        Sty: Boolean;

}
