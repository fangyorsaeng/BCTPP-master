report 50027 "Material Delivery"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/MaterialDelivery.rdl';
    Caption = 'Material Delivery';
    dataset
    {
        dataitem("Material Delivery Header"; "Material Delivery Header")
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

            dataitem("Material Delivery Line"; "Material Delivery Line")
            {
                DataItemLink = "Document No." = field("Req. No.");
                DataItemLinkReference = "Material Delivery Header";
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(Part_No_; "Part No.") { }
                column(Part_Name; "Part Name") { }
                column(Quantity; Quantity) { }
                column(Machine; Machine) { }
                column(Remark; Remark) { }
                column(Process; Process) { }
                column(Rows; Rows) { }
                trigger OnAfterGetRecord()
                begin
                    Rows += 1;
                end;

            }
            trigger OnAfterGetRecord()
            begin
                MDLLine.Reset();
                MDLLine.SetRange("Document No.", "Material Delivery Header"."Req. No.");
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
        MDLLine: Record "Material Delivery Line";
}