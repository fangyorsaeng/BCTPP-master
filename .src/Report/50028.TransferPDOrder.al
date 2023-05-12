report 50028 "Transfer Production"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/TransferPDOrder.rdl';
    Caption = 'Transfer Production Order';
    dataset
    {
        dataitem("Transfer Production Header"; "Transfer Production Header")
        {
            RequestFilterFields = "Req. No.";
            column(Req__No_; "Req. No.") { }
            column(Req__Date; "Req. Date") { }
            column(Req__By; "Req. By") { }
            column(ProcessH; Process) { }
            column(Status; Status) { }
            column(RemarkH; Remark) { }
            column(Ref__Document; "Ref. Document") { }
            column(CountA; CountA) { }

            dataitem("Transfer Production Line"; "Transfer Production Line")
            {
                DataItemLink = "Document No." = field("Req. No.");
                DataItemLinkReference = "Transfer Production Header";
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(Part_No_; "Part No.") { }
                column(Part_Name; "Part Name") { }
                column(Box; Box) { }
                column(Quantity; Quantity) { }
                column(Lot_No_; "Lot No.") { }
                column(Remark; Remark) { }
                column(Machine_No_; "Machine No.") { }
                column(Reamer_Machine; "Reamer Machine") { }
                column(NC_Date; "NC Date") { }
                column(MC_Date; "MC Date") { }
                column(RRD_Date; "RRD Date") { }
                column(Ship1; Ship1) { }
                column(Ship2; Ship2) { }
                column(Process; Process) { }

                column(Rows; Rows) { }
                trigger OnAfterGetRecord()
                begin
                    Rows += 1;
                    Ship1 := '';
                    Ship2 := '';
                    if Shift = Shift::"1S" then
                        Ship1 := 'X';
                    if Shift = Shift::"2S" then
                        Ship2 := 'X';
                end;

            }
            trigger OnAfterGetRecord()
            begin
                MDLLine.Reset();
                MDLLine.SetRange("Document No.", "Transfer Production Header"."Req. No.");
                if MDLLine.Find('-') then begin
                    repeat
                        CountA += 1;
                    until MDLLine.Next = 0;
                end;
            end;

        }
    }
    var
        utility: Codeunit Utility;
        Rows: Integer;
        CountA: Integer;
        MDLLine: Record "Transfer Production Line";
        Ship1: Text[10];
        Ship2: Text[10];
}