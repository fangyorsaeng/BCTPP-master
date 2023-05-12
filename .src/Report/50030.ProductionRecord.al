report 50030 "Production Record Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/ProductonRecordReport.rdl';
    Caption = 'Production Record Report';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Record Header"; "Production Record Header")
        {
            RequestFilterFields = "Req. No.", "Req. Date", Process, "Process Name";
            column(Req__No_; "Req. No.") { }
            column(Req__By; "Req. By") { }
            column(Req__Date; "Req. Date") { }
            column(Process; Process) { }
            column(Process_Name; "Process Name") { }
            column(RemarkH; Remark) { }
            dataitem("Production Record Line"; "Production Record Line")
            {
                DataItemLink = "Document No." = field("Req. No.");
                DataItemLinkReference = "Production Record Header";
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(Document_No_; "Document No.") { }
                column(Line_No_; "Line No.") { }
                column(Ref__Process; "Ref. Process") { }
                column(Part_No_; "Part No.") { }
                column(Part_Name; "Part Name") { }
                column(Shift; Shift) { }
                column(Machine_No_; "Machine No.") { }
                column(Box; Box) { }
                column(Quantity; Quantity) { }
                column(NG_Qty; "NG Qty") { }
                column(RemarkL; Remark) { }
                column(RowNo; RowNo) { }
                trigger OnAfterGetRecord()
                begin
                    RowNo += 1;
                end;
            }

        }
    }
    var
        RowNo: Integer;
}