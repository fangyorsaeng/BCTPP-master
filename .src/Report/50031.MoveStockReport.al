report 50031 "MoveStock Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/MoveStockReport.rdl';
    Caption = 'MoveStock Report';
    dataset
    {
        dataitem("MoveStock Header"; "MoveStock Header")
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

            dataitem("MoveStock Line"; "MoveStock Line")
            {
                DataItemLink = "Document No." = field("Req. No.");
                DataItemLinkReference = "MoveStock Header";
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(Part_No_; "Part No.") { }
                column(Part_Name; "Part Name") { }
                column(Quantity; Quantity) { }
                column(Machine; "Machine No.") { }
                column(Remark; Remark) { }
                column(Process; Process) { }
                column(OLD_Location; "OLD Location") { }
                column(New_Locatin; "New Locatin") { }
                column(Lot_No_; "Lot No.") { }
                column(Rows; Rows) { }
                trigger OnAfterGetRecord()
                begin
                    Rows += 1;
                end;

            }
            trigger OnAfterGetRecord()
            begin
                MDLLine.Reset();
                MDLLine.SetRange("Document No.", "MoveStock Header"."Req. No.");
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
        MDLLine: Record "MoveStock Line";
}