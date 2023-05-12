report 50008 "Kanban Label"
{
    PreviewMode = Normal;
    Caption = 'Label';
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/Label.rdlc';
    dataset
    {
        dataitem("Kanban List"; "Kanban List")
        {
            RequestFilterFields = "Master No.";
            column(Master_No_; "Master No.") { }
            column(Seq; Seq) { }
            column(Part_No_; "Part No.") { }
            column(Part_Name; "Part Name") { }
            column(Maker; Maker) { }
            column(Classification; Classification) { }
            column(Location; Location) { }
            column(Address; Address) { }
            column(Tool_; "Tool#") { }
            column(Process; Process) { }
            column(Note; Note) { }
            trigger OnAfterGetRecord()
            begin
                // CalcFields("Part Name");
            end;
        }

    }
    trigger OnPreReport()
    begin

    end;

    var
        ItemS: Record Item;
        utility: Codeunit Utility;
}